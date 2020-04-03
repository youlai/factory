//
//  AddressViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddressViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,EmptyViewProtocol {
    var showEmtpy: Bool{
        get {
            return dataSource.count == 0
        }
    }
    func configEmptyView() -> UIView? {
        let view=Bundle.main.loadNibNamed("NoAddrView", owner: nil, options: nil)?[0]as?UIView
        view?.height=screenH-tableview.y
        view?.width=screenW
        view?.addOnClickListener(target: self, action: #selector(addnew))
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableview.dequeueReusableCell(withIdentifier: "re") as! AddressTableViewCell
        let address=dataSource[indexPath.row]
        if address.IsDefault=="1"{
            cell.lb_default.isHidden=false
        }else{
            cell.lb_default.isHidden=true
        }
        cell.lb_default.textColor=UIColor.red
        cell.lb_default.backgroundColor=UIColor.orange
        cell.lb_default.layer.cornerRadius=5
        cell.lb_default.clipsToBounds=true
        cell.lb_name.text=address.UserName
        cell.lb_phone.text=address.Phone
        cell.lb_address.text="\(address.Province!)\(address.City!)\(address.Area!)\(address.District!)\(address.Address!)"
        cell.lb_first.text=address.UserName?.prefix(1).description
        cell.lb_first.layer.cornerRadius=15
        
        cell.lb_edit.isUserInteractionEnabled = true
        cell.lb_delete.isUserInteractionEnabled = true
        let signTap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(edit(sender:)))
        let signTap2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(delete(sender:)))
        cell.lb_edit.addGestureRecognizer(signTap1)
        cell.lb_delete.addGestureRecognizer(signTap2)
        signTap1.view!.tag = indexPath.row
        signTap2.view!.tag = indexPath.row
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if choose {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "choose"), object: dataSource[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
    

    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var lb_addnew: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var dataSource=[mShippingAddress]()
    var address:mShippingAddress!
    var choose:Bool=false
    init(choose:Bool){
        super.init(nibName: nil, bundle: nil)
        self.choose=choose
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        uv_back.addOnClickListener(target: self, action: #selector(back))
        lb_addnew.addOnClickListener(target: self, action: #selector(addnew))
        tableview.separatorStyle = .none
        tableview.setEmtpyViewDelegate(target: self)
        tableview.register(UINib(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        loaddata()
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name("updateAddress"), object: nil)
        // Do any additional setup after loading the view.
    }
    @objc func update(){
        loaddata()
    }
    @objc func edit(sender:UITapGestureRecognizer){
        let index=sender.view!.tag
        address=dataSource[index]
        self.navigationController?.pushViewController(AddNewAddrViewController(shippingAddress: address), animated: true)
    }
    @objc func delete(sender:UITapGestureRecognizer){
        let index=sender.view!.tag
        address=dataSource[index]
        //创建UIAlertController(警告窗口)
        let alert = UIAlertController(title: "提示", message: "是否删除该地址？", preferredStyle: .alert)
        //创建UIAlertController(动作表单)
        //        let alertB = UIAlertController(title: "Information", message: "sub title", preferredStyle: .actionSheet)
        //创建UIAlertController的Action
        let OK = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            self.postDeleteShippingAddress()
        }
        let Cancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
            print("you selected cancel")
        }
        //将Actiont加入到AlertController
        alert.addAction(OK)
        alert.addAction(Cancel)
        //以模态方式弹出
        self.present(alert, animated: true, completion: nil)
    }
    @objc func postDeleteShippingAddress(){
        let d = ["AccountAdressID":"\(address.AccountAdressID)"] as [String : String]
        AlamofireHelper.post(url: DeleteAccountAddress, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.loaddata()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func addnew(){
        self.navigationController?.pushViewController(AddNewAddrViewController(), animated: true)
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    func loaddata(){
        var d = ["UserID":UserID!] as [String : String]
        AlamofireHelper.post(url: GetAccountAddress, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.dataSource=res["Data"].arrayValue.compactMap({ mShippingAddress(json: $0)})
            ss.tableview.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }

}

struct mShippingAddress {
    var UserName: String?
    var IsDefault: String?
    var Address: String?
    var District: String?
    var Province: String?
    var Id: Int = 0
    var Area: String?
    var IsUse: String?
    var AccountAdressID: Int = 0
    var Version: Int = 0
    var City: String?
    var Phone: String?
    var UserID: String?
    
    init(json: JSON) {
        UserName = json["UserName"].stringValue
        IsDefault = json["IsDefault"].stringValue
        Address = json["Address"].stringValue
        District = json["District"].stringValue
        Province = json["Province"].stringValue
        Id = json["Id"].intValue
        Area = json["Area"].stringValue
        IsUse = json["IsUse"].stringValue
        AccountAdressID = json["AccountAdressID"].intValue
        Version = json["Version"].intValue
        City = json["City"].stringValue
        Phone = json["Phone"].stringValue
        UserID = json["UserID"].stringValue
    }
}
