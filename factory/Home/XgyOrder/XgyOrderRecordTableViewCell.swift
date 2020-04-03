//
//  XgyOrderRecordTableViewCell.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/26.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class XgyOrderRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var dot_view: UIImageView!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var line_top: UIView!
    @IBOutlet weak var line_bottom: UIView!
    @IBOutlet weak var lb_content: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
