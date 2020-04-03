//
//  CateOfxgy.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/15.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CateOfxgy1 {
    var InstallPrice: Int = 0
    var IsUse: String?
    var Level1ID: Int = 0
    var Level1Name: String?
    var Level: Int = 0
    var Version: Int = 0
    var GeInstallPrice: Int = 0
    var BrandName: String?
    var InitPrice: Int = 0
    var ParentName: String?
    var ParentID: Int = 0
    var GeInitPrice: Int = 0
    var page: Int = 0
    var limit: Int = 0
    var BrandID: Int = 0
    var FCategoryName: String?
    var Id: Int = 0
    var FCategoryID: Int = 0
    
    init(json: JSON) {
        InstallPrice = json["InstallPrice"].intValue
        IsUse = json["IsUse"].stringValue
        Level1ID = json["Level1ID"].intValue
        Level1Name = json["Level1Name"].stringValue
        Level = json["Level"].intValue
        Version = json["Version"].intValue
        GeInstallPrice = json["GeInstallPrice"].intValue
        BrandName = json["BrandName"].stringValue
        InitPrice = json["InitPrice"].intValue
        ParentName = json["ParentName"].stringValue
        ParentID = json["ParentID"].intValue
        GeInitPrice = json["GeInitPrice"].intValue
        page = json["page"].intValue
        limit = json["limit"].intValue
        BrandID = json["BrandID"].intValue
        FCategoryName = json["FCategoryName"].stringValue
        Id = json["Id"].intValue
        FCategoryID = json["FCategoryID"].intValue
    }
}
struct CateOfxgy {
    var CategoryID: Int = 0
    var CourseCount: String?
    var SubCategoryName: String?
    var IsUse: String?
    var page: Int = 0
    var BrandCategoryID: Int = 0
    var Imge: String?
    var Id: Int = 0
    var ProductTypeID: Int = 0
    var CategoryName: String?
    var BrandName: String?
    var ProductTypeName: String?
    var SubCategoryID: Int = 0
    var BrandID: Int = 0
    var UserID: String?
    var limit: Int = 0
    var Version: Int = 0

    init(json: JSON) {
        CategoryID = json["CategoryID"].intValue
        CourseCount = json["CourseCount"].stringValue
        SubCategoryName = json["SubCategoryName"].stringValue
        IsUse = json["IsUse"].stringValue
        page = json["page"].intValue
        BrandCategoryID = json["BrandCategoryID"].intValue
        Imge = json["Imge"].stringValue
        Id = json["Id"].intValue
        ProductTypeID = json["ProductTypeID"].intValue
        CategoryName = json["CategoryName"].stringValue
        BrandName = json["BrandName"].stringValue
        ProductTypeName = json["ProductTypeName"].stringValue
        SubCategoryID = json["SubCategoryID"].intValue
        BrandID = json["BrandID"].intValue
        UserID = json["UserID"].stringValue
        limit = json["limit"].intValue
        Version = json["Version"].intValue
    }
}
struct BrandOfxgy {
    var Categorys: String?
    var IsUse: String?
    var Id: Int = 0
    var Version: Int = 0
    var UserID: String?
    var FBrandName: String?
    var FBrandID: Int = 0
    
    init(json: JSON) {
        Categorys = json["Categorys"].stringValue
        IsUse = json["IsUse"].stringValue
        Id = json["Id"].intValue
        Version = json["Version"].intValue
        UserID = json["UserID"].stringValue
        FBrandName = json["FBrandName"].stringValue
        FBrandID = json["FBrandID"].intValue
    }
}
