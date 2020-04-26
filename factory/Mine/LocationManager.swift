//
//  LocationManager.swift
//  MasterWorker
//
//  Created by Apple on 2019/10/9.
//  Copyright © 2019 Apple. All rights reserved.
//

import CoreLocation

typealias MKPositioningClosure = (String,String,String,(String,String,String,String)) -> ()

class LocationManager: NSObject {
    
    public static let shared = LocationManager()
    
    var clousre : MKPositioningClosure?
    private var locationManager : CLLocationManager?
    private var viewController : UIViewController?      // 承接外部传过来的视图控制器，做弹框处理
    
    
    // 外部初始化的对象调用，执行定位处理。
    func startPositioning(_ vc:UIViewController) {
        viewController = vc
        if (self.locationManager != nil) && (CLLocationManager.authorizationStatus() == .denied) {
            // 定位提示
            alter(viewController: viewController!)
        } else {
            requestLocationServicesAuthorization()
        }
    }
    
    
    // 初始化定位
    private func requestLocationServicesAuthorization() {
        
        if (self.locationManager == nil) {
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
        }
        
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined) {
            locationManager?.requestWhenInUseAuthorization()
        }
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            let distance : CLLocationDistance = 10.0
            locationManager?.distanceFilter = distance
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
    }
    
    
    // 获取定位代理返回状态进行处理
    private func reportLocationServicesAuthorizationStatus(status:CLAuthorizationStatus) {
        
        if status == .notDetermined {
            // 未决定,继续请求授权
            requestLocationServicesAuthorization()
        } else if (status == .restricted) {
            // 受限制，尝试提示然后进入设置页面进行处理
            alter(viewController: viewController!)
        } else if (status == .denied) {
            // 受限制，尝试提示然后进入设置页面进行处理
            alter(viewController: viewController!)
        }
    }
    
    
    private func alter(viewController:UIViewController) {
        let alert = UIAlertController(title: "定位服务未开启,是否前往开启?", message: "请进入系统[设置]->[隐私]->[定位服务]中打开开关，并允许“西瓜鱼服务”使用定位服务", preferredStyle: .alert)
        let OK = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            let url = URL(fileURLWithPath: UIApplication.openSettingsURLString)
            if UIApplication.shared.canOpenURL(url){
                UIApplication.shared.openURL(url)
            }
        }
        let Cancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
            print("you selected cancel")
        }
        //将Actiont加入到AlertController
        alert.addAction(OK)
        alert.addAction(Cancel)
        //以模态方式弹出
        viewController.present(alert, animated: true, completion: nil)
    }
}

extension LocationManager:  CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager?.stopUpdatingLocation()
        
        let location = locations.last ?? CLLocation()
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if error != nil {
                if self.clousre != nil {
                    self.clousre!("定位失败","","", ("","","",""))
                }
                return
            }
            
            if let place = placemarks?[0]{
                
                // 国家 省  市  区  街道  名称  国家编码  邮编
                //                let country = place.country ?? ""
                let administrativeArea = place.administrativeArea ?? ""
                let locality = place.locality ?? ""
                let subLocality = place.subLocality ?? ""
                let thoroughfare = place.thoroughfare ?? ""
                let name = place.name ?? ""
                
                //                let isoCountryCode = place.isoCountryCode ?? ""
                //                let postalCode = place.postalCode ?? ""
                
                let addressLines =  administrativeArea + locality + subLocality + thoroughfare + name
                let latitude=place.location?.coordinate.latitude
                let longitude=place.location?.coordinate.longitude
                self.clousre!(addressLines,"\(String(describing: latitude!))","\(String(describing: longitude!))",(administrativeArea,locality,subLocality,thoroughfare))
            } else {
                
                if self.clousre != nil {
                    self.clousre!("定位失败","","",("","","",""))
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        reportLocationServicesAuthorizationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager?.stopUpdatingLocation()
    }
}
