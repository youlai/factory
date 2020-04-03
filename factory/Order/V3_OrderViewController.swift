//
//  V3_OrderViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/20.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit
import Tabman
import Pageboy
class V3_OrderViewController: TabmanViewController,PageboyViewControllerDataSource, TMBarDataSource{
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return vcs.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return vcs[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.at(index: self.index)
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: titles[index])
    }
    
    
    //    init(index:Int){
    //        super.init(nibName: nil, bundle: nil)
    //        self.index=index
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    var vcs:[UIViewController]! = []
    var index:Int!
    var titles = ["待确认","已接待预约", "服务中", "待审核"
        , "待返件", "质保单", "完成待取机",
          "已完成","预约不成功"]
    let statuses = [9,1,2,3,8,4,5,6,7]
    /*
     * 师傅端获取工单列表新接口
     * 师傅端state
     9、远程费申请待确认
     0、待接单
     1、已接待预约
     2、服务中
     3、返件单
     4、质保单
     5、完成待取机
     6、已完成
     7、预约不成功
     8、配件单
     * */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.index=0
        navigationBarNumber()
        //        for index in statuses{
        //              vcs.append(V3_OrderTableViewController(status: index))
        //        }
        vcs.append(SubOrderViewController())
        vcs.append(V3_OrderTableViewController2(status: 1))
        vcs.append(V3_OrderTableViewController3(status: 2))
        vcs.append(V3_OrderTableViewController3(status: 11))
        vcs.append(V3_OrderTableViewController3(status: 8))
        vcs.append(V3_OrderTableViewController3(status: 12))
        vcs.append(V3_OrderTableViewController3(status: 6))
        self.dataSource = self
        
        // Create bar
        let Tbar = TMBar.ButtonBar()
        
        Tbar.layout.transitionStyle = .none // Customize
        // Add to view
        //        addBar(Tbar, dataSource: self, at: .custom(view: bg, layout: { (bar) in
        //            bar.translatesAutoresizingMaskIntoConstraints = false
        //            NSLayoutConstraint.activate([
        //                bar.topAnchor.constraint(equalTo: bg.topAnchor),
        //                bar.centerXAnchor.constraint(equalTo: bg.centerXAnchor)
        //                ])
        //        }))
        Tbar.buttons.customize { (button) in
            button.tintColor = .black
            button.selectedTintColor = "#048CFF".color()
            button.font=UIFont.systemFont(ofSize: 16)
        }
        
        Tbar.indicator.tintColor = "#048CFF".color()
        Tbar.indicator.weight = .custom(value: 1)
        Tbar.layout.contentMode = .intrinsic
        //        Tbar.tintColor = .white
        Tbar.systemBar().backgroundStyle = .blur(style: .dark)
        Tbar.backgroundColor = .white
        //        Tbar.snp.makeConstraints { (make) in
        //            make.height.equalTo(60)
        //        }
        Tbar.layout.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        addBar(Tbar, dataSource: self, at: .top)
        //        addBar(Tbar, dataSource: self, at: .custom(view: bg, layout: nil))
        //        bar.isHidden=true
        //        bg.isHidden=true
        print(kStatusBarHeight)
        //        self.additionalSafeAreaInsets=UIEdgeInsets(top: 110, left: 0, bottom: 0, right: 0)
        print(self.calculateRequiredInsets())
        self.view.backgroundColor=UIColor.white
        self.view.tintColor = .white
        //MARK:接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("接单成功"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("预约成功"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("预约不成功"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("已完成"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("待返件"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("待审核"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("工单数量"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("确认收货"), object: nil)
    }
    //MARK:接收通知刷新接单列表
    @objc func reload(noti:Notification){
        if noti.name.rawValue=="确认收货"{
            self.index=0
            navigationBarNumber()
        }
        if noti.name.rawValue=="接单成功"{
            self.index=1
            navigationBarNumber()
        }
        if noti.name.rawValue=="待审核"{
            self.index=2
            navigationBarNumber()
        }
        if noti.name.rawValue=="预约成功"{
            self.index=2
            navigationBarNumber()
        }
        if noti.name.rawValue=="工单数量"{
            let orderStatus=noti.object as! Int
            switch orderStatus {
            case 13:
                self.index=0
            case 14:
                self.index=0
            case 15:
                self.index=0
            case 1:
                self.index=1
            case 16:
                self.index=1
            case 2:
                self.index=2
            case 11:
                self.index=3
            case 8:
                self.index=4
            case 12:
                self.index=5
            case 6:
                self.index=6
            default:
                self.index=0
            }
            navigationBarNumber()
        }
        vcs.removeAll()
        vcs.append(V3_OrderTableViewController(status: 13))
        vcs.append(V3_OrderTableViewController2(status: 1))
        vcs.append(V3_OrderTableViewController3(status: 2))
        vcs.append(V3_OrderTableViewController3(status: 11))
        vcs.append(V3_OrderTableViewController3(status: 8))
        vcs.append(V3_OrderTableViewController3(status: 12))
        vcs.append(V3_OrderTableViewController3(status: 6))
        self.reloadData()
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //    {
    //      "Info" : "请求(或处理)成功",
    //      "StatusCode" : 200,
    //      "Data" : {
    //        "Item1" : true,
    //        "Item2" : {
    //          "Count4" : 0,
    //          "Count6" : 1,
    //          "Count2" : 0,
    //          "Count3" : 5,
    //          "Count5" : 1,
    //          "Count1" : 0
    //        }
    //      }
    //    }
    /**
     * 各工单数量
     * var Count1 = 0;//待处理数量
     * var Count2 = 0;//待预约数量
     * var Count3 = 0;//待服务数量
     * var Count4 = 0;//待寄件数量
     * var Count5 = 0;//待返件数量
     * var Count6 = 0;//待结算数量
     * */
    @objc func navigationBarNumber(){
        let d = ["UserID":UserID,
                 "page":"1",
                 "limit":"10"
            ] as! [String : String]
        AlamofireHelper.post(url: NavigationBarNumber, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.titles=[
                "待处理(\(res["Data"]["Item2"]["Count1"]))",
                "待预约(\(res["Data"]["Item2"]["Count2"]))",
                "待服务(\(res["Data"]["Item2"]["Count3"]))",
                "待寄件(\(res["Data"]["Item2"]["Count4"]))",
                "待返件(\(res["Data"]["Item2"]["Count5"]))",
                "待结算(\(res["Data"]["Item2"]["Count6"]))",
                "已完结(\(res["Data"]["Item2"]["Count7"]))"
            ]
            ss.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
struct mOrder {
    var SendOrderList = [mSendOrderList]()
    var AppointmentMessage: String?
    var Id: Int = 0
    var QuaMoney: Int = 0
    var Accessory: String?
    var AppraiseDate: String?
    var FactoryComplaint: String?
    var EndRemark: String?
    var IsPressFactory: String?
    var BrandName: String?
    var BeyondDistance: String?
    var DistanceTureOrFalse: Bool?
    var Extra: String?
    var ExtraStr: String?{
        get{
            if self.Extra=="Y"{
                return "/加急"
            }else{
                return ""
            }
        }
    }
    var Distance: Int = 0
    var Address: String?
    var Dimension: String?
    var OrderID: Int = 0
    var SettlementTime: String?
    var ReceiveOrderDate: String?
    var ExtraTime: String?
    var IsReturn: String?
    var SubCategoryName: String?
    var Longitude: String?
    var SettlementMoney: Int = 0
    var BeyondMoney: Double = 0
    var IsSettlement: String?
    var limit: Int = 0
    var IsUse: String?
    var IsCall: String?
    var BrandID: Int = 0
    var AccessoryMemo: String?
    var IsLook: String?
    var ProductTypeID: String?
    var FIsLook: String?
    var MallID: Int = 0
    var BeyondID: Int = 0
    var Version: Int = 0
    var AccessoryMoney: Int = 0
    var ApplyCancel: String?
    var UpdateTime: String?
    var CategoryName: String?
    var AccessorySequency: String?
    var FactoryApplyState: String?
    var DistrictCode: String?
    var OrderMoney: Double = 0
    var terraceMoney: Double = 0
    var TypeName: String?
    var AccessorySearchState: String?
    var AccessoryIsPay: String?
    var WorkerComplaint: String?
    var AccessoryState: String?
    var CategoryID: Int = 0
    var OrderSource: String?
    var IsRecevieGoods: String?
    var ReturnAccessory: String?
    var IsExtraTime: String?
    var AccessoryApplyState: String?
    var Guarantee: String?
    var GuaranteeStr: String?{
        get{
            if self.Guarantee=="Y"{
                return "保内"
            }else{
                return "保外"
            }
        }
    }
    var AccessorySendState: String?
    var QApplyNum: Int = 0
    var SubTypeName: String?
    var ExpressNo: String?
    var State: String?
    var page: Int = 0
    var PostMoney: Int = 0
    var PostPayType: String?
    var IsPay: String?
    var LateTime: String?
    var Service: String?
    var SendAddress: String?
    var SendOrderMsg: String?
    var OrgAppraise: String?
    var SubTypeID: Int = 0
    var NewMoney: String?
    var IsLate: String?
    var ApplyNum: Int = 0
    var BeyondState: String?
    var SubCategoryID: Int = 0
    var ThirdPartyNo: String?
    var PartyNo: String?
    var AreaCode: String?
    var ServiceApplyState: String?
    var Num: Int = 0
    var Grade3: Int = 0
    var IsSendRepair: String?
    var CreateDate: String?
    var RecycleOrderHour: Int = 0
    var ReturnAccessoryMsg: String?
    var AccessoryRefuseState: String?
    var SendUser: String?
    var ProductType: String?
    var ServiceApplyDate: String?
    var AccessoryApplyDate: String?
    var SendOrderState: String?
    var OrderSort: String?
    var StateHtml: String?
    var ExtraFee: Int = 0
    var UserID: String?
    var Grade: Int = 0
    var OrderAccessoryStr: String?
    var AppointmentRefuseState: String?
    var RepairCompleteDate: String?
    var Grade2: Int = 0
    var OrderPayStr: String?
    var OrgSendUser: String?
    var Grade1: Int = 0
    var ProvinceCode: String?
    var Memo: String?
    var TypeID: Int = 0
    var AccessoryServiceMoney: Int = 0
    var AppointmentState: String?
    var InitMoney: Int = 0
    var UserName: String?
    var CityCode: String?
    var AddressBack: String?
    var Phone: String?
    var ServiceMoney: Int = 0
    var AudDate: String?
    var LoginUser: String?
    
    init(json: JSON) {
        SendOrderList = json["SendOrderList"].arrayValue.compactMap({ mSendOrderList(json: $0)})
        AppointmentMessage = json["AppointmentMessage"].stringValue
        Id = json["Id"].intValue
        QuaMoney = json["QuaMoney"].intValue
        Accessory = json["Accessory"].stringValue
        AppraiseDate = json["AppraiseDate"].stringValue
        FactoryComplaint = json["FactoryComplaint"].stringValue
        EndRemark = json["EndRemark"].stringValue
        IsPressFactory = json["IsPressFactory"].stringValue
        BrandName = json["BrandName"].stringValue
        BeyondDistance = json["BeyondDistance"].stringValue
        DistanceTureOrFalse = json["DistanceTureOrFalse"].boolValue
        Extra = json["Extra"].stringValue
        Distance = json["Distance"].intValue
        Address = json["Address"].stringValue
        Dimension = json["Dimension"].stringValue
        OrderID = json["OrderID"].intValue
        SettlementTime = json["SettlementTime"].stringValue
        ReceiveOrderDate = json["ReceiveOrderDate"].stringValue
        ExtraTime = json["ExtraTime"].stringValue
        IsReturn = json["IsReturn"].stringValue
        SubCategoryName = json["SubCategoryName"].stringValue
        Longitude = json["Longitude"].stringValue
        SettlementMoney = json["SettlementMoney"].intValue
        BeyondMoney = json["BeyondMoney"].doubleValue
        IsSettlement = json["IsSettlement"].stringValue
        limit = json["limit"].intValue
        IsUse = json["IsUse"].stringValue
        IsCall = json["IsCall"].stringValue
        BrandID = json["BrandID"].intValue
        AccessoryMemo = json["AccessoryMemo"].stringValue
        IsLook = json["IsLook"].stringValue
        ProductTypeID = json["ProductTypeID"].stringValue
        FIsLook = json["FIsLook"].stringValue
        MallID = json["MallID"].intValue
        BeyondID = json["BeyondID"].intValue
        Version = json["Version"].intValue
        AccessoryMoney = json["AccessoryMoney"].intValue
        ApplyCancel = json["ApplyCancel"].stringValue
        UpdateTime = json["UpdateTime"].stringValue
        CategoryName = json["CategoryName"].stringValue
        AccessorySequency = json["AccessorySequency"].stringValue
        FactoryApplyState = json["FactoryApplyState"].stringValue
        DistrictCode = json["DistrictCode"].stringValue
        OrderMoney = json["OrderMoney"].doubleValue
        terraceMoney = json["terraceMoney"].doubleValue
        TypeName = json["TypeName"].stringValue
        AccessorySearchState = json["AccessorySearchState"].stringValue
        AccessoryIsPay = json["AccessoryIsPay"].stringValue
        WorkerComplaint = json["WorkerComplaint"].stringValue
        AccessoryState = json["AccessoryState"].stringValue
        CategoryID = json["CategoryID"].intValue
        OrderSource = json["OrderSource"].stringValue
        IsRecevieGoods = json["IsRecevieGoods"].stringValue
        ReturnAccessory = json["ReturnAccessory"].stringValue
        IsExtraTime = json["IsExtraTime"].stringValue
        AccessoryApplyState = json["AccessoryApplyState"].stringValue
        Guarantee = json["Guarantee"].stringValue
        AccessorySendState = json["AccessorySendState"].stringValue
        QApplyNum = json["QApplyNum"].intValue
        SubTypeName = json["SubTypeName"].stringValue
        ExpressNo = json["ExpressNo"].stringValue
        State = json["State"].stringValue
        page = json["page"].intValue
        PostMoney = json["PostMoney"].intValue
        PostPayType = json["PostPayType"].stringValue
        IsPay = json["IsPay"].stringValue
        LateTime = json["LateTime"].stringValue
        Service = json["Service"].stringValue
        SendAddress = json["SendAddress"].stringValue
        SendOrderMsg = json["SendOrderMsg"].stringValue
        OrgAppraise = json["OrgAppraise"].stringValue
        SubTypeID = json["SubTypeID"].intValue
        NewMoney = json["NewMoney"].stringValue
        IsLate = json["IsLate"].stringValue
        ApplyNum = json["ApplyNum"].intValue
        BeyondState = json["BeyondState"].stringValue
        SubCategoryID = json["SubCategoryID"].intValue
        ThirdPartyNo = json["ThirdPartyNo"].stringValue
        PartyNo = json["PartyNo"].stringValue
        AreaCode = json["AreaCode"].stringValue
        ServiceApplyState = json["ServiceApplyState"].stringValue
        Num = json["Num"].intValue
        Grade3 = json["Grade3"].intValue
        IsSendRepair = json["IsSendRepair"].stringValue
        CreateDate = json["CreateDate"].stringValue
        RecycleOrderHour = json["RecycleOrderHour"].intValue
        ReturnAccessoryMsg = json["ReturnAccessoryMsg"].stringValue
        AccessoryRefuseState = json["AccessoryRefuseState"].stringValue
        SendUser = json["SendUser"].stringValue
        ProductType = json["ProductType"].stringValue
        ServiceApplyDate = json["ServiceApplyDate"].stringValue
        AccessoryApplyDate = json["AccessoryApplyDate"].stringValue
        SendOrderState = json["SendOrderState"].stringValue
        OrderSort = json["OrderSort"].stringValue
        StateHtml = json["StateHtml"].stringValue
        ExtraFee = json["ExtraFee"].intValue
        UserID = json["UserID"].stringValue
        Grade = json["Grade"].intValue
        OrderAccessoryStr = json["OrderAccessoryStr"].stringValue
        AppointmentRefuseState = json["AppointmentRefuseState"].stringValue
        RepairCompleteDate = json["RepairCompleteDate"].stringValue
        Grade2 = json["Grade2"].intValue
        OrderPayStr = json["OrderPayStr"].stringValue
        OrgSendUser = json["OrgSendUser"].stringValue
        Grade1 = json["Grade1"].intValue
        ProvinceCode = json["ProvinceCode"].stringValue
        Memo = json["Memo"].stringValue
        TypeID = json["TypeID"].intValue
        AccessoryServiceMoney = json["AccessoryServiceMoney"].intValue
        AppointmentState = json["AppointmentState"].stringValue
        InitMoney = json["InitMoney"].intValue
        UserName = json["UserName"].stringValue
        CityCode = json["CityCode"].stringValue
        AddressBack = json["AddressBack"].stringValue
        Phone = json["Phone"].stringValue
        ServiceMoney = json["ServiceMoney"].intValue
        AudDate = json["AudDate"].stringValue
        LoginUser = json["LoginUser"].stringValue
    }
}

