//
//  CodeLoginViewController.swift
//  MasterWorker
//
//  Created by Apple on 2019/8/28.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CodeLoginViewController: UIViewController {

    @IBOutlet weak var iv_img: UIImageView!
    @IBOutlet weak var uv_name: UIView!
    @IBOutlet weak var uv_code: UIView!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_code: UITextField!
    @IBOutlet weak var btn_codelogin: UIButton!
    @IBOutlet weak var btn_pwdlogin: UIButton!
    @IBOutlet weak var btn_getcode: UIButton!
    var name:String!
    var code:String!
    var remainingSeconds: Int = 0 {
        willSet {
            btn_getcode.setTitle("\(newValue)秒后重新获取", for: .normal)
            
            if newValue <= 0 {
                btn_getcode.setTitle("重新获取验证码", for: .normal)
                isCounting = false
            }
        }
    }
    var countdownTimer: Timer?
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime(timer:)), userInfo: nil, repeats: true)
                
                remainingSeconds = 60
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                
            }
            
            btn_getcode.isEnabled = !newValue
        }
    }
    @objc func updateTime(timer: Timer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer().rainbowLayer()
        gradientLayer.frame = btn_codelogin.bounds
        self.btn_codelogin.layer.insertSublayer(gradientLayer, at: 0)
        self.btn_codelogin.clipsToBounds=true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        iv_img.layer.cornerRadius=40
        btn_codelogin.layer.cornerRadius=5
        uv_name.border(color: .gray, width: 0.5, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        uv_code.border(color: .gray, width: 0.5, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        btn_codelogin.addOnClickListener(target: self, action: #selector(codelogin))
        btn_pwdlogin.addOnClickListener(target: self, action: #selector(back))
        btn_getcode.addOnClickListener(target: self, action: #selector(getcode))
        tf_name.text=UserID
    }
    @objc func getcode(){
        name=tf_name.text!
        if name.isEmpty {
            HUD.showText("请输入用户名！")
            return
        }
        //发送验证码
        validateUsername()
    }
    @objc func validateUsername(){
        let d = ["UserID":name] as [String : String]
        AlamofireHelper.post(url: ValidateUserName, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"].boolValue{
                HUD.showText("该账号未注册")
            }else{
                ss.getPhoneCode()
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func getPhoneCode(){
        let d = [
            "mobile":name,
            "type":"3",
            "roleType":"worker"
            ] as [String : String]
        AlamofireHelper.post(url: GetCode, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                HUD.showText("验证码已发送，请注意查收")
                ss.isCounting=true
            }else{
                HUD.showText(res["Data"]["Item2"].stringValue)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func codelogin(){
        name=tf_name.text
        code=tf_code.text
        if name.isEmpty{
            HUD.showText("请输入手机号码")
            return
        }
        if code.isEmpty{
            HUD.showText("请输入验证码")
            return
        }
        var d = ["mobile":name,
                 "code":code,
                 "type":"3",
                 "roleType":"6"//角色类型 5平台 6工厂 7师傅 8商城 10代表包含5678
            ] as [String : String]
        AlamofireHelper.post(url: LoginOnMessage, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                UserDefaults.standard.set(res["Data"]["Item2"].stringValue, forKey: "adminToken")
                UserDefaults.standard.set(ss.name, forKey: "UserID")
                adminToken=UserDefaults.standard.string(forKey: "adminToken")
                UserID=UserDefaults.standard.string(forKey: "UserID")
                HUD.showText("登录成功")
                ss.addAndUpdatePushAccount()
                ss.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tab"), animated: true)
            }else{
                HUD.showText(res["Data"]["Item2"].stringValue)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func addAndUpdatePushAccount(){
        let d = ["UserID":UserID,
                 "token":pushToken==nil ? "" : pushToken,
                 "type":"6",
                 "platform":"iOS"
            ] as! [String : String]
        AlamofireHelper.post(url: AddAndUpdatePushAccount, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
