//
//  XgyOrderTableViewCell.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/26.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class XgyOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var uv_cell: UIView!
    @IBOutlet weak var lb_ordernum: UILabel!
    @IBOutlet weak var uv_copy: UIView!
    
    @IBOutlet weak var lb_user: UILabel!
    @IBOutlet weak var lb_memo: UILabel!
    @IBOutlet weak var lb_mask: UILabel!
    @IBOutlet weak var lb_address: UILabel!
    @IBOutlet weak var uv_type: UIView!
    @IBOutlet weak var lb_type: UILabel!
    @IBOutlet weak var lb_status: UILabel!
    @IBOutlet weak var lb_money: UILabel!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_complaint: UIButton!
    @IBOutlet weak var btn_seedetail: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
