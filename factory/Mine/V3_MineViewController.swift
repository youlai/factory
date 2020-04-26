//
//  V3_MineViewController.swift
//  MasterWorker
//
//  Created by Apple on 2019/8/29.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class V3_MineViewController: UIViewController{
    var userOfxgy:UserOfxgy!
    @IBOutlet weak var uv_wallet: UIView!
    @IBOutlet weak var uv_brand: UIView!
    @IBOutlet weak var uv_type: UIView!
    @IBOutlet weak var uv_mingxi: UIView!
    @IBOutlet weak var uv_feedback: UIView!
    @IBOutlet weak var uv_service: UIView!
    @IBOutlet weak var uv_aboutus: UIView!
    @IBOutlet weak var uv_info: UIView!
    @IBOutlet weak var uv_setting: UIView!
    @IBOutlet weak var iv_avatar: UIImageView!
    @IBOutlet weak var usv: UIScrollView!
    
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var btn_recharge: UIButton!
    @IBOutlet weak var lb_count: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserInfoList()
        
        iv_avatar.layer.cornerRadius=30
        iv_avatar.addOnClickListener(target: self, action: #selector(info))
        uv_info.addOnClickListener(target: self, action: #selector(info))
        uv_wallet.addOnClickListener(target: self, action: #selector(mywallet))
        uv_brand.addOnClickListener(target: self, action: #selector(addBrand))
        uv_type.addOnClickListener(target: self, action: #selector(addType))
        uv_mingxi.addOnClickListener(target: self, action: #selector(toMingxi))
        uv_feedback.addOnClickListener(target: self, action: #selector(feedback))
        uv_service.addOnClickListener(target: self, action: #selector(callphone))
        uv_aboutus.addOnClickListener(target: self, action: #selector(aboutus))
        uv_setting.addOnClickListener(target: self, action: #selector(setting))
        btn_recharge.addOnClickListener(target: self, action: #selector(toRecharge))
        buttonStyle(btn: btn_recharge)
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.getUserInfoList()
            strongSelf.usv.mj_header.endRefreshing()
        })
        usv.mj_header = header
        //MARK:接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("更新用户信息"), object: nil)
    }
    //MARK:按钮样式
    func buttonStyle(btn:UIButton){
        btn.border(color: UIColor.lightGray, width: 0.5, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 3)
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.contentEdgeInsets=UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        btn.snp.makeConstraints{(mask) in
            mask.height.equalTo(30)
        }
    }
    //MARK:接收通知更新用户信息
    @objc func reload(noti:Notification){
        self.getUserInfoList()
    }
    //MARK:个人资料
    @objc func info(){
        self.tabBarController?.navigationController?.pushViewController(V3_PersonalInfoViewController(), animated: true)
    }
    //MARK:充值
    @objc func toRecharge(){
        self.tabBarController?.navigationController?.pushViewController(RechargeViewController(), animated: true)
    }
    //MARK:我的钱包
    @objc func mywallet(){
        self.tabBarController?.navigationController?.pushViewController(F_WalletViewController(), animated: true)
    }
    //MARK:添加品牌
    @objc func addBrand(){
        self.tabBarController?.navigationController?.pushViewController(BrandViewController(), animated: true)
    }
    //MARK:添加型号
    @objc func addType(){
        self.tabBarController?.navigationController?.pushViewController(TypeViewController(), animated: true)
    }
    //MARK:意见反馈
    @objc func feedback(){
        self.tabBarController?.navigationController?.pushViewController(FeedbackViewController(), animated: true)
    }
    //MARK:消费明细
    @objc func toMingxi(){
        self.navigationController?.pushViewController(RechargeRecordViewController(State: "2"), animated: true)
    }
    //MARK:客服电话
    @objc func callphone(){
        //拨打电话
        UIApplication.shared.open(URL(string: "tel://4006262365")!, options: [:], completionHandler: { (result) in
            print(result)
        })
    }
    //MARK:设置
    @objc func setting(){
        self.tabBarController?.navigationController?.pushViewController(V3_SettingViewController(), animated: true)
    }
    //MARK:关于我们
    @objc func aboutus(){
        self.tabBarController?.navigationController?.pushViewController(AboutUsViewController(), animated: true)
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
                ss.iv_avatar.setImage(path: URL.init(string: "https://img.xigyu.com/Pics/Avator/\(ss.userOfxgy.Avator!)")!)
            }
            ss.getmessageBytype()
            ss.getUserOrderNum()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:获取公司信息
    @objc func getmessageBytype(){
        let d = ["UserID":UserID
            ] as! [String : String]
        AlamofireHelper.post(url: GetmessageBytype, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                ss.lb_name.text=res["Data"]["Item2"]["CompanyName"].stringValue
            }else{
               ss.lb_name.text="未认证"
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:获取已发工单数量
    @objc func getUserOrderNum(){
        let d = ["UserID":UserID
            ] as! [String : String]
        AlamofireHelper.post(url: GetUserOrderNum, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.lb_count.text="已发工单数：\(res["Data"]["count"].stringValue)"
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
