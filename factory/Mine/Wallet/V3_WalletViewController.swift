//
//  V3_WalletViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/2.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class V3_WalletViewController: UIViewController {

    @IBOutlet weak var btn_withdraw: UIButton!
    @IBOutlet weak var btn_recharge: UIButton!
    @IBOutlet weak var lb_CanCarry: UILabel!
    @IBOutlet weak var lb_TotalRevenue: UILabel!
    @IBOutlet weak var lb_WithdrawalOf: UILabel!
    @IBOutlet weak var lb_ToBeConfirmed: UILabel!
    @IBOutlet weak var lb_QualityMoney: UILabel!
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var uv_bg: UIView!
    @IBOutlet weak var uv_card: UIView!
    
    var userOfxgy:UserOfxgy!
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer().rainbowLayer()
        gradientLayer.frame = uv_bg.bounds
        self.uv_bg.layer.insertSublayer(gradientLayer, at: 0)
        self.uv_bg.clipsToBounds=true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfoList()
        toBepresent()
        uv_back.addOnClickListener(target: self, action: #selector(back))
        btn_withdraw.addOnClickListener(target: self, action: #selector(withdraw))
        btn_recharge.addOnClickListener(target: self, action: #selector(recharge))
        uv_card.addOnClickListener(target: self, action: #selector(toCard))
        //先边框
        uv_bg.layer.borderWidth = 0.3
        uv_bg.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        //中阴影
        uv_bg.layer.shadowColor = UIColor.black.cgColor
        uv_bg.layer.shadowOpacity = 0.5//不透明度
        uv_bg.layer.shadowRadius = 3.0//设置阴影所照射的范围
        uv_bg.layer.shadowOffset = CGSize.init(width: 0, height: 0)// 设置阴影的偏移量
        
        //后设置圆角
        uv_bg.layer.cornerRadius=10
        btn_recharge.layer.cornerRadius=5
        btn_withdraw.layer.cornerRadius=5
        
        
//        CAGradientLayer:0x11651e0a0; position = CGPoint (207 189); bounds = CGRect (0 0; 394 150); allowsGroupOpacity = YES; endPoint = CGPoint (1 0); startPoint = CGPoint (0 0);
        //MARK:接收支付宝支付通知
        NotificationCenter.default.addObserver(self, selector: #selector(getUserInfoList), name: NSNotification.Name("recharge"), object: nil)
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func withdraw(){
        if userOfxgy == nil{
            return
        }
        self.navigationController?.pushViewController(WithDrawViewController(balance: userOfxgy.TotalMoney-userOfxgy.FrozenMoney), animated: true)
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
            ss.lb_TotalRevenue.text="￥\(String(format:"%.2f",ss.userOfxgy.UnfinishedAmount))"
            ss.lb_ToBeConfirmed.text="￥\(String(format:"%.2f",ss.userOfxgy.ServiceTotalMoney))"
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
            
            ss.lb_WithdrawalOf.text="￥\(String(format:"%.2f",res["Data"]["Item2"]["data"].stringValue))"
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
