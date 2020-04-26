//
//  MarginViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/2.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class MarginViewController: UIViewController {
    
    @IBOutlet weak var btn_withdraw: UIButton!
    @IBOutlet weak var btn_recharge: UIButton!
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var uv_one: UIView!//MARK:缴纳保证金记录
    @IBOutlet weak var uv_two: UIView!//MARK:提取保证金记录
    
    var tag=1000
    var payway=1
    var popview: ZXPopView!
    var marginView: MarginView!
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_withdraw.layer.cornerRadius=5
        btn_recharge.layer.cornerRadius=5
        uv_back.addOnClickListener(target: self, action: #selector(back))
        btn_withdraw.addOnClickListener(target: self, action: #selector(toWithdraw))
        btn_recharge.addOnClickListener(target: self, action: #selector(showpop))
        uv_one.addOnClickListener(target: self, action: #selector(toOne))
        uv_two.addOnClickListener(target: self, action: #selector(toTwo))
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:缴纳保证金记录
    @objc func toOne(){
        self.navigationController?.pushViewController(DepositRecordViewController(type:0), animated: true)
    }
    //MARK:提取保证金记录
    @objc func toTwo(){
        self.navigationController?.pushViewController(DepositRecordViewController(type:1), animated: true)
    }
    //MARK:提取保证金
    @objc func toWithdraw(){
        self.navigationController?.pushViewController(WithDrawViewController(), animated: true)
    }
    //MARK:缴纳保证金
    @objc func showpop(){
        popview = ZXPopView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        marginView=Bundle.main.loadNibNamed("MarginView", owner: nil, options: nil)?[0] as? MarginView
        
        marginView.lb_money.text="我要缴纳\(tag)元保证金"
        
        marginView.btn_submit.addOnClickListener(target: self, action: #selector(submit))
        marginView.btn_cancel.addOnClickListener(target: self, action: #selector(dismisspopview))
        
        marginView.uv_500.addOnClickListener(target: self, action: #selector(change(ges:)))
        marginView.uv_1000.addOnClickListener(target: self, action: #selector(change(ges:)))
        marginView.uv_1500.addOnClickListener(target: self, action: #selector(change(ges:)))
        marginView.uv_3000.addOnClickListener(target: self, action: #selector(change(ges:)))
        marginView.uv_5000.addOnClickListener(target: self, action: #selector(change(ges:)))
        marginView.uv_10000.addOnClickListener(target: self, action: #selector(change(ges:)))
        marginView.uv_alipay.addOnClickListener(target: self, action: #selector(changePayWay(ges:)))
        marginView.uv_wechat.addOnClickListener(target: self, action: #selector(changePayWay(ges:)))
        
        marginView.clipsToBounds=true
        marginView.layer.cornerRadius=10
        marginView.btn_submit.layer.cornerRadius=5
        marginView.btn_cancel.layer.cornerRadius=5
        popview.contenView=marginView
        popview.anim = 0
        popview.contenView!.snp.makeConstraints { (make) in
            make.width.equalTo(screenW-20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(383)
            make.center.equalToSuperview()
        }
        popview.showInWindow()
    }
    //MARK:确认充值
    @objc func submit(){
        if payway==1{
            getOrderStr()
        }else{
            getWXOrderStr()
        }
    }
    @objc func dismisspopview(){
        tag=1000
        payway=1
        popview.dismissView()
    }
    //MARK:面额切换
    @objc func change(ges:UITapGestureRecognizer){
        marginView.iv_500.image=UIImage(named: "circle")
        marginView.iv_1000.image=UIImage(named: "circle")
        marginView.iv_1500.image=UIImage(named: "circle")
        marginView.iv_3000.image=UIImage(named: "circle")
        marginView.iv_5000.image=UIImage(named: "circle")
        marginView.iv_10000.image=UIImage(named: "circle")
        tag=ges.view!.tag
        switch tag {
        case 500:
            marginView.iv_500.image=UIImage(named: "yuangou")
        case 1000:
            marginView.iv_1000.image=UIImage(named: "yuangou")
        case 1500:
            marginView.iv_1500.image=UIImage(named: "yuangou")
        case 3000:
            marginView.iv_3000.image=UIImage(named: "yuangou")
        case 5000:
            marginView.iv_5000.image=UIImage(named: "yuangou")
        case 10000:
            marginView.iv_10000.image=UIImage(named: "yuangou")
        default:
            marginView.iv_1000.image=UIImage(named: "yuangou")
        }
        marginView.lb_money.text="我要缴纳\(tag)元保证金"
    }
    //MARK:支付方式切换
    @objc func changePayWay(ges:UITapGestureRecognizer){
        marginView.iv_alipay.image=UIImage(named: "circle")
        marginView.iv_wechat.image=UIImage(named: "circle")
        
        payway=ges.view!.tag
        if payway==1{//支付宝
            marginView.iv_alipay.image=UIImage(named: "yuangou")
        }else{//微信
            marginView.iv_wechat.image=UIImage(named: "yuangou")
        }
    }
    /**
    * 充值信息
    *
    * @param UserID      账号
    * @param TotalAmount 金额
    * @param Type        1余额 2 诚意金 3订单支付
    * @param Style       工厂传factory 商城mall
    * @return
    */
    //MARK:支付宝
    func getOrderStr(){
        let d = ["UserID":UserID!,
                 "TotalAmount":tag,
                 "Type":"2",
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
    /**
    * 充值信息
    *
    * @param UserID      账号
    * @param TotalAmount 金额
    * @param Type        1余额 2 诚意金 3订单支付
    * @param Style       工厂传factory 商城mall
    * @return
    */
    //MARK:微信
    func getWXOrderStr(){
        let d = ["UserID":UserID!,
                 "TotalAmount":tag,
                 "Type":"2",
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
