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
    
    @IBOutlet weak var uv_djgd: UIView!
    @IBOutlet weak var uv_yjgd: UIView!
    @IBOutlet weak var uv_xbgd: UIView!
    @IBOutlet weak var uv_dfj: UIView!
    @IBOutlet weak var uv_zbgd: UIView!
    @IBOutlet weak var uv_ytgd: UIView!
    @IBOutlet weak var uv_gbgd: UIView!
    @IBOutlet weak var uv_ywc: UIView!
    
    @IBOutlet weak var lb_djgd: UILabel!
    @IBOutlet weak var lb_yjgd: UILabel!
    @IBOutlet weak var lb_xbgd: UILabel!
    @IBOutlet weak var lb_dfj: UILabel!
    @IBOutlet weak var lb_zbgd: UILabel!
    @IBOutlet weak var lb_ytgd: UILabel!
    @IBOutlet weak var lb_gbgd: UILabel!
    @IBOutlet weak var lb_ywc: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        messgIsOrNo()
        getUserInfoList()
        getListCategoryContentByCategoryID()
        uv_msg.addOnClickListener(target: self, action: #selector(msg))
        uv_one.addOnClickListener(target: self, action: #selector(toInstallSendOrder))
        uv_two.addOnClickListener(target: self, action: #selector(toRepairSendOrder))
        uv_three.addOnClickListener(target: self, action: #selector(toInstallSendOrder))
        uv_four.addOnClickListener(target: self, action: #selector(toInstallSendOrder))
        uv_bar.border(color: .red, width: 1, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 7)
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
    //MARK:去发安装
        @objc func toInstallSendOrder(){
            self.tabBarController?.navigationController!.pushViewController(Install_SendOrderViewController(), animated: true)
        }
    //MARK:去发维修
    @objc func toRepairSendOrder(){
        self.tabBarController?.navigationController!.pushViewController(Repair_SendOrderViewController(), animated: true)
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
//        self.tabBarController?.navigationController?.pushViewController(V3_MsgViewController(), animated: true)
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
                authenticationView.lb_content.text="您暂时未实名认证，无法进行接单,赶紧去认证吧。"
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
                authenticationView.lb_content.text="您暂时未实名认证，无法进行接单,赶紧去认证吧。"
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
//        self.tabBarController?.navigationController!.pushViewController(V3_CertificationViewController(), animated: true)
        dismisspopview()
    }
    @objc func dismisspopview(){
        popview.dismissView()
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
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:系统消息
    @objc func getListCategoryContentByCategoryID(){
        let d = ["CategoryID":"7",
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
struct mSystemMsg {
    var Content: String?
    var Id: Int = 0
    var Title: String?
    var limit: Int = 0
    var CategoryID: Int = 0
    var Author: String?
    var CategoryContentID: Int = 0
    var IsUse: String?
    var page: Int = 0
    var ParentCategoryID: Int = 0
    var CreateTime: String?
    var Url: String?
    var Version: Int = 0
    var Source: String?
    
    init(json: JSON) {
        Content = json["Content"].stringValue
        Id = json["Id"].intValue
        Title = json["Title"].stringValue
        limit = json["limit"].intValue
        CategoryID = json["CategoryID"].intValue
        Author = json["Author"].stringValue
        CategoryContentID = json["CategoryContentID"].intValue
        IsUse = json["IsUse"].stringValue
        page = json["page"].intValue
        ParentCategoryID = json["ParentCategoryID"].intValue
        CreateTime = json["CreateTime"].stringValue
        Url = json["Url"].stringValue
        Version = json["Version"].intValue
        Source = json["Source"].stringValue
    }
}
