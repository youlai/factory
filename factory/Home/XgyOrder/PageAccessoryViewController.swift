//
//  PageAccessoryViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/21.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SKPhotoBrowser

class PageAccessoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,LBXScanViewControllerDelegate {
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        expressView.tf_expressno.text=scanResult.strScanned
    }
    
    
    @IBOutlet weak var uv_expressno: UIView!
    @IBOutlet weak var lb_expressno: UILabel!
    @IBOutlet weak var lb_type: UILabel!
    @IBOutlet weak var lb_memo: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var yes: UIView!
    @IBOutlet weak var no: UILabel!
    @IBOutlet weak var uv_no: UIView!
    @IBOutlet weak var uv_yes: UIView!
    @IBOutlet weak var usv_yes: UIStackView!
    @IBOutlet weak var btn_reject: UIButton!
    @IBOutlet weak var btn_pass: UIButton!
    @IBOutlet weak var btn_send: UIButton!
    @IBOutlet weak var lb_addr: UILabel!
    @IBOutlet weak var uv_csdf: UIView!
    @IBOutlet weak var uv_xf: UIView!
    @IBOutlet weak var btn_modify: UIButton!
    @IBOutlet weak var iv_no: UIImageView!
    @IBOutlet weak var iv_yes: UIImageView!
    @IBOutlet weak var iv_csdf: UIImageView!
    @IBOutlet weak var iv_xf: UIImageView!
    var popview: ZXPopView!
    var expressView: ExpressView!
    
    var popviewOfAccessory:ZXPopView!
    var approveAccessoryView:ApproveAccessoryView!
    
    var OrderID:String!//工单号
    var AccessoryID:String!//配件ID
    var OrderAccessoryID:String!//工单配件ID
    var AccessoryName:String!//配件名称
    var AccessoryPrice:String!//配件价格
    var IsReturn="2" //是否返件 1是 2否
    var AddressBack:String!//返件地址
    var PostPayType="1" //1厂商到付 2维修商现付
    var addr:mShippingAddress!
    
    var AccessoryAndServiceApplyState:String!
    var AccessorySequencyStr:String!//寄件类型
    
    
    var dataSource=[mOrderAccessroyDetail]()
    init(OrderID:String){
        super.init(nibName: nil, bundle: nil)
        self.OrderID=OrderID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.view.safeAreaInsets=UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
        btn_send.layer.cornerRadius=5
        btn_pass.layer.cornerRadius=5
        btn_reject.layer.cornerRadius=5
        btn_modify.layer.cornerRadius=5
        uv_no.addOnClickListener(target: self, action: #selector(yn))
        uv_yes.addOnClickListener(target: self, action: #selector(yn))
        uv_csdf.addOnClickListener(target: self, action: #selector(xf))
        uv_xf.addOnClickListener(target: self, action: #selector(xf))
        btn_pass.addOnClickListener(target: self, action: #selector(ok))
        btn_reject.addOnClickListener(target: self, action: #selector(reject))
        btn_send.addOnClickListener(target: self, action: #selector(send(sender:)))
        btn_modify.addOnClickListener(target: self, action: #selector(chooseAddr))
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name("choose"), object: nil)
        tableview.dataSource=self
        tableview.delegate=self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: "AccessoryTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        getOrderDetail()
    }
    //MARK:工单详情
    func getOrderDetail(){
        let d = ["OrderID":OrderID]as[String:String]
        AlamofireHelper.post(url: GetOrderInfo, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            let detail=mXgyOrderDetail.init(json: res["Data"])
            ss.IsReturn=detail.IsReturn!
            ss.PostPayType=detail.PostPayType!
            ss.AddressBack=detail.AddressBack!
            //MARK:0 待审核 1审核通过 -1拒绝 2拒绝自购件 发厂家寄件
            if detail.AccessoryAndServiceApplyState == "0" {
                ss.btn_pass.isHidden=false
                ss.btn_reject.isHidden=false
                ss.btn_send.isHidden=true
                ss.uv_yes.isUserInteractionEnabled=true
                ss.uv_no.isUserInteractionEnabled=true
                ss.uv_csdf.isUserInteractionEnabled=true
                ss.uv_xf.isUserInteractionEnabled=true
            }else if detail.AccessoryAndServiceApplyState == "-1" {
                ss.btn_pass.isHidden=true
                ss.btn_reject.isHidden=true
                ss.btn_send.isHidden=true
                ss.uv_yes.isUserInteractionEnabled=false
                ss.uv_no.isUserInteractionEnabled=false
                ss.uv_csdf.isUserInteractionEnabled=false
                ss.uv_xf.isUserInteractionEnabled=false
            }else{
                if detail.ExpressNo==""{//配件是否发货
                    ss.btn_send.isHidden=false
                    ss.uv_expressno.isHidden=true
                }else{
                    ss.btn_send.isHidden=true
                    ss.uv_expressno.isHidden=false
                    ss.lb_expressno.text=detail.ExpressNo!
                }
                ss.btn_pass.isHidden=true
                ss.btn_reject.isHidden=true
                
                ss.uv_yes.isUserInteractionEnabled=false
                ss.uv_no.isUserInteractionEnabled=false
                ss.uv_csdf.isUserInteractionEnabled=false
                ss.uv_xf.isUserInteractionEnabled=false
            }
            
            if ss.IsReturn == "1"{
                ss.iv_yes.image=UIImage(named: "yuangou")
                ss.iv_no.image=UIImage(named: "circle")
                ss.usv_yes.isHidden=false
            }else{
                ss.iv_yes.image=UIImage(named: "circle")
                ss.iv_no.image=UIImage(named: "yuangou")
                ss.usv_yes.isHidden=true
            }
            if ss.PostPayType == "1"{
                ss.iv_csdf.image=UIImage(named: "yuangou")
                ss.iv_xf.image=UIImage(named: "circle")
            }else{
                ss.iv_csdf.image=UIImage(named: "circle")
                ss.iv_xf.image=UIImage(named: "yuangou")
            }
            ss.lb_addr.text=detail.AddressBack!
            if ss.AddressBack==nil{
                ss.getAddress()
            }
            ss.lb_memo.text=detail.AccessoryMemo
            ss.AccessorySequencyStr=detail.AccessorySequencyStr
            ss.lb_type.text=detail.AccessorySequencyStr
            ss.dataSource=detail.OrderAccessroyDetail
            if ss.dataSource.count>0{
                ss.yes.isHidden=false
                ss.no.isHidden=true
            }else{
                ss.yes.isHidden=true
                ss.no.isHidden=false
            }
            ss.tableview.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
//MARK:配件列表
extension PageAccessoryViewController{
    //MARK:审核配件和服务
    @objc func approveOrderAccessoryAndService(){
        let d = [
            "OrderID":OrderID,
            "AccessoryAndServiceApplyState":AccessoryAndServiceApplyState,
            //            "PostPayType":PostPayType,
            //            "IsReturn":IsReturn
            ]as[String:String]
        AlamofireHelper.post(url: ApproveOrderAccessoryAndService, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                HUD.showText("审核成功")
                ss.getOrderDetail()
            }else{
                HUD.showText("审核失败")
            }
            
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableview.dequeueReusableCell(withIdentifier: "re")as!AccessoryTableViewCell
        cell.selectionStyle = .none
        let item=dataSource[indexPath.row]
        cell.lb_name.text=item.FAccessoryName
        cell.lb_count.text="\(item.Quantity)个"
        cell.iv_photo1.setImage(path: URL(string: "https://img.xigyu.com/Pics/Accessory/\(item.Photo1!)")!)
        cell.iv_photo2.setImage(path: URL(string: "https://img.xigyu.com/Pics/Accessory/\(item.Photo2!)")!)
        let tap1=UITapGestureRecognizer(target: self, action: #selector(biger1(sender:)))
        let tap2=UITapGestureRecognizer(target: self, action: #selector(biger1(sender:)))
        cell.iv_photo1.addGestureRecognizer(tap1)
        cell.iv_photo2.addGestureRecognizer(tap2)
        tap1.view!.tag=indexPath.row
        tap2.view!.tag=indexPath.row
        return cell
    }
    //MARK:查看大图
    @objc func biger1(sender:UITapGestureRecognizer!){
        let item=dataSource[sender.view!.tag]
        // URL pattern snippet
        var images = [SKPhoto]()
        images.append(SKPhoto.photoWithImageURL("https://img.xigyu.com/Pics/Accessory/\(item.Photo1!)"))
        images.append(SKPhoto.photoWithImageURL("https://img.xigyu.com/Pics/Accessory/\(item.Photo2!)"))
        
        // create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        self.present(browser, animated: true, completion: {})
    }
    //MARK:拒绝 -1
    @objc func reject(){
        var message=""
        if self.AccessorySequencyStr=="厂家寄件"{
            message = "是否拒绝配件申请？"
        }else{
            message = "亲，拒绝自购件申请，将会发送厂家寄件哦"
        }
        //创建UIAlertController(警告窗口)
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        let OK = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            if self.AccessorySequencyStr=="厂家寄件"{
                self.AccessoryAndServiceApplyState = "-1"
            }else{
                self.AccessoryAndServiceApplyState = "2"
            }
            self.approveOrderAccessoryAndService()
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
    //MARK:通过 1
    @objc func ok(){
        //创建UIAlertController(警告窗口)
        let alert = UIAlertController(title: "提示", message: "是否同意配件申请？", preferredStyle: .alert)
        let OK = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            self.AccessoryAndServiceApplyState = "1"
            self.approveOrderAccessoryAndService()
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
}
//MARK:旧件返厂
extension PageAccessoryViewController{
    @objc func yn(){
        if IsReturn == "2"{
            IsReturn="1"
            iv_yes.image=UIImage(named: "yuangou")
            iv_no.image=UIImage(named: "circle")
            usv_yes.isHidden=false
        }else{
            IsReturn="2"
            iv_yes.image=UIImage(named: "circle")
            iv_no.image=UIImage(named: "yuangou")
            usv_yes.isHidden=true
        }
        if IsReturn=="1"&&AddressBack==nil{
            HUD.showText("请添加寄送地址")
            return
        }
        updateIsReturnByOrderID()
    }
    @objc func xf(){
        if PostPayType == "2"{
            PostPayType="1"
            iv_csdf.image=UIImage(named: "yuangou")
            iv_xf.image=UIImage(named: "circle")
        }else{
            PostPayType="2"
            iv_csdf.image=UIImage(named: "circle")
            iv_xf.image=UIImage(named: "yuangou")
        }
        updateIsReturnByOrderID()
    }
    @objc func chooseAddr(){
        self.navigationController?.pushViewController(AddressViewController(choose: true), animated: true)
    }
    @objc func update(noti: Notification){
        addr=(noti.object as!mShippingAddress)
        AddressBack="\(addr.Province!)\(addr.City!)\(addr.Area!)\(addr.District!)\(addr.Address!)(\(addr.UserName!))收\(addr.Phone!)"
        lb_addr.text=AddressBack
        updateIsReturnByOrderID()
    }
    func getAddress(){
        var d = ["UserID":UserID!] as [String : String]
        AlamofireHelper.post(url: GetAccountAddress, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            let dataSource=res["Data"].arrayValue.compactMap({ mShippingAddress(json: $0)})
            if dataSource.count>0{
                ss.addr=dataSource[0]
                ss.lb_addr.text="\(ss.addr.Province!)\(ss.addr.City!)\(ss.addr.Area!)\(ss.addr.District!)\(ss.addr.Address!)(\(ss.addr.UserName!))收\(ss.addr.Phone!)"
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:旧件是否需要返厂
    func updateIsReturnByOrderID(){
        let d = [
            "OrderID":OrderID,
            "IsReturn":IsReturn,
            "AddressBack":AddressBack,
            "PostPayType":PostPayType
            ]as[String:String]
        AlamofireHelper.post(url: UpdateIsReturnByOrderID, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                
            }else{
                
            }
            
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
//MARK:配件发货
extension PageAccessoryViewController{
    @objc func send(sender:UIButton){
        popview = ZXPopView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        expressView=Bundle.main.loadNibNamed("ExpressView", owner: nil, options: nil)?[0] as? ExpressView
        expressView.layer.cornerRadius=10
        expressView.uv_express.layer.cornerRadius=5
        expressView.btn_submit.addOnClickListener(target: self, action: #selector(submit))
        expressView.uv_qrcode.addOnClickListener(target: self, action: #selector(scan))
        expressView.btn_cancel.addOnClickListener(target: self, action: #selector(dismissview))
        popview.contenView = expressView
        popview.anim = 0
        expressView.snp.makeConstraints { (make) in
            make.width.equalTo(screenW-20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(170)
            make.center.equalToSuperview()
        }
        popview.showInView(view: self.view)
    }
    @objc func dismissview(){
        popview.dismissView()
    }
    @objc func scan(){
        LBXPermissions.authorizeCameraWith { [weak self] (granted) in
            if granted {
                self?.scanQrCode()
            } else {
                LBXPermissions.jumpToSystemPrivacySetting()
            }
        }
    }
    func scanQrCode() {
        //MARK:设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 60;
        style.xScanRetangleOffset = 30;
        if UIScreen.main.bounds.size.height <= 480 {
            //3.5inch 显示的扫码缩小
            style.centerUpOffset = 40;
            style.xScanRetangleOffset = 20;
        }
        style.color_NotRecoginitonArea = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner;
        style.photoframeLineW = 2.0;
        style.photoframeAngleW = 16;
        style.photoframeAngleH = 16;
        style.isNeedShowRetangle = false;
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid;
        style.animationImage = UIImage(named: "qrcode_scan_full_net")
        let vc = LBXScanViewController();
        vc.scanStyle = style
        vc.scanResultDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func submit(){
        var expressno=expressView.tf_expressno.text
        if expressno!.isEmpty{
            expressno="123"
        }
        let d = [
            "OrderID":OrderID,
            "ExpressNo":expressno!
            ]as[String:String]
        AlamofireHelper.post(url: AddOrUpdateExpressNo, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                ss.popview.dismissView()
                ss.getOrderDetail()
            }
            HUD.showText(res["Data"]["Item2"].stringValue)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
