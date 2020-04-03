//
//  PageOrderRecordViewController
//  ShopIOS
//
//  Created by Apple on 2019/8/20.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class PageOrderRecordViewController: UITableViewController {
    var dataSource=[mOrderRecord]()
    var OrderID:String!
    init(OrderID:String){
        super.init(nibName: nil, bundle: nil)
        self.OrderID=OrderID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundColor="#f2f2f2".color()
        tableView.register(UINib(nibName: "XgyOrderRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        getOrderRecordByOrderID()
        // Do any additional setup after loading the view.
    }
    func getOrderRecordByOrderID(){
        let d = ["OrderID":OrderID]as[String:String]
        AlamofireHelper.post(url: GetOrderRecordByOrderID, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.dataSource=res["Data"].arrayValue.compactMap({ mOrderRecord(json: $0)})
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
        cell.lb_time.text=item.CreateDate?.replacingOccurrences(of: "T", with: " ")
        cell.lb_content.text=item.StateName
        cell.selectionStyle = .none
        return cell
    }
}
