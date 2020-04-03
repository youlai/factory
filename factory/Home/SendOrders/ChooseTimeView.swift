//
//  ChooseTimeView.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/15.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ChooseTimeView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableview: UITableView!
    var timeList=["请选择","12小时","1天","2天"]
    var selectIndex:IndexPath = IndexPath(row: 0, section: 0)
    //选中上门时间闭包回调
    var timeSelect: ((_ time: (String,Int)) -> Void)? = nil

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            var cell=tableView.dequeueReusableCell(withIdentifier: "right")
            if cell == nil {
                cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "right")
            }
            let item=timeList[indexPath.row]
            cell?.textLabel!.text=item
            cell!.selectionStyle = .none
            return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if timeSelect != nil{
            timeSelect!((timeList[indexPath.row],indexPath.row))
        }
    }
}
