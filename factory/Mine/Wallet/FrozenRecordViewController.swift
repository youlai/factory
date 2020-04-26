//
//  FrozenRecordViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/29.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class FrozenRecordViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,EmptyViewProtocol {
    var showEmtpy: Bool{
        get {
            return dataSouce.count == 0
        }
    }
    func configEmptyView() -> UIView? {
        let view=Bundle.main.loadNibNamed("emptyView", owner: nil, options: nil)?[0]as?UIView
        view?.height=tableView.height
        view?.width=screenW
        return view
    }
    var orderStatus:Int!
    var pageNo:Int=1
    var tag:Int=1
    var limit:Int=20
    var dataSouce=[mFrozenRecord]()
    var orders=[mFrozenRecord]()
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var lb_money: UILabel!
    @IBOutlet weak var lb_day: UILabel!
    @IBOutlet weak var lb_week: UILabel!
    @IBOutlet weak var lb_month: UILabel!
    @IBOutlet weak var lb_year: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lb_day.layer.cornerRadius =   15
        lb_week.layer.cornerRadius =  15
        lb_month.layer.cornerRadius = 15
        lb_year.layer.cornerRadius =  15
        
        lb_day.textColor = .white
        lb_day.backgroundColor = .red
        
        uv_back.addOnClickListener(target: self, action: #selector(back))
        
        lb_day.addOnClickListener(target: self, action: #selector(change(ges:)))
        lb_week.addOnClickListener(target: self, action: #selector(change(ges:)))
        lb_month.addOnClickListener(target: self, action: #selector(change(ges:)))
        lb_year.addOnClickListener(target: self, action: #selector(change(ges:)))
        
        tableView.register(UINib(nibName: "RechargeRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        tableView.separatorInset=UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.setEmtpyViewDelegate(target: self)
        tableView.backgroundColor = "#F0F0F0".color()
//        tableView.separatorStyle = .none
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNo = 1
            strongSelf.tableView.mj_footer.state = .idle
            strongSelf.tableView.mj_header.endRefreshing()
            if strongSelf.tag==1{
                strongSelf.loadData(start: strongSelf.getLastDay(), end: strongSelf.nowTime())
            }else if strongSelf.tag==2{
                strongSelf.loadData(start: strongSelf.getLastWeek(), end: strongSelf.nowTime())
            }else if strongSelf.tag==3{
                strongSelf.loadData(start: strongSelf.getLastMonth(), end: strongSelf.nowTime())
            }else if strongSelf.tag==4{
                strongSelf.loadData(start: strongSelf.getLastYear(), end: strongSelf.nowTime())
            }
        })
        
        tableView.mj_header = header;
        
        let footer = TTRefreshFooter  {  [weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNo = strongSelf.pageNo + 1
            if strongSelf.tag==1{
                strongSelf.loadData(start: strongSelf.getLastDay(), end: strongSelf.nowTime())
            }else if strongSelf.tag==2{
                strongSelf.loadData(start: strongSelf.getLastWeek(), end: strongSelf.nowTime())
            }else if strongSelf.tag==3{
                strongSelf.loadData(start: strongSelf.getLastMonth(), end: strongSelf.nowTime())
            }else if strongSelf.tag==4{
                strongSelf.loadData(start: strongSelf.getLastYear(), end: strongSelf.nowTime())
            }
        }
        
        tableView.mj_footer = footer
        tableView.mj_footer.isHidden = false
        loadData(start: getLastDay(), end: nowTime())
    }
    // MARK: 获取当前时间
    func nowTime() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let time = formatter.string(from: currentDate)
        return time
    }
    // MARK: 前一天的时间
    // nowDay 是传入的需要计算的日期
    func getLastDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 先把传入的时间转为 date
        let date = dateFormatter.date(from: nowTime())
        let lastTime: TimeInterval = -(24*60*60) // 往前减去一天的秒数，昨天
        //        let nextTime: TimeInterval = 24*60*60 // 这是后一天的时间，明天
        
        let lastDate = date?.addingTimeInterval(lastTime)
        let lastDay = dateFormatter.string(from: lastDate!)
        return lastDay
    }
    // MARK: 前一周的时间
    // nowDay 是传入的需要计算的日期
    func getLastWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 先把传入的时间转为 date
        let date = dateFormatter.date(from: nowTime())
        let lastTime: TimeInterval = -(24*60*60*7) // 往前减去一天的秒数，昨天
        //        let nextTime: TimeInterval = 24*60*60 // 这是后一天的时间，明天
        
        let lastDate = date?.addingTimeInterval(lastTime)
        let lastDay = dateFormatter.string(from: lastDate!)
        return lastDay
    }
    // MARK: 前一月的时间
    // nowDay 是传入的需要计算的日期
    func getLastMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 先把传入的时间转为 date
        let date = dateFormatter.date(from: nowTime())
        let lastTime: TimeInterval = -(24*60*60*30) // 往前减去一天的秒数，昨天
        //        let nextTime: TimeInterval = 24*60*60 // 这是后一天的时间，明天
        
        let lastDate = date?.addingTimeInterval(lastTime)
        let lastDay = dateFormatter.string(from: lastDate!)
        return lastDay
    }
    // MARK: 前一年的时间
    // nowDay 是传入的需要计算的日期
    func getLastYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 先把传入的时间转为 date
        let date = dateFormatter.date(from: nowTime())
        let lastTime: TimeInterval = -(24*60*60*365) // 往前减去一天的秒数，昨天
        //        let nextTime: TimeInterval = 24*60*60 // 这是后一天的时间，明天
        
        let lastDate = date?.addingTimeInterval(lastTime)
        let lastDay = dateFormatter.string(from: lastDate!)
        return lastDay
    }
    @objc func loadData(start:String,end:String){
        let d = ["UserID":UserID!,
                 "CreateTimeStart":start,
            "CreateTimeEnd":end,
            "page":"\(pageNo)",
            "limit":"\(limit)"
        ] as [String : String]
        print(d)
        AlamofireHelper.post(url: FreezingAmount, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.lb_money.text="￥\(res["Data"]["Item2"]["Money"].stringValue)"
            if ss.pageNo == 1{ ss.dataSouce.removeAll()}
            
            if ss.tableView.mj_footer.isRefreshing() {
                ss.tableView.mj_footer.endRefreshing()
                
            }
            if res["StatusCode"].intValue==200{
                ss.orders=res["Data"]["Item2"]["data"].arrayValue.compactMap({ mFrozenRecord(json: $0)})
                if ss.orders.count>0 {
                    if ss.tableView.mj_footer.isHidden && ss.orders.count > 0 {
                        ss.tableView.mj_footer.isHidden = false
                    }
                    ss.dataSouce.insert(contentsOf: ss.orders, at: ss.dataSouce.count)
                    if ss.orders.count < ss.limit {
                        ss.tableView.mj_footer.state = .noMoreData
                    }
                }
                ss.tableView.reloadData()
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
            if ss.tableView.mj_header.isRefreshing(){ss.tableView.mj_header.endRefreshing()}
            else if ss.tableView.mj_footer.isRefreshing() {ss.tableView.mj_footer.endRefreshing()}
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouce.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "re") as! RechargeRecordTableViewCell
        let item=dataSouce[indexPath.row]
        cell.lb_time.text=Date.dateFormatterWithString(item.CreateTime!.replacingOccurrences(of: "T", with: " "))
        cell.lb_name.text="\(item.StateStr!)"
        cell.lb_orderid.text="工单号：\(item.OrderID)"
        cell.lb_count.text="\(item.PayMoney)"
        cell.lb_orderid.isHidden=false
        cell.lb_count.isHidden=false
        cell.lb_pre.text="\(item.StateStr!.prefix(1))"
        cell.selectionStyle = .none
        cell.lb_pre.layer.cornerRadius=15
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(XgyOrderDetailViewController(OrderID: "\(dataSouce[indexPath.row].OrderID)"), animated: true)
    }
    //MARK:日 月 周 年切换
    @objc func change(ges:UITapGestureRecognizer){
        lb_day.textColor = .black
        lb_week.textColor = .black
        lb_month.textColor = .black
        lb_year.textColor = .black
        lb_day.backgroundColor = .clear
        lb_week.backgroundColor = .clear
        lb_month.backgroundColor = .clear
        lb_year.backgroundColor = .clear
        (ges.view as! UILabel).textColor = .white
        (ges.view as! UILabel).backgroundColor = .red
        tag=ges.view!.tag
        pageNo=1
        dataSouce.removeAll()
        tableView.mj_footer.state = .idle
        if tag==1{
            loadData(start: getLastDay(), end: nowTime())
        }else if tag==2{
            loadData(start: getLastWeek(), end: nowTime())
        }else if tag==3{
            loadData(start: getLastMonth(), end: nowTime())
        }else if tag==4{
            loadData(start: getLastYear(), end: nowTime())
        }
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
}
struct mFrozenRecord {
    var TypeID: String?
    var CreateTime: String?
    var Id: Int = 0
    var Version: Int = 0
    var PayID: Int = 0
    var CreateTimeStart: String?
    var IsUse: String?
    var OrderAccessoryId: Int = 0
    var PayName: String?
    var QApplyNum: Int = 0
    var State: String?
    var StateStr: String?{
        get{
            switch (State){
                case "0":
                    return "空"
                case "1":
                    return "配件"
                case "2":
                    return "远程费"
                case "3":
                    return "邮费"
                case "4":
                    return "简修钱"
                case "5":
                    return "加急费"
                case "6":
                    return "发单费";
                case "7":
                    return "二次上门费"
                default:
                    return "空"
            }
        }
    }
    var AccessoryState: String?
    var ApplyNum: Int = 0
    var PayTypeCode: String?
    var PayMoney: Int = 0
    var ItemID: Int = 0
    var limit: Int = 0
    var Relation: String?
    var UserID: String?
    var OrderID: Int = 0
    var page: Int = 0
    var CreateTimeEnd: String?

    init(json: JSON) {
        TypeID = json["TypeID"].stringValue
        CreateTime = json["CreateTime"].stringValue
        Id = json["Id"].intValue
        Version = json["Version"].intValue
        PayID = json["PayID"].intValue
        CreateTimeStart = json["CreateTimeStart"].stringValue
        IsUse = json["IsUse"].stringValue
        OrderAccessoryId = json["OrderAccessoryId"].intValue
        PayName = json["PayName"].stringValue
        QApplyNum = json["QApplyNum"].intValue
        State = json["State"].stringValue
        AccessoryState = json["AccessoryState"].stringValue
        ApplyNum = json["ApplyNum"].intValue
        PayTypeCode = json["PayTypeCode"].stringValue
        PayMoney = json["PayMoney"].intValue
        ItemID = json["ItemID"].intValue
        limit = json["limit"].intValue
        Relation = json["Relation"].stringValue
        UserID = json["UserID"].stringValue
        OrderID = json["OrderID"].intValue
        page = json["page"].intValue
        CreateTimeEnd = json["CreateTimeEnd"].stringValue
    }
}
