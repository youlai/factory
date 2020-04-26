//
//  CardTableViewCell.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/26.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class RechargeRecordTableViewCell: UITableViewCell {
    @IBOutlet weak var iv_copy: UIImageView!
    @IBOutlet weak var lb_pre: UILabel!
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_orderid: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_count: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
