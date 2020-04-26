//
//  CertificationViewController.swift
//  MasterWorker
//
//  Created by Apple on 2019/10/8.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CertificationViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AMapSearchDelegate {
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var tf_companyName: UITextField!
    @IBOutlet weak var tf_license: UITextField!
    @IBOutlet weak var tf_manageName: UITextField!
    @IBOutlet weak var tf_managePhone: UITextField!
    @IBOutlet weak var tf_servicePhone: UITextField!
    @IBOutlet weak var tf_financialPhone: UITextField!
    @IBOutlet weak var tf_tecPhone: UITextField!
    @IBOutlet weak var iv_license: UIImageView!
    @IBOutlet weak var uv_location: UIView!
    @IBOutlet weak var lb_location: UILabel!
    @IBOutlet weak var btn_submit: UIButton!

    var companyName:String!
    var license:String!
    var managePhone:String!
    var manageName:String!
    var servicePhone:String!
    var financialPhone:String!
    var tecPhone:String!
    
    var PhotoUrl=""
    var IfAuth=""
    
    var Address:String!
    var Province:String!
    var City:String!
    var Area:String!
    var District:String!
    
    var search: AMapSearchAPI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uv_back.addOnClickListener(target: self, action: #selector(back))
        iv_license.addOnClickListener(target: self, action: #selector(idCardUpload))
        uv_location.addOnClickListener(target: self, action: #selector(location))
        
        btn_submit.layer.cornerRadius=5
        btn_submit.addOnClickListener(target: self, action: #selector(submit))
        LocationManager.shared.startPositioning(self)
        LocationManager.shared.clousre={addr,Dimension,Longitude,place in
            self.lb_location.text=addr
            self.Address=addr
            self.Province=place.0
            self.City=place.1
            self.Area=place.2
            self.District=place.3
        }
        
        search = AMapSearchAPI()
        search.delegate = self

        //MARK:接收通知地图选点
        NotificationCenter.default.addObserver(self, selector: #selector(selectaddr(noti:)), name: NSNotification.Name("地图选点"), object: nil)
    }
    //MARK:接收通知地图选点
    @objc func selectaddr(noti:Notification){
        let tip=noti.object as! AMapTip
        self.lb_location.text="\(tip.district ?? "")\(tip.address ?? "")\(tip.name ?? "")"
        self.Address="\(tip.district ?? "")\(tip.address ?? "")\(tip.name ?? "")"
        
        let request = AMapReGeocodeSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: tip.location.latitude, longitude: tip.location.longitude)
        request.requireExtension = true
        search.aMapReGoecodeSearch(request)
    }
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("Error:\(error)")
    }
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
     
        if response.regeocode == nil {
            return
        }
        self.Province=response.regeocode.addressComponent.province
        self.City=response.regeocode.addressComponent.city
        self.Area=response.regeocode.addressComponent.district
        self.District=response.regeocode.addressComponent.township
        print(Province!)
        print(City!)
        print(Area!)
        print(District!)
        //解析response获取地址描述，具体解析见 Demo
    }
    //MARK:地图选点
    @objc func location(){
        self.navigationController?.pushViewController(TipViewController(), animated: true)
    }
    //MARK:营业执照照片
    @objc func idCardUpload(){
        let actionSheet = UIAlertController(title: "上传图片", message: nil, preferredStyle: .actionSheet)
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        
        let takePhotos = UIAlertAction(title: "拍照", style: .destructive, handler: {
            (action: UIAlertAction) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
                
            }
            else
            {
                print("模拟其中无法打开照相机,请在真机中使用");
            }
            
        })
        let selectPhotos = UIAlertAction(title: "相册选取", style: .default, handler: {
            (action:UIAlertAction)
            -> Void in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
            
        })
        actionSheet.addAction(cancelBtn)
        actionSheet.addAction(takePhotos)
        actionSheet.addAction(selectPhotos)
        self.present(actionSheet, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        关闭相册界面
        picker.dismiss(animated: true, completion: nil)
        let type = info[UIImagePickerController.InfoKey.mediaType] as! String
        if type == "public.image" {
            let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            AlamofireHelper.upload(to: IDCardUpload, parameters: ["UserID":UserID!,"Sort":"1"], uploadFiles: [image], successHandler: { [weak self](res) in
                HUD.dismiss()
                guard let ss = self else {return}
                if res["Data"]["Item1"].boolValue{
                    ss.PhotoUrl="上传成功"
                    ss.iv_license.image = image
                }else{
                    HUD.showText("图片上传失败")
                }
            }) {
                HUD.dismiss()
                HUD.showText("图片上传失败")
            }
            
        }
    }
    //MARK:返回
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:提交实名认证
    @objc func submit(){
        companyName=tf_companyName.text
        license=tf_license.text
        manageName=tf_manageName.text
        managePhone=tf_managePhone.text
        servicePhone=tf_servicePhone.text
        financialPhone=tf_financialPhone.text
        tecPhone=tf_tecPhone.text
        
        if companyName.isEmpty{
            HUD.showText("请填写公司名称！")
            return
        }
        if tecPhone.isEmpty{
            HUD.showText("请填写技术电话！")
            return
        }
        if license.isEmpty{
            HUD.showText("请填写营业执照号码！")
            return
        }
        if PhotoUrl==""{
            HUD.showText("请上传营业执照照片！")
            return
        }
        if Province==nil{
            HUD.showText("定位失败，请稍后再试！")
            return
        }
        let d = [
            "UserID":UserID!,
            "CompanyName":companyName,
            "CompanyNum":license,
            "ManagyName":manageName,
            "ManagyPhone":managePhone,
            "ServicePhone":servicePhone,
            "FinancePhone":financialPhone,
            "ArtisanPhone":tecPhone,
            "Address":Address,
            "Province":Province,
            "City":City,
            "Area":Area,
            "District":District,
            "IfAuth":IfAuth
        ] as! [String : String]
        print(d)
        AlamofireHelper.post(url: FactoryApplyAuthInfo, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                HUD.showText("提交成功，请等待审核。")
                self?.navigationController?.popViewController(animated: true)
            }else{
                HUD.showText("提交失败")
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
