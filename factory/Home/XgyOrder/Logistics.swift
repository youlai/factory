//
//  Logistics.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/20.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import SwiftyJSON
struct mLogistics {
    var content: String?
    var time: String?
    
    init(json: JSON) {
        content = json["content"].stringValue
        time = json["time"].stringValue
    }
}
