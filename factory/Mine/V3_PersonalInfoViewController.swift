//
//  V3_PersonalInfoViewController.swift
//  MasterWorker
//
//  Created by Apple on 2019/11/7.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class V3_PersonalInfoViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var iv_avatar: UIImageView!
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var uv_avatar: UIView!
    @IBOutlet weak var uv_name: UIView!
    @IBOutlet weak var lb_Name: UILabel!
    @IBOutlet weak var uv_addr: UIView!
    @IBOutlet weak var lb_companyName: UILabel!
    @IBOutlet weak var lb_phone: UILabel!
    @IBOutlet weak var lb_license: UILabel!
    @IBOutlet weak var lb_addr: UILabel!
    var userOfxgy:UserOfxgy!
    var nick=""
    override func viewDidLoad() {
        super.viewDidLoad()
        uv_back.addOnClickListener(target: self, action: #selector(back))
        uv_avatar.addOnClickListener(target: self, action: #selector(avator))
        uv_name.addOnClickListener(target: self, action: #selector(changeNick))
        uv_addr.addOnClickListener(target: self, action: #selector(myaddr))
        iv_avatar.layer.cornerRadius=25
        getUserInfoList()
        // Do any additional setup after loading the view.
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:验证手机号
    func validateMobile(phone:String) -> Bool {
        let phoneRegex: String = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    //MARK:更换昵称
    @objc func changeNick(){
        let alertController = UIAlertController(title: "修改昵称", message: "请输入新昵称", preferredStyle: UIAlertController.Style.alert);
        alertController.addTextField { (textField:UITextField!) -> Void in
            textField.placeholder = "新昵称";
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil )
        let okAction = UIAlertAction(title: "好的", style: UIAlertAction.Style.default) { (ACTION) -> Void in
            let tf_nick = alertController.textFields!.first! as UITextField
            print("昵称：\(tf_nick.text!)")
            self.nick=tf_nick.text!
            self.updateAccountNickName()
        }
        alertController.addAction(cancelAction);
        alertController.addAction(okAction);
        self.present(alertController, animated: true, completion: nil)
    }
    //MARK:更换昵称
    func updateAccountNickName(){
        let d = ["UserID":UserID,
                 "NickName":nick
            ] as! [String : String]
        AlamofireHelper.post(url: UpdateAccountNickName, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                ss.lb_Name.text=ss.nick
                //MARK:发送通知
                NotificationCenter.default.post(name: NSNotification.Name("更新用户信息"), object: nil)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:更换头像
    @objc func avator(){
        let actionSheet = UIAlertController(title: "上传头像", message: nil, preferredStyle: .actionSheet)
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
            AlamofireHelper.upload(to: UploadAvator, parameters: ["UserID":UserID!], uploadFiles: [image], successHandler: { [weak self](res) in
                HUD.dismiss()
                guard let ss = self else {return}
                if res["Data"]["Item1"].boolValue{
                    HUD.showText("头像上传成功")
                    ss.iv_avatar.image = image
                    //MARK:发送通知
                    NotificationCenter.default.post(name: NSNotification.Name("更新用户信息"), object: nil)
                }else{
                    HUD.showText("头像上传失败")
                }
            }) {
                HUD.dismiss()
                HUD.showText("头像上传失败")
            }
            
        }
    }
    //MARK:账号与安全
    @objc func accountSafety(){
        self.navigationController?.pushViewController(SafetyViewController(), animated: true)
    }
    //MARK:去实名
    @objc func toCertificate(){
//        self.navigationController?.pushViewController(V3_CertificationViewController(), animated: true)
    }
    //MARK:收件地址
    @objc func myaddr(){
        var d = ["UserID":UserID!] as [String : String]
        AlamofireHelper.post(url: GetAccountAddress, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            let dataSource=res["Data"].arrayValue.compactMap({ mShippingAddress(json: $0)})
            if dataSource.count>0{
                ss.navigationController?.pushViewController(AddNewAddrViewController(shippingAddress: dataSource[0]), animated: true)
            }else{
                ss.navigationController?.pushViewController(AddNewAddrViewController(), animated: true)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
        
    }
    @objc func getUserInfoList(){
        let d = ["UserID":UserID,
                 "limit":"1"
            ] as! [String : String]
        AlamofireHelper.post(url: GetUserInfoList, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Info"] == "HTTP请求不合法，请求有可能被篡改"{
                return
            }
            ss.userOfxgy=res["Data"]["data"].arrayValue.compactMap({ UserOfxgy(json: $0)})[0]
            if ss.userOfxgy != nil{
                if ss.userOfxgy.Avator != nil{
                    ss.iv_avatar.setImage(path: URL.init(string: "https://img.xigyu.com/Pics/Avator/\(ss.userOfxgy.Avator!)")!)
                }
                if ss.userOfxgy.IfAuth == "1"{
                    ss.getmessageBytype()
                }else{
                    ss.lb_companyName.text="未认证"
                }
                ss.lb_phone.text=ss.userOfxgy.Phone
                ss.lb_Name.text=ss.userOfxgy.NickName
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:获取公司信息
    @objc func getmessageBytype(){
        let d = ["UserID":UserID
            ] as! [String : String]
        AlamofireHelper.post(url: GetmessageBytype, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.lb_companyName.text=res["Data"]["Item2"]["CompanyName"].stringValue
            ss.lb_license.text=res["Data"]["Item2"]["CompanyNum"].stringValue
            let province=res["Data"]["Item2"]["Province"].stringValue
            let city=res["Data"]["Item2"]["City"].stringValue
            let area=res["Data"]["Item2"]["Area"].stringValue
            let district=res["Data"]["Item2"]["District"].stringValue
            let addr=res["Data"]["Item2"]["Address"].stringValue
            ss.lb_addr.text="\(province)\(city)\(area)\(district)\(addr)"
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
