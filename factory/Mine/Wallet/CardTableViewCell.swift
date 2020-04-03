//
//  CardTableViewCell.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/26.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {
    @IBOutlet weak var uv_cell: UIView!
    @IBOutlet weak var iv_img: UIImageView!
    
    @IBOutlet weak var lb_name: UILabel!
    
    @IBOutlet weak var lb_num: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
