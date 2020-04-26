//
//  AppDelegate.swift
//  MasterWorker
//
//  Created by Apple on 2019/8/28.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        // Override point for customization after application launch.
//        UserID=nil
        if UserID==nil{
            
        }else{
            let nav=UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nav") as! UINavigationController
            nav.setNavigationBarHidden(true, animated: true)
//            nav.addChild(RootTabBarViewController())
            nav.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tab"), animated: true)
            window?.rootViewController=nav
            self.window!.tintColor = UIColor.red
        }
        
        _ = WXApi.registerApp("wxbaf9ee1d21a481af")//appid字符串
        
        AMapServices.shared().apiKey = "c4aab911b2b3976551ff9aad1408f862"
        
        IQKeyboardManager.shared.enable = true
        
        
//        if launchOptions != nil{
//            let userinfo=launchOptions![UIApplication.LaunchOptionsKey.remoteNotification]
//            if userinfo != nil{
//                print(userinfo!)
//                let dic=userinfo as! NSDictionary
//                let orderId=dic["OrderID"] as? String
//                if orderId != ""&&orderId != nil{
//                    (self.window!.rootViewController as! UINavigationController).pushViewController(V3_OrderDetailViewController(orderid: orderId), animated: true)
//                }
//            }
//        }
        
        
        //推送代码
        let entity = JPUSHRegisterEntity()
        entity.types = 1 << 0 | 1 << 1 | 1 << 2
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        //需要IDFA 功能，定向投放广告功能
        //let advertisingId = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        JPUSHService.setup(withOption: launchOptions, appKey: "8d0ccf1152ef5e9851aa9d3d", channel: "App Store", apsForProduction: false, advertisingIdentifier: nil)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //销毁通知红点
        UIApplication.shared.applicationIconBadgeNumber = 0
        JPUSHService.setBadge(0)
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


//MARK:微信登录
extension AppDelegate: WXApiDelegate {
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        switch url.scheme {
        case "wxbaf9ee1d21a481af":
            _ = WXApi.handleOpen(url, delegate: self)
        default:
            print("handleOpenUrl1")
        }
        
        if url.host == "safepay"{
                    AlipaySDK.defaultService().processOrder(withPaymentResult: url){
                        value in
                        let code = value!
                        let resultStatus = code["resultStatus"] as!String
                        var content = ""
                        switch resultStatus {
                        case "9000":
                            content = "支付成功"
        //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPaySucceess"), object: content)
                        case "8000":
                            content = "订单正在处理中"
        //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayUnknowStatus"), object: content)
                        case "4000":
                            content = "支付失败"
        //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                        case "5000":
                            content = "重复请求"
        //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                        case "6001":
                            content = "中途取消"
        //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                        case "6002":
                            content = "网络连接出错"
        //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefault"), object: content)
                        case "6004":
                            content = "支付结果未知"
        //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayUnknowStatus"), object: content)
                        default:
                            content = "支付失败"
        //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPayDefeat"), object: content)
                            break
                        }
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "aliPay"), object: (resultStatus,content))
                    }
                }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL
        , sourceApplication: String?, annotation: Any) -> Bool {
        switch url.scheme {
        case "wxbaf9ee1d21a481af":
            _ = WXApi.handleOpen(url, delegate: self)
        default:
            print("handleOpenUrl2")
        }
        return true
    }
    func onResp(_ resp: BaseResp) {
//        var code: String?
//        var error: String?
        if resp.isKind(of: SendAuthResp.self) {
            let authResp = resp as! SendAuthResp
//            if authResp.errCode == 0 {
//                code = authResp.code
//            } else {
//                error = authResp.errStr
//            }
            //MARK:发送通知
            NotificationCenter.default.post(name: NSNotification.Name("微信登录"), object: authResp)
        } else if resp.isKind(of: PayResp.self) {
            let payResp = resp as! PayResp
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WXPayNotification"), object: resp.errCode)
//            if payResp.errCode == 0 {
//                code = payResp.returnKey
//            } else {
//                error = payResp.errStr
//            }
        }
//        if wechatAuthBack != nil {
//            if error == nil && code == nil {
//                error = "登录失败"
//            }
//            wechatAuthBack?.finish(result: code, error: error)
//        } else if wechatPayBack != nil {
//            if error == nil && code == nil {
//                error = "支付失败"
//            }
//            wechatPayBack?.finish(result: code, error: error)
//        }
    }
}
//MARK:--推送代理
extension AppDelegate : JPUSHRegisterDelegate {
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {
        
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
       // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
       completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
       let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        // 系统要求执行这个方法
        completionHandler()
    }
    
    //点推送进来执行这个方法
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
           JPUSHService.handleRemoteNotification(userInfo)
           completionHandler(UIBackgroundFetchResult.newData)
        
    }
    //系统获取Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
        pushToken=JPUSHService.registrationID()
    }
    //获取token 失败
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { //可选
        print("did Fail To Register For Remote Notifications With Error: \(error)")
    }
}
