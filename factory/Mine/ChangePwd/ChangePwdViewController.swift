//
//  ChangePwdViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/2.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
//MARK:修改密码
class ChangePwdViewController: UIViewController {
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var tf_old: UITextField!
    @IBOutlet weak var tf_pwd: UITextField!
    @IBOutlet weak var tf_repwd:UITextField!
    @IBOutlet weak var btn_submit: UIButton!
    var old:String!
    var pwd:String!
    var repwd:String!
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer().rainbowLayer()
        gradientLayer.frame = btn_submit.bounds
        self.btn_submit.layer.insertSublayer(gradientLayer, at: 0)
        self.btn_submit.clipsToBounds=true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        uv_back.addOnClickListener(target: self, action: #selector(back))
        btn_submit.addOnClickListener(target: self, action: #selector(submit))
        btn_submit.layer.cornerRadius=5
    }
    //MARK:返回
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:保存
    @objc func submit(){
         old=tf_old.text!
         pwd=tf_pwd.text!
         repwd=tf_repwd.text!
        if old.isEmpty{
            HUD.showText("请输入旧密码")
            return
        }
        if pwd.isEmpty{
            HUD.showText("请输入新密码")
            return
        }
        if repwd.isEmpty{
            HUD.showText("请再次确认密码")
            return
        }
        if repwd != pwd{
            HUD.showText("两次密码不一致")
            return
        }
//        var d = ["app_key":app_key,
//                 "oldPassword":old,
//                 "password":pwd,
//                 "userkey":userkey!,
//                 "timestamp":getTimestamp()
//            ] as [String : String]
//        let sign=SignTopRequest(params: d)
//        d["sign"]=sign
//        print(d)
//        AlamofireHelper.post(url: PostChangePassword, parameters: d, successHandler: {[weak self](res)in
//            HUD.dismiss()
//            guard let ss = self else {return}
//            if res["success"].boolValue{
//                ss.updatePassword()
//            }else{
//                HUD.showText(res["msg"].stringValue)
//            }
//        }){[weak self] (error) in
//            HUD.dismiss()
//            guard let ss = self else {return}
//        }
        updatePassword()
    }
    @objc func updatePassword(){
        let d = ["UserID":UserID!,
                 "Password":pwd!
            ] as [String : Any]
        AlamofireHelper.post(url: UpdatePassword, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                HUD.showText("修改成功")
                UserDefaults.standard.set(ss.pwd, forKey: "Pwd")
                Pwd=UserDefaults.standard.string(forKey: "Pwd")
                ss.navigationController?.popViewController(animated: true)
            }else{
                HUD.showText("修改失败，请稍后再试")
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}

