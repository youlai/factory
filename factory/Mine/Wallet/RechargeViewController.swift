//
//  RechargeViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/29.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class RechargeViewController: UIViewController {

    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var tf_money: UITextField!
    @IBOutlet weak var uv_alipay: UIView!
    @IBOutlet weak var uv_wechat: UIView!
    @IBOutlet weak var check_alipay: UIImageView!
    @IBOutlet weak var check_wechat: UIImageView!
    @IBOutlet weak var btn_recharge: UIButton!
    var payway=1 //1支付宝支付2微信支付
    var money:String! //充值多少
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer().rainbowLayer()
        gradientLayer.frame = btn_recharge.bounds
        self.btn_recharge.layer.insertSublayer(gradientLayer, at: 0)
        self.btn_recharge.clipsToBounds=true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_recharge.layer.cornerRadius=5
        uv_back.addOnClickListener(target: self, action: #selector(back))
        uv_alipay.addOnClickListener(target: self, action: #selector(changeway))
        uv_wechat.addOnClickListener(target: self, action: #selector(changeway))
        btn_recharge.addOnClickListener(target: self, action: #selector(recharge))
        // Do any additional setup after loading the view.
        //MARK:接收支付宝支付通知
        NotificationCenter.default.addObserver(self, selector: #selector(aliPay(noti:)), name: NSNotification.Name("aliPay"), object: nil)
        //MARK:接收微信支付通知
        NotificationCenter.default.addObserver(self, selector: #selector(WXPay(noti:)), name: NSNotification.Name("WXPayNotification"), object: nil)
    }
    @objc func aliPay(noti:Notification){
        let m=noti.object as! (String,String)
        HUD.showText(m.1)
        switch m.0 {
        case "9000":
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "recharge"), object: nil)
            self.navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    @objc func WXPay(noti:Notification){
        let m=noti.object as! Int
        switch m {
        case 0:
            HUD.showText("支付成功")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "recharge"), object: nil)
            self.navigationController?.popViewController(animated: true)
        default:
            HUD.showText("支付失败")
            break
        }
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func recharge(){
        money=tf_money.text
        if money.isEmpty{
            HUD.showText("请输入充值金额")
            return
        }
        if payway==1{
            getOrderStr()
        }else{
            getWXOrderStr()
        }
    }
    @objc func changeway(){
        if payway==1{
            payway=2
            check_alipay.image=UIImage(named: "pay_uncheck")
            check_wechat.image=UIImage(named: "yuangou")
        }else{
            payway=1
            check_alipay.image=UIImage(named: "yuangou")
            check_wechat.image=UIImage(named: "pay_uncheck")
        }
    }
    //MARK:支付宝信息
    func getOrderStr(){
        let d = ["UserID":UserID!,
                 "TotalAmount":money!,
//                 "TotalAmount":"0.01",
                 "Type":"1",
            ] as [String : Any]
        print(d)
        AlamofireHelper.post(url: GetOrderStr, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                let orderString=res["Data"]["Item2"].stringValue
                let appScheme="xigyucs"
                AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme){
                    result in
                }
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:微信信息
    func getWXOrderStr(){
        let d = ["UserID":UserID!,
                 "TotalAmount":money!,
                 "Type":"1",
                 "Style":"iosfactory"
            ] as [String : Any]
        print(d)
        AlamofireHelper.post(url: GetWXOrderStr, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                //调起微信
                let req = PayReq()
                //应用的AppID(固定的)
                req.openID = res["Data"]["Item2"]["appid"].stringValue
                //商户号(固定的)
                req.partnerId = res["Data"]["Item2"]["partnerid"].stringValue
                //扩展字段(固定的)
                req.package = "Sign=WXPay"
                //统一下单返回的预支付交易会话ID
                req.prepayId = res["Data"]["Item2"]["prepayid"].stringValue
                //随机字符串
                req.nonceStr = res["Data"]["Item2"]["noncestr"].stringValue
                //时间戳(10位)
                req.timeStamp = UInt32(res["Data"]["Item2"]["timestamp"].stringValue)!
                //签名
                req.sign = res["Data"]["Item2"]["sign"].stringValue
                WXApi.send(req)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
