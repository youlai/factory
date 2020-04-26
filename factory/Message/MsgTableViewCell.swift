//
//  MsgTableViewCell.swift
//  StoryDemo
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019年 zhkj. All rights reserved.
//

import UIKit

class MsgTableViewCell: UITableViewCell {


    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var time: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
