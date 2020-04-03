//
//  ChooseTypeView.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/15.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ChooseTypeView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableview: UITableView!
    var cateList=[CateOfxgy]()
    var selectIndex:IndexPath = IndexPath(row: 0, section: 0)
    //选中分类闭包回调
    var cateSelect: ((_ cateOfxgy: CateOfxgy) -> Void)? = nil

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cateList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            var cell=tableView.dequeueReusableCell(withIdentifier: "right")
            if cell == nil {
                cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "right")
            }
            let item=cateList[indexPath.row]
            cell?.textLabel!.text="\(item.CategoryName!)/\(item.SubCategoryName!)/\(item.ProductTypeName!)"
            cell!.selectionStyle = .none
            return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cateSelect != nil{
            cateSelect!(cateList[indexPath.row])
        }
    }
}
