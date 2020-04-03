//
//  XgyOrder.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import SwiftyJSON
struct XgyOrder {
    var AreaCode: String?
    var page: Int = 0
    var BeyondDistance: String?
    var RepairCompleteDate: String?
    var AccessoryRefuseState: String?
    var OrderSource: String?
    var IsPressFactory: String?
    var AppointmentRefuseState: String?
    var AccessoryMemo: String?
    var AccessoryServiceMoney: Int = 0
    var Dimension: String?
    var AppraiseDate: String?
    var Service: String?
    var BrandName: String?
    var AddressBack: String?
    var RecycleOrderHour: Int = 0
    var ApplyNum: Int = 0
    var Distance: Int = 0
    var Extra: String?
    var DistrictCode: String?
    var AppointmentMessage: String?
    var ExtraTime: String?
    var ProductTypeID: String?
    var AudDate: String?
    var Accessory: String?
    var MallID: Int = 0
    var NewMoney: String?
    var limit: Int = 0
    var AppointmentState: String?
    var OrgAppraise: String?
    var Grade1: Int = 0
    var ServiceApplyState: String?
    var EndRemark: String?
    var IsReturn: String?
    var ReturnAccessoryMsg: String?
    var Id: Int = 0
    var CreateDate: String?
    var FIsLook: String?
    var SendOrderState: String?
    var UserName: String?
    var IsUse: String?
    var BrandID: Int = 0
    var UserID: String?
    var Memo: String?
    var Grade3: Int = 0
    var FactoryComplaint: String?
    var IsExtraTime: String?
    var LoginUser: String?
    var SubTypeName: String?
    var ExpressNo: String?
    var Version: Int = 0
    var CityCode: String?
    var ProductType: String?
    var TypeID: Int = 0
    var IsLook: String?
    var AccessoryMoney: Int = 0
    var QuaMoney: Int = 0
    var InitMoney: Int = 0
    var Address: String?
    var Phone: String?
    var PostMoney: Int = 0
    var WorkerComplaint: String?
    var Grade: Int = 0
    var OrderID: Int = 0
    var QApplyNum: Int = 0
    var ServiceMoney: Int = 0
    var OrderMoney: Int = 0
    var IsSendRepair: String?
    var AccessorySearchState: String?
    var OrderPayStr: String?
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
    var TypeName: String?
    var AccessorySequency: String?
    var StateHtml: String?
    var ProvinceCode: String?
    var PostPayType: String?
    var Num: Int = 0
    var SubTypeID: Int = 0
    var OrgSendUser: String?
    var SendOrderMsg: String?
    var ThirdPartyNo: String?
    var OrderSort: String?
    var FactoryApplyState: String?
    var LateTime: String?
    var CategoryID: Int = 0
    var SubCategoryID: Int = 0
    var AccessorySendState: String?
    var ReceiveOrderDate: String?
    var Longitude: String?
    var UpdateTime: String?
    var ApplyCancel: String?
    var AccessoryApplyState: String?
    var AccessoryApplyStateStr: String?{
        get{
            var str=""
            switch self.AccessoryApplyState {
            case "0":
                str="配件待审核"
            case "1":
                str="配件审核通过"
            case "-1":
                str="配件已拒"
            default:
                str=""
            }
            return str
        }
    }
    var SubCategoryName: String?
    var ReturnAccessory: String?
    var CategoryName: String?
    var AccessoryApplyDate: String?
    var ExtraFee: Int = 0
    var AccessoryState: String?
    var BeyondMoney: Int = 0
    var IsPay: String?
    var Grade2: Int = 0
    var BeyondID: Int = 0
    var BeyondState: String?
    var BeyondStateStr: String?{
        get{
            var str=""
            switch self.BeyondState {
            case "0":
                str="远程费待审核"
            case "1":
                str="远程费审核通过"
            case "-1":
                str="远程费已拒"
            default:
                str=""
            }
            return str
        }
    }
    var IsRecevieGoods: String?
    var ServiceApplyDate: String?
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
    var AccessoryIsPay: String?
    var SendUser: String?
    var IsLate: String?
    
    init(json: JSON) {
        AreaCode = json["AreaCode"].stringValue
        page = json["page"].intValue
        BeyondDistance = json["BeyondDistance"].stringValue
        RepairCompleteDate = json["RepairCompleteDate"].stringValue
        AccessoryRefuseState = json["AccessoryRefuseState"].stringValue
        OrderSource = json["OrderSource"].stringValue
        IsPressFactory = json["IsPressFactory"].stringValue
        AppointmentRefuseState = json["AppointmentRefuseState"].stringValue
        AccessoryMemo = json["AccessoryMemo"].stringValue
        AccessoryServiceMoney = json["AccessoryServiceMoney"].intValue
        Dimension = json["Dimension"].stringValue
        AppraiseDate = json["AppraiseDate"].stringValue
        Service = json["Service"].stringValue
        BrandName = json["BrandName"].stringValue
        AddressBack = json["AddressBack"].stringValue
        RecycleOrderHour = json["RecycleOrderHour"].intValue
        ApplyNum = json["ApplyNum"].intValue
        Distance = json["Distance"].intValue
        Extra = json["Extra"].stringValue
        DistrictCode = json["DistrictCode"].stringValue
        AppointmentMessage = json["AppointmentMessage"].stringValue
        ExtraTime = json["ExtraTime"].stringValue
        ProductTypeID = json["ProductTypeID"].stringValue
        AudDate = json["AudDate"].stringValue
        Accessory = json["Accessory"].stringValue
        MallID = json["MallID"].intValue
        NewMoney = json["NewMoney"].stringValue
        limit = json["limit"].intValue
        AppointmentState = json["AppointmentState"].stringValue
        OrgAppraise = json["OrgAppraise"].stringValue
        Grade1 = json["Grade1"].intValue
        ServiceApplyState = json["ServiceApplyState"].stringValue
        EndRemark = json["EndRemark"].stringValue
        IsReturn = json["IsReturn"].stringValue
        ReturnAccessoryMsg = json["ReturnAccessoryMsg"].stringValue
        Id = json["Id"].intValue
        CreateDate = json["CreateDate"].stringValue
        FIsLook = json["FIsLook"].stringValue
        SendOrderState = json["SendOrderState"].stringValue
        UserName = json["UserName"].stringValue
        IsUse = json["IsUse"].stringValue
        BrandID = json["BrandID"].intValue
        UserID = json["UserID"].stringValue
        Memo = json["Memo"].stringValue
        Grade3 = json["Grade3"].intValue
        FactoryComplaint = json["FactoryComplaint"].stringValue
        IsExtraTime = json["IsExtraTime"].stringValue
        LoginUser = json["LoginUser"].stringValue
        SubTypeName = json["SubTypeName"].stringValue
        ExpressNo = json["ExpressNo"].stringValue
        Version = json["Version"].intValue
        CityCode = json["CityCode"].stringValue
        ProductType = json["ProductType"].stringValue
        TypeID = json["TypeID"].intValue
        IsLook = json["IsLook"].stringValue
        AccessoryMoney = json["AccessoryMoney"].intValue
        QuaMoney = json["QuaMoney"].intValue
        InitMoney = json["InitMoney"].intValue
        Address = json["Address"].stringValue
        Phone = json["Phone"].stringValue
        PostMoney = json["PostMoney"].intValue
        WorkerComplaint = json["WorkerComplaint"].stringValue
        Grade = json["Grade"].intValue
        OrderID = json["OrderID"].intValue
        QApplyNum = json["QApplyNum"].intValue
        ServiceMoney = json["ServiceMoney"].intValue
        OrderMoney = json["OrderMoney"].intValue
        IsSendRepair = json["IsSendRepair"].stringValue
        AccessorySearchState = json["AccessorySearchState"].stringValue
        OrderPayStr = json["OrderPayStr"].stringValue
        Guarantee = json["Guarantee"].stringValue
        TypeName = json["TypeName"].stringValue
        AccessorySequency = json["AccessorySequency"].stringValue
        StateHtml = json["StateHtml"].stringValue
        ProvinceCode = json["ProvinceCode"].stringValue
        PostPayType = json["PostPayType"].stringValue
        Num = json["Num"].intValue
        SubTypeID = json["SubTypeID"].intValue
        OrgSendUser = json["OrgSendUser"].stringValue
        SendOrderMsg = json["SendOrderMsg"].stringValue
        ThirdPartyNo = json["ThirdPartyNo"].stringValue
        OrderSort = json["OrderSort"].stringValue
        FactoryApplyState = json["FactoryApplyState"].stringValue
        LateTime = json["LateTime"].stringValue
        CategoryID = json["CategoryID"].intValue
        SubCategoryID = json["SubCategoryID"].intValue
        AccessorySendState = json["AccessorySendState"].stringValue
        ReceiveOrderDate = json["ReceiveOrderDate"].stringValue
        Longitude = json["Longitude"].stringValue
        UpdateTime = json["UpdateTime"].stringValue
        ApplyCancel = json["ApplyCancel"].stringValue
        AccessoryApplyState = json["AccessoryApplyState"].stringValue
        SubCategoryName = json["SubCategoryName"].stringValue
        ReturnAccessory = json["ReturnAccessory"].stringValue
        CategoryName = json["CategoryName"].stringValue
        AccessoryApplyDate = json["AccessoryApplyDate"].stringValue
        ExtraFee = json["ExtraFee"].intValue
        AccessoryState = json["AccessoryState"].stringValue
        BeyondMoney = json["BeyondMoney"].intValue
        IsPay = json["IsPay"].stringValue
        Grade2 = json["Grade2"].intValue
        BeyondID = json["BeyondID"].intValue
        BeyondState = json["BeyondState"].stringValue
        IsRecevieGoods = json["IsRecevieGoods"].stringValue
        ServiceApplyDate = json["ServiceApplyDate"].stringValue
        State = json["State"].stringValue
        AccessoryIsPay = json["AccessoryIsPay"].stringValue
        SendUser = json["SendUser"].stringValue
        IsLate = json["IsLate"].stringValue
    }
}
