//
//  V3_OrderTableViewCell.swift
//  MasterWorker
//
//  Created by Apple on 2019/10/7.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class V3_OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var iv_star: UIImageView!
    @IBOutlet weak var iv_copy: UIImageView!
    @IBOutlet weak var lb_orderid: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_status: UILabelPadding!
    @IBOutlet weak var lb_content: UILabel!
    @IBOutlet weak var lb_memo: UILabel!
    @IBOutlet weak var lb_addr: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
