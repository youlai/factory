//
//  ChooseAccessoryView.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/15.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ChooseAccessoryView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var btn_confirm: UIButton!
    var accessoryList=[Accessory]()
    var selectedIndexs = [Int]()
    //选中闭包回调
    var Select: ((_ items: [Int]) -> Void)? = nil
    func initView(){
        
        tableview.register(UINib(nibName: "AccessoryCell", bundle: nil), forCellReuseIdentifier: "re")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell=tableView.dequeueReusableCell(withIdentifier: "re")as!AccessoryCell
            var item=accessoryList[indexPath.row]
            cell.lb_name!.text=item.AccessoryName
            cell.pp_num.currentNumber="\(item.count)"
            cell.pp_num.NumberResultClosure={(number) in
                self.accessoryList[indexPath.row].count=Int(number)!
            }
        //判断是否选中（选中单元格尾部打勾）
        if selectedIndexs.contains(indexPath.row) {
            cell.accessoryType = .checkmark
            cell.pp_num.isHidden=false
        } else {
            cell.accessoryType = .none
            cell.pp_num.isHidden=true
        }
            cell.selectionStyle = .none
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //判断该行原先是否选中
        if let index = selectedIndexs.firstIndex(of: indexPath.row){
            selectedIndexs.remove(at: index) //原来选中的取消选中
        }else{
            selectedIndexs.append(indexPath.row) //原来没选中的就选中
        }
        if Select != nil{
            Select!(selectedIndexs)
        }
        ////刷新该行
        self.tableview?.reloadRows(at: [indexPath], with: .automatic)
    }
}
