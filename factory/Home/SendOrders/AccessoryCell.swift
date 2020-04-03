//
//  AccessoryCell.swift
//  MasterWorker
//
//  Created by Apple on 2019/10/23.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AccessoryCell: UITableViewCell {

    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var pp_num: PPNumberButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
