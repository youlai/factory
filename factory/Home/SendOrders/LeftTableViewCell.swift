//
//  LeftTableViewCell.swift
//  StoryDemo
//
//  Created by mac on 2019/7/8.
//  Copyright © 2019年 zhkj. All rights reserved.
//

import UIKit

class LeftTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var left_line: UIView!
    @IBOutlet weak var right_line: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
