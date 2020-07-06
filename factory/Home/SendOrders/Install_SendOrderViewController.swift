//
//  Install_SendOrderViewController.swift
//  发布安装需求
//  Created by Apple on 2019/8/13.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Install_SendOrderViewController: UIViewController,LBXScanViewControllerDelegate {
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
    @IBOutlet weak var uv_count: UIView!
    
    @IBOutlet weak var usv_install: UIStackView!
    @IBOutlet weak var uv_install: UIView!
    @IBOutlet weak var uv_qrcode: UIView!
    @IBOutlet weak var uv_expressno: UIView!
    @IBOutlet weak var tf_expressno: UITextField!
    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_phone: UITextField!
    @IBOutlet weak var tv_addr: UITextView!
    @IBOutlet weak var tv_memo: UITextView!
    @IBOutlet weak var uv_scan: UIView!
    @IBOutlet weak var uv_time: UIView!
    
    @IBOutlet weak var lb_brand: UILabel!
    @IBOutlet weak var lb_type: UILabel!
    @IBOutlet weak var lb_common: UILabel!
    @IBOutlet weak var lb_cate: UILabel!
    @IBOutlet weak var lb_gg: UILabel!
    @IBOutlet weak var btn_addbrand: UIButton!
    @IBOutlet weak var btn_addprodmodel: UIButton!
    
    @IBOutlet weak var uv_addr: UIView!
    @IBOutlet weak var lb_addr: UILabel!
    @IBOutlet weak var btn_num: PPNumberButton!
    @IBOutlet weak var check_yqs: UIView!
    @IBOutlet weak var check_wqs: UIView!
    @IBOutlet weak var iv_yqs: UIImageView!
    @IBOutlet weak var iv_wqs: UIImageView!
    @IBOutlet weak var check_bn: UIView!
    @IBOutlet weak var check_nw: UIView!
    @IBOutlet weak var iv_bn: UIImageView!
    @IBOutlet weak var iv_bw: UIImageView!
    @IBOutlet weak var uv_choose_time: UIView!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_extra: UILabel!
    @IBOutlet weak var btn_submit: UIButton!
    
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
    
    var flag1="1"//选中了安装还是维修 1维修 2安装
    var flag2="N"//是否已发配件 N否 Y是
    var flag3="Y"//是否已签收产品 Y已签收 N未签收
    var Guarantee="1"//保内 N保外
    
    
    var Memo:String!//故障描述
    var ExpressNo=""//快递单号
    var Num="1"//数量默认1
    
    var Extra="N"//是否加急 默认否
    var ExtraTime="0"//加急时间
    var ExtraFee="0"//加急费用
    
    var ContinueIssuing="0"//是否重复发单

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        uv_back.addOnClickListener(target: self, action: #selector(back))

        uv_brand.addOnClickListener(target: self, action: #selector(getFactoryBrandByUserID))
        uv_common.addOnClickListener(target: self, action: #selector(getFactoryProd))
        uv_cate.addOnClickListener(target: self, action: #selector(getProdCategory))
        uv_gg.addOnClickListener(target: self, action: #selector(getProdSpecifications))
        uv_type.addOnClickListener(target: self, action: #selector(getType))
        
        btn_addbrand.addOnClickListener(target: self, action: #selector(addBrand))
        btn_addprodmodel.addOnClickListener(target: self, action: #selector(addProdModel))

        uv_addr.addOnClickListener(target: self, action: #selector(chooseAddr))
        check_yqs.addOnClickListener(target: self, action: #selector(qs))
        check_wqs.addOnClickListener(target: self, action: #selector(qs))
        check_bn.addOnClickListener(target: self, action: #selector(bnw))
        check_nw.addOnClickListener(target: self, action: #selector(bnw))
        uv_choose_time.addOnClickListener(target: self, action: #selector(getTime))
        uv_scan.addOnClickListener(target: self, action: #selector(scan))
        btn_submit.layer.cornerRadius=5
        btn_submit.addOnClickListener(target: self, action: #selector(submit))
        
        
        
        btn_num.NumberResultClosure={(number) in
            self.Num=number
        }
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
    //MARK:是否已签收产品
    @objc func qs(){
        
        if flag3 == "N"{
            flag3="Y"
            iv_yqs.image=UIImage(named: "yuangou")
            iv_wqs.image=UIImage(named: "circle")
            uv_qrcode.isHidden=true
        }else{
            flag3="N"
            iv_yqs.image=UIImage(named: "circle")
            iv_wqs.image=UIImage(named: "yuangou")
            uv_qrcode.isHidden=false
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
            Memo=tv_memo.text
            if Memo.isEmpty{
                HUD.showText("请填写安装说明!")
                return
            }
            var d = [
                "phone":phone!,
                "name":name!,
                "city":addr!,
                "addstr":addr_detail!,
                "servicetype":"2",
                "guaranteetype":Guarantee,
                "subCategoryID":subid!,
                "specifications":spid!,
                "factoryBrandName":brandid!,
                "prodModel":modelid!,
                "parts":"N",
                "bak":Memo!,
                "Num":Num,
                "ContinueIssuing":ContinueIssuing
                ] as [String : Any]
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
extension Install_SendOrderViewController{
    //MARK:未添加品牌是否去添加品牌
    @objc func noBrand(){
        let alertVC : UIAlertController = UIAlertController.init(title: "你还未添加品牌，是否去添加？", message: "", preferredStyle: .alert)
        let falseAA : UIAlertAction = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let trueAA : UIAlertAction = UIAlertAction.init(title: "确定", style: .default) { (alertAction) in
            self.navigationController?.pushViewController(BrandViewController(), animated: true)
        }
        alertVC.addAction(falseAA)
        alertVC.addAction(trueAA)
        self.present(alertVC, animated: true, completion: nil)
    }
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
extension Install_SendOrderViewController{
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
extension Install_SendOrderViewController{
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
extension Install_SendOrderViewController{
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
extension Install_SendOrderViewController{
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
extension Install_SendOrderViewController{
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
    @objc func showPopOfTime(){
        if popviewOfTime != nil{
            popviewOfTime.showInView(view: self.view)
        }else{
            getTime()
        }
    }
}
