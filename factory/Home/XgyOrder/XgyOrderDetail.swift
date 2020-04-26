//
//  XgyOrder.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import SwiftyJSON
struct mXgyOrderDetail {
    var AppraiseDate: String?
    var OrderID: Int = 0
    var InitMoney: Int = 0
    var AccessorySequency: String?
    var AccessorySequencyStr: String?{
        get{
            var status=""
            switch self.AccessoryState {
            case "0":
                status="厂家寄件"
            case "1":
                status="师傅自购件"
            case "2":
                status="用户自购件"
            default:
                status=""
            }
            return status
        }
    }
    var PostPayType: String?
    var IsUse: String?
    var AccessorySendState: String?
    var AccessorySendStateStr: String?{
        get{
            if self.AccessorySendState=="Y"{
                return "是"
            }else{
                return "否"
            }
        }
    }
    var ThirdPartyNo: String?
    var IsExtraTime: String?
    var Grade: Int = 0
    var BeyondID: Int = 0
    var StateHtml: String?
    var OrderMoney: Int = 0
    var AccessoryApplyDate: String?
    var ReturnAccessoryMsg: String?
    var ServiceApplyDate: String?
    var IsSendRepair: String?
    var Extra: String?
    var IsReturn: String?
    var BrandName: String?
    var IsLate: String?
    var LateTime: String?
    var Longitude: String?
    var Accessory: String?
    var ProductTypeID: String?
    var UserID: String?
    var SubCategoryName: String?
    var QApplyNum: Int = 0
    var AppointmentState: String?
    var Grade1: Int = 0
    var DistrictCode: String?
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
    var Num: Int = 0
    var AccessoryServiceMoney: Int = 0
    var Service: String?
    var IsPressFactory: String?
    var ExtraFee: Int = 0
    var BeyondMoney: Int = 0
    var Grade3: Int = 0
    var OrderSort: String?
    var State: String?
    var StateStr: String?{
        get{
            var status=""
            switch self.State {
            case "-2":
                status="申请废除工单"
            case "-1":
                status="退单处理"
            case "0":
                status="待审核"
            case "1":
                status="待接单"
            case "2":
                status="已接单待联系客户"
            case "3":
                status="已联系客户待服务"
            case "4":
                status="服务中"
            case "5":
                status="服务完成"
            case "6":
                status="待评价"
            case "7":
                status="已完成"
            default:
                status=""
            }
            return status
        }
    }
    var CategoryName: String?
    var FIsLook: String?
    var WorkerComplaint: String?
    var QuaMoney: Int = 0
    var AppointmentMessage: String?
    var UserName: String?
    var ReturnAccessory: String?
    var SubCategoryID: Int = 0
    var ExpressNo: String?
    var AudDate: String?
    var SubTypeID: Int = 0
    var OrderSource: String?
    var ApplyNum: Int = 0
    var OrderComplaintDetail = [mOrderComplaintDetail]()
    var SendOrderList = [mSendOrderList]()
    var OrderAccessroyDetail = [mOrderAccessroyDetail]()
    var OrderBeyondImg = [mOrderBeyondImg]()
    var LeavemessageList = [mLeavemessageList]()
    var PostMoney: Int = 0
    var Id: Int = 0
    var ProvinceCode: String?
    var CategoryID: Int = 0
    var ServiceMoney: Int = 0
    var Distance: Int = 0
    var BeyondDistance: String?
    var NewMoney: String?
    var Address: String?
    var AccessorySearchState: String?
    var CityCode: String?
    var Phone: String?
    var LoginUser: String?
    var AccessoryIsPay: String?
    var AccessoryMoney: Int = 0
    var TypeID: Int = 0
    var Grade2: Int = 0
    var Memo: String?
    var AreaCode: String?
    var AddressBack: String?
    var BeyondState: String?
    var SendUser: String?
    var IsLook: String?
    var AppointmentRefuseState: String?
    var Version: Int = 0
    var ApplyCancel: String?
    var SendOrderMsg: String?
    var BrandID: Int = 0
    var FactoryComplaint: String?
    var ProductType: String?
    var IsPay: String?
    var SubTypeName: String?
    var page: Int = 0
    var CreateDate: String?
    var Dimension: String?
    var SendOrderState: String?
    var IsRecevieGoods: String?
    var ReceiveOrderDate: String?
    var ExtraTime: String?
    var EndRemark: String?
    var AccessoryState: String?
    var OrgAppraise: String?
    var limit: Int = 0
    var FactoryApplyState: String?
    var AccessoryRefuseState: String?
    var UpdateTime: String?
    var RepairCompleteDate: String?
    var AccessoryApplyState: String?
    var TypeName: String?
    var AccessoryMemo: String?
    var RecycleOrderHour: Int = 0
    var MallID: Int = 0
    var OrderPayStr: String?
    var ServiceApplyState: String?
    var OrgSendUser: String?
    var AccessoryAndServiceApplyState: String?
    
    init(json: JSON) {
        AppraiseDate = json["AppraiseDate"].stringValue
        OrderID = json["OrderID"].intValue
        InitMoney = json["InitMoney"].intValue
        AccessorySequency = json["AccessorySequency"].stringValue
        PostPayType = json["PostPayType"].stringValue
        IsUse = json["IsUse"].stringValue
        AccessorySendState = json["AccessorySendState"].stringValue
        ThirdPartyNo = json["ThirdPartyNo"].stringValue
        IsExtraTime = json["IsExtraTime"].stringValue
        Grade = json["Grade"].intValue
        BeyondID = json["BeyondID"].intValue
        StateHtml = json["StateHtml"].stringValue
        OrderMoney = json["OrderMoney"].intValue
        AccessoryApplyDate = json["AccessoryApplyDate"].stringValue
        ReturnAccessoryMsg = json["ReturnAccessoryMsg"].stringValue
        ServiceApplyDate = json["ServiceApplyDate"].stringValue
        IsSendRepair = json["IsSendRepair"].stringValue
        Extra = json["Extra"].stringValue
        IsReturn = json["IsReturn"].stringValue
        BrandName = json["BrandName"].stringValue
        IsLate = json["IsLate"].stringValue
        LateTime = json["LateTime"].stringValue
        Longitude = json["Longitude"].stringValue
        Accessory = json["Accessory"].stringValue
        ProductTypeID = json["ProductTypeID"].stringValue
        UserID = json["UserID"].stringValue
        SubCategoryName = json["SubCategoryName"].stringValue
        QApplyNum = json["QApplyNum"].intValue
        AppointmentState = json["AppointmentState"].stringValue
        Grade1 = json["Grade1"].intValue
        DistrictCode = json["DistrictCode"].stringValue
        Guarantee = json["Guarantee"].stringValue
        Num = json["Num"].intValue
        AccessoryServiceMoney = json["AccessoryServiceMoney"].intValue
        Service = json["Service"].stringValue
        IsPressFactory = json["IsPressFactory"].stringValue
        ExtraFee = json["ExtraFee"].intValue
        BeyondMoney = json["BeyondMoney"].intValue
        Grade3 = json["Grade3"].intValue
        OrderSort = json["OrderSort"].stringValue
        State = json["State"].stringValue
        CategoryName = json["CategoryName"].stringValue
        FIsLook = json["FIsLook"].stringValue
        WorkerComplaint = json["WorkerComplaint"].stringValue
        QuaMoney = json["QuaMoney"].intValue
        AppointmentMessage = json["AppointmentMessage"].stringValue
        UserName = json["UserName"].stringValue
        ReturnAccessory = json["ReturnAccessory"].stringValue
        SubCategoryID = json["SubCategoryID"].intValue
        ExpressNo = json["ExpressNo"].stringValue
        AudDate = json["AudDate"].stringValue
        SubTypeID = json["SubTypeID"].intValue
        OrderSource = json["OrderSource"].stringValue
        ApplyNum = json["ApplyNum"].intValue
        OrderComplaintDetail = json["OrderComplaintDetail"].arrayValue.compactMap({ mOrderComplaintDetail(json: $0)})
        SendOrderList = json["SendOrderList"].arrayValue.compactMap({ mSendOrderList(json: $0)})
        OrderAccessroyDetail = json["OrderAccessroyDetail"].arrayValue.compactMap({ mOrderAccessroyDetail(json: $0)})
        OrderBeyondImg = json["OrderBeyondImg"].arrayValue.compactMap({ mOrderBeyondImg(json: $0)})
        LeavemessageList = json["LeavemessageList"].arrayValue.compactMap({ mLeavemessageList(json: $0)})
        PostMoney = json["PostMoney"].intValue
        Id = json["Id"].intValue
        ProvinceCode = json["ProvinceCode"].stringValue
        CategoryID = json["CategoryID"].intValue
        ServiceMoney = json["ServiceMoney"].intValue
        Distance = json["Distance"].intValue
        BeyondDistance = json["BeyondDistance"].stringValue
        NewMoney = json["NewMoney"].stringValue
        Address = json["Address"].stringValue
        AccessorySearchState = json["AccessorySearchState"].stringValue
        CityCode = json["CityCode"].stringValue
        Phone = json["Phone"].stringValue
        LoginUser = json["LoginUser"].stringValue
        AccessoryIsPay = json["AccessoryIsPay"].stringValue
        AccessoryMoney = json["AccessoryMoney"].intValue
        TypeID = json["TypeID"].intValue
        Grade2 = json["Grade2"].intValue
        Memo = json["Memo"].stringValue
        AreaCode = json["AreaCode"].stringValue
        AddressBack = json["AddressBack"].stringValue
        BeyondState = json["BeyondState"].stringValue
        SendUser = json["SendUser"].stringValue
        IsLook = json["IsLook"].stringValue
        AppointmentRefuseState = json["AppointmentRefuseState"].stringValue
        Version = json["Version"].intValue
        ApplyCancel = json["ApplyCancel"].stringValue
        SendOrderMsg = json["SendOrderMsg"].stringValue
        BrandID = json["BrandID"].intValue
        FactoryComplaint = json["FactoryComplaint"].stringValue
        ProductType = json["ProductType"].stringValue
        IsPay = json["IsPay"].stringValue
        SubTypeName = json["SubTypeName"].stringValue
        page = json["page"].intValue
        CreateDate = json["CreateDate"].stringValue
        Dimension = json["Dimension"].stringValue
        SendOrderState = json["SendOrderState"].stringValue
        IsRecevieGoods = json["IsRecevieGoods"].stringValue
        ReceiveOrderDate = json["ReceiveOrderDate"].stringValue
        ExtraTime = json["ExtraTime"].stringValue
        EndRemark = json["EndRemark"].stringValue
        AccessoryState = json["AccessoryState"].stringValue
        OrgAppraise = json["OrgAppraise"].stringValue
        limit = json["limit"].intValue
        FactoryApplyState = json["FactoryApplyState"].stringValue
        AccessoryRefuseState = json["AccessoryRefuseState"].stringValue
        UpdateTime = json["UpdateTime"].stringValue
        RepairCompleteDate = json["RepairCompleteDate"].stringValue
        AccessoryApplyState = json["AccessoryApplyState"].stringValue
        TypeName = json["TypeName"].stringValue
        AccessoryMemo = json["AccessoryMemo"].stringValue
        RecycleOrderHour = json["RecycleOrderHour"].intValue
        MallID = json["MallID"].intValue
        OrderPayStr = json["OrderPayStr"].stringValue
        ServiceApplyState = json["ServiceApplyState"].stringValue
        OrgSendUser = json["OrgSendUser"].stringValue
        AccessoryAndServiceApplyState = json["AccessoryAndServiceApplyState"].stringValue
    }
}

struct mOrderComplaintDetail {
    var limit: Int = 0
    var ComplaintID: Int = 0
    var UserID: String?
    var OrderID: Int = 0
    var page: Int = 0
    var CreateTime: String?
    var `Type`: String?
    var Id: Int = 0
    var IsUse: String?
    var Version: Int = 0
    var Content: String?
    
    init(json: JSON) {
        limit = json["limit"].intValue
        ComplaintID = json["ComplaintID"].intValue
        UserID = json["UserID"].stringValue
        OrderID = json["OrderID"].intValue
        page = json["page"].intValue
        CreateTime = json["CreateTime"].stringValue
        Type = json["Type"].stringValue
        Id = json["Id"].intValue
        IsUse = json["IsUse"].stringValue
        Version = json["Version"].intValue
        Content = json["Content"].stringValue
    }
}
struct mSendOrderList {
    var Phone: String?
    var AreaCode: String?
    var OrderID: Int = 0
    var CreateDate: String?
    var SendID: Int = 0
    var CategoryID: Int = 0
    var UserName: String?
    var Memo: String?
    var Id: Int = 0
    var ServiceDate2: String?
    var Guarantee: String?
    var ServiceDate: String?
    var page: Int = 0
    var Address: String?
    var UpdateDate: String?
    var LoginUser: String?
    var State: String?
    var BrandID: Int = 0
    var AppointmentMessage: String?
    var AppointmentState: String?
    var ProvinceCode: String?
    var UserID: String?
    var BrandName: String?
    var SubTypeName: String?
    var CategoryName: String?
    var CityCode: String?
    var Version: Int = 0
    var limit: Int = 0
    var IsUse: String?
    var SubTypeID: Int = 0
    var ProductType: String?
    
    init(json: JSON) {
        Phone = json["Phone"].stringValue
        AreaCode = json["AreaCode"].stringValue
        OrderID = json["OrderID"].intValue
        CreateDate = json["CreateDate"].stringValue
        SendID = json["SendID"].intValue
        CategoryID = json["CategoryID"].intValue
        UserName = json["UserName"].stringValue
        Memo = json["Memo"].stringValue
        Id = json["Id"].intValue
        ServiceDate2 = json["ServiceDate2"].stringValue
        Guarantee = json["Guarantee"].stringValue
        ServiceDate = json["ServiceDate"].stringValue
        page = json["page"].intValue
        Address = json["Address"].stringValue
        UpdateDate = json["UpdateDate"].stringValue
        LoginUser = json["LoginUser"].stringValue
        State = json["State"].stringValue
        BrandID = json["BrandID"].intValue
        AppointmentMessage = json["AppointmentMessage"].stringValue
        AppointmentState = json["AppointmentState"].stringValue
        ProvinceCode = json["ProvinceCode"].stringValue
        UserID = json["UserID"].stringValue
        BrandName = json["BrandName"].stringValue
        SubTypeName = json["SubTypeName"].stringValue
        CategoryName = json["CategoryName"].stringValue
        CityCode = json["CityCode"].stringValue
        Version = json["Version"].intValue
        limit = json["limit"].intValue
        IsUse = json["IsUse"].stringValue
        SubTypeID = json["SubTypeID"].intValue
        ProductType = json["ProductType"].stringValue
    }
}
struct mOrderAccessroyDetail {
    var SizeID: Int = 0
    var TypeID: String?
    var QApplyNum: Int = 0
    var ApplyNum: Int = 0
    var CreateTime: String?
    var IsUse: String?
    var Photo2: String?
    var Quantity: Int = 0
    var Id: Int = 0
    var OrderID: Int = 0
    var SendState: String?
    var AccessoryState: String?
    var NeedPlatformAuth: String?
    var Photo1: String?
    var State: String?
    var FAccessoryName: String?
    var ExpressNo: String?
    var FCategoryID: Int = 0
    var IsPay: String?
    var Version: Int = 0
    var FAccessoryID: Int = 0
    var DiscountPrice: Int = 0
    var Relation: String?
    var AccessoryID: Int = 0
    var Price: Int = 0
    
    init(json: JSON) {
        SizeID = json["SizeID"].intValue
        TypeID = json["TypeID"].stringValue
        QApplyNum = json["QApplyNum"].intValue
        ApplyNum = json["ApplyNum"].intValue
        CreateTime = json["CreateTime"].stringValue
        IsUse = json["IsUse"].stringValue
        Photo2 = json["Photo2"].stringValue
        Quantity = json["Quantity"].intValue
        Id = json["Id"].intValue
        OrderID = json["OrderID"].intValue
        SendState = json["SendState"].stringValue
        AccessoryState = json["AccessoryState"].stringValue
        NeedPlatformAuth = json["NeedPlatformAuth"].stringValue
        Photo1 = json["Photo1"].stringValue
        State = json["State"].stringValue
        FAccessoryName = json["FAccessoryName"].stringValue
        ExpressNo = json["ExpressNo"].stringValue
        FCategoryID = json["FCategoryID"].intValue
        IsPay = json["IsPay"].stringValue
        Version = json["Version"].intValue
        FAccessoryID = json["FAccessoryID"].intValue
        DiscountPrice = json["DiscountPrice"].intValue
        Relation = json["Relation"].stringValue
        AccessoryID = json["AccessoryID"].intValue
        Price = json["Price"].intValue
    }
}
struct mOrderBeyondImg {
    var limit: Int = 0
    var CreateTime: String?
    var Url: String?
    var OrderID: Int = 0
    var Version: Int = 0
    var OrderBeyondImgID: Int = 0
    var page: Int = 0
    var IsUse: String?
    var Id: Int = 0
    
    init(json: JSON) {
        limit = json["limit"].intValue
        CreateTime = json["CreateTime"].stringValue
        Url = json["Url"].stringValue
        OrderID = json["OrderID"].intValue
        Version = json["Version"].intValue
        OrderBeyondImgID = json["OrderBeyondImgID"].intValue
        page = json["page"].intValue
        IsUse = json["IsUse"].stringValue
        Id = json["Id"].intValue
    }
}
struct mLeavemessageList {
    var limit: Int = 0
    var factoryIslook: String?
    var Id: Int = 0
    var photo: String?
    var UserName: String?
    var IsUse: String?
    var UserId: String?
    var Content: String?
    var LeaveMessageId: Int = 0
    var platformIslook: String?
    var OrderId: Int = 0
    var workerIslook: String?
    var page: Int = 0
    var Version: Int = 0
    var CreateDate: String?
    var `Type`: String?

    init(json: JSON) {
        limit = json["limit"].intValue
        factoryIslook = json["factoryIslook"].stringValue
        Id = json["Id"].intValue
        photo = json["photo"].stringValue
        UserName = json["UserName"].stringValue
        IsUse = json["IsUse"].stringValue
        UserId = json["UserId"].stringValue
        Content = json["Content"].stringValue
        LeaveMessageId = json["LeaveMessageId"].intValue
        platformIslook = json["platformIslook"].stringValue
        OrderId = json["OrderId"].intValue
        workerIslook = json["workerIslook"].stringValue
        page = json["page"].intValue
        Version = json["Version"].intValue
        CreateDate = json["CreateDate"].stringValue
        Type = json["Type"].stringValue
    }
}
