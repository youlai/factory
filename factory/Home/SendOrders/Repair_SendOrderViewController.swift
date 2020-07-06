//
//  Repair_SendOrderViewController.swift
//  发布维修需求
//  Created by Apple on 2019/8/13.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class Repair_SendOrderViewController: UIViewController,LBXScanViewControllerDelegate {
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        self.tf_expressno.text = scanResult.strScanned!
    }
    
    
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var uv_common: UIView!
    @IBOutlet weak var uv_cate: UIView!
    @IBOutlet weak var uv_gg: UIView!
    @IBOutlet weak var uv_brand: UIView!
    @IBOutlet weak var uv_type: UIView!
    
    @IBOutlet weak var uv_yfpj: UIView!
    
    @IBOutlet weak var btn_addbrand: UIButton!
    @IBOutlet weak var btn_addprodmodel: UIButton!
    @IBOutlet weak var btn_addacc: UIButton!
    @IBOutlet weak var lb_acc: UILabel!
    @IBOutlet weak var uv_fc: UIView!
    
    
    @IBOutlet weak var uv_qrcode: UIView!
    @IBOutlet weak var uv_expressno: UIView!
    @IBOutlet weak var tf_expressno: UITextField!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_phone: UITextField!
    @IBOutlet weak var tv_addr: UITextView!
    @IBOutlet weak var tv_memo: UITextView!
    @IBOutlet weak var uv_scan: UIView!
    @IBOutlet weak var uv_time: UIView!
    
    @IBOutlet weak var lb_common: UILabel!
    @IBOutlet weak var lb_cate: UILabel!
    @IBOutlet weak var lb_gg: UILabel!
    @IBOutlet weak var lb_brand: UILabel!
    @IBOutlet weak var lb_type: UILabel!
    
    @IBOutlet weak var uv_addr: UIView!
    @IBOutlet weak var lb_addr: UILabel!
    @IBOutlet weak var check_yqs: UIView!
    @IBOutlet weak var check_wqs: UIView!
    @IBOutlet weak var iv_yqs: UIImageView!
    @IBOutlet weak var iv_wqs: UIImageView!
    @IBOutlet weak var check_bn: UIView!
    @IBOutlet weak var check_nw: UIView!
    @IBOutlet weak var iv_bn: UIImageView!
    @IBOutlet weak var iv_bw: UIImageView!
    @IBOutlet weak var check_fc: UIView!
    @IBOutlet weak var check_bfc: UIView!
    @IBOutlet weak var iv_fc: UIImageView!
    @IBOutlet weak var iv_bfc: UIImageView!
    @IBOutlet weak var check_df: UIView!
    @IBOutlet weak var check_xf: UIView!
    @IBOutlet weak var iv_df: UIImageView!
    @IBOutlet weak var iv_xf: UIImageView!
    @IBOutlet weak var uv_choose_time: UIView!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_extra: UILabel!
    @IBOutlet weak var btn_submit: UIButton!
    
    @IBOutlet weak var lb_fjaddr: UILabel!
    @IBOutlet weak var btn_fjaddr: UIButton!
    
    
    var popviewOfBrand: ZXPopView!
    var chooseCommonView: ChooseCommonView!
    var chooseProdCategoryView: ChooseProdCategoryView!
    var chooseProdSpecificationsView: ChooseProdSpecificationsView!
    var chooseBrandView: ChooseBrandView!
    var chooseProdModelView: ChooseProdModelView!
    
    var popviewOfType: ZXPopView!
    var chooseTypeView: ChooseTypeView!
    
    var popviewOfTime: ZXPopView!
    var chooseTimeView: ChooseTimeView!
    
    var brand: BrandOfxgy!//选中的品牌
    var prodCommon: ProdCommon!//选中的常用型号
    var prodCategory: ProdCategory!//选中的分类
    var prodSpecifications: ProdSpecifications!//选中的规格
    var prodModel: ProdModel!//选中的型号
    
    var subid: Int!//选中的分类ID
    var spid: Int!//选中的规格ID
    var brandid: Int!//选中的品牌ID
    var modelid: Int!//选中的型号ID
    
    var time: String!//选中的上门时间
    var name: String!//姓名
    var phone: String!//手机
    var provinceCode: String!//省
    var cityCode: String!//市
    var areaCode: String!//区
    var streetCode: String!//街道
    var addr: String!//所在地区
    var addr_detail: String!//详细地址
    
    var IsRecevieGoods="N"//是否已发配件 N否 Y是
    
    var Guarantee="1"//1保内 2保外
    var AddressBack=""//旧件地址
    var PostPayType="1"//1到付 2现付
    var IsReturn="2"//1返件  2不返件
    
    
    var Memo:String!//故障描述
    var ExpressNo=""//快递单号
    var Num="1"//数量默认1
    
    var Extra="N"//是否加急 默认否
    var ExtraTime="0"//加急时间
    var ExtraFee="0"//加急费用
    
    var ContinueIssuing="0"//是否重复发单
    
    var popviewOfAccessory:ZXPopView!
    var chooseAccessoryView:ChooseAccessoryView!
    var acc_list=[Accessory]()
    var acc_ready_list=[Accessory]()
    var selectedIndexs = [Int]()
    
    var SizeIDs=[Int]()
    var maxSizeID:Int!//传递给工厂的最大sizeID
    var factoryMoney:Double!//传递给工厂的money
    var OrderAccessoryStr:JSON!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        uv_back.addOnClickListener(target: self, action: #selector(back))
        
        uv_brand.addOnClickListener(target: self, action: #selector(getFactoryBrandByUserID))
        uv_type.addOnClickListener(target: self, action: #selector(getType))
        
        uv_common.addOnClickListener(target: self, action: #selector(getFactoryProd))
        uv_cate.addOnClickListener(target: self, action: #selector(getProdCategory))
        uv_gg.addOnClickListener(target: self, action: #selector(getProdSpecifications))
        
        btn_addbrand.addOnClickListener(target: self, action: #selector(addBrand))
        btn_addprodmodel.addOnClickListener(target: self, action: #selector(addProdModel))
        
        uv_addr.addOnClickListener(target: self, action: #selector(chooseAddr))
        btn_fjaddr.addOnClickListener(target: self, action: #selector(changeAddr))
        check_yqs.addOnClickListener(target: self, action: #selector(qs))
        check_wqs.addOnClickListener(target: self, action: #selector(qs))
        check_bn.addOnClickListener(target: self, action: #selector(bnw))
        check_nw.addOnClickListener(target: self, action: #selector(bnw))
        check_fc.addOnClickListener(target: self, action: #selector(fc))
        check_bfc.addOnClickListener(target: self, action: #selector(fc))
        check_xf.addOnClickListener(target: self, action: #selector(dfOrxf))
        check_df.addOnClickListener(target: self, action: #selector(dfOrxf))
        uv_choose_time.addOnClickListener(target: self, action: #selector(getTime))
        uv_scan.addOnClickListener(target: self, action: #selector(scan))
        btn_submit.layer.cornerRadius=5
        btn_submit.addOnClickListener(target: self, action: #selector(submit))
        btn_addacc.addOnClickListener(target: self, action: #selector(add_accessory))
        NotificationCenter.default.addObserver(self, selector: #selector(update), name: NSNotification.Name("choose"), object: nil)
    }
    //MARK:添加品牌
    @objc func addBrand(){
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
                let d = [
                         "brandName":tf_name.text!
                ]
                AlamofireHelper.post(url: AddBrand, parameters: d, successHandler: {[weak self](res)in
                    HUD.dismiss()
                    guard let ss = self else {return}
                    if res["Data"]["status"].boolValue{
                        HUD.showText("添加品牌成功")
                    }else{
                        HUD.showText(res["Data"]["msg"].stringValue)
                    }
                }){[weak self] (error) in
                    HUD.dismiss()
                    guard let ss = self else {return}
                }
            }
            alertController.addAction(cancelAction);
            alertController.addAction(okAction);
            self.present(alertController, animated: true, completion: nil)
    }
    //MARK:添加型号
    @objc func addProdModel(){
        if spid==nil{
            HUD.showText("请先选择规格")
            return
        }
            let alertController = UIAlertController(title: "添加型号", message: "请输入型号名称", preferredStyle: UIAlertController.Style.alert);
            alertController.addTextField { (textField:UITextField!) -> Void in
                textField.placeholder = "型号名称";
            }
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil )
            let okAction = UIAlertAction(title: "确认", style: UIAlertAction.Style.default) { (ACTION) -> Void in
                let tf_name = alertController.textFields!.first! as UITextField
                if tf_name.text!.isEmpty{
                    HUD.showText("不能为空")
                    return
                }
                let d = ["specificationsID":self.spid!,
                         "prodModel":tf_name.text!
                    ] as [String : Any]
                AlamofireHelper.post(url: AddProdModel, parameters: d, successHandler: {[weak self](res)in
                    HUD.dismiss()
                    guard let ss = self else {return}
                    if res["Data"]["status"].boolValue{
                        HUD.showText("添加型号成功")
                    }else{
                        HUD.showText(res["Data"]["msg"].stringValue)
                    }
                }){[weak self] (error) in
                    HUD.dismiss()
                    guard let ss = self else {return}
                }
            }
            alertController.addAction(cancelAction);
            alertController.addAction(okAction);
            self.present(alertController, animated: true, completion: nil)
    }
    //MARK:旧件地址修改
    @objc func changeAddr(){
        self.navigationController?.pushViewController(AddressViewController(choose: true), animated: true)
    }
    @objc func update(noti: Notification){
        let addr=(noti.object as!mShippingAddress)
        AddressBack="\(addr.Province!)\(addr.City!)\(addr.Area!)\(addr.District!)\(addr.Address!)(\(addr.UserName!))收\(addr.Phone!)"
        lb_fjaddr.text=AddressBack
        //            updateIsReturnByOrderID()
    }
    //MARK:添加配件
    @objc func add_accessory(){
        if spid==nil{
            HUD.showText("请选择规格")
            return
        }
        let d = ["FCategoryID":spid]
        AlamofireHelper.post(url: GetFactoryAccessory, parameters: d as [String : Any], successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.selectedIndexs.removeAll()
            ss.popviewOfAccessory = ZXPopView.init(frame: ss.view.bounds)
            ss.chooseAccessoryView=Bundle.main.loadNibNamed("ChooseAccessoryView", owner: nil, options: nil)?[0] as? ChooseAccessoryView
            ss.chooseAccessoryView.accessoryList=res["Data"]["data"].arrayValue.compactMap({ Accessory(json: $0)})
            ss.chooseAccessoryView.tableview.register(UINib(nibName: "AccessoryCell", bundle: nil), forCellReuseIdentifier: "re")
            ss.chooseAccessoryView.tableview.reloadData()
            ss.chooseAccessoryView.btn_confirm.addOnClickListener(target: ss, action: #selector(ss.dismisspopview))
            ss.chooseAccessoryView.tableview.separatorStyle = .none
            ss.chooseAccessoryView.Select={ (item:[Int]) -> Void in
                ss.selectedIndexs=item
            }
            ss.chooseAccessoryView.clipsToBounds=true
            
            let gradientLayer = CAGradientLayer().rainbowLayer()
            gradientLayer.frame = ss.chooseAccessoryView.btn_confirm.bounds
            ss.chooseAccessoryView.btn_confirm.layer.insertSublayer(gradientLayer, at: 0)
            ss.chooseAccessoryView.btn_confirm.clipsToBounds=true
            
            ss.chooseAccessoryView.btn_confirm.layer.cornerRadius=10
            //            ss.chooseAccessoryView.layer.cornerRadius=10
            ss.popviewOfAccessory.contenView = ss.chooseAccessoryView
            ss.popviewOfAccessory.anim = 0
            ss.chooseAccessoryView.snp.makeConstraints { (make) in
                make.width.equalTo(screenW-20)
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.height.equalTo(screenH/3*2)
                make.center.equalToSuperview()
            }
            ss.popviewOfAccessory.showInView(view: ss.view)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func dismisspopview(){
        acc_list.removeAll()
        for index in selectedIndexs{
            acc_list.append(chooseAccessoryView.accessoryList[index])
        }
        if acc_list.count==0{
            HUD.showText("请选择配件！")
            return
        }
        var accStr=""
        for item in acc_list {
            accStr+="\(item.AccessoryName ?? "")(\(item.count)个)、"
        }
        lb_acc.text=String(accStr.prefix(accStr.count-1))
        var list=[JSON]()
        for i in 0..<acc_list.count{
            let item=OrderAccessoryModel(State: "0", Price: 0, Quantity: "\(acc_list[i].count)", Photo1: acc_list[i].photo1, DiscountPrice: 0, SizeID: "\(acc_list[i].SizeID)", IsPay: "N", FAccessoryName: acc_list[i].AccessoryName, FCategoryID: "\(acc_list[i].FCategoryID)", Relation: "", SendState: "N", NeedPlatformAuth: "N", Photo2: acc_list[i].photo2, ExpressNo: "", FAccessoryID: "\(acc_list[i].FAccessoryID)")
            list.append(JSON(parseJSON: item.toJSON()!))
        }
        
        let acc_dic=["OrderAccessory":list]
        self.OrderAccessoryStr=JSON(acc_dic)
        popviewOfAccessory.dismissView()
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
    //MARK:扫描快递单号
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
    //MARK:是否已发配件
    @objc func qs(){
        
        if IsRecevieGoods == "N"{
            IsRecevieGoods="Y"
            iv_yqs.image=UIImage(named: "yuangou")
            iv_wqs.image=UIImage(named: "circle")
            uv_yfpj.isHidden=false
        }else{
            IsRecevieGoods="N"
            iv_yqs.image=UIImage(named: "circle")
            iv_wqs.image=UIImage(named: "yuangou")
            uv_yfpj.isHidden=true
        }
    }
    //MARK:旧件是否返厂
    @objc func fc(){
        
        if IsReturn == "2"{
            IsReturn="1"
            iv_fc.image=UIImage(named: "yuangou")
            iv_bfc.image=UIImage(named: "circle")
            uv_fc.isHidden=false
        }else{
            IsReturn="2"
            iv_fc.image=UIImage(named: "circle")
            iv_bfc.image=UIImage(named: "yuangou")
            uv_fc.isHidden=true
        }
    }
    //MARK:邮费支付方式
    @objc func dfOrxf(){
        
        if PostPayType == "1"{
            PostPayType="2"
            iv_xf.image=UIImage(named: "yuangou")
            iv_df.image=UIImage(named: "circle")
        }else{
            PostPayType="1"
            iv_xf.image=UIImage(named: "circle")
            iv_df.image=UIImage(named: "yuangou")
        }
    }
    //MARK:保内保外
    @objc func bnw(){
        
        if Guarantee == "2"{
            Guarantee="1"
            iv_bn.image=UIImage(named: "yuangou")
            iv_bw.image=UIImage(named: "circle")
        }else{
            Guarantee="2"
            iv_bn.image=UIImage(named: "circle")
            iv_bw.image=UIImage(named: "yuangou")
        }
    }
    //MARK:返回
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:所在地区
    @objc func chooseAddr(){
        AlamofireHelper.post(url: GetProvince, parameters: nil, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            let alert = ChooseAddressAlert(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH), andHeight: kSize(width:500))
            alert.alpha = 0
            UIApplication.shared.keyWindow?.addSubview(alert)
            alert.selectAddress = {(select:(Street,String,(Province,City,Area,Street))) -> Void in
                ss.addr = "\(select.2.0.name ?? "")/\(select.2.1.name ?? "")/\(select.2.2.name ?? "")/\(select.2.3.name ?? "")"
                ss.lb_addr.text = select.1
            }
            alert.initprovince(addressModel: res["Data"].arrayValue.compactMap({ Province(json: $0)}))
            alert.showView()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:确认提交
    @objc func submit(){
        if subid==nil{
            HUD.showText("请选择分类!")
            return
        }
        if spid==nil{
            HUD.showText("请选择规格!")
            return
        }
        if brandid==nil{
            HUD.showText("请选择品牌!")
            return
        }
        if modelid==nil{
            HUD.showText("请选择型号!")
            return
        }
        name=tf_name.text
        phone=tf_phone.text
        if name.isEmpty{
            HUD.showText("请输入客户姓名!")
            return
        }
        if phone.isEmpty{
            HUD.showText("请输入客户手机!")
            return
        }
        if addr==nil{
            HUD.showText("请添加所在地区!")
            return
        }
        addr_detail=tv_addr.text
        if addr_detail.isEmpty{
            HUD.showText("请输入详细地址!")
            return
        }
        if IsRecevieGoods=="Y"{//已发配件
            ExpressNo=tf_expressno.text!
            if ExpressNo.isEmpty{
                HUD.showText("请填写快递单号!")
                return
            }
            if OrderAccessoryStr==nil{
                HUD.showText("请添加配件!")
                return
            }
            if IsReturn=="1"{//返件
                if AddressBack.isEmpty{
                    HUD.showText("请添加返件地址!")
                    return
                }
            }
        }
        Memo=tv_memo.text
        if Memo.isEmpty{
            HUD.showText("请填写故障描述!")
            return
        }
        var d = [
            "phone":phone!,
            "name":name!,
            "city":addr!,
            "addstr":addr_detail!,
            "servicetype":"1",
            "guaranteetype":Guarantee,
            "subCategoryID":subid!,
            "specifications":spid!,
            "factoryBrandName":brandid!,
            "prodModel":modelid!,
            "parts":IsRecevieGoods,
            "bak":Memo!,
            "Num":Num,
            "ContinueIssuing":ContinueIssuing
            ] as [String : Any]
        if IsRecevieGoods=="Y"{//已发配件
            d["ExpressNo"]=ExpressNo//快递单号
            d["backParts"]=IsReturn//是否返件 (1返,2不返)
            if IsReturn=="1"{
                d["postpaytype"]=PostPayType//1到付，2现付
                d["backAddress"]=AddressBack//旧配件返件地址、联系人、电话号码
            }
            if acc_list.count==0 {
                d["partsVal"]=""
            }else{
                var acc=[Any]()
                for item in acc_list {
                    acc.append(["name":item.AccessoryName!,"value":item.FAccessoryID])
                }
                d["partsVal"]=acc
            }
        }
        print(d)
//        AlamofireHelper.post(url: AddOrder, parameters: d, successHandler: {[weak self](res)in
//            HUD.dismiss()
//            guard let ss = self else {return}
//            if res["Data"]["status"].boolValue{
//                HUD.showText(res["Data"]["msg"].stringValue)
//                ss.navigationController?.popViewController(animated: true)
//            }else{
//                HUD.showText(res["Data"]["msg"].stringValue)
//            }
//        }){[weak self] (error) in
//            HUD.dismiss()
//            guard let ss = self else {return}
//        }
        guard AddOrder.lengthOfBytes(using: String.Encoding.utf8) > 0 else { return}
                var header:HTTPHeaders = [:]
                if  (UserID != nil) {
                    header["userName"] = UserID
                    header["adminToken"] = adminToken
                }
                
        Alamofire.request(AddOrder, method:.post, parameters: d, encoding:JSONEncoding.default, headers: header)
                    .validate()
                    .responseJSON { (dataResponse) in
                        DispatchQueue.main.async {
                            switch dataResponse.result {
                            case .success(let value):
                                let jsonData = JSON.init(value as Any)
                                if jsonData["Data"]["status"].boolValue{
                                    HUD.showText(jsonData["Data"]["msg"].stringValue)
                                    self.navigationController?.popViewController(animated: true)
                                }else{
                                    HUD.showText(jsonData["Data"]["msg"].stringValue)
                                }
                                break
                                
                            case .failure(let error):
                                HUD.showText("服务器错误")
                                break
                            }
                        }
                }
    }
    //MARK:余额不足是否前往充值
    @objc func toRecharge(){
            let alertVC : UIAlertController = UIAlertController.init(title: "账户可用余额小于工单金额,是否前往充值？", message: "", preferredStyle: .alert)
        let falseAA : UIAlertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let trueAA : UIAlertAction = UIAlertAction.init(title: "确定", style: .default) { (alertAction) in
            self.navigationController?.pushViewController(RechargeViewController(), animated: true)
        }
        alertVC.addAction(falseAA)
        alertVC.addAction(trueAA)
        self.present(alertVC, animated: true, completion: nil)
    }
    //MARK:重复发单提醒
    @objc func showrepeat(){
            let alertVC : UIAlertController = UIAlertController.init(title: "该用户已有工单，是否继续发单？", message: "", preferredStyle: .alert)
        let falseAA : UIAlertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let trueAA : UIAlertAction = UIAlertAction.init(title: "确定", style: .default) { (alertAction) in
            self.ContinueIssuing=""
            self.submit()
        }
        alertVC.addAction(falseAA)
        alertVC.addAction(trueAA)
        self.present(alertVC, animated: true, completion: nil)
    }
    //MARK:未充值保证金是否前往充值
    @objc func toMargin(){
            let alertVC : UIAlertController = UIAlertController.init(title: "保证金低于最低需缴纳金额,是否前往缴纳保证金？", message: "", preferredStyle: .alert)
        let falseAA : UIAlertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let trueAA : UIAlertAction = UIAlertAction.init(title: "确定", style: .default) { (alertAction) in
            self.navigationController?.pushViewController(MarginViewController(), animated: true)
        }
        alertVC.addAction(falseAA)
        alertVC.addAction(trueAA)
        self.present(alertVC, animated: true, completion: nil)
    }
}

//MARK:选择品牌
extension Repair_SendOrderViewController{
    @objc func getFactoryBrandByUserID(){
        let d = ["UserID":UserID!]
        AlamofireHelper.post(url: GetFactoryBrandByUserID, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.popviewOfBrand = ZXPopView.init(frame: ss.view.bounds)
            ss.chooseBrandView=Bundle.main.loadNibNamed("ChooseBrandView", owner: nil, options: nil)?[0] as? ChooseBrandView
            ss.chooseBrandView.brandList=res["Data"].arrayValue.compactMap({ BrandOfxgy(json: $0)})
            if ss.chooseBrandView.brandList.count==0{
                HUD.showText("无品牌")
                return
            }
            ss.chooseBrandView.tableview.reloadData()
            ss.chooseBrandView.tableview.separatorStyle = .none
            ss.chooseBrandView.brandSelect={ (brand:BrandOfxgy) -> Void in
                ss.brand=brand
                ss.brandid=brand.FBrandID
                ss.lb_brand.text=brand.FBrandName
                ss.popviewOfBrand.dismissView()
            }
            ss.chooseBrandView.clipsToBounds=true
            ss.chooseBrandView.layer.cornerRadius=10
            ss.popviewOfBrand.contenView = ss.chooseBrandView
            ss.popviewOfBrand.anim = 0
            ss.chooseBrandView.snp.makeConstraints { (make) in
                make.width.equalTo(screenW-20)
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.height.equalTo(screenH/2)
                make.center.equalToSuperview()
            }
            ss.popviewOfBrand.showInView(view: ss.view)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func dismissPopOfBrand(){
        popviewOfBrand.dismissView()
    }
}
//MARK:选择常用型号
extension Repair_SendOrderViewController{
    @objc func getFactoryProd(){
        let d = ["searchName":""]
        AlamofireHelper.post(url: GetFactoryProd, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.popviewOfBrand = ZXPopView.init(frame: ss.view.bounds)
            ss.chooseCommonView=Bundle.main.loadNibNamed("ChooseCommonView", owner: nil, options: nil)?[0] as? ChooseCommonView
            ss.chooseCommonView.brandList=res["Data"].arrayValue.compactMap({ ProdCommon(json: $0)})
            if ss.chooseCommonView.brandList.count==0{
                HUD.showText("无常用型号")
                return
            }
            ss.chooseCommonView.tableview.reloadData()
            ss.chooseCommonView.tableview.separatorStyle = .none
            ss.chooseCommonView.brandSelect={ (brand:ProdCommon) -> Void in
                ss.prodCommon=brand
                
                ss.subid=brand.SubCategoryID
                ss.spid=brand.ProductTypeID
                ss.brandid=brand.BrandID
                ss.modelid=brand.ProdModelID
                
                ss.lb_common.text="\(brand.BrandName ?? "")-\(brand.ProdModel ?? "")"
                ss.lb_cate.text=brand.SubCategoryName
                ss.lb_gg.text=brand.ProductTypeName
                ss.lb_brand.text=brand.BrandName
                ss.lb_type.text=brand.ProdModel
                ss.popviewOfBrand.dismissView()
            }
            ss.chooseCommonView.clipsToBounds=true
            ss.chooseCommonView.layer.cornerRadius=10
            ss.popviewOfBrand.contenView = ss.chooseCommonView
            ss.popviewOfBrand.anim = 0
            ss.chooseCommonView.snp.makeConstraints { (make) in
                make.width.equalTo(screenW-20)
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.height.equalTo(screenH/2)
                make.center.equalToSuperview()
            }
            ss.popviewOfBrand.showInView(view: ss.view)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
//MARK:选择分类
extension Repair_SendOrderViewController{
    @objc func getProdCategory(){
//        let d = ["searchName":""]
        AlamofireHelper.post(url: GetProdCategory, parameters: nil, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.popviewOfBrand = ZXPopView.init(frame: ss.view.bounds)
            ss.chooseProdCategoryView=Bundle.main.loadNibNamed("ChooseProdCategoryView", owner: nil, options: nil)?[0] as? ChooseProdCategoryView
            ss.chooseProdCategoryView.brandList=res["Data"].arrayValue.compactMap({ ProdCategory(json: $0)})
            if ss.chooseProdCategoryView.brandList.count==0{
                HUD.showText("无分类")
                return
            }
            ss.chooseProdCategoryView.tableview.reloadData()
            ss.chooseProdCategoryView.tableview.separatorStyle = .none
            ss.chooseProdCategoryView.brandSelect={ (brand:ProdCategory) -> Void in
                ss.prodCategory=brand
                ss.subid=brand.SpecificationsID
                ss.spid=nil
                ss.modelid=nil
                ss.prodSpecifications=nil
                ss.prodModel=nil
                ss.lb_cate.text=brand.FCategoryName
                ss.lb_gg.text=""
                ss.lb_type.text=""
                ss.popviewOfBrand.dismissView()
            }
            ss.chooseProdCategoryView.clipsToBounds=true
            ss.chooseProdCategoryView.layer.cornerRadius=10
            ss.popviewOfBrand.contenView = ss.chooseProdCategoryView
            ss.popviewOfBrand.anim = 0
            ss.chooseProdCategoryView.snp.makeConstraints { (make) in
                make.width.equalTo(screenW-20)
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.height.equalTo(screenH/2)
                make.center.equalToSuperview()
            }
            ss.popviewOfBrand.showInView(view: ss.view)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
//MARK:选择规格
extension Repair_SendOrderViewController{
    @objc func getProdSpecifications(){
        if subid==nil{
            HUD.showText("请先选择分类！")
            return
        }
        let d = ["subCategoryID":subid]
        AlamofireHelper.post(url: GetProdSpecifications, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.popviewOfBrand = ZXPopView.init(frame: ss.view.bounds)
            ss.chooseProdSpecificationsView=Bundle.main.loadNibNamed("ChooseProdSpecificationsView", owner: nil, options: nil)?[0] as? ChooseProdSpecificationsView
            ss.chooseProdSpecificationsView.brandList=res["Data"].arrayValue.compactMap({ ProdSpecifications(json: $0)})
            if ss.chooseProdSpecificationsView.brandList.count==0{
                HUD.showText("无规格")
                return
            }
            ss.chooseProdSpecificationsView.tableview.reloadData()
            ss.chooseProdSpecificationsView.tableview.separatorStyle = .none
            ss.chooseProdSpecificationsView.brandSelect={ (brand:ProdSpecifications) -> Void in
                ss.prodSpecifications=brand
                ss.spid=brand.SpecificationsID
                ss.modelid=nil
                ss.prodModel=nil
                ss.lb_gg.text=brand.FCategoryName
                ss.lb_type.text=""
                ss.popviewOfBrand.dismissView()
            }
            ss.chooseProdSpecificationsView.clipsToBounds=true
            ss.chooseProdSpecificationsView.layer.cornerRadius=10
            ss.popviewOfBrand.contenView = ss.chooseProdSpecificationsView
            ss.popviewOfBrand.anim = 0
            ss.chooseProdSpecificationsView.snp.makeConstraints { (make) in
                make.width.equalTo(screenW-20)
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.height.equalTo(screenH/2)
                make.center.equalToSuperview()
            }
            ss.popviewOfBrand.showInView(view: ss.view)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
//MARK:选择型号
extension Repair_SendOrderViewController{
    @objc func getType(){
        if spid==nil {
            HUD.showText("请先选择规格！")
            return
        }
        let d = ["specificationsID":spid
        ]
        print(d)
        AlamofireHelper.post(url: GetProdModel, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.popviewOfType = ZXPopView.init(frame: ss.view.bounds)
            ss.chooseProdModelView=Bundle.main.loadNibNamed("ChooseProdModelView", owner: nil, options: nil)?[0] as? ChooseProdModelView
            ss.chooseProdModelView.brandList=res["Data"].arrayValue.compactMap({ ProdModel(json: $0)})
            if ss.chooseProdModelView.brandList.count==0{
                HUD.showText("无型号")
                return
            }
            ss.chooseProdModelView.tableview.reloadData()
            ss.chooseProdModelView.tableview.separatorStyle = .none
            ss.chooseProdModelView.brandSelect={ (cate:ProdModel) -> Void in
                ss.prodModel=cate
                ss.modelid=cate.ID
                ss.lb_type.text=cate.ModelName
                ss.popviewOfType.dismissView()
            }
            ss.chooseProdModelView.clipsToBounds=true
            ss.chooseProdModelView.layer.cornerRadius=10
            ss.popviewOfType.contenView = ss.chooseProdModelView
            ss.popviewOfType.anim = 0
            ss.chooseProdModelView.snp.makeConstraints { (make) in
                make.width.equalTo(screenW-20)
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.height.equalTo(screenH/2)
                make.center.equalToSuperview()
            }
            ss.popviewOfType.showInView(view: ss.view)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func dismissPopOfType(){
        popviewOfType.dismissView()
    }
}
//MARK:指定上门时间
extension Repair_SendOrderViewController{
    @objc func getTime(){
        popviewOfTime = ZXPopView.init(frame: self.view.bounds)
        chooseTimeView=Bundle.main.loadNibNamed("ChooseTimeView", owner: nil, options: nil)?[0] as? ChooseTimeView
        chooseTimeView.tableview.separatorStyle = .none
        chooseTimeView.timeSelect={ (time:(String,Int)) -> Void in
            self.time=time.0
            self.lb_time.text=time.0
            switch time.1 {
            case 1:
                self.Extra="Y"
                self.ExtraTime="12"
                self.ExtraFee="60"
                self.lb_extra.text="加急费用￥60"
            case 2:
                self.Extra="Y"
                self.ExtraTime="24"
                self.ExtraFee="40"
                self.lb_extra.text="加急费用￥40"
            case 3:
                self.Extra="Y"
                self.ExtraTime="48"
                self.ExtraFee="20"
                self.lb_extra.text="加急费用￥20"
            default:
                self.Extra="N"
                self.ExtraTime="0"
                self.ExtraFee="0"
                self.lb_extra.text="加急费用￥0"
            }
            self.popviewOfTime.dismissView()
        }
        chooseTimeView.clipsToBounds=true
        chooseTimeView.layer.cornerRadius=10
        popviewOfTime.contenView = chooseTimeView
        popviewOfTime.anim = 0
        chooseTimeView.snp.makeConstraints { (make) in
            make.width.equalTo(screenW-20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(screenH/2)
            make.center.equalToSuperview()
        }
        popviewOfTime.showInView(view: self.view)
    }
    @objc func dismissPopOfTime(){
        popviewOfTime.dismissView()
    }
}

struct Acc:JSONSerializable {
    var name: String
    var value: Int
    init(name:String,value:Int){
        self.name=name
        self.value=value
    }
}

struct Accessory {
    var count: Int=1 //配件数量
    var photo1: String? //配件图片
    var photo2: String? //主机图片
    var Sate: String?
    var Id: Int = 0
    var AccessoryPrice: Int = 0
    var SubCategoryID: Int = 0
    var AccessoryName: String?
    var SizeID: Int = 0
    var IsUse: String?
    var SubCategoryName: String?
    var FAccessoryID: Int = 0
    var ParentName: String?
    var page: Int = 0
    var ServicePrice: Int = 0
    var limit: Int = 0
    var Version: Int = 0
    var FCategoryID: Int = 0
    var ParentID: Int = 0
    var FCategoryName: String?
    init(AccessoryName:String?,photo1:String?){
        self.AccessoryName=AccessoryName
        self.photo1=photo1
    }
    init(json: JSON) {
        Sate = json["Sate"].stringValue
        Id = json["Id"].intValue
        AccessoryPrice = json["AccessoryPrice"].intValue
        SubCategoryID = json["SubCategoryID"].intValue
        AccessoryName = json["AccessoryName"].stringValue
        SizeID = json["SizeID"].intValue
        IsUse = json["IsUse"].stringValue
        SubCategoryName = json["SubCategoryName"].stringValue
        FAccessoryID = json["FAccessoryID"].intValue
        ParentName = json["ParentName"].stringValue
        page = json["page"].intValue
        ServicePrice = json["ServicePrice"].intValue
        limit = json["limit"].intValue
        Version = json["Version"].intValue
        FCategoryID = json["FCategoryID"].intValue
        ParentID = json["ParentID"].intValue
        FCategoryName = json["FCategoryName"].stringValue
    }
}
struct OrderAccessoryModel:JSONSerializable {
    var State: String?
    var Price: Float = 0.0
    var Quantity: String?
    var Photo1: String?
    var DiscountPrice: Float = 0.0
    var SizeID: String?
    var IsPay: String?
    var FAccessoryName: String?
    var FCategoryID: String?
    var Relation: String?
    var SendState: String?
    var NeedPlatformAuth: String?
    var Photo2: String?
    var ExpressNo: String?
    var FAccessoryID: String?
    init(
    State: String?,
    Price: Float = 0.0,
    Quantity: String?,
    Photo1: String?,
    DiscountPrice: Float = 0.0,
    SizeID: String?,
    IsPay: String?,
    FAccessoryName: String?,
    FCategoryID: String?,
    Relation: String?,
    SendState: String?,
    NeedPlatformAuth: String?,
    Photo2: String?,
    ExpressNo: String?,
    FAccessoryID: String?) {
        self.State=State
        self.Price=Price
        self.Quantity=Quantity
        self.Photo1=Photo1
        self.Photo2=Photo2
        self.DiscountPrice=DiscountPrice
        self.SizeID=SizeID
        self.IsPay=IsPay
        self.FAccessoryName=FAccessoryName
        self.FAccessoryID=FAccessoryID
        self.FCategoryID=FCategoryID
        self.ExpressNo=ExpressNo
        self.NeedPlatformAuth=NeedPlatformAuth
        self.SendState=SendState
        self.Relation=Relation
    }
}
//MARK:常用型号
struct ProdCommon {
//    {
//      "UserID" : "18888888888",
//      "limit" : 999,
//      "ProdModelID" : 26,
//      "BrandCategoryID" : 542,
//      "ProdModel" : "测试型号",
//      "BrandName" : "奥克斯",
//      "CategoryName" : "冰洗类",
//      "BrandID" : 308,
//      "ProductTypeName" : "卧式冷柜≤300升",
//      "ProductTypeID" : 263,
//      "IsUse" : "Y",
//      "UseNum" : 17,
//      "SubCategoryName" : "冷柜",
//      "SubCategoryID" : 262,
//      "CourseCount" : null,
//      "Id" : 542,
//      "Imge" : null,
//      "CategoryID" : 287,
//      "page" : 1,
//      "Version" : 0
//    }
    var UseNum: Int = 0
    var UserID: String?
    var SubCategoryID: Int = 0
    var SubCategoryName: String?
    var BrandID: Int = 0
    var CourseCount: String?
    var Imge: String?
    var limit: Int = 0
    var Version: Int = 0
    var page: Int = 0
    var BrandName: String?
    var ProdModelID: Int = 0
    var ProductTypeID: Int = 0
    var CategoryName: String?
    var Id: Int = 0
    var IsUse: String?
    var BrandCategoryID: Int = 0
    var CategoryID: Int = 0
    var ProdModel: String?
    var ProductTypeName: String?

    init(json: JSON) {
        UseNum = json["UseNum"].intValue
        UserID = json["UserID"].stringValue
        SubCategoryID = json["SubCategoryID"].intValue
        SubCategoryName = json["SubCategoryName"].stringValue
        BrandID = json["BrandID"].intValue
        CourseCount = json["CourseCount"].stringValue
        Imge = json["Imge"].stringValue
        limit = json["limit"].intValue
        Version = json["Version"].intValue
        page = json["page"].intValue
        BrandName = json["BrandName"].stringValue
        ProdModelID = json["ProdModelID"].intValue
        ProductTypeID = json["ProductTypeID"].intValue
        CategoryName = json["CategoryName"].stringValue
        Id = json["Id"].intValue
        IsUse = json["IsUse"].stringValue
        BrandCategoryID = json["BrandCategoryID"].intValue
        CategoryID = json["CategoryID"].intValue
        ProdModel = json["ProdModel"].stringValue
        ProductTypeName = json["ProductTypeName"].stringValue
    }
}
//MARK:分类
struct ProdCategory {
//    {
//      "PlatformFee" : 0,
//      "CompanyName" : null,
//      "UserID" : null,
//      "StandardPrice" : 0,
//      "limit" : 0,
//      "CreateDate" : null,
//      "FSpecificationsID" : 0,
//      "SpecificationsID" : 262,
//      "IsUse" : "Y",
//      "ParentID" : 0,
//      "Operator" : null,
//      "TypeName" : null,
//      "FactoryAccessorys" : null,
//      "FactoryServices" : null,
//      "Id" : 0,
//      "PriceType" : 0,
//      "Guarantee" : null,
//      "FCategoryName" : "冷柜",
//      "page" : 0,
//      "Version" : 0,
//      "FactoryPrice" : 0
//    }
    var IsUse: String?
    var limit: Int = 0
    var StandardPrice: Int = 0
    var FactoryServices: String?
    var FactoryPrice: Int = 0
    var CompanyName: String?
    var FSpecificationsID: Int = 0
    var CreateDate: String?
    var Operator: String?
    var UserID: String?
    var SpecificationsID: Int = 0
    var PriceType: Int = 0
    var Guarantee: String?
    var Version: Int = 0
    var PlatformFee: Int = 0
    var FCategoryName: String?
    var TypeName: String?
    var ParentID: Int = 0
    var FactoryAccessorys: String?
    var Id: Int = 0
    var page: Int = 0

    init(json: JSON) {
        IsUse = json["IsUse"].stringValue
        limit = json["limit"].intValue
        StandardPrice = json["StandardPrice"].intValue
        FactoryServices = json["FactoryServices"].stringValue
        FactoryPrice = json["FactoryPrice"].intValue
        CompanyName = json["CompanyName"].stringValue
        FSpecificationsID = json["FSpecificationsID"].intValue
        CreateDate = json["CreateDate"].stringValue
        Operator = json["Operator"].stringValue
        UserID = json["UserID"].stringValue
        SpecificationsID = json["SpecificationsID"].intValue
        PriceType = json["PriceType"].intValue
        Guarantee = json["Guarantee"].stringValue
        Version = json["Version"].intValue
        PlatformFee = json["PlatformFee"].intValue
        FCategoryName = json["FCategoryName"].stringValue
        TypeName = json["TypeName"].stringValue
        ParentID = json["ParentID"].intValue
        FactoryAccessorys = json["FactoryAccessorys"].stringValue
        Id = json["Id"].intValue
        page = json["page"].intValue
    }
}
//MARK:规格
struct ProdSpecifications {
//    {
//      "PlatformFee" : 0,
//      "CompanyName" : null,
//      "UserID" : null,
//      "StandardPrice" : 0,
//      "limit" : 0,
//      "CreateDate" : null,
//      "FSpecificationsID" : 0,
//      "SpecificationsID" : 263,
//      "IsUse" : "Y",
//      "ParentID" : 0,
//      "Operator" : null,
//      "TypeName" : null,
//      "FactoryAccessorys" : null,
//      "FactoryServices" : null,
//      "Id" : 0,
//      "PriceType" : 0,
//      "Guarantee" : null,
//      "FCategoryName" : "卧式冷柜≤300升",
//      "page" : 0,
//      "Version" : 0,
//      "FactoryPrice" : 0
//    }
    var FactoryServices: String?
    var FactoryPrice: Int = 0
    var Operator: String?
    var CreateDate: String?
    var UserID: String?
    var SpecificationsID: Int = 0
    var FSpecificationsID: Int = 0
    var Id: Int = 0
    var limit: Int = 0
    var Guarantee: String?
    var FCategoryName: String?
    var FactoryAccessorys: String?
    var page: Int = 0
    var Version: Int = 0
    var TypeName: String?
    var StandardPrice: Int = 0
    var ParentID: Int = 0
    var IsUse: String?
    var PlatformFee: Int = 0
    var CompanyName: String?
    var PriceType: Int = 0

    init(json: JSON) {
        FactoryServices = json["FactoryServices"].stringValue
        FactoryPrice = json["FactoryPrice"].intValue
        Operator = json["Operator"].stringValue
        CreateDate = json["CreateDate"].stringValue
        UserID = json["UserID"].stringValue
        SpecificationsID = json["SpecificationsID"].intValue
        FSpecificationsID = json["FSpecificationsID"].intValue
        Id = json["Id"].intValue
        limit = json["limit"].intValue
        Guarantee = json["Guarantee"].stringValue
        FCategoryName = json["FCategoryName"].stringValue
        FactoryAccessorys = json["FactoryAccessorys"].stringValue
        page = json["page"].intValue
        Version = json["Version"].intValue
        TypeName = json["TypeName"].stringValue
        StandardPrice = json["StandardPrice"].intValue
        ParentID = json["ParentID"].intValue
        IsUse = json["IsUse"].stringValue
        PlatformFee = json["PlatformFee"].intValue
        CompanyName = json["CompanyName"].stringValue
        PriceType = json["PriceType"].intValue
    }
}

//MARK:品牌
//MARK:型号
struct ProdModel {
//    {
//      "IsUse" : "Y",
//      "ModelName" : "测试型号",
//      "Id" : 26,
//      "FactoryID" : "18888888888",
//      "Version" : 0,
//      "SpecificationsID" : 263,
//      "ID" : 26
//    }
    var ModelName: String?
    var Id: Int = 0
    var IsUse: String?
    var SpecificationsID: Int = 0
    var Version: Int = 0
    var FactoryID: String?
    var ID: Int = 0

    init(json: JSON) {
        ModelName = json["ModelName"].stringValue
        Id = json["Id"].intValue
        IsUse = json["IsUse"].stringValue
        SpecificationsID = json["SpecificationsID"].intValue
        Version = json["Version"].intValue
        FactoryID = json["FactoryID"].stringValue
        ID = json["ID"].intValue
    }
}
