//
//  WalletViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/2.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {

    @IBOutlet weak var btn_withdraw: UIButton!
    @IBOutlet weak var btn_share: UIButton!
    @IBOutlet weak var btn_recharge: UIButton!
    @IBOutlet weak var lb_coincount: UILabel!
    @IBOutlet weak var iv_eye: UIImageView!
    @IBOutlet weak var lb_money: UILabel!
    @IBOutlet weak var iv_avator: UIImageView!
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var uv_coin: UIView!
    @IBOutlet weak var uv_record: UIView!
    @IBOutlet weak var uv_top: UIView!
    @IBOutlet weak var uv_card: UIView!
    var userOfxgy:UserOfxgy!
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfoList()
        uv_back.addOnClickListener(target: self, action: #selector(back))
        iv_eye.addOnClickListener(target: self, action: #selector(eye))
        btn_share.addOnClickListener(target: self, action: #selector(presentcoin))
        btn_withdraw.addOnClickListener(target: self, action: #selector(withdraw))
        btn_recharge.addOnClickListener(target: self, action: #selector(recharge))
        uv_record.addOnClickListener(target: self, action: #selector(record))
        uv_card.addOnClickListener(target: self, action: #selector(card))
        //先边框
        uv_top.layer.borderWidth = 0.3
        uv_top.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        //中阴影
        uv_top.layer.shadowColor = UIColor.black.cgColor
        //UIColor.init(hexColor: "A5A5A5").cgColor
        uv_top.layer.shadowOpacity = 0.5//不透明度
        uv_top.layer.shadowRadius = 3.0//设置阴影所照射的范围
        uv_top.layer.shadowOffset = CGSize.init(width: 0, height: 0)// 设置阴影的偏移量
        
        //后设置圆角
        uv_top.layer.cornerRadius=10
        btn_share.layer.cornerRadius=5
        btn_recharge.layer.cornerRadius=5
        btn_withdraw.layer.cornerRadius=5
        iv_avator.layer.cornerRadius=30
        //MARK:接收支付宝支付通知
        NotificationCenter.default.addObserver(self, selector: #selector(getUserInfoList), name: NSNotification.Name("recharge"), object: nil)
    }
    @objc func eye(){
        print(Eye)
        if Eye{
            Eye=false
            UserDefaults.standard.set(false, forKey: "Eye")
            iv_eye.image=UIImage(named: "eye_close")
            lb_money.text="****"
            lb_coincount.text="西瓜币余额 ****"
        }else{
            Eye=true
            UserDefaults.standard.set(true, forKey: "Eye")
            iv_eye.image=UIImage(named: "eye_open")
            if userOfxgy==nil{
                return
            }
            lb_money.text="￥\(userOfxgy.TotalMoney-userOfxgy.FrozenMoney)"
            lb_coincount.text="西瓜币余额 ￥\(userOfxgy.Con)"
        }
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func presentcoin(){
        self.navigationController?.pushViewController(PresentViewController(), animated: true)
    }
    @objc func card(){
        self.navigationController?.pushViewController(MyCardViewController(choose: false), animated: true)
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
    @objc func record(){
        self.navigationController?.pushViewController(WithDrawRecordViewController(index: 0), animated: true)
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
            if ss.userOfxgy.Avator != nil{
                ss.iv_avator.setImage(path: URL.init(string: "https://img.xigyu.com/Pics/Avator/\(ss.userOfxgy.Avator!)")!)
            }
            Eye=UserDefaults.standard.bool(forKey: "Eye")
            if !Eye{
                ss.iv_eye.image=UIImage(named: "eye_close")
                ss.lb_money.text="****"
                ss.lb_coincount.text="西瓜币余额 ****"
            }else{
                ss.iv_eye.image=UIImage(named: "eye_open")
                ss.lb_money.text="￥\(ss.userOfxgy.TotalMoney-ss.userOfxgy.FrozenMoney)"
                ss.lb_coincount.text="西瓜币余额 ￥\(ss.userOfxgy.Con)"
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
