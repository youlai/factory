//
//  ChooseCateView.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/15.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ChooseCateView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var iv_close: UIImageView!
    @IBOutlet weak var leftTable: UITableView!
    @IBOutlet weak var rightTable: UITableView!
    var leftList=[CateOfxgy1]()
    var rightList=[CateOfxgy1]()
    var selectIndex:IndexPath = IndexPath(row: 0, section: 0)
    //选中分类闭包回调
    var cateSelect: ((_ cateOfxgy: CateOfxgy1) -> Void)? = nil

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isDescendant(of: leftTable){
            return leftList.count
        }else{
            return rightList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.isDescendant(of: leftTable){
            let cell=tableView.dequeueReusableCell(withIdentifier: "re")as!LeftTableViewCell
            let item=leftList[indexPath.row]
            if selectIndex==indexPath {
                getFactoryCategory(ParentID: "\(leftList[indexPath.row].FCategoryID)")
                cell.name.textColor=UIColor.red
                cell.left_line.isHidden=false
                cell.right_line.isHidden=true
            }else{
                cell.name.textColor=UIColor.black
                cell.left_line.isHidden=true
                cell.right_line.isHidden=false
            }
            cell.name.text=item.FCategoryName
            cell.selectionStyle = .none
            return cell
        }else{
            var cell=tableView.dequeueReusableCell(withIdentifier: "right")
            if cell == nil {
                cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "right")
            }
            let item=rightList[indexPath.row]
            cell?.textLabel!.text=item.FCategoryName
            cell!.selectionStyle = .none
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isDescendant(of: leftTable){
            selectIndex=indexPath
            leftTable.reloadData()
        }else{
            if cateSelect != nil{
                cateSelect!(rightList[indexPath.row])
            }
        }
    }
    @objc func getFactoryCategory(ParentID:String){
        let d = ["ParentID":ParentID]
        AlamofireHelper.post(url: GetFactoryCategory, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.rightList=res["Data"]["data"].arrayValue.compactMap({ CateOfxgy1(json: $0)})
            ss.rightTable.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
