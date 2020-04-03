//
//  WithDrawViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/29.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class WithDrawViewController: UIViewController {
    
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var lb_choose: UILabel!
    @IBOutlet weak var lb_bankname: UILabel!
    @IBOutlet weak var lb_cardno: UILabel!
    @IBOutlet weak var lb_balance: UILabel!
    @IBOutlet weak var uv_choose: UIView!
    @IBOutlet weak var uv_card: UIView!
    @IBOutlet weak var iv_bankicon: UIImageView!
    @IBOutlet weak var tf_money: UITextField!
    @IBOutlet weak var btn_withdraw: UIButton!
    var money:String! //金额
    var CardNo="" //卡号
    var balance:Float //卡号
    init(balance:Float){
        self.balance=balance
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer().rainbowLayer()
        gradientLayer.frame = btn_withdraw.bounds
        self.btn_withdraw.layer.insertSublayer(gradientLayer, at: 0)
        self.btn_withdraw.clipsToBounds=true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lb_balance.text="可用余额￥\(balance)"
        btn_withdraw.layer.cornerRadius=5
        uv_back.addOnClickListener(target: self, action: #selector(back))
        btn_withdraw.addOnClickListener(target: self, action: #selector(getIDCardImg))
        uv_choose.addOnClickListener(target: self, action: #selector(choosecard))
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name("choosecard"), object: nil)
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func update(noti: Notification){
        let card=(noti.object as!MyCard)
        lb_choose.isHidden=true
        uv_card.isHidden=false
        lb_bankname.text=card.PayInfoName
        lb_cardno.text="尾号\(card.PayNo!.suffix(4))"
        CardNo=card.PayNo!
        switch card.PayInfoName {
        case "光大银行":
            iv_bankicon.image=UIImage(named: "guangda")
        case "广发银行股份有限公司":
            iv_bankicon.image=UIImage(named: "guangfa")
        case "工商银行":
            iv_bankicon.image=UIImage(named: "gongshang")
        case "中国工商银行":
            iv_bankicon.image=UIImage(named: "gongshang")
        case "华夏银行":
            iv_bankicon.image=UIImage(named: "huaxia")
        case "中国建设银行":
            iv_bankicon.image=UIImage(named: "jianshe")
        case "建设银行":
            iv_bankicon.image=UIImage(named: "jianshe")
        case "中国交通银行":
            iv_bankicon.image=UIImage(named: "jiaotong")
        case "民生银行":
            iv_bankicon.image=UIImage(named: "minsheng")
        case "宁波银行":
            iv_bankicon.image=UIImage(named: "ningbo")
        case "农业银行":
            iv_bankicon.image=UIImage(named: "nongye")
        case "中国农业银行贷记卡":
            iv_bankicon.image=UIImage(named: "nongye")
        case "浦发银行":
            iv_bankicon.image=UIImage(named: "pufa")
        case "兴业银行":
            iv_bankicon.image=UIImage(named: "xinye")
        case "邮政储蓄银行":
            iv_bankicon.image=UIImage(named: "youzheng")
        case "邮储银行":
            iv_bankicon.image=UIImage(named: "youzheng")
        case "招商银行":
            iv_bankicon.image=UIImage(named: "zhaoshang")
        case "浙商银行":
            iv_bankicon.image=UIImage(named: "zheshang")
        case "中国银行":
            iv_bankicon.image=UIImage(named: "zhongguo")
        case "中信银行":
            iv_bankicon.image=UIImage(named: "zhongxin")
        default:
            iv_bankicon.image=UIImage(named: "zhongxin")
        }
    }
    @objc func choosecard(){
        self.navigationController?.pushViewController(MyCardViewController(choose: true), animated: true)
    }
    
    @objc func withDraw(){
        money=tf_money.text
        if money.isEmpty{
            HUD.showText("请输入提现金额")
            return
        }
        if CardNo.isEmpty{
            HUD.showText("请选择银行卡")
            return
        }
        let d = ["UserID":UserID!,
                 "DrawMoney":money!,
                 "CardNo":CardNo
            ] as [String : Any]
        print(d)
        AlamofireHelper.post(url: WithDraw, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                HUD.showText(res["Data"]["Item2"].stringValue)
                ss.navigationController?.popViewController(animated: true)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:获取身份证照片
    @objc func getIDCardImg(){
        let d = ["UserID":UserID
            ] as! [String : String]
        AlamofireHelper.post(url: GetIDCardImg, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"].arrayValue.count != 3{
                ss.unComplete()
            }else{
                ss.withDraw()
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:实名信息不完善
    @objc func unComplete(){
        let alertVC : UIAlertController = UIAlertController.init(title: "提示", message: "您实名信息不完善，不能提现，是否去完善并提现", preferredStyle: .alert)
        let falseAA : UIAlertAction = UIAlertAction.init(title: "否", style: .cancel, handler: nil)
        let trueAA : UIAlertAction = UIAlertAction.init(title: "是", style: .default) { (alertAction) in
//            self.navigationController?.pushViewController(CompleteCertificationViewController(), animated: true)
        }
        alertVC.addAction(falseAA)
        alertVC.addAction(trueAA)
        self.present(alertVC, animated: true, completion: nil)
    }
}
