//
//  F_WalletViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/2.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class F_WalletViewController: UIViewController {

    @IBOutlet weak var btn_withdraw: UIButton!
    @IBOutlet weak var btn_recharge: UIButton!
    @IBOutlet weak var lb_CanCarry: UILabel!
    @IBOutlet weak var lb_TotalMoney: UILabel!
    @IBOutlet weak var lb_FrozenMoney: UILabel!
    @IBOutlet weak var lb_QualityMoney: UILabel!
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var uv_bg: UIView!
    @IBOutlet weak var uv_recharge: UIView!
    @IBOutlet weak var uv_danliang: UIView!
    @IBOutlet weak var uv_dongjie: UIView!
    @IBOutlet weak var uv_mingxi: UIView!
    @IBOutlet weak var uv_fapiao: UIView!
    
    var userOfxgy:UserOfxgy!
    override func viewDidLayoutSubviews() {
//        let gradientLayer = CAGradientLayer().rainbowLayer()
//        gradientLayer.frame = uv_bg.bounds
//        self.uv_bg.layer.insertSublayer(gradientLayer, at: 0)
//        self.uv_bg.clipsToBounds=true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfoList()
        toBepresent()
        uv_back.addOnClickListener(target: self, action: #selector(back))
        uv_recharge.addOnClickListener(target: self, action: #selector(toRecharge))
        uv_danliang.addOnClickListener(target: self, action: #selector(toOrderRecord))
        uv_dongjie.addOnClickListener(target: self, action: #selector(toFrozenRecord))
        uv_mingxi.addOnClickListener(target: self, action: #selector(toMingxi))
        uv_fapiao.addOnClickListener(target: self, action: #selector(toRecharge))
        btn_withdraw.addOnClickListener(target: self, action: #selector(withdraw))
        btn_recharge.addOnClickListener(target: self, action: #selector(recharge))
        shadow(view: uv_bg)
        shadow(view: uv_recharge)
        shadow(view: uv_danliang)
        shadow(view: uv_dongjie)
        shadow(view: uv_mingxi)
        shadow(view: uv_fapiao)
        btn_recharge.layer.cornerRadius=5
        btn_withdraw.layer.cornerRadius=5
        
        
//        CAGradientLayer:0x11651e0a0; position = CGPoint (207 189); bounds = CGRect (0 0; 394 150); allowsGroupOpacity = YES; endPoint = CGPoint (1 0); startPoint = CGPoint (0 0);
        //MARK:接收支付宝支付通知
        NotificationCenter.default.addObserver(self, selector: #selector(getUserInfoList), name: NSNotification.Name("recharge"), object: nil)
    }
    //MARK:阴影圆角
    @objc func shadow(view:UIView){
        //先边框
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        //中阴影
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5//不透明度
        view.layer.shadowRadius = 1.0//设置阴影所照射的范围
        view.layer.shadowOffset = CGSize.init(width: 0, height: 0)// 设置阴影的偏移量
        
        //后设置圆角
        view.layer.cornerRadius=5
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:充值记录
    @objc func toRecharge(){
        self.navigationController?.pushViewController(RechargeRecordViewController(State: "1"), animated: true)
    }
    //MARK:单量记录
    @objc func toOrderRecord(){
        self.navigationController?.pushViewController(SendOrderRecordViewController(), animated: true)
    }
    //MARK:冻结金额
    @objc func toFrozenRecord(){
        self.navigationController?.pushViewController(FrozenRecordViewController(), animated: true)
    }
    //MARK:消费明细
    @objc func toMingxi(){
        self.navigationController?.pushViewController(RechargeRecordViewController(State: "2"), animated: true)
    }
    @objc func withdraw(){
        if userOfxgy == nil{
            return
        }
        self.navigationController?.pushViewController(MarginViewController(), animated: true)
    }
    @objc func recharge(){
        self.navigationController?.pushViewController(RechargeViewController(), animated: true)
    }
    @objc func toCard(){
        self.navigationController?.pushViewController(MyCardViewController(choose: false), animated: true)
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
//            ss.lb_CanCarry.text="￥\(ss.userOfxgy.TotalMoney-ss.userOfxgy.FrozenMoney)"
//            ss.lb_TotalRevenue.text="￥\(ss.userOfxgy.UnfinishedAmount)"
//            ss.lb_ToBeConfirmed.text="￥\(ss.userOfxgy.ServiceTotalMoney)"
//            ss.lb_QualityMoney.text="￥\(ss.userOfxgy.DepositMoney)"
            ss.lb_CanCarry.text="￥\(String(format:"%.2f",ss.userOfxgy.TotalMoney-ss.userOfxgy.FrozenMoney))"
            ss.lb_TotalMoney.text="￥\(String(format:"%.2f",ss.userOfxgy.TotalMoney))"
            ss.lb_FrozenMoney.text="￥\(String(format:"%.2f",ss.userOfxgy.FrozenMoney))"
            ss.lb_QualityMoney.text="￥\(String(format:"%.2f",ss.userOfxgy.DepositMoney))"
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:查询待提现
    @objc func toBepresent(){
        let d = ["UserID":UserID,
                 "limit":"1"
            ] as! [String : String]
        AlamofireHelper.post(url: ToBepresent, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            
//            ss.lb_WithdrawalOf.text="￥\(String(format:"%.2f",res["Data"]["Item2"]["data"].stringValue))"
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
