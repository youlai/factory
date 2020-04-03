//
//  XgyOrder.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import SwiftyJSON
struct mOrderRecord {
    var StateName: String?
    var CreateDate: String?
    var Id: Int = 0
    var State: String?
    var StateHtml: String?
    var Version: Int = 0
    var RecordID: Int = 0
    var IsUse: String?
    var OrderID: Int = 0
    
    init(json: JSON) {
        StateName = json["StateName"].stringValue
        CreateDate = json["CreateDate"].stringValue
        Id = json["Id"].intValue
        State = json["State"].stringValue
        StateHtml = json["StateHtml"].stringValue
        Version = json["Version"].intValue
        RecordID = json["RecordID"].intValue
        IsUse = json["IsUse"].stringValue
        OrderID = json["OrderID"].intValue
    }
}
