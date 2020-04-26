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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "V3_OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        tableView.separatorInset=UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
//    "急需处理", "待完成", "星标工单"11, "已完成", "质保单"4, "退单处理","所有工单"5
//    "远程费审核"9,"配件审核"1,"待寄件"10,"留言"15
//    "30日内"16,"30日以上"17
//    "待支付"2,"已支付"3
//    "取消工单"13,"关闭工单"12
    @objc func loadData(){
        let d = ["UserID":UserID!,
                 "State":"\(orderStatus ?? 1)",
            "page":"\(pageNo)",
            "limit":"\(limit)"
        ] 
        AlamofireHelper.post(url: NewFactoryGetOrderList, parameters: d, successHandler: {[weak self](res)in
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
        cell.lb_content.text="\(item.ProductType!)"
        cell.lb_orderid.text="工单号：\(item.OrderID)"
        if item.TypeID==1{
            cell.lb_memo.text="故障：\(item.Memo!)"
        }else{
            cell.lb_memo.text="备注：\(item.Memo!)"
        }
        cell.lb_addr.text="地址：\(item.Address ?? "")"
        if item.FStarOrder == "Y"{
            cell.iv_star.image=UIImage(named: "star_select")
        }else{
            cell.iv_star.image=UIImage(named: "star")
        }
        cell.selectionStyle = .none
        cell.lb_status.layer.cornerRadius=3
        let tap1=UITapGestureRecognizer(target: self, action: #selector(copy_orderid(sender:)))
        let tap2=UITapGestureRecognizer(target: self, action: #selector(stared(sender:)))
        
        cell.iv_copy.addGestureRecognizer(tap1)
        cell.iv_star.addGestureRecognizer(tap2)
        
        tap1.view!.tag=indexPath.row
        tap2.view!.tag=indexPath.row
        
        return cell
    }
    //MARK:复制
    @objc func copy_orderid(sender:UITapGestureRecognizer!){
        let past = UIPasteboard.general
        
        past.string = "\(self.dataSouce[sender.view!.tag].OrderID)"
        
        HUD.showText(past.string!)
    }
    //MARK:星标
    @objc func stared(sender:UITapGestureRecognizer!){
        let order=self.dataSouce[sender.view!.tag]
        var FStarOrder=order.FStarOrder
        if FStarOrder == "Y"{
            FStarOrder="N"
        }else{
            FStarOrder="Y"
        }
        let orderid = "\(order.OrderID)"
            let d = ["OrderID":orderid,
                     "FStarOrder":FStarOrder
                ] as! [String : String]
            AlamofireHelper.post(url: GetFStarOrder, parameters: d, successHandler: {[weak self](res)in
                HUD.dismiss()
                guard let ss = self else {return}
                ss.loadData()
            }){[weak self] (error) in
                HUD.dismiss()
                guard let ss = self else {return}
            }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(XgyOrderDetailViewController(OrderID: "\(dataSouce[indexPath.row].OrderID)"), animated: true)
    }
}

