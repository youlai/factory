//
//  XgyOrderTableViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/26.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class XgyOrderTableViewController: UITableViewController,EmptyViewProtocol {
    var showEmtpy: Bool{
        get {
            return orders.count == 0
        }
    }
    var label:UILabel?
    
    var orderStatus:Int!
    var pageNo:Int=1
    var orders=[XgyOrder]()
    
    var OrderID=""
    
    var popview: ZXPopView!
    var complaintView: ComplaintView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "XgyOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        tableView.backgroundColor = "#f2f2f2".color()
        tableView.separatorStyle = .none
        tableView.contentInset=UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.setEmtpyViewDelegate(target: self)
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
    }
    init(status:Int){
        super.init(style: UITableView.Style.plain)
        self.orderStatus=status
        loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData(){
        let d = ["UserID":UserID,
                 "state":"\(orderStatus!)"
            ] as! [String : String]
        AlamofireHelper.post(url: GetOrderByhmalluserid, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            
            if ss.pageNo == 1{ ss.orders.removeAll()}
            
            if ss.tableView.mj_header.isRefreshing(){
                ss.tableView.mj_header.endRefreshing()
            }else if ss.tableView.mj_footer.isRefreshing() {
                ss.tableView.mj_footer.endRefreshing()
                
            }
            let temp=res["Data"]["Item2"].arrayValue.compactMap({ XgyOrder(json: $0)})
            
            if temp.count>0 {
                if ss.tableView.mj_footer.isHidden && temp.count > 0 {
                    ss.tableView.mj_footer.isHidden = false
                }
                ss.orders.insert(contentsOf: temp, at: ss.orders.count)
                if ss.orders.count < 20 {
                    ss.tableView.mj_footer.state = .noMoreData
                }
            }else {
                ss.tableView.mj_footer.state = .noMoreData
            }
            
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
            if ss.tableView.mj_header.isRefreshing(){ss.tableView.mj_header.endRefreshing()}
            else if ss.tableView.mj_footer.isRefreshing() {ss.tableView.mj_footer.endRefreshing()}
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orders.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! XgyOrderTableViewCell
        let item=orders[indexPath.row]
        cell.uv_cell.layer.cornerRadius=10
        cell.uv_type.layer.cornerRadius=5
        cell.btn_cancel.border(color: UIColor.lightGray, width: 1, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        cell.btn_complaint.border(color: UIColor.lightGray, width: 1, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        cell.btn_seedetail.border(color: UIColor.lightGray, width: 1, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        cell.btn_cancel.contentEdgeInsets=UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        cell.btn_complaint.contentEdgeInsets=UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        cell.btn_seedetail.contentEdgeInsets=UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        cell.lb_ordernum.text="工单号：\(item.OrderID)"
        cell.lb_memo.text=item.Memo
        cell.lb_type.text="\(item.TypeName!)/\(item.GuaranteeStr!)"
        cell.lb_status.text="\(item.StateStr!)"
        cell.lb_user.text="\(item.UserName!)\(item.Phone!)"
        cell.lb_address.text=item.Address
        cell.lb_money.text="工单价格：￥\(item.OrderMoney)"
        cell.lb_mask.text="\(item.BeyondStateStr!)  \(item.AccessoryApplyStateStr!)"
        if item.StateStr=="待接单"{
            cell.btn_cancel.isHidden=false
        }else{
            cell.btn_cancel.isHidden=true
        }
        
        cell.btn_cancel.addTarget(self, action: #selector(cancel(sender:)), for: UIControl.Event.touchUpInside)
        cell.btn_cancel.tag = indexPath.row
        
        cell.btn_complaint.addTarget(self, action: #selector(complaint(sender:)), for: UIControl.Event.touchUpInside)
        cell.btn_complaint.tag = indexPath.row
        
        cell.btn_seedetail.addTarget(self, action: #selector(seedetail(sender:)), for: UIControl.Event.touchUpInside)
        cell.btn_seedetail.tag = indexPath.row
        
        cell.selectionStyle = .none
        return cell
    }
    
    func configEmptyView() -> UIView? {
        let view=Bundle.main.loadNibNamed("NoOrderView", owner: nil, options: nil)?[0]as?UIView
        view?.height=screenH-90-kStatusBarHeight
        view?.width=screenW
        return view
    }
    @objc func cancel(sender:UIButton){
        //创建UIAlertController(警告窗口)
        let alert = UIAlertController(title: "提示", message: "是否作废工单？", preferredStyle: .alert)
        let OK = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            let item=self.orders[sender.tag]
            let d = ["OrderID":"\(item.OrderID)"]
            AlamofireHelper.post(url: ApplyCancelOrder, parameters: d, successHandler: {[weak self](res)in
                HUD.dismiss()
                guard let ss = self else {return}
                if res["Data"]["Item1"].boolValue{
                    ss.loadData()
                }
                HUD.showText(res["Data"]["Item2"].stringValue)
            }){[weak self] (error) in
                HUD.dismiss()
                guard let ss = self else {return}
            }
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
    @objc func complaint(sender:UIButton){
        let item=orders[sender.tag]
        OrderID="\(item.OrderID)"
        popview = ZXPopView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        complaintView=Bundle.main.loadNibNamed("ComplaintView", owner: nil, options: nil)?[0] as? ComplaintView
        complaintView.layer.cornerRadius=10
        complaintView.uv_tf.layer.cornerRadius=10
        complaintView.btn_submit.addOnClickListener(target: self, action: #selector(submit))
        complaintView.btn_cancel.addOnClickListener(target: self, action: #selector(dismissview))
        popview.contenView = complaintView
        popview.anim = 0
        complaintView.snp.makeConstraints { (make) in
            make.width.equalTo(screenW-20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(300)
            make.center.equalToSuperview()
        }
        popview.showInWindow()
    }
    @objc func dismissview(){
        popview.dismissView()
    }
    @objc func submit(){
        let content=complaintView.tf_reason.text
        if content!.isEmpty{
            HUD.showText("请输入投诉内容！")
            return
        }
        let d = ["OrderID":OrderID,"Content":content!]as[String:String]
        AlamofireHelper.post(url: FactoryComplaint, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                ss.popview.dismissView()
            }
            HUD.showText(res["Data"]["Item2"].stringValue)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func seedetail(sender:UIButton){
        let item=orders[sender.tag]
        self.navigationController?.pushViewController(XgyOrderDetailViewController(OrderID: "\(item.OrderID)"), animated: true)
    }
}
