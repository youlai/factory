//
//  WithDrawRecordTableViewCell.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/26.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class WithDrawRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_price: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
