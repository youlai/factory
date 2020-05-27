//
//  HomeViewController.swift
//  MasterWorker
//
//  Created by Apple on 2020/1/13.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit
import PPBadgeViewSwift

class V3_HomeViewController: UIViewController,YLSinglerViewDelegate{
    
    
    //MARK:按钮样式
    func buttonStyle(btn:UIButton){
        btn.layer.cornerRadius=5
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.contentEdgeInsets=UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        btn.snp.makeConstraints{(mask) in
            mask.width.equalTo(100)
            mask.height.equalTo(30)
        }
    }
    var Sysmsg=[mSystemMsg]()//MARK:公告消息
    var userOfxgy:UserOfxgy!
    var popview:ZXPopView!
    var authenticationView:AuthenticationView!
    @IBOutlet weak var usv: UIScrollView!
    @IBOutlet weak var uv_msg: UIView!
    @IBOutlet weak var uv_bar: UIView!
    @IBOutlet weak var uv_news: UIView!
    @IBOutlet weak var uv_neworder: UIView!
    
    @IBOutlet weak var uv_infoview: UIView!
    
    @IBOutlet weak var uv_one: UIView!
    @IBOutlet weak var uv_two: UIView!
    @IBOutlet weak var uv_three: UIView!
    @IBOutlet weak var uv_four: UIView!
    
    @IBOutlet weak var uv_in_one: UIView!
    @IBOutlet weak var uv_in_two: UIView!
    @IBOutlet weak var uv_in_three: UIView!
    @IBOutlet weak var uv_in_four: UIView!
    
    @IBOutlet weak var uv_sygd: UIView!
    @IBOutlet weak var uv_jxgd: UIView!
    @IBOutlet weak var uv_dwcgd: UIView!
    @IBOutlet weak var uv_xbgd: UIView!
    @IBOutlet weak var uv_ywc: UIView!
    @IBOutlet weak var uv_zbgd: UIView!
    @IBOutlet weak var uv_tdgd: UIView!
    
    @IBOutlet weak var uv_dsh: UIView!
    @IBOutlet weak var uv_djj: UIView!
    @IBOutlet weak var uv_dzf: UIView!
    @IBOutlet weak var uv_ywc1: UIView!
    
    @IBOutlet weak var lb_sygd: UILabel!
    @IBOutlet weak var lb_jxgd: UILabel!
    @IBOutlet weak var lb_dwcgd: UILabel!
    @IBOutlet weak var lb_xbgd: UILabel!
    @IBOutlet weak var lb_ywc: UILabel!
    @IBOutlet weak var lb_zbgd: UILabel!
    @IBOutlet weak var lb_tdgd: UILabel!
    
    @IBOutlet weak var lb_dsh: UILabel!
    @IBOutlet weak var lb_djj: UILabel!
    @IBOutlet weak var lb_dzf: UILabel!
    @IBOutlet weak var lb_ywc1: UILabel!
    
    @IBOutlet weak var iv_avator: UIImageView!
    @IBOutlet weak var lb_phone: UILabel!
    @IBOutlet weak var lb_name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        VersionManager.init(appleId: "1509650055",auto: true)
        
        iv_avator.layer.cornerRadius=20
        messgIsOrNo()
        getUserInfoList()
        factoryNavigationBarNumber()
        getListCategoryContentByCategoryID()
        
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.messgIsOrNo()
            strongSelf.getUserInfoList()
            strongSelf.factoryNavigationBarNumber()
            strongSelf.getListCategoryContentByCategoryID()
            strongSelf.usv.mj_header.endRefreshing()
        })
        usv.mj_header = header
        
        //MARK:待审核，待寄件，待支付，已完成
        uv_dsh.addOnClickListener(target: self, action: #selector(toDsh))
        uv_djj.addOnClickListener(target: self, action: #selector(toDjj))
        uv_dzf.addOnClickListener(target: self, action: #selector(toDzf))
        uv_ywc1.addOnClickListener(target: self, action: #selector(toYwc))
        //MARK:所有工单，急需处理，待完成，星标工单，已完成，质保单，退单处理
        uv_sygd.addOnClickListener(target: self, action: #selector(toSygd))
        uv_jxgd.addOnClickListener(target: self, action: #selector(toJxcl))
        uv_dwcgd.addOnClickListener(target: self, action: #selector(toDwc))
        uv_xbgd.addOnClickListener(target: self, action: #selector(toXbgd))
        uv_ywc.addOnClickListener(target: self, action: #selector(toYwc))
        uv_zbgd.addOnClickListener(target: self, action: #selector(toZbd))
        uv_tdgd.addOnClickListener(target: self, action: #selector(toTdcl))
        //MARK:消息
        uv_msg.addOnClickListener(target: self, action: #selector(msg))
        //MARK:发布安装，发布维修，发布送修，批量发单
        uv_one.addOnClickListener(target: self, action: #selector(toInstallSendOrder))
        uv_two.addOnClickListener(target: self, action: #selector(toRepairSendOrder))
        uv_three.addOnClickListener(target: self, action: #selector(toInstallSendOrder))
        uv_four.addOnClickListener(target: self, action: #selector(toInstallSendOrder))
        
        uv_bar.border(color: .red, width: 0.5, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 7)
        uv_infoview.border(color: .lightGray, width: 0.2, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 7)
        shadow(view: uv_one)
        shadow(view: uv_two)
        shadow(view: uv_three)
        shadow(view: uv_four)
        
        uv_in_one.layer.cornerRadius=15
        uv_in_two.layer.cornerRadius=15
        uv_in_three.layer.cornerRadius=15
        uv_in_four.layer.cornerRadius=15
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.uv_neworder.bounds
        self.uv_neworder.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [UIColor.red.cgColor,UIColor.red.cgColor]
        let gradientLocations:[NSNumber] = [0.5,1.0]
        gradientLayer.locations = gradientLocations
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0.5)
        
        //MARK:接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(reloadUserinfo(noti:)), name: NSNotification.Name("更新用户信息"), object: nil)
    }
    //MARK:去待审核
    @objc func toDsh(){
        self.tabBarController?.selectedIndex=1
        //MARK:发送通知
        NotificationCenter.default.post(name: NSNotification.Name("待审核"), object: nil)
    }
    //MARK:去待寄件
    @objc func toDjj(){
        self.tabBarController?.selectedIndex=1
        //MARK:发送通知
        NotificationCenter.default.post(name: NSNotification.Name("待寄件"), object: nil)
    }
    //MARK:去待支付
    @objc func toDzf(){
        self.tabBarController?.selectedIndex=1
        //MARK:发送通知
        NotificationCenter.default.post(name: NSNotification.Name("待支付"), object: nil)
    }
    //MARK:去已完成
    @objc func toYwc(){
        self.tabBarController?.selectedIndex=1
        //MARK:发送通知
        NotificationCenter.default.post(name: NSNotification.Name("已完成"), object: nil)
    }
    //MARK:去所有工单
    @objc func toSygd(){
        self.tabBarController?.selectedIndex=1
        //MARK:发送通知
        NotificationCenter.default.post(name: NSNotification.Name("所有工单"), object: nil)
    }
    //MARK:去急需处理
    @objc func toJxcl(){
        self.tabBarController?.selectedIndex=1
        //MARK:发送通知
        NotificationCenter.default.post(name: NSNotification.Name("急需处理"), object: nil)
    }
    //MARK:去待完成
    @objc func toDwc(){
        self.tabBarController?.selectedIndex=1
        //MARK:发送通知
        NotificationCenter.default.post(name: NSNotification.Name("待完成"), object: nil)
    }
    //MARK:去星标工单
    @objc func toXbgd(){
        self.tabBarController?.selectedIndex=1
        //MARK:发送通知
        NotificationCenter.default.post(name: NSNotification.Name("星标工单"), object: nil)
    }
    //MARK:去质保单
    @objc func toZbd(){
        self.tabBarController?.selectedIndex=1
        //MARK:发送通知
        NotificationCenter.default.post(name: NSNotification.Name("质保单"), object: nil)
    }
    //MARK:去退单处理
    @objc func toTdcl(){
        self.tabBarController?.selectedIndex=1
        //MARK:发送通知
        NotificationCenter.default.post(name: NSNotification.Name("退单处理"), object: nil)
    }
    //MARK:去发安装
    @objc func toInstallSendOrder(){
        if userOfxgy != nil{
            if userOfxgy.IfAuth=="1"{//账号已实名可以发单
                self.tabBarController?.navigationController!.pushViewController(Install_SendOrderViewController(), animated: true)
            }else{
                showpop()
            }
        }
    }
    //MARK:去发维修
    @objc func toRepairSendOrder(){
        if userOfxgy.IfAuth=="1"{//账号已实名可以发单
            self.tabBarController?.navigationController!.pushViewController(Repair_SendOrderViewController(), animated: true)
        }else{
            showpop()
        }
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
    //MARK:接收通知更新用户信息
    @objc func reloadUserinfo(noti:Notification){
        self.getUserInfoList()
    }
    
    //MARK: -- YLSinglerViewDelegate
    func singlerView(_ singlerowView: YLSinglerowView, selectedIndex index: Int) {
        print("点击了第\(index)个数据")
        let item=Sysmsg[index]
        self.tabBarController?.navigationController?.pushViewController(UIWebViewViewController(headtitle: item.Title!, url: item.Content!,type:1), animated: true)
    }
    //MARK:消息
    @objc func msg(){
        self.tabBarController?.navigationController?.pushViewController(V3_MsgViewController(), animated: true)
    }
    //MARK:实名弹框
    @objc func showpop(){
        popview = ZXPopView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        authenticationView=Bundle.main.loadNibNamed("AuthenticationView", owner: nil, options: nil)?[0] as? AuthenticationView
        
        authenticationView.btn_toauth.addOnClickListener(target: self, action: #selector(tocertification))
        authenticationView.btn_cancel.addOnClickListener(target: self, action: #selector(dismisspopview))
        authenticationView.clipsToBounds=true
        authenticationView.layer.cornerRadius=10
        authenticationView.btn_toauth.layer.cornerRadius=5
        authenticationView.btn_cancel.layer.cornerRadius=5
        popview.contenView=authenticationView
        if userOfxgy != nil{
            if userOfxgy.IfAuth!.isEmpty{
                authenticationView.lb_content.text="您暂时未实名认证，无法进行发单,赶紧去认证吧。"
                authenticationView.btn_toauth.setTitle("去实名", for: .normal)
                authenticationView.btn_cancel.setTitle("下次再说", for: .normal)
                authenticationView.btn_toauth.isHidden=false
            }else if userOfxgy.IfAuth=="0"{
                authenticationView.lb_content.text="您的实名信息正在等待管理员审核，预计1个工作日内审核完毕，审核结果会短信通知到您的手机上。"
                authenticationView.btn_cancel.setTitle("好的", for: .normal)
                authenticationView.btn_toauth.isHidden=true
            }else if userOfxgy.IfAuth=="1"{
                authenticationView.lb_content.text="实名通过"
            }else if userOfxgy.IfAuth=="-1"{
                authenticationView.lb_content.text="抱歉，您的实名信息未通过审核，请重新填写资料，有疑问请联系客服。"
                authenticationView.btn_toauth.setTitle("重新认证", for: .normal)
                authenticationView.btn_cancel.setTitle("下次再说", for: .normal)
                authenticationView.btn_toauth.isHidden=false
            }else{
                authenticationView.lb_content.text="您暂时未实名认证，无法进行发单,赶紧去认证吧。"
                authenticationView.btn_toauth.setTitle("去实名", for: .normal)
                authenticationView.btn_cancel.setTitle("下次再说", for: .normal)
                authenticationView.btn_toauth.isHidden=false
            }
        }
        popview.anim = 0
        popview.contenView!.snp.makeConstraints { (make) in
            make.width.equalTo(screenW-20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(200)
            make.center.equalToSuperview()
        }
        popview.showInWindow()
    }
    //MARK:去实名
    @objc func tocertification(){
        self.tabBarController?.navigationController!.pushViewController(CertificationViewController(), animated: true)
        dismisspopview()
    }
    @objc func dismisspopview(){
        popview.dismissView()
    }
    /**
     * 各工单数量
     * var Count1 = 0;//所有工单数量
     * var Count2 = 0;//急需处理数量
     * var Count3 = 0;//待完成数量
     * var Count4 = 0;//已完成数量
     * var Count5 = 0;//质保单数量
     * var Count6 = 0;//退单处理数量
     * var Count7 = 0;//星标工单数量
     * var Count8 = 0;//待审核数量
     * var Count9 = 0;//待寄件数量
     * var Count10 = 0;//待支付数量
     * var Count11= 0;//已完成数量
     * */
    @objc func factoryNavigationBarNumber(){
        let d = ["UserID":UserID,
                 "page":"1",
                 "limit":"10"
            ] as! [String : String]
        AlamofireHelper.post(url: FactoryNavigationBarNumber, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.lb_sygd.text="(\(res["Data"]["Item2"]["Count1"]))"
            ss.lb_jxgd.text="(\(res["Data"]["Item2"]["Count2"]))"
            ss.lb_dwcgd.text="(\(res["Data"]["Item2"]["Count3"]))"
            ss.lb_ywc.text="(\(res["Data"]["Item2"]["Count4"]))"
            ss.lb_zbgd.text="(\(res["Data"]["Item2"]["Count5"]))"
            ss.lb_tdgd.text="(\(res["Data"]["Item2"]["Count6"]))"
            ss.lb_xbgd.text="(\(res["Data"]["Item2"]["Count7"]))"
            ss.lb_dsh.text="(\(res["Data"]["Item2"]["Count8"]))"
            ss.lb_djj.text="(\(res["Data"]["Item2"]["Count9"]))"
            ss.lb_dzf.text="(\(res["Data"]["Item2"]["Count10"]))"
            ss.lb_ywc1.text="(\(res["Data"]["Item2"]["Count11"]))"
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:获取个人信息
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
            if ss.userOfxgy != nil{
                if ss.userOfxgy.IfAuth == ""{//账号未实名
                    ss.showpop()
                }
            }
            if ss.userOfxgy.Avator != nil{
                ss.iv_avator.setImage(path: URL.init(string: "https://img.xigyu.com/Pics/Avator/\(ss.userOfxgy.Avator!)")!)
            }
            ss.getmessageBytype()
            ss.lb_phone.text = "\(ss.userOfxgy.UserID!.prefix(3))****\(ss.userOfxgy.UserID!.suffix(4))"
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
    //MARK:系统消息
    @objc func getListCategoryContentByCategoryID(){
        let d = ["CategoryID":"3",
                 "limit":"5",
                 "page":"1"
        ]
        print(d)
        AlamofireHelper.post(url: GetListCategoryContentByCategoryID, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.Sysmsg=res["Data"]["data"].arrayValue.compactMap({ mSystemMsg(json: $0)})
            var titles=[String]()
            var tags=[String]()
            for item in ss.Sysmsg{
                titles.append(item.Title!)
                tags.append("公告")
            }
            let singlerView = YLSinglerowView(frame:CGRect(x: 0, y: 0, width: ss.uv_news.width, height: ss.uv_news.height), scrollStyle: .up, roundTime: 5, contentSource: titles,tagSource: tags)
            singlerView.delegate = self
            singlerView.backColor = .white
            singlerView.contentTextColor = .black
            ss.uv_news.addSubview(singlerView)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:消息是否已读
    @objc func messgIsOrNo(){
        let d = ["UserID":UserID,
                 "limit":"1",
                 "page":"1"
            ] as! [String : String]
        AlamofireHelper.post(url: MessgIsOrNo, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                ss.uv_msg.pp.addDot()
                ss.uv_msg.pp.moveBadge(x: -15, y: 10)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
//MARK:用户信息
struct UserOfxgy {
    var emergencyContact: String?
    var teamNumber: Int?
    var IsOrNoTruck: String?
    var IsOrNoTruckStr: String?{
        get{
            if self.IsOrNoTruck=="Y"{
                return "有"
            }else{
                return "无"
            }
        }
    }
    var IDCard: String?
    var TotalMoney: Float = 0
    var DistrictCode: String?
    var Address: String?
    var Sex: String?
    var Version: Int = 0
    var limit: Int = 0
    var Con: Int = 0
    var PassWord: String?
    var page: Int = 0
    var LoginCount: Int = 0
    var RoleName: String?
    var NickName: String?
    var `Type`: String?
    var EndDate: String?
    var AreaCode: String?
    var TopRank: String?
    var RemainMoney: Float = 0
    var Dimension: String?
    var Id: String?
    var DepositMoney: Float = 0
    var AuthMessage: String?
    var ParentUserID: String?
    var UserID: String?
    var Phone: String?
    var PayPassWord: String?
    var FrozenMoney: Float = 0.0
    var Skills: String?
    var CityCode: String?
    var TrueName: String?
    var IsUse: String?
    var DepositFrozenMoney: Float = 0
    var CreateDate: String?
    var ProvinceCode: String?
    var RoleID: Int = 0
    var Avator: String?
    var Longitude: String?
    var AccountID: Int = 0
    var LastLoginDate: String?
    var StartDate: String?
    var IfAuth: String?
    var IfAuthStr: String?{
        get{
            if self.IfAuth=="0"{
                return "实名待审核"
            }else if self.IfAuth=="1"{
                return "已实名认证"
            }else{
                return "未实名认证"
            }
        }
    }
    var ServiceTotalOrderNum:Int=0
    var ServiceTotalMoney:Float=0
    var ServiceComplaintNum:Int=0
    var UnfinishedAmount:Double=0
    
    init(json: JSON) {
        emergencyContact = json["emergencyContact"].stringValue
        teamNumber = json["teamNumber"].intValue
        IsOrNoTruck = json["IsOrNoTruck"].stringValue
        ServiceTotalOrderNum = json["ServiceTotalOrderNum"].intValue
        ServiceTotalMoney = json["ServiceTotalMoney"].floatValue
        ServiceComplaintNum = json["ServiceComplaintNum"].intValue
        UnfinishedAmount = json["UnfinishedAmount"].doubleValue
        IDCard = json["IDCard"].stringValue
        TotalMoney = json["TotalMoney"].floatValue
        DistrictCode = json["DistrictCode"].stringValue
        Address = json["Address"].stringValue
        Sex = json["Sex"].stringValue
        Version = json["Version"].intValue
        limit = json["limit"].intValue
        Con = json["Con"].intValue
        PassWord = json["PassWord"].stringValue
        page = json["page"].intValue
        LoginCount = json["LoginCount"].intValue
        RoleName = json["RoleName"].stringValue
        NickName = json["NickName"].stringValue
        Type = json["Type"].stringValue
        EndDate = json["EndDate"].stringValue
        AreaCode = json["AreaCode"].stringValue
        TopRank = json["TopRank"].stringValue
        RemainMoney = json["RemainMoney"].floatValue
        Dimension = json["Dimension"].stringValue
        Id = json["Id"].stringValue
        DepositMoney = json["DepositMoney"].floatValue
        AuthMessage = json["AuthMessage"].stringValue
        ParentUserID = json["ParentUserID"].stringValue
        UserID = json["UserID"].stringValue
        Phone = json["Phone"].stringValue
        PayPassWord = json["PayPassWord"].stringValue
        FrozenMoney = json["FrozenMoney"].floatValue
        Skills = json["Skills"].stringValue
        CityCode = json["CityCode"].stringValue
        TrueName = json["TrueName"].stringValue
        IsUse = json["IsUse"].stringValue
        DepositFrozenMoney = json["DepositFrozenMoney"].floatValue
        CreateDate = json["CreateDate"].stringValue
        ProvinceCode = json["ProvinceCode"].stringValue
        RoleID = json["RoleID"].intValue
        Avator = json["Avator"].stringValue
        Longitude = json["Longitude"].stringValue
        AccountID = json["AccountID"].intValue
        LastLoginDate = json["LastLoginDate"].stringValue
        StartDate = json["StartDate"].stringValue
        IfAuth = json["IfAuth"].stringValue
    }
}
