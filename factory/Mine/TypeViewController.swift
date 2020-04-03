//
//  TypeViewController.swift
//  factory
//
//  Created by Apple on 2020/4/1.
//  Copyright © 2020 zhkj. All rights reserved.
//

import UIKit
import SwiftyJSON

class TypeViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,EmptyViewProtocol {
    var showEmtpy: Bool{
        get {
            return dataSource.count == 0
        }
    }
    func configEmptyView() -> UIView? {
        let view=Bundle.main.loadNibNamed("emptyView", owner: nil, options: nil)?[0]as?UIView
        view?.height=screenH-tableView.y
        view?.width=screenW
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "re") as! TypeTableViewCell
        let item=dataSource[indexPath.row]
        cell.lb_brand.text="品牌：\(item.BrandName!)"
        cell.lb_cate.text="分类：\(item.CategoryName!)"
        cell.lb_type.text="型号：\(item.ProductTypeName!)"
        cell.selectionStyle = .none
        cell.uv_delete.isUserInteractionEnabled = true
        let signTap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteBrandcategory(sender:)))
        cell.uv_delete.addGestureRecognizer(signTap1)
        signTap1.view!.tag = indexPath.row
        return cell
    }
    var dataSource=[CateOfxgy]()
    
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var iv_add: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iv_add.layer.cornerRadius=25
        iv_add.addOnClickListener(target: self, action: #selector(addBrandcategory))
        uv_back.addOnClickListener(target: self, action: #selector(back))
        tableView.register(UINib(nibName: "TypeTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.setEmtpyViewDelegate(target: self)
        getBrandWithCategory()
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:获取型号
    @objc func getBrandWithCategory(){
        let d = ["UserID":UserID
            ] as! [String : String]
        AlamofireHelper.post(url: GetBrandWithCategory, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.dataSource=res["Data"]["Item2"].arrayValue.compactMap({ CateOfxgy(json: $0)})
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:添加型号
    @objc func addBrandcategory(){
        self.navigationController?.pushViewController(AddTypeViewController(vc:self), animated: true)
    }
    //MARK:删除型号
    @objc func deleteBrandcategory(sender:UITapGestureRecognizer){
            let alertController = UIAlertController(title: "", message: "确认删除该型号吗？", preferredStyle: UIAlertController.Style.alert);
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil )
            let okAction = UIAlertAction(title: "确认", style: UIAlertAction.Style.default) { (ACTION) -> Void in
                let d = ["UserID":UserID,
                         "BrandID":"\(self.dataSource[sender.view!.tag].BrandID)",
                    "ProductTypeID":"\(self.dataSource[sender.view!.tag].ProductTypeID)"
                    ] as! [String : String]
                AlamofireHelper.post(url: DeleteBrandcategory, parameters: d, successHandler: {[weak self](res)in
                    HUD.dismiss()
                    guard let ss = self else {return}
                    ss.getBrandWithCategory()
                }){[weak self] (error) in
                    HUD.dismiss()
                    guard let ss = self else {return}
                }
            }
            alertController.addAction(cancelAction);
            alertController.addAction(okAction);
            self.present(alertController, animated: true, completion: nil)
    }
}
