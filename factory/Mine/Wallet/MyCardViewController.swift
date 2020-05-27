//
//  MyCardViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/29.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyCardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var lb_add: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var dataSource=[MyCard]()
    var choose:Bool=false
    var card:MyCard!
    init(choose:Bool){
        super.init(nibName: nil, bundle: nil)
        self.choose=choose
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        uv_back.addOnClickListener(target: self, action: #selector(back))
        lb_add.addOnClickListener(target: self, action: #selector(addcard))
        getAccountPayInfoList()
        tableView.register(UINib(nibName: "CardTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        tableView.register(UINib(nibName: "CardFooterView", bundle: nil), forHeaderFooterViewReuseIdentifier: "footer")
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.separatorInset =  UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset=UIEdgeInsets(top: -30, left: 0, bottom: 10, right: 0)
        NotificationCenter.default
            .addObserver(self, selector: #selector(updateCard(notification:)), name: NSNotification.Name("updateCard"), object: nil)
        
        
    }
    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizer.State.began {
            
            let touchPoint = sender.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                self.card=dataSource[indexPath.row]
                deleteCard()
            }
        }
    }
    //MARK:
    @objc func deleteCard(){
        let alertVC : UIAlertController = UIAlertController.init(title: "是否删除该银行卡", message: "", preferredStyle: .alert)
        let falseAA : UIAlertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let trueAA : UIAlertAction = UIAlertAction.init(title: "确定", style: .default) { (alertAction) in
            self.addorUpdateAccountPayInfo()
        }
        alertVC.addAction(falseAA)
        alertVC.addAction(trueAA)
        self.present(alertVC, animated: true, completion: nil)
    }
    @objc func addorUpdateAccountPayInfo(){
        let d = [
            "UserID":UserID!,
            "AccountPayID":card.AccountPayID,
            "IsUse":"N"] as [String : Any]
        print(d)
        AlamofireHelper.post(url: AddorUpdateAccountPayInfo, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                HUD.showText("删除成功")
                NotificationCenter.default.post(name: NSNotification.Name("updateCard"), object: self)
            }else{
               HUD.showText(res["Data"]["Item2"].stringValue)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func updateCard(notification: Notification){
        getAccountPayInfoList()
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func addcard(){
        self.navigationController?.pushViewController(AddCardViewController(), animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if choose {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "choosecard"), object: dataSource[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "re")as!CardTableViewCell
        let item=dataSource[indexPath.row]
        cell.lb_name.text=item.PayInfoName
        switch item.PayInfoName {
        case "光大银行":
            cell.iv_img.image=UIImage(named: "guangda")
            cell.uv_cell.backgroundColor="#8B658B".color()
        case "广发银行股份有限公司":
            cell.iv_img.image=UIImage(named: "guangfa")
            cell.uv_cell.backgroundColor="#B22222".color()
        case "工商银行":
            cell.iv_img.image=UIImage(named: "gongshang")
            cell.uv_cell.backgroundColor="#EE6363".color()
        case "中国工商银行":
            cell.iv_img.image=UIImage(named: "gongshang")
            cell.uv_cell.backgroundColor="#EE6363".color()
        case "华夏银行":
            cell.iv_img.image=UIImage(named: "huaxia")
            cell.uv_cell.backgroundColor="#FF0000".color()
        case "中国建设银行":
            cell.iv_img.image=UIImage(named: "jianshe")
            cell.uv_cell.backgroundColor="#1E90FF".color()
        case "建设银行":
            cell.iv_img.image=UIImage(named: "jianshe")
            cell.uv_cell.backgroundColor="#1E90FF".color()
        case "中国交通银行":
            cell.iv_img.image=UIImage(named: "jiaotong")
            cell.uv_cell.backgroundColor="#4169E1".color()
        case "民生银行":
            cell.iv_img.image=UIImage(named: "minsheng")
            cell.uv_cell.backgroundColor="#00BFFF".color()
        case "宁波银行":
            cell.iv_img.image=UIImage(named: "ningbo")
            cell.uv_cell.backgroundColor="#FFF68F".color()
        case "农业银行":
            cell.iv_img.image=UIImage(named: "nongye")
            cell.uv_cell.backgroundColor="#00CED1".color()
        case "中国农业银行贷记卡":
            cell.iv_img.image=UIImage(named: "nongye")
            cell.uv_cell.backgroundColor="#00CED1".color()
        case "浦发银行":
            cell.iv_img.image=UIImage(named: "pufa")
            cell.uv_cell.backgroundColor="#0000CD".color()
        case "兴业银行":
            cell.iv_img.image=UIImage(named: "xinye")
            cell.uv_cell.backgroundColor="#1E90FF".color()
        case "邮政储蓄银行":
            cell.iv_img.image=UIImage(named: "youzheng")
            cell.uv_cell.backgroundColor="#006400".color()
        case "邮储银行":
            cell.iv_img.image=UIImage(named: "youzheng")
            cell.uv_cell.backgroundColor="#006400".color()
        case "招商银行":
            cell.iv_img.image=UIImage(named: "zhaoshang")
            cell.uv_cell.backgroundColor="#EE7942".color()
        case "浙商银行":
            cell.iv_img.image=UIImage(named: "zheshang")
            cell.uv_cell.backgroundColor="#FFD700".color()
        case "中国银行":
            cell.iv_img.image=UIImage(named: "zhongguo")
            cell.uv_cell.backgroundColor="#8B3A3A".color()
        case "中信银行":
            cell.iv_img.image=UIImage(named: "zhongxin")
            cell.uv_cell.backgroundColor="#EE2C2C".color()
        default:
            cell.iv_img.image=UIImage(named: "zhongxin")
            cell.uv_cell.backgroundColor="#EE2C2C".color()
        }
        cell.lb_num.text="\(item.PayNo!.prefix(4)) **** **** \(item.PayNo!.suffix(4))"
        
        //先边框
        cell.uv_cell.layer.borderWidth = 0.3
        cell.uv_cell.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
        //中阴影
        cell.uv_cell.layer.shadowColor = UIColor.black.cgColor
        //UIColor.init(hexColor: "A5A5A5").cgColor
        cell.uv_cell.layer.shadowOpacity = 0.5//不透明度
        cell.uv_cell.layer.shadowRadius = 3.0//设置阴影所照射的范围
        cell.uv_cell.layer.shadowOffset = CGSize.init(width: 0, height: 0)// 设置阴影的偏移量
        
        //后设置圆角
        cell.uv_cell.layer.cornerRadius=10
        
        cell.selectionStyle = .none
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        cell.addGestureRecognizer(longPressRecognizer)
        return cell
    }
    /*分区头部部高度*/
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 20
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        let label=UILabel.init()
//        label.frame=CGRect(x: 0, y: 0, width: screenW, height: 55)
//        label.textAlignment = .center
//        label.text="公安部监管信息安全"
//        label.textColor=UIColor.darkGray
//        return label
//
//    }
    /*分区尾部高度*/
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionFootView=tableView.dequeueReusableHeaderFooterView(withIdentifier: "footer") as! CardFooterView
        sectionFootView.width=screenW
//        var rect = sectionFootView.uv_addcard.frame
        let rect=CGRect(x: 0, y: 0, width: screenW-20, height: 60)
        let layer = CAShapeLayer.init()
        let path = UIBezierPath(roundedRect: rect,cornerRadius: 5)
        layer.path = path.cgPath;
        layer.strokeColor = UIColor.red.cgColor;
        layer.lineDashPattern = [10,10];
        layer.backgroundColor = UIColor.clear.cgColor;
        layer.fillColor = UIColor.clear.cgColor;
        sectionFootView.usv_addcard.layer.addSublayer(layer);
        sectionFootView.usv_addcard.addOnClickListener(target: self, action: #selector(addcard))
        return sectionFootView
    }
    
    func getAccountPayInfoList(){
        let d = ["UserID":UserID!] as [String : Any]
        print(d)
        AlamofireHelper.post(url: GetAccountPayInfoList, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.dataSource=res["Data"].arrayValue.compactMap({ MyCard(json: $0)})
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    
}
struct MyCard {
    var page: Int = 0
    var PayInfoName: String?
    var PayName: String?
    var limit: Int = 0
    var IsUse: String?
    var Version: Int = 0
    var UserID: String?
    var Id: Int = 0
    var PayInfoCode: String?
    var AccountPayID: Int = 0
    var PayNo: String?
    
    init(json: JSON) {
        page = json["page"].intValue
        PayInfoName = json["PayInfoName"].stringValue
        PayName = json["PayName"].stringValue
        limit = json["limit"].intValue
        IsUse = json["IsUse"].stringValue
        Version = json["Version"].intValue
        UserID = json["UserID"].stringValue
        Id = json["Id"].intValue
        PayInfoCode = json["PayInfoCode"].stringValue
        AccountPayID = json["AccountPayID"].intValue
        PayNo = json["PayNo"].stringValue
    }
}
