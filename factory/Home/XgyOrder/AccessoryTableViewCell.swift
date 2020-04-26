//
//  AccessoryTableViewCell.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/21.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AccessoryTableViewCell: UITableViewCell {
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_count: UILabel!
    @IBOutlet weak var iv_photo1: UIImageView!
    @IBOutlet weak var iv_photo2: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
