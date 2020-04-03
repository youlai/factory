//
//  AddCardViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/29.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddCardViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_bankname: UITextField!
    
    @IBOutlet weak var tf_cardno: UITextField!
    @IBOutlet weak var tf_phone: UITextField!
    @IBOutlet weak var btn_submit: UIButton!
    var CardNo:String!
    var PayInfoName:String!
    var name:String!
    var phone:String!
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer().rainbowLayer()
        gradientLayer.frame = btn_submit.bounds
        self.btn_submit.layer.insertSublayer(gradientLayer, at: 0)
        self.btn_submit.clipsToBounds=true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_submit.layer.cornerRadius=5
        uv_back.addOnClickListener(target: self, action: #selector(back))
        btn_submit.addOnClickListener(target: self, action: #selector(addorUpdateAccountPayInfo))
        tf_cardno.addTarget(self, action: #selector(textChange(_:)), for: .allEditingEvents)
        tf_cardno.delegate=self
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text!.count + string.count > 19) {
            return false
        }
        if (textField.text!.count < range.location + range.length) {
            return false
        }
        
        return true
    }
    @objc func textChange(_ textField:UITextField) {
        if tf_cardno.text?.count==6{
            CardNo=tf_cardno.text!
            getBankNameByCardNo()
        }
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    func getBankNameByCardNo(){
        let d = ["CardNo":CardNo!] as [String : Any]
        print(d)
        AlamofireHelper.post(url: GetBankNameByCardNo, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.tf_bankname.text=res["Data"]["Item2"].stringValue
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func addorUpdateAccountPayInfo(){
        PayInfoName=tf_bankname.text
        CardNo=tf_cardno.text
        name=tf_name.text
        phone=tf_phone.text
        if name.isEmpty{
            HUD.showText("请输入姓名")
            return
        }
        if CardNo.isEmpty{
            HUD.showText("请输入卡号")
            return
        }
        if PayInfoName.isEmpty{
            HUD.showText("请输入正确的银行卡号")
            return
        }
        if phone.isEmpty{
            HUD.showText("请输入手机号码")
            return
        }
        let d = [
            "UserID":UserID!,
            "PayInfoCode":"Bank",
            "PayInfoName":PayInfoName!,
            "PayNo":CardNo!,
            "PayName":name!
            ] as [String : Any]
        print(d)
        AlamofireHelper.post(url: AddorUpdateAccountPayInfo, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                HUD.showText("绑定成功")
                NotificationCenter.default.post(name: NSNotification.Name("updateCard"), object: self)
                ss.navigationController?.popViewController(animated: true)
            }else{
               HUD.showText(res["Data"]["Item2"].stringValue)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}

