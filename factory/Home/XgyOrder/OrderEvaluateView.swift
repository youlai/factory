//
//  OrderEvaluateView.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/23.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class OrderEvaluateView: UIView {

    @IBOutlet weak var lb_ordernum: UILabel!
    @IBOutlet weak var lb_score: UILabel!
    @IBOutlet weak var srv_total: JNStarRateView!
    @IBOutlet weak var lb_total: UILabel!
    @IBOutlet weak var srv_smsd: JNStarRateView!
    @IBOutlet weak var srv_wxsd: JNStarRateView!
    @IBOutlet weak var srv_fwtd: JNStarRateView!
    @IBOutlet weak var lb_smsd: UILabel!
    @IBOutlet weak var lb_wxsd: UILabel!
    @IBOutlet weak var lb_fwtd: UILabel!
    @IBOutlet weak var uv_content: UIView!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_confirm: UIButton!
    @IBOutlet weak var tv_content: UITextView!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
