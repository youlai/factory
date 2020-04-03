//
//  V3_OrderTableViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/26.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import EventKit
import MapKit

class V3_OrderTableViewController3: UIViewController,UITableViewDelegate,UITableViewDataSource,EmptyViewProtocol {
    var showEmtpy: Bool{
        get {
            return dataSouce.count == 0
        }
    }
    func configEmptyView() -> UIView? {
        let view=Bundle.main.loadNibNamed("NoOrderView", owner: nil, options: nil)?[0]as?UIView
        view?.height=tableView.height
        view?.width=screenW
        return view
    }
    var orderStatus:Int!
    var pageNo:Int=1
    var limit:Int=10
    var dataSouce=[mOrder]()
    var orders=[mOrder]()
    var order:mOrder!
    var jsonStr:JSON!
    var popview:ZXPopView!
    var startDate:Date!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uv_search: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uv_search.layer.cornerRadius=5
        uv_search.addOnClickListener(target: self, action: #selector(search))
        tableView.register(UINib(nibName: "V3_OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        //        tableView.register(UINib(nibName: "OrderHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
        //        tableView.register(UINib(nibName: "OrderFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "footer")
        //        tableView.separatorStyle = .none
        tableView.separatorInset=UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //        tableView.contentInset=UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.setEmtpyViewDelegate(target: self)
        tableView.backgroundColor = "#F0F0F0".color()
        tableView.separatorStyle = .none
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNo = 1
            strongSelf.tableView.mj_footer.state = .idle
            strongSelf.tableView.mj_header.endRefreshing()
            strongSelf.loadData()
            //MARK:发送通知
            NotificationCenter.default.post(name: NSNotification.Name("工单数量"), object: self!.orderStatus)
        })
        
        tableView.mj_header = header;
        
        let footer = TTRefreshFooter  {  [weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNo = strongSelf.pageNo + 1
            strongSelf.loadData();
        }
        
        tableView.mj_footer = footer
        tableView.mj_footer.isHidden = false
        loadData()
    }
    init(status:Int){
        super.init(nibName: nil, bundle: nil)
        self.orderStatus=status
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:搜索
    @objc func search(){
//        self.navigationController?.pushViewController(SearchOrderTableViewController(), animated: true)
    }
    @objc func loadData(){
        let d = ["UserID":UserID!,
                 "State":"\(orderStatus ?? 1)",
            "page":"\(pageNo)",
            "limit":"\(limit)"
        ] 
        AlamofireHelper.post(url: NewWorkerGetOrderList, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            
            if ss.pageNo == 1{ ss.dataSouce.removeAll()}
            
            if ss.tableView.mj_footer.isRefreshing() {
                ss.tableView.mj_footer.endRefreshing()
                
            }
            if res["StatusCode"].intValue==200{
                ss.orders=res["Data"]["data"].arrayValue.compactMap({ mOrder(json: $0)})
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
        let cell=tableView.dequeueReusableCell(withIdentifier: "re") as! V3_OrderTableViewCell
        let item=dataSouce[indexPath.row]
        cell.lb_time.text=Date.dateFormatterWithString(item.CreateDate!.replacingOccurrences(of: "T", with: " "))
        cell.lb_status.text="\(item.TypeName!)/\(item.GuaranteeStr!)"
        cell.lb_distance.text="距离：\(item.Distance)km"
        cell.lb_content.text="\(item.ProductType!)"
        if item.TypeID==1{
            cell.lb_memo.text="故障：\(item.Memo!)"
        }else{
            cell.lb_memo.text="备注：\(item.Memo!)"
        }
        cell.lb_addr.text="地址：\(item.Address ?? "")"
        cell.selectionStyle = .none
        cell.btn_join.isHidden=true
        cell.lb_status.layer.cornerRadius=3
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.navigationController?.pushViewController(V3_OrderDetailViewController(orderid: "\(dataSouce[indexPath.row].OrderID)"), animated: true)
    }
}

