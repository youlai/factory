//
//  BrandViewController.swift
//  factory
//
//  Created by Apple on 2020/4/1.
//  Copyright © 2020 zhkj. All rights reserved.
//

import UIKit
import SwiftyJSON

class BrandViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,EmptyViewProtocol {
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
        let cell=tableView.dequeueReusableCell(withIdentifier: "re") as! BrandTableViewCell
        let item=dataSource[indexPath.row]
        cell.lb_name.text=item.FBrandName
        cell.selectionStyle = .none
        cell.uv_delete.isUserInteractionEnabled = true
        let signTap1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteFactoryBrand(sender:)))
        cell.uv_delete.addGestureRecognizer(signTap1)
        signTap1.view!.tag = indexPath.row
        return cell
    }
    var dataSource=[BrandOfxgy]()
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var iv_add: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iv_add.layer.cornerRadius=25
        iv_add.addOnClickListener(target: self, action: #selector(addFactoryBrand))
        uv_back.addOnClickListener(target: self, action: #selector(back))
        tableView.register(UINib(nibName: "BrandTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.setEmtpyViewDelegate(target: self)
        getFactoryBrandByUserID()
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:获取品牌
    @objc func getFactoryBrandByUserID(){
        let d = ["UserID":UserID
            ] as! [String : String]
        AlamofireHelper.post(url: GetFactoryBrandByUserID, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.dataSource=res["Data"].arrayValue.compactMap({ BrandOfxgy(json: $0)})
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:添加品牌
    @objc func addFactoryBrand(){
        
            let alertController = UIAlertController(title: "添加品牌", message: "请输入品牌名称", preferredStyle: UIAlertController.Style.alert);
            alertController.addTextField { (textField:UITextField!) -> Void in
                textField.placeholder = "品牌名称";
            }
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil )
            let okAction = UIAlertAction(title: "确认", style: UIAlertAction.Style.default) { (ACTION) -> Void in
                let tf_name = alertController.textFields!.first! as UITextField
                if tf_name.text!.isEmpty{
                    HUD.showText("不能为空")
                    return
                }
                let d = ["UserID":UserID,
                         "FBrandName":tf_name.text!
                    ] as! [String : String]
                AlamofireHelper.post(url: AddFactoryBrand, parameters: d, successHandler: {[weak self](res)in
                    HUD.dismiss()
                    guard let ss = self else {return}
                    ss.getFactoryBrandByUserID()
                }){[weak self] (error) in
                    HUD.dismiss()
                    guard let ss = self else {return}
                }
            }
            alertController.addAction(cancelAction);
            alertController.addAction(okAction);
            self.present(alertController, animated: true, completion: nil)
    }
    //MARK:删除品牌
    @objc func deleteFactoryBrand(sender:UITapGestureRecognizer){
            let alertController = UIAlertController(title: "", message: "确认删除该品牌吗？", preferredStyle: UIAlertController.Style.alert);
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil )
            let okAction = UIAlertAction(title: "确认", style: UIAlertAction.Style.default) { (ACTION) -> Void in
                let d = ["UserID":UserID,
                         "FBrandID":"\(self.dataSource[sender.view!.tag].FBrandID)"
                    ] as! [String : String]
                AlamofireHelper.post(url: DeleteFactoryBrand, parameters: d, successHandler: {[weak self](res)in
                    HUD.dismiss()
                    guard let ss = self else {return}
                    ss.getFactoryBrandByUserID()
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
