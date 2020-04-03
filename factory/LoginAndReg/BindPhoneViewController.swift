//
//  BindPhoneViewController.swift
//  MasterWorker
//
//  Created by Apple on 2019/8/28.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class BindPhoneViewController: UIViewController {
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_code: UITextField!
    @IBOutlet weak var btn_getcode: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    var name:String!
    var code:String!
    var wx_info:Wx_userinfo!
    init(wx_info:Wx_userinfo!){
        super.init(nibName: nil, bundle: nil)
        self.wx_info=wx_info
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
    var flag=0
    @objc func updateTime(timer: Timer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_submit.layer.cornerRadius=5
        uv_back.addOnClickListener(target: self, action: #selector(back))
        btn_getcode.addOnClickListener(target: self, action: #selector(getcode))
        btn_submit.addOnClickListener(target: self, action: #selector(submit))
        
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func getcode(){
        name=tf_name.text!
        if name.isEmpty {
            HUD.showText("请输入手机号码！")
            return
        }
        
        //发送验证码
        getPhoneCode()
//        validateUsername()
    }
//    @objc func validateUsername(){
//        let d = ["UserID":name] as [String : String]
//        AlamofireHelper.post(url: ValidateUserName, parameters: d, successHandler: {[weak self](res)in
//            HUD.dismiss()
//            guard let ss = self else {return}
//            if res["Data"].boolValue{
//                HUD.showText("该账号未注册")
//            }else{
//                ss.getPhoneCode()
//            }
//        }){[weak self] (error) in
//            HUD.dismiss()
//            guard let ss = self else {return}
//        }
//    }
    @objc func getPhoneCode(){
        let d = [
            "mobile":name,
            "type":"1",
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
    @objc func submit(){
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
                 "type":"1",
                 "openid":wx_info.openid!,
                 "unionid":wx_info.unionid!,
                 "code":code,
                 "roleType":"worker"
            ] as [String : String]
        print(d)
        AlamofireHelper.post(url: WxReg, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                ss.wxRegister(info: ss.wx_info)
            }else{
                HUD.showText(res["Data"]["Item2"].stringValue)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:
    func wxRegister(info:Wx_userinfo){
        let d = ["openid":info.openid!,
                 "nickname":info.nickname!,
                 "sex":info.sex,
                 "language":info.language!,
                 "city":info.city!,
                 "province":info.province!,
                 "country":info.country!,
                 "headimgurl":info.headimgurl!,
                 "unionid":info.unionid!
            ] as [String : Any]
        print(d)
        AlamofireHelper.post(url: WxRegister, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                UserDefaults.standard.set(res["Data"]["Item2"]["data"].stringValue, forKey: "adminToken")
                UserDefaults.standard.set(res["Data"]["Item2"]["UserID"].stringValue, forKey: "UserID")
                adminToken=UserDefaults.standard.string(forKey: "adminToken")
                UserID=UserDefaults.standard.string(forKey: "UserID")
                HUD.showText("登录成功")
                ss.addAndUpdatePushAccount()
                ss.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tab"), animated: true)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
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
