//
//  LoginViewController.swift
//  MasterWorker
//
//  Created by Apple on 2019/8/28.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewController: UIViewController {
    
    @IBOutlet weak var iv_img: UIImageView!
    @IBOutlet weak var uv_name: UIView!
    @IBOutlet weak var uv_pwd: UIView!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_pwd: UITextField!
    @IBOutlet weak var btn_codelogin: UIButton!
    @IBOutlet weak var btn_rigster: UIButton!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var btn_wechat: UIButton!
    @IBOutlet weak var btn_forgetpwd: UIButton!
    
    @IBOutlet weak var uv_wechat: UIView!
    
    
    var name:String!
    var pwd:String!
    
//    override func awakeFromNib() {
//        if UserID != nil && Pwd != nil && adminToken != nil {
//            self.navigationController?.pushViewController(RootTabBarViewController(), animated: true)
//        }
//    }
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer().rainbowLayer()
        gradientLayer.frame = btn_login.bounds
        self.btn_login.layer.insertSublayer(gradientLayer, at: 0)
        self.btn_login.clipsToBounds=true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Thread.sleep(forTimeInterval: 1.0) //延长1秒
        // Do any additional setup after loading the view.
        iv_img.layer.cornerRadius=40
        btn_login.layer.cornerRadius=5
        uv_name.border(color: .gray, width: 0.5, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        uv_pwd.border(color: .gray, width: 0.5, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        btn_codelogin.addOnClickListener(target: self, action: #selector(codelogin))
        btn_login.addOnClickListener(target: self, action: #selector(login))
        btn_rigster.addOnClickListener(target: self, action: #selector(register))
        btn_wechat.addOnClickListener(target: self, action: #selector(wechat_login))
        btn_forgetpwd.addOnClickListener(target: self, action: #selector(forgetpwd))
        tf_name.text=UserID
        tf_pwd.text=Pwd
        if WXApi.isWXAppInstalled(){
            uv_wechat.isHidden=false
        }else{
            uv_wechat.isHidden=true
        }
        NotificationCenter.default.addObserver(self, selector: #selector(wx_login(noti:)), name: NSNotification.Name("微信登录"), object: nil)
    }
    //MARK:接收通知微信登录
    @objc func wx_login(noti:Notification){
        let resp=noti.object as! SendAuthResp
        if resp.errCode==0{
            //登录成功回调
            AlamofireHelper.post(url: "https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxbaf9ee1d21a481af&secret=13f6d3f2006611c3cfc61ecc0f681d91&code=\(resp.code!)&grant_type=authorization_code", parameters: nil, successHandler: {[weak self](res)in
                HUD.dismiss()
                guard let ss = self else {return}
                let wx_token=Wx_access_token.init(json: res)
                AlamofireHelper.post(url: "https://api.weixin.qq.com/sns/userinfo?access_token=\(wx_token.access_token ?? "")&openid=\(wx_token.openid ?? "")", parameters: nil, successHandler: {[weak self](res)in
                    HUD.dismiss()
                    let wx_userinfo=Wx_userinfo.init(json: res)
                    ss.wxRegister(info: wx_userinfo)
                }){[weak self] (error) in
                    HUD.dismiss()
                }
            }){[weak self] (error) in
                HUD.dismiss()
            }
        } else {
            //登录失败回调
        }
    }
    //MARK:忘记密码
    @objc func forgetpwd(){
        self.navigationController?.pushViewController(ForgetPwdViewController(), animated: true)
    }
    //MARK:微信登录
    @objc func wechat_login(){
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo" //获取用户信息
        req.state = String(Date().timeIntervalSince1970) //随机值即可，这里用时间戳
        WXApi.send(req)
    }
    @objc func codelogin(){
        self.navigationController?.pushViewController(CodeLoginViewController(), animated: true)
    }
    @objc func register(){
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    @objc func login(){
        name=tf_name.text
        pwd=tf_pwd.text
        if name.isEmpty{
            HUD.showText("请输入手机号码")
            return
        }
        if pwd.isEmpty{
            HUD.showText("请输入密码")
            return
        }
        var d = ["userName":name,
                 "passWord":pwd,
                 "RoleType":"6"//角色类型 5平台 6工厂 7师傅 8商城 10代表包含5678
            ] as [String : String]
        AlamofireHelper.post(url: LoginOn, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                UserDefaults.standard.set(res["Data"]["Item2"].stringValue, forKey: "adminToken")
                UserDefaults.standard.set(ss.name, forKey: "UserID")
                UserDefaults.standard.set(ss.pwd, forKey: "Pwd")
                adminToken=UserDefaults.standard.string(forKey: "adminToken")
                UserID=UserDefaults.standard.string(forKey: "UserID")
                Pwd=UserDefaults.standard.string(forKey: "Pwd")
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
            }else{
                ss.navigationController?.pushViewController(BindPhoneViewController(wx_info:info), animated: true)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}



struct Wx_access_token {
    var unionid: String?
    var scope: String?
    var refresh_token: String?
    var access_token: String?
    var expires_in: Int = 0
    var openid: String?
    
    init(json: JSON) {
        unionid = json["unionid"].stringValue
        scope = json["scope"].stringValue
        refresh_token = json["refresh_token"].stringValue
        access_token = json["access_token"].stringValue
        expires_in = json["expires_in"].intValue
        openid = json["openid"].stringValue
    }
}
struct Wx_userinfo {
    var nickname: String?
    var sex: Int = 0
    var country: String?
    var language: String?
    var province: String?
    var city: String?
    var openid: String?
    var unionid: String?
    var headimgurl: String?
    
    init(json: JSON) {
        nickname = json["nickname"].stringValue
        sex = json["sex"].intValue
        country = json["country"].stringValue
        language = json["language"].stringValue
        province = json["province"].stringValue
        city = json["city"].stringValue
        openid = json["openid"].stringValue
        unionid = json["unionid"].stringValue
        headimgurl = json["headimgurl"].stringValue
    }
}
