//
//  BrandTableViewCell.swift
//  factory
//
//  Created by Apple on 2020/4/1.
//  Copyright © 2020 zhkj. All rights reserved.
//

import UIKit

class BrandTableViewCell: UITableViewCell {

    @IBOutlet weak var uv_delete: UIView!
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var uv_bg: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
