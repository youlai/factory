//
//  FeedbackViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/2.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var btn_countType: UIButton!
    @IBOutlet weak var btn_payType: UIButton!
    @IBOutlet weak var btn_otherType: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var tv_content: UITextView!
    var type=1
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer().rainbowLayer()
        gradientLayer.frame = btn_submit.bounds
        self.btn_submit.layer.insertSublayer(gradientLayer, at: 0)
        self.btn_submit.clipsToBounds=true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        uv_back.addOnClickListener(target: self, action: #selector(back))
        btn_countType.addTarget(self, action: #selector(clickbutton(btn:)), for: UIControl.Event.touchUpInside)
        btn_payType.addTarget(self, action: #selector(clickbutton(btn:)), for: UIControl.Event.touchUpInside)
        btn_otherType.addTarget(self, action: #selector(clickbutton(btn:)), for: UIControl.Event.touchUpInside)
        tv_content.border(color: UIColor.lightGray, width: 1, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        btn_submit.addOnClickListener(target: self, action: #selector(submit))
        buttonStyle(btn: btn_countType)
        buttonStyle(btn: btn_payType)
        buttonStyle(btn: btn_otherType)
        btn_countType.setTitleColor(UIColor.red, for: UIControl.State.normal)
        btn_submit.layer.cornerRadius=5
        tv_content.layer.cornerRadius=5
    }
    func buttonStyle(btn:UIButton){
        btn.border(color: UIColor.clear, width: 1, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        btn.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.contentEdgeInsets=UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        btn.snp.makeConstraints{(mask) in
            mask.height.equalTo(40)
        }
    }
    //MARK:返回
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:按钮点击选中效果
    @objc func clickbutton(btn:UIButton){
        type=btn.tag
        btn_countType.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn_payType.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn_otherType.setTitleColor(UIColor.black, for: UIControl.State.normal)
        btn.setTitleColor(UIColor.red, for: UIControl.State.normal)
    }
    //MARK:提交反馈
    @objc func submit(){
        let content=tv_content.text!
        if content.isEmpty{
            HUD.showText("请输入反馈内容")
            return
        }
        let d = ["UserID":UserID!,
                 "BackType":"\(type)",
            "Content":content
            ] as [String : Any]
        AlamofireHelper.post(url: AddOpinion, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            HUD.showText("反馈成功")
            ss.tv_content.text=""
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}

