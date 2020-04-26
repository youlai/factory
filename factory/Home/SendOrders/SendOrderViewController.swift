//
//  SendOrderViewController.swift
//  ShopIOS
//  召唤师傅页面
//  Created by Apple on 2019/8/13.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SendOrderViewController: UIViewController,LBXScanViewControllerDelegate {
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        self.tf_expressno.text = scanResult.strScanned!
    }
    

    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var uv_top: UIView!
    @IBOutlet weak var usv_add: UIStackView!
    @IBOutlet weak var uv_add: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var uv_category: UIView!
    @IBOutlet weak var uv_brand: UIView!
    @IBOutlet weak var uv_type: UIView!
    @IBOutlet weak var uv_count: UIView!
    @IBOutlet weak var uv_service_type: UIView!
    @IBOutlet weak var usv_repair: UIStackView!
    @IBOutlet weak var usv_install: UIStackView!
    @IBOutlet weak var uv_install: UIView!
    @IBOutlet weak var uv_qrcode: UIView!
    @IBOutlet weak var uv_expressno: UIView!
    @IBOutlet weak var tf_expressno: UITextField!
    @IBOutlet weak var uv_scan: UIView!
    @IBOutlet weak var uv_time: UIView!
    @IBOutlet weak var uv_submit: UIView!
    @IBOutlet weak var lb_category: UILabel!
    @IBOutlet weak var lb_brand: UILabel!
    @IBOutlet weak var lb_type: UILabel!
    @IBOutlet weak var btn_num: PPNumberButton!
    @IBOutlet weak var check_repair: UIView!
    @IBOutlet weak var check_install: UIView!
    @IBOutlet weak var iv_repair: UIImageView!
    @IBOutlet weak var iv_install: UIImageView!
    @IBOutlet weak var tf_memo: UITextView!
    @IBOutlet weak var check_yes: UIView!
    @IBOutlet weak var check_no: UIView!
    @IBOutlet weak var iv_yes: UIImageView!
    @IBOutlet weak var iv_no: UIImageView!
    @IBOutlet weak var check_yqs: UIView!
    @IBOutlet weak var check_wqs: UIView!
    @IBOutlet weak var iv_yqs: UIImageView!
    @IBOutlet weak var iv_wqs: UIImageView!
    @IBOutlet weak var uv_choose_time: UIView!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_extra: UILabel!
    @IBOutlet weak var lb_money: UILabel!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var uv_memo: UIView!
    @IBOutlet weak var uv_accessory: UIView!
    
    var popview: ZXPopView!
    var chooseCateView: ChooseCateView!
    
    var popviewOfBrand: ZXPopView!
    var chooseBrandView: ChooseBrandView!
    
    var popviewOfType: ZXPopView!
    var chooseTypeView: ChooseTypeView!
    
    var popviewOfTime: ZXPopView!
    var chooseTimeView: ChooseTimeView!
    
    var cate: CateOfxgy!//选中的分类
    var brand: BrandOfxgy!//选中的品牌
    var type: CateOfxgy!//选中的类型
    var time: String!//选中的上门时间
    
    var flag1="1"//选中了安装还是维修 1维修 2安装
    var flag2="N"//是否已发配件 N否 Y是
    var flag3="Y"//是否已签收产品 Y已签收 N未签收
    
    var ScategoryID:String!//选中的分类ID
    
    var Memo:String!//故障描述
    var ExpressNo=""//快递单号
    var Num="1"//数量默认1
    
    var Extra="N"//是否加急 默认否
    var ExtraTime="0"//加急时间
    var ExtraFee="0"//加急费用
    
    var repairPrice=0//维修费用
    var installPrice=0//安装费用
    
    var addr:mShippingAddress! //发单地址

    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentview.snp.makeConstraints { (make) in
            make.height.equalTo(uv_submit.y+60)
        }
        uv_top.layer.cornerRadius=5
        uv_category.layer.cornerRadius=5
        uv_brand.layer.cornerRadius=5
        uv_type.layer.cornerRadius=5
        uv_count.layer.cornerRadius=5
        uv_service_type.layer.cornerRadius=5
        usv_install.clipsToBounds=true
        uv_scan.clipsToBounds=true
        uv_install.clipsToBounds=true
        uv_qrcode.clipsToBounds=true
        usv_install.layer.cornerRadius=5
        uv_qrcode.layer.cornerRadius=5
        uv_qrcode.layer.maskedCorners=CACornerMask(rawValue: CACornerMask.layerMinXMaxYCorner.rawValue|CACornerMask.layerMaxXMaxYCorner.rawValue)
        uv_install.layer.cornerRadius=5
        uv_time.layer.cornerRadius=5
        uv_submit.layer.cornerRadius=5
        uv_memo.layer.cornerRadius=5
        uv_accessory.layer.cornerRadius=5
        uv_expressno.layer.cornerRadius=5
        btn_submit.layer.cornerRadius=5
        
        uv_back.addOnClickListener(target: self, action: #selector(back))
        uv_top.addOnClickListener(target: self, action: #selector(chooseAddr))
        uv_brand.addOnClickListener(target: self, action: #selector(showPopOfBrand))
        uv_type.addOnClickListener(target: self, action: #selector(showPopOfType))
        check_repair.addOnClickListener(target: self, action: #selector(service_type))
        check_install.addOnClickListener(target: self, action: #selector(service_type))
        check_yes.addOnClickListener(target: self, action: #selector(yn))
        check_no.addOnClickListener(target: self, action: #selector(yn))
        check_yqs.addOnClickListener(target: self, action: #selector(qs))
        check_wqs.addOnClickListener(target: self, action: #selector(qs))
        uv_choose_time.addOnClickListener(target: self, action: #selector(showPopOfTime))
        uv_scan.addOnClickListener(target: self, action: #selector(scan))
        btn_submit.addOnClickListener(target: self, action: #selector(submit))
        
        
        
        btn_num.NumberResultClosure={(number) in
            self.Num=number
        }
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
    @objc func service_type(){
        if flag1 != "1"{
            flag1="1"
            iv_repair.image=UIImage(named: "yuangou")
            iv_install.image=UIImage(named: "circle")
            usv_install.isHidden=true
            usv_repair.isHidden=false
        }else{
            flag1="2"
            iv_repair.image=UIImage(named: "circle")
            iv_install.image=UIImage(named: "yuangou")
            usv_install.isHidden=false
            usv_repair.isHidden=true
        }
    }
    @objc func yn(){
        if flag2 == "N"{
            flag2="Y"
            iv_yes.image=UIImage(named: "yuangou")
            iv_no.image=UIImage(named: "circle")
        }else{
            flag2="N"
            iv_yes.image=UIImage(named: "circle")
            iv_no.image=UIImage(named: "yuangou")
        }
    }
    @objc func qs(){
        
        if flag3 == "N"{
            flag3="Y"
            iv_yqs.image=UIImage(named: "yuangou")
            iv_wqs.image=UIImage(named: "circle")
            uv_qrcode.isHidden=true
            uv_install.layer.maskedCorners=CACornerMask(rawValue: CACornerMask.layerMinXMinYCorner.rawValue|CACornerMask.layerMaxXMinYCorner.rawValue|CACornerMask.layerMinXMaxYCorner.rawValue|CACornerMask.layerMaxXMaxYCorner.rawValue)
        }else{
            flag3="N"
            iv_yqs.image=UIImage(named: "circle")
            iv_wqs.image=UIImage(named: "yuangou")
            uv_qrcode.isHidden=false
            uv_install.layer.maskedCorners=CACornerMask(rawValue: CACornerMask.layerMinXMinYCorner.rawValue|CACornerMask.layerMaxXMinYCorner.rawValue)
        }
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func chooseAddr(){
//        self.navigationController?.pushViewController(AddressViewController(choose: true), animated: true)
    }
    @objc func dismissPop(){
        popview.topToBottom()
    }
    @objc func getBrandByCategory(){
        if ScategoryID==nil {
            HUD.showText("请先选择分类！")
            return
        }
        let d = ["ScategoryID":ScategoryID!]
        AlamofireHelper.post(url: GetBrandByCategory, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.popviewOfBrand = ZXPopView.init(frame: ss.view.bounds)
            ss.chooseBrandView=Bundle.main.loadNibNamed("ChooseBrandView", owner: nil, options: nil)?[0] as? ChooseBrandView
            ss.chooseBrandView.brandList=res["Data"]["Item2"].arrayValue.compactMap({ BrandOfxgy(json: $0)})
            ss.chooseBrandView.tableview.reloadData()
            ss.chooseBrandView.tableview.separatorStyle = .none
            ss.chooseBrandView.brandSelect={ (brand:BrandOfxgy) -> Void in
                ss.brand=brand
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
    @objc func showPopOfBrand(){
        if popviewOfBrand != nil{
            popviewOfBrand.showInView(view: self.view)
        }else{
            getBrandByCategory()
        }
    }
    @objc func getType(){
        
    }
    @objc func dismissPopOfType(){
        popviewOfType.dismissView()
    }
    @objc func showPopOfType(){
        if popviewOfType != nil{
            popviewOfType.showInView(view: self.view)
        }else{
            getType()
        }
    }
    
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
            if self.flag1=="1"{
                self.lb_money.text="服务金额￥\(self.repairPrice+Int(self.ExtraFee)!)"
            }else{
                self.lb_money.text="服务金额￥\(self.installPrice+Int(self.ExtraFee)!)"
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
    @objc func showPopOfTime(){
        if popviewOfTime != nil{
            popviewOfTime.showInView(view: self.view)
        }else{
            getTime()
        }
    }
    //最终确认提交
    /**
     * 发布工单
     * TypeID;//分类ID 1维修 2安装 3其他服务
     * TypeName;//
     * UserID;//用户id
     * FBrandID;//品牌id
     * FBrandName;//品牌名
     * FCategoryID;//分类id
     * FCategoryName;//分类名
     * FProductTypeID;//型号id
     * FProductType;//型号名
     * ProvinceCode;//省code
     * CityCode;//市code
     * AreaCode;//区code
     * Address;//详细地址
     * UserName;//客户姓名
     * Phone;//客户手机
     * Memo;//故障描述
     * RecycleOrderHour;//回收时间
     * Guarantee;//保内Y保外N
     * AccessorySendState;//是否已发配件 Y是N否
     * Extra;//是否加急Y是N否
     * ExtraTime;//加急时间
     * ExtraFee;//加急费用
     * Num;//数量
     * IsRecevieGoods;//是否签收产品 Y是N否
     * ExpressNo;//快递单号
     * MallID;//商城订单号
     * OrderSource;//订单来源 商城传“Mall”
     */
    @objc func submit(){
        if addr==nil{
            HUD.showText("请添加地址!")
            return
        }
        if cate==nil{
            HUD.showText("请选择分类!")
            return
        }
        if brand==nil{
            HUD.showText("请选择品牌!")
            return
        }
        if type==nil{
            HUD.showText("请选择型号!")
            return
        }
        if flag1=="1"{
            Memo=tf_memo.text!
            if Memo.isEmpty{
                HUD.showText("请填写故障描述!")
                return
            }
        }else{
            if flag3=="N"{
                ExpressNo=tf_expressno.text!
                if ExpressNo.isEmpty{
                    HUD.showText("请填写快递单号!")
                    return
                }
            }
            Memo=""
        }
//        let addrcode=addr.RegionIdPath!.split(separator: ",")
//        print(addrcode)
        let d = [
            "TypeID":flag1,
            "TypeName":flag1=="1" ? "维修" : "安装",
            "UserID":UserID!,
            "BrandID":brand.FBrandID,
            "BrandName":brand.FBrandName!,
            "CategoryID":cate.CategoryID,
            "CategoryName":cate.CategoryName!,
            "SubCategoryID":type.CategoryID,
            "SubCategoryName":type.CategoryName!,
//            "ProvinceCode":addrcode[0],
//            "CityCode":addrcode[1],
//            "AreaCode":addrcode[2],
//            "DistrictCode":addrcode[3],
//            "Address":"\(addr.RegionFullName!)\(addr.Address!)",
//            "UserName":addr.ShipTo!,
//            "Phone":addr.Phone!,
            "Memo":Memo!,
            "RecycleOrderHour":"48",
            "Guarantee":"N",//商城保外单
            "Extra":Extra,
            "ExtraTime":ExtraTime,
            "ExtraFee":ExtraFee,
            "Num":Num,
            "IsRecevieGoods":flag3,
            "ExpressNo":ExpressNo,
            "MallID":"123456789",
            "OrderSource":"Mall"
            ] as [String : Any]
        AlamofireHelper.post(url: AddOrder, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                HUD.showText(res["Data"]["Item2"].stringValue)
                ss.navigationController?.popViewController(animated: true)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
