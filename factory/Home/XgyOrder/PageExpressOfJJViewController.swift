//
//  PageExpressOfJJViewController
//  ShopIOS
//
//  Created by Apple on 2019/8/20.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class PageExpressOfJJViewController: UITableViewController,EmptyViewProtocol {
    var showEmtpy: Bool{
        get {
            return dataSource.count == 0
        }
    }
    func configEmptyView() -> UIView? {
        let view=Bundle.main.loadNibNamed("emptyView", owner: nil, options: nil)?[0]as?UIView
        view?.height=screenH
        view?.width=screenW
        return view
    }
    var dataSource=[mLogistics]()
    var OrderID:String!
    var ExpressNo:String!
    init(OrderID:String){
        super.init(nibName: nil, bundle: nil)
        self.OrderID=OrderID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setEmtpyViewDelegate(target: self)
        tableView.separatorStyle = .none
        tableView.backgroundColor="#f2f2f2".color()
        tableView.register(UINib(nibName: "XgyOrderRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        getOrderDetail()
        // Do any additional setup after loading the view.
    }
    func getOrderDetail(){
        let d = ["OrderID":OrderID]as[String:String]
        AlamofireHelper.post(url: GetOrderInfo, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            let detail=mXgyOrderDetail.init(json: res["Data"])
            if detail.OrderAccessroyDetail.count>0{
                ss.ExpressNo=detail.OrderAccessroyDetail[0].ExpressNo
                ss.getExpressInfo()
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    func getExpressInfo(){
        let d = ["ExpressNo":"75150832260164"]as[String:String]
        AlamofireHelper.post(url: GetExpressInfo, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.dataSource=res["Data"]["Item2"].arrayValue.compactMap({ mLogistics(json: $0)})
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "re")as!XgyOrderRecordTableViewCell
        let item=dataSource[indexPath.row]
        if indexPath.row==0{//第一条数据
            cell.line_top.isHidden=true
            cell.line_bottom.isHidden=false
            cell.dot_view.image=UIImage(named: "red_dot")
        }else if indexPath.row==dataSource.count-1{//最后一条数据
            cell.line_top.isHidden=false
            cell.line_bottom.isHidden=true
            cell.dot_view.image=UIImage(named: "gray_dot")
        }else{//中间数据
            cell.line_top.isHidden=false
            cell.line_bottom.isHidden=false
            cell.dot_view.image=UIImage(named: "gray_dot")
        }
        cell.lb_time.text=item.time
        cell.lb_content.text=item.content
        cell.selectionStyle = .none
        return cell
    }
}
