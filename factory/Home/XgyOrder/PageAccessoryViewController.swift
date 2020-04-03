//
//  PageAccessoryViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/21.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class PageAccessoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,LBXScanViewControllerDelegate {
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        expressView.tf_expressno.text=scanResult.strScanned
    }
    
    
    
    @IBOutlet weak var lb_type: UILabel!
    @IBOutlet weak var lb_memo: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var yes: UIView!
    @IBOutlet weak var no: UILabel!
    @IBOutlet weak var uv_no: UIView!
    @IBOutlet weak var uv_yes: UIView!
    @IBOutlet weak var usv_yes: UIStackView!
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
    
    var AccessoryState:String!

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
        btn_send.layer.cornerRadius=5
        btn_modify.layer.cornerRadius=5
        uv_no.addOnClickListener(target: self, action: #selector(yn))
        uv_yes.addOnClickListener(target: self, action: #selector(yn))
        uv_csdf.addOnClickListener(target: self, action: #selector(xf))
        uv_xf.addOnClickListener(target: self, action: #selector(xf))
        btn_send.addOnClickListener(target: self, action: #selector(send(sender:)))
        btn_modify.addOnClickListener(target: self, action: #selector(chooseAddr))
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name("choose"), object: nil)
        tableview.dataSource=self
        tableview.delegate=self
        tableview.separatorStyle = .none
        tableview.register(UINib(nibName: "AccessoryTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        getOrderDetail()
    }
    //工单详情
    func getOrderDetail(){
        let d = ["OrderID":OrderID]as[String:String]
        AlamofireHelper.post(url: GetOrderInfo, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            let detail=mXgyOrderDetail.init(json: res["Data"])
            ss.IsReturn=detail.IsReturn!
            ss.PostPayType=detail.PostPayType!
            ss.AddressBack=detail.AddressBack!
            if ss.IsReturn == "1"{
                ss.iv_yes.image=UIImage(named: "ic_check_true")
                ss.iv_no.image=UIImage(named: "ic_check_false")
                ss.usv_yes.isHidden=false
            }else{
                ss.iv_yes.image=UIImage(named: "ic_check_false")
                ss.iv_no.image=UIImage(named: "ic_check_true")
                ss.usv_yes.isHidden=true
            }
            if ss.PostPayType == "1"{
                ss.iv_csdf.image=UIImage(named: "ic_check_true")
                ss.iv_xf.image=UIImage(named: "ic_check_false")
            }else{
                ss.iv_csdf.image=UIImage(named: "ic_check_false")
                ss.iv_xf.image=UIImage(named: "ic_check_true")
            }
            ss.lb_addr.text=detail.AddressBack!
            if ss.AddressBack==nil{
                ss.getAddress()
            }
            ss.lb_memo.text=detail.AccessoryMemo
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
//配件列表
extension PageAccessoryViewController{
    @objc func approve(){
        popviewOfAccessory = ZXPopView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH))
        approveAccessoryView=Bundle.main.loadNibNamed("ApproveAccessoryView", owner: nil, options: nil)?[0] as? ApproveAccessoryView
        approveAccessoryView.layer.cornerRadius=10
        approveAccessoryView.uv_name.layer.cornerRadius=5
        approveAccessoryView.uv_price.layer.cornerRadius=5
        approveAccessoryView.btn_submit.addOnClickListener(target: self, action: #selector(approveok))
        approveAccessoryView.btn_cancel.addOnClickListener(target: self, action: #selector(dismissviewOfApprove))
        popviewOfAccessory.contenView = approveAccessoryView
        popviewOfAccessory.anim = 0
        approveAccessoryView.snp.makeConstraints { (make) in
            make.width.equalTo(screenW-20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(235)
            make.center.equalToSuperview()
        }
        popviewOfAccessory.showInView(view: self.view)
    }
    @objc func dismissviewOfApprove(){
        popviewOfAccessory.dismissView()
    }
    @objc func updateFactoryAccessorybyFactory(){
        let d = [
            "Id":AccessoryID,
            "AccessoryName":AccessoryName,
            "AccessoryPrice":AccessoryPrice,
            "OrderAccessoryId":OrderAccessoryID
            ]as[String:String]
        AlamofireHelper.post(url: UpdateFactoryAccessorybyFactory, parameters: d, successHandler: {[weak self](res)in
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
    func approveOrderAccessoryByModifyPrice(){
        let d = [
            "OrderID":OrderID,
            "OrderAccessoryID":OrderAccessoryID,
            "NewMoney":"0",
            "AccessoryApplyState":AccessoryState
            ]as[String:String]
        AlamofireHelper.post(url: ApproveOrderAccessoryByModifyPrice, parameters: d, successHandler: {[weak self](res)in
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
        cell.btn_reject.layer.cornerRadius=5
        cell.btn_ok.layer.cornerRadius=5
        cell.lb_name.text=item.FAccessoryName
        cell.lb_count.text="￥\(item.Price)/\(item.Quantity)个"
        if item.State=="0"{
            cell.usv_btn.isHidden=false
            cell.lb_status.isHidden=true
        }else{
            cell.usv_btn.isHidden=true
            cell.lb_status.isHidden=false
            if item.State=="1"{
                cell.lb_status.text="已通过"
            }else{
                cell.lb_status.text="已拒绝"
            }
        }
        cell.btn_reject.addTarget(self, action: #selector(reject(sender:)), for: UIControl.Event.touchUpInside)
        cell.btn_ok.addTarget(self, action: #selector(ok(sender:)), for: UIControl.Event.touchUpInside)
        cell.btn_reject.tag = indexPath.row
        cell.btn_ok.tag = indexPath.row
        return cell
    }
    //拒绝 -1
    @objc func reject(sender:UIButton){
        let item=dataSource[sender.tag]
        AccessoryID="\(item.FAccessoryID)"
        OrderAccessoryID="\(item.Id)"
        AccessoryName=item.FAccessoryName
        AccessoryPrice="\(item.Price)"
        AccessoryState="-1"
        //创建UIAlertController(警告窗口)
        let alert = UIAlertController(title: "提示", message: "是否拒绝？", preferredStyle: .alert)
        let OK = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            self.approveOrderAccessoryByModifyPrice()
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
    //通过 1
    @objc func ok(sender:UIButton){
        let item=dataSource[sender.tag]
        AccessoryID="\(item.FAccessoryID)"
        OrderAccessoryID="\(item.Id)"
        AccessoryState="1"

        approve()
    }
    //通过 提交
    @objc func approveok(){
        let AccessoryName=approveAccessoryView.tf_name.text
        let AccessoryPrice=approveAccessoryView.tf_price.text
        if !AccessoryName!.isEmpty{
            self.AccessoryName=AccessoryName
        }
        if !AccessoryPrice!.isEmpty{
            self.AccessoryPrice=AccessoryPrice
        }
        updateFactoryAccessorybyFactory()
        approveOrderAccessoryByModifyPrice()
    }
}
//旧件返厂
extension PageAccessoryViewController{
    @objc func yn(){
        if IsReturn == "2"{
            IsReturn="1"
            iv_yes.image=UIImage(named: "ic_check_true")
            iv_no.image=UIImage(named: "ic_check_false")
            usv_yes.isHidden=false
        }else{
            IsReturn="2"
            iv_yes.image=UIImage(named: "ic_check_false")
            iv_no.image=UIImage(named: "ic_check_true")
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
            iv_csdf.image=UIImage(named: "ic_check_true")
            iv_xf.image=UIImage(named: "ic_check_false")
        }else{
            PostPayType="2"
            iv_csdf.image=UIImage(named: "ic_check_false")
            iv_xf.image=UIImage(named: "ic_check_true")
        }
        updateIsReturnByOrderID()
    }
    @objc func chooseAddr(){
        self.navigationController?.pushViewController(AddressViewController(choose: true), animated: true)
    }
    @objc func update(noti: Notification){
        addr=(noti.object as!mShippingAddress)
//        AddressBack="\(addr.RegionFullName!)\(addr.Address!)(\(addr.ShipTo!))收\(addr.Phone!)"
//        lb_addr.text="\(addr.RegionFullName!)\(addr.Address!)(\(addr.ShipTo!))收\(addr.Phone!)"
        updateIsReturnByOrderID()
    }
    func getAddress(){
//        var d = ["userkey":UserID!,
//                 "app_key":app_key,
//                 "timestamp":getTimestamp()
//            ] as [String : String]
//        let sign=SignTopRequest(params: d)
//        d["sign"]=sign
//        AlamofireHelper.get(url: GetShippingAddressList, parameters: d, successHandler: {[weak self](res)in
//            HUD.dismiss()
//            guard let ss = self else {return}
//            let addrList=mShippingAddressList.init(json: res)
//            var shippingAddr:mShippingAddress!
//            if addrList.ShippingAddress.count>0{
//                for addr in addrList.ShippingAddress{
//                    if addr.IsDefault{
//                        shippingAddr=addr
//                    }
//                }
//                if shippingAddr == nil{
//                    shippingAddr=addrList.ShippingAddress[0]
//                }
//                ss.addr=shippingAddr
//                ss.AddressBack="\(ss.addr.RegionFullName!)\(ss.addr.Address!)(\(ss.addr.ShipTo!))收\(ss.addr.Phone!)"
//                ss.lb_addr.text="\(ss.addr.RegionFullName!)\(ss.addr.Address!)(\(ss.addr.ShipTo!))收\(ss.addr.Phone!)"
//                ss.btn_modify.setTitle("修改地址", for: .normal)
//            }else{
//                ss.lb_addr.text=""
//                ss.btn_modify.setTitle("添加地址", for: .normal)
//            }
//
//        }){[weak self] (error) in
//            HUD.dismiss()
//            guard let ss = self else {return}
//        }
    }
    //旧件是否需要返厂
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
//配件发货
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
        //设置扫码区域参数
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
            }
            HUD.showText(res["Data"]["Item2"].stringValue)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
