//
//  WithDrawRecordTableViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/26.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class WithDrawRecordTableViewController: UITableViewController,EmptyViewProtocol {
    var showEmtpy: Bool{
        get {
            return dataSouce.count == 0
        }
    }
    var state:String!
    var dataSouce=[MoneyRecord]()
    var tempData=[MoneyRecord]()
    var pageNo=1
    var limit=20
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.register(UINib(nibName: "WithDrawRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tableView.setEmtpyViewDelegate(target: self)
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNo = 1
            strongSelf.tableView.mj_footer.state = .idle
            strongSelf.tableView.mj_header.endRefreshing()
            strongSelf.loadData(state: strongSelf.state)
        })
        
        tableView.mj_header = header;
        
        let footer = TTRefreshFooter  {  [weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNo = strongSelf.pageNo + 1
            strongSelf.loadData(state: strongSelf.state)
        }
        tableView.mj_footer = footer
        tableView.mj_footer.isHidden = true
        
    }
    init(state:String){
        super.init(style: UITableView.Style.plain)
        self.state=state
        loadData(state: state)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(state:String){
        let d = ["UserID":UserID,
                 "state":"\(state)",
            "page":"\(pageNo)",
            "limit":"\(limit)"
            ] as! [String : String]
        print(d)
        AlamofireHelper.post(url: AccountBill, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if ss.pageNo == 1{ ss.dataSouce.removeAll()}
            
            if ss.tableView.mj_footer.isRefreshing() {
                ss.tableView.mj_footer.endRefreshing()
            }
            ss.tempData = res["Data"]["Item2"]["data"].arrayValue.compactMap({ MoneyRecord(json: $0)})
            if ss.tempData.count>0 {
                if ss.tableView.mj_footer.isHidden && ss.tempData.count > 0 {
                    ss.tableView.mj_footer.isHidden = false
                }
                ss.dataSouce.insert(contentsOf: ss.tempData, at: ss.dataSouce.count)
                if ss.tempData.count < 20 {
                    ss.tableView.mj_footer.state = .noMoreData
                }
            }else {
                ss.tableView.mj_footer.state = .noMoreData
            }
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSouce.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! WithDrawRecordTableViewCell
        let item=dataSouce[indexPath.row]
        switch item.State {
        case "1":
            cell.lb_name.text="充值"
            cell.lb_price.text="+￥\(item.PayMoney)元"
            cell.lb_price.textColor = .black
        case "2":
            cell.lb_name.text="支出"
            cell.lb_price.text="-￥\(item.PayMoney)元"
            cell.lb_price.textColor = .red
        case "3":
            cell.lb_name.text="提现"
            cell.lb_price.text="-￥\(item.PayMoney)元"
            cell.lb_price.textColor = .red
        case "5":
            cell.lb_name.text="收入"
            cell.lb_price.text="+￥\(item.PayMoney)元"
            cell.lb_price.textColor = .black
        default:
            cell.lb_name.text=""
        }
        cell.lb_time.text=item.CreateTime?.replacingOccurrences(of: "T", with: " ")
        cell.selectionStyle = .none
        return cell
    }
    func configEmptyView() -> UIView? {
        let view=Bundle.main.loadNibNamed("emptyView", owner: nil, options: nil)?[0]as?UIView
        view?.height=screenH-124
        view?.width=screenW
        return view
    }
    
}
struct MoneyRecord {
    var EndTime: String?
    var ActualMoney: Int = 0
    var ShareMoney: Int = 0
    var page: Int = 0
    var StartTime: String?
    var BuyerAccount: String?
    var StateName: String?
    var OrderID: Int = 0
    var Id: Int = 0
    var CreateTime: String?
    var BisID: String?
    var FinancialID: Int = 0
    var PayTypeName: String?
    var UserID: String?
    var PayMoney: Double = 0
    var ThirdPartyNo: String?
    var Version: Int = 0
    var IsInvoice: String?
    var limit: Int = 0
    var State: String?
    var ShareUserId: String?
    var IsUse: String?
    var PayTypeCode: String?
    var OutTradeNo: String?
    
    init(json: JSON) {
        EndTime = json["EndTime"].stringValue
        ActualMoney = json["ActualMoney"].intValue
        ShareMoney = json["ShareMoney"].intValue
        page = json["page"].intValue
        StartTime = json["StartTime"].stringValue
        BuyerAccount = json["BuyerAccount"].stringValue
        StateName = json["StateName"].stringValue
        OrderID = json["OrderID"].intValue
        Id = json["Id"].intValue
        CreateTime = json["CreateTime"].stringValue
        BisID = json["BisID"].stringValue
        FinancialID = json["FinancialID"].intValue
        PayTypeName = json["PayTypeName"].stringValue
        UserID = json["UserID"].stringValue
        PayMoney = json["PayMoney"].doubleValue
        ThirdPartyNo = json["ThirdPartyNo"].stringValue
        Version = json["Version"].intValue
        IsInvoice = json["IsInvoice"].stringValue
        limit = json["limit"].intValue
        State = json["State"].stringValue
        ShareUserId = json["ShareUserId"].stringValue
        IsUse = json["IsUse"].stringValue
        PayTypeCode = json["PayTypeCode"].stringValue
        OutTradeNo = json["OutTradeNo"].stringValue
    }
}
