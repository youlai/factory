//
//  AddressTableViewCell.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var lb_first: UILabel!
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_phone: UILabel!
    @IBOutlet weak var lb_address: UILabel!
    @IBOutlet weak var lb_edit: UILabel!
    @IBOutlet weak var lb_delete: UILabel!
    @IBOutlet weak var lb_default: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
