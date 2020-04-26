//
//  ChangePayPwdViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/2.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
//MARK:修改密码
class ChangePayPwdViewController: UIViewController {
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var tf_old: UITextField!
    @IBOutlet weak var tf_pwd: UITextField!
    @IBOutlet weak var tf_repwd:UITextField!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var lb_title: UILabel!
    
    @IBOutlet weak var uv_old: UIView!
    
    var userOfxgy:UserOfxgy!
    var old:String!
    var pwd:String!
    var repwd:String!
    var type=1
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
        getUserInfoList()
    }
    //MARK:返回
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    func getUserInfoList(){
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
            if ss.userOfxgy.PayPassWord != ""{
                ss.lb_title.text="修改支付密码"
                ss.uv_old.isHidden=false
                ss.type=1
            }else{
                ss.lb_title.text="设置支付密码"
                ss.uv_old.isHidden=true
                ss.type=2
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:保存
    @objc func submit(){
         old=tf_old.text!
         pwd=tf_pwd.text!
         repwd=tf_repwd.text!
        if type==1{
            if old.isEmpty{
                HUD.showText("请输入旧密码")
                return
            }
        }
        if pwd.isEmpty{
            HUD.showText("请输入新密码")
            return
        }
        if pwd.count != 6{
            HUD.showText("支付密码长度为6位数字")
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
        var d = ["UserID":UserID!,
                 "OldPayPassword":old,
                 "PayPassword":pwd
            ] as [String : String]
        print(d)
        AlamofireHelper.post(url: ChangePayPassword, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item2"] != "旧密码错误"{
                HUD.showText(res["Data"]["Item2"].stringValue)
                ss.navigationController?.popViewController(animated: true)
            }else{
                HUD.showText(res["Data"]["Item2"].stringValue)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}

