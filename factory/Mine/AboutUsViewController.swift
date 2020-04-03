//
//  AboutUsViewController.swift
//  MasterWorker
//
//  Created by Apple on 2019/11/7.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    @IBOutlet weak var iv_app: UIImageView!
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var btn_feedback: UIButton!
    @IBOutlet weak var btn_agreement: UIButton!
    @IBOutlet weak var lb_version: UILabel!
    @IBOutlet weak var lb_phone: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iv_app.layer.cornerRadius=50
        buttonStyle(btn: btn_feedback)
        buttonStyle(btn: btn_agreement)
        uv_back.addOnClickListener(target: self, action: #selector(back))
        btn_agreement.addOnClickListener(target: self, action: #selector(agreement))
        btn_feedback.addOnClickListener(target: self, action: #selector(feedback))
        lb_phone.addOnClickListener(target: self, action: #selector(call_service))
        lb_version.text="v\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "")"
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:拨打客服电话
    @objc func call_service(){
        //拨打电话
        UIApplication.shared.open(URL(string: "tel://4006262365")!, options: [:], completionHandler: { (result) in
            print(result)
        })
    }
    //MARK:按钮样式
    func buttonStyle(btn:UIButton){
        btn.border(color: UIColor.lightGray, width: 1, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 2)
        btn.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        btn.contentEdgeInsets=UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        btn.snp.makeConstraints{(mask) in
            mask.height.equalTo(30)
        }
    }
    //MARK:用户协议
    @objc func agreement(){
        self.navigationController?.pushViewController(UIWebViewViewController(headtitle: "用户协议", url: "https://admin.xigyu.com/Agreement",type:0), animated: true)
    }
    //MARK:意见反馈
    @objc func feedback(){
        self.navigationController?.pushViewController(FeedbackViewController(), animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
