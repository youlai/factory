//
//  JYTagViewCell.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/6.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

class JYTagViewCell: UIView {
    
    var identifier:String?
    
    var textLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    convenience init(identifier: String) {
        self.init()
        backgroundColor = .white
        self.identifier = identifier
        self.addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = self.bounds
    }
}
