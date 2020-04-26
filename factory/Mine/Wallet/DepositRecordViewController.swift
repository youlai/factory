//
//  DepositRecordViewController.swift
//  factory
//
//  Created by Apple on 2020/4/1.
//  Copyright © 2020 zhkj. All rights reserved.
//

import UIKit
import SwiftyJSON

class DepositRecordViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,EmptyViewProtocol {
    var showEmtpy: Bool{
        get {
            switch type {
            case 0:
                return jn_dataSource.count==0
            default:
                return tq_dataSource.count==0
            }
        }
    }
    func configEmptyView() -> UIView? {
        let view=Bundle.main.loadNibNamed("emptyView", owner: nil, options: nil)?[0]as?UIView
        view?.height=screenH-tableView.y
        view?.width=screenW
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case 0:
            return jn_dataSource.count
        default:
            return tq_dataSource.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "re") as! RechargeRecordTableViewCell
        switch type {
        case 0:
            let item=jn_dataSource[indexPath.row]
            cell.lb_time.text=Date.dateFormatterWithString(item.CreateTime!.replacingOccurrences(of: "T", with: " "))
            cell.lb_name.text="\(item.StateName!)"
            cell.lb_count.text="\(item.PayMoney)"
            cell.lb_count.isHidden=false
            cell.lb_orderid.isHidden=true
            cell.lb_pre.text="\(item.StateName!.prefix(1))"
            cell.selectionStyle = .none
            cell.lb_pre.layer.cornerRadius=15
        default:
            let item=tq_dataSource[indexPath.row]
            cell.lb_time.text=Date.dateFormatterWithString(item.CreateTime!.replacingOccurrences(of: "T", with: " "))
            cell.lb_name.text="提取保证金"
            cell.lb_count.text="\(item.PayMoney)"
            cell.lb_count.isHidden=false
            cell.lb_orderid.isHidden=true
            cell.lb_pre.text="提"
            cell.selectionStyle = .none
            cell.lb_pre.layer.cornerRadius=15
        }
        cell.selectionStyle = .none
        return cell
    }
    var jn_dataSource=[mDepositRecharge]()//缴纳保证金记录
    var tq_dataSource=[MoneyRecord]()//提取保证金记录
    var type=0
        init(type:Int){
        super.init(nibName: nil, bundle: nil)
        self.type=type
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uv_back.addOnClickListener(target: self, action: #selector(back))
        tableView.register(UINib(nibName: "RechargeRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.setEmtpyViewDelegate(target: self)
        if type==1{
            lb_title.text="提取保证金记录"
            getDepositWithDrawList()
        }else{
            lb_title.text="缴纳保证金记录"
            depositRechargeList()
        }
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:提取保证金记录
    @objc func getDepositWithDrawList(){
        let d = ["UserID":UserID,"State":"1"
            ] as! [String : String]
        AlamofireHelper.post(url: GetDepositWithDrawList, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.tq_dataSource=res["Data"]["data"].arrayValue.compactMap({ MoneyRecord(json: $0)})
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:缴纳保证金记录
    @objc func depositRechargeList(){
        let d = ["UserID":UserID,"State":"1"
            ] as! [String : String]
        AlamofireHelper.post(url: DepositRechargeList, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.jn_dataSource=res["Data"]["Item2"]["data"].arrayValue.compactMap({ mDepositRecharge(json: $0)})
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
//缴纳保证金记录
struct mDepositRecharge {
    var OrderID: Int = 0
    var limit: Int = 0
    var PayMoney: Int = 0
    var PayTypeName: String?
    var page: Int = 0
    var PayTypeCode: String?
    var FinancialID: Int = 0
    var Version: Int = 0
    var CreateTime: String?
    var BisID: String?
    var StartTime: String?
    var StateName: String?
    var ActualMoney: Int = 0
    var OutTradeNo: String?
    var UserID: String?
    var EndTime: String?
    var BuyerAccount: String?
    var ShareMoney: Int = 0
    var ShareUserId: String?
    var ThirdPartyNo: String?
    var Id: Int = 0
    var State: String?
    var IsUse: String?
    var IsInvoice: String?

    init(json: JSON) {
        OrderID = json["OrderID"].intValue
        limit = json["limit"].intValue
        PayMoney = json["PayMoney"].intValue
        PayTypeName = json["PayTypeName"].stringValue
        page = json["page"].intValue
        PayTypeCode = json["PayTypeCode"].stringValue
        FinancialID = json["FinancialID"].intValue
        Version = json["Version"].intValue
        CreateTime = json["CreateTime"].stringValue
        BisID = json["BisID"].stringValue
        StartTime = json["StartTime"].stringValue
        StateName = json["StateName"].stringValue
        ActualMoney = json["ActualMoney"].intValue
        OutTradeNo = json["OutTradeNo"].stringValue
        UserID = json["UserID"].stringValue
        EndTime = json["EndTime"].stringValue
        BuyerAccount = json["BuyerAccount"].stringValue
        ShareMoney = json["ShareMoney"].intValue
        ShareUserId = json["ShareUserId"].stringValue
        ThirdPartyNo = json["ThirdPartyNo"].stringValue
        Id = json["Id"].intValue
        State = json["State"].stringValue
        IsUse = json["IsUse"].stringValue
        IsInvoice = json["IsInvoice"].stringValue
    }
}
