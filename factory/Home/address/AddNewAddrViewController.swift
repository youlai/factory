//
//  AddNewAddrViewController.swift
//  ShopIOS
//  添加收货地址
//
//  Created by Apple on 2019/7/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import ContactsUI
import PopupDialog

class AddNewAddrViewController: UIViewController,CNContactPickerDelegate {
    
    @IBOutlet weak var btn_save: UIButton!
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_save: UILabel!
    @IBOutlet weak var tf_shipto: UITextField!
    @IBOutlet weak var uv_contact: UIView!
    @IBOutlet weak var tf_phone: UITextField!
    @IBOutlet weak var uv_choose_address: UIView!
    @IBOutlet weak var tf_address: UITextField!
    @IBOutlet weak var tf_detail: UITextField!
    @IBOutlet weak var uv_default: UIView!
    @IBOutlet weak var default_switch: UISwitch!
    var regionId=""
    var province=""
    var city=""
    var area=""
    var street=""
    var address=""
    var telphone=""
    var shipTo=""
    var isDefault="false"
    var shippingAddress:mShippingAddress!
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    init(shippingAddress:mShippingAddress) {
        super.init(nibName: nil, bundle: nil)
        self.shippingAddress=shippingAddress
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer().rainbowLayer()
        gradientLayer.frame = btn_save.bounds
        self.btn_save.layer.insertSublayer(gradientLayer, at: 0)
        self.btn_save.clipsToBounds=true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_save.layer.cornerRadius=5
        uv_back.addOnClickListener(target: self, action: #selector(back))
        lb_save.addOnClickListener(target: self, action: #selector(save))
        btn_save.addOnClickListener(target: self, action: #selector(save))
        uv_contact.addOnClickListener(target: self, action: #selector(contack))
        uv_choose_address.addOnClickListener(target: self, action: #selector(choose_address))
        tf_shipto.attributedPlaceholder = NSAttributedString.init(string:"收货人", attributes: [
            NSAttributedString.Key.foregroundColor:UIColor.lightGray,NSAttributedString.Key.font:UIFont.systemFont(ofSize:15)])
        tf_phone.attributedPlaceholder = NSAttributedString.init(string:"手机号码", attributes: [
            NSAttributedString.Key.foregroundColor:UIColor.lightGray,NSAttributedString.Key.font:UIFont.systemFont(ofSize:15)])
        tf_address.attributedPlaceholder = NSAttributedString.init(string:"所在地区", attributes: [
            NSAttributedString.Key.foregroundColor:UIColor.lightGray,NSAttributedString.Key.font:UIFont.systemFont(ofSize:15)])
        tf_detail.attributedPlaceholder = NSAttributedString.init(string:"详细地址：如道路、门牌号、小区、楼栋号、单元室等", attributes: [
            NSAttributedString.Key.foregroundColor:UIColor.lightGray,NSAttributedString.Key.font:UIFont.systemFont(ofSize:15)])
        if shippingAddress != nil {
            lb_title.text="编辑收货地址"
            //            uv_default.isHidden=false
            tf_shipto.text=shippingAddress.UserName
            tf_phone.text=shippingAddress.Phone
            tf_address.text="\(shippingAddress.Province!)\(shippingAddress.City!)\(shippingAddress.Area!)\(shippingAddress.District!)"
            tf_detail.text=shippingAddress.Address
            
            shipTo=shippingAddress.UserName!
            telphone=shippingAddress.Phone!
            regionId="\(shippingAddress.AccountAdressID)"
            province=shippingAddress.Province!
            city=shippingAddress.City!
            area=shippingAddress.Area!
            street=shippingAddress.District!
            address=shippingAddress.Address!
            default_switch.isOn=(shippingAddress.IsDefault=="1")
        }else{
            lb_title.text="添加收货地址"
            uv_default.isHidden=true
        }
        
        // Do any additional setup after loading the view.
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func save(){
        shipTo=tf_shipto.text!
        telphone=tf_phone.text!
        address=tf_detail.text!
        if shipTo==""{
            HUD.showText("请填写收货人！")
            return
        }
        if telphone==""{
            HUD.showText("请填写联系号码")
            return
        }
        if province==""{
            HUD.showText("请选择地址")
            return
        }
        if address==""{
            HUD.showText("请输入详细地址")
            return
        }
        if shippingAddress != nil {
            isDefault=default_switch.isOn ? "1" : "0"
            let d = ["UserID":UserID!,
                     "AccountAdressID":"\(shippingAddress.AccountAdressID)",
                "Province":province,
                "City":city,
                "Area":area,
                "District":street,
                "Address":address,
                "IsDefault":isDefault,
                "UserName":shipTo,
                "Phone":telphone
            ]
            AlamofireHelper.post(url: UpdateAccountAddress, parameters: d, successHandler: {[weak self](res)in
                HUD.dismiss()
                guard let ss = self else {return}
                if res["Data"]["Item1"].boolValue{
                    HUD.showText("修改成功！")
                    NotificationCenter.default.post(name: NSNotification.Name("updateAddress"), object: self)
                    ss.navigationController?.popViewController(animated: true)
                }else{
                    HUD.showText("修改失败！")
                }
            }){[weak self] (error) in
                HUD.dismiss()
                guard let ss = self else {return}
                HUD.showText("修改失败！")
            }
        }else{
            let d = ["UserID":UserID!,
                     "Province":province,
                     "City":city,
                     "Area":area,
                     "District":street,
                     "Address":address,
                     "IsDefault":"0",
                     "UserName":shipTo,
                     "Phone":telphone
            ]
            AlamofireHelper.post(url: AddAccountAddress, parameters: d, successHandler: {[weak self](res)in
                HUD.dismiss()
                guard let ss = self else {return}
                if res["Data"]["Item1"].boolValue{
                    HUD.showText("添加成功！")
                    NotificationCenter.default.post(name: NSNotification.Name("updateAddress"), object: self)
                    ss.navigationController?.popViewController(animated: true)
                }else{
                    HUD.showText("添加失败！")
                }
            }){[weak self] (error) in
                HUD.dismiss()
                guard let ss = self else {return}
                HUD.showText("添加失败！")
            }
        }
        
    }
    @objc func contack(){
        //联系人选择控制器
        let contactPicker = CNContactPickerViewController()
        //设置代理
        contactPicker.delegate = self
        //添加可选项目的过滤条件
        //        contactPicker.predicateForEnablingContact
        //            = NSPredicate(format: "emailAddresses.@count > 0", argumentArray: nil)
        //弹出控制器
        self.present(contactPicker, animated: true, completion: nil)
    }
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        //获取联系人的姓名
        let lastName = contact.familyName
        let firstName = contact.givenName
        tf_shipto.text=lastName
        shipTo=lastName
        print("选中人的姓：\(lastName)")
        print("选中人的名：\(firstName)")
        
        //获取联系人电话号码
        print("选中人电话：")
        let phones = contact.phoneNumbers
        for phone in phones {
            //获得标签名（转为能看得懂的本地标签名，比如work、home）
            let phoneLabel = CNLabeledValue<NSString>.localizedString(forLabel: phone.label!)
            //获取号码
            let phoneValue = phone.value.stringValue
            tf_phone.text=phoneValue
            telphone=phoneValue
            print("\(phoneLabel):\(phoneValue)")
        }
    }
    func loaddata(){
        AlamofireHelper.post(url: GetProvince, parameters: nil, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            let alert = ChooseAddressAlert(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH), andHeight: kSize(width:500))
            alert.alpha = 0
            UIApplication.shared.keyWindow?.addSubview(alert)
            alert.selectAddress = {(select:(Street,String,(Province,City,Area,Street))) -> Void in
                ss.tf_address.text = select.1
                ss.province=select.2.0.name!
                ss.city=select.2.1.name!
                ss.area=select.2.2.name!
                ss.street=select.2.3.name!
            }
            alert.initprovince(addressModel: res["Data"].arrayValue.compactMap({ Province(json: $0)}))
            alert.showView()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func choose_address(){
        loaddata()
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
