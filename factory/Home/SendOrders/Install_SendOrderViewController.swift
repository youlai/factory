//
//  Install_SendOrderViewController.swift
//  发布安装需求
//  Created by Apple on 2019/8/13.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class Install_SendOrderViewController: UIViewController,LBXScanViewControllerDelegate {
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        self.tf_expressno.text = scanResult.strScanned!
    }
    

    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    
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
    var chooseBrandView: ChooseBrandView!
    
    var popviewOfType: ZXPopView!
    var chooseTypeView: ChooseTypeView!
    
    var popviewOfTime: ZXPopView!
    var chooseTimeView: ChooseTimeView!
    
    var brand: BrandOfxgy!//选中的品牌
    var type: CateOfxgy!//选中的类型
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
    var Guarantee="Y"//保内 N保外
    
    
    var Memo:String!//故障描述
    var ExpressNo=""//快递单号
    var Num="1"//数量默认1
    
    var Extra="N"//是否加急 默认否
    var ExtraTime="0"//加急时间
    var ExtraFee="0"//加急费用

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        uv_back.addOnClickListener(target: self, action: #selector(back))

        uv_brand.addOnClickListener(target: self, action: #selector(getFactoryBrandByUserID))
        uv_type.addOnClickListener(target: self, action: #selector(getType))

        uv_addr.addOnClickListener(target: self, action: #selector(chooseAddr))
        check_yqs.addOnClickListener(target: self, action: #selector(qs))
        check_wqs.addOnClickListener(target: self, action: #selector(qs))
        check_bn.addOnClickListener(target: self, action: #selector(bnw))
        check_nw.addOnClickListener(target: self, action: #selector(bnw))
        uv_choose_time.addOnClickListener(target: self, action: #selector(getTime))
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
        
        if Guarantee == "N"{
            Guarantee="Y"
            iv_bn.image=UIImage(named: "yuangou")
            iv_bw.image=UIImage(named: "circle")
        }else{
            Guarantee="N"
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
                ss.addr = select.1
                ss.lb_addr.text = select.1
                ss.provinceCode=select.2.0.code!
                ss.cityCode=select.2.1.code!
                ss.areaCode=select.2.2.code!
                ss.streetCode=select.2.3.code!
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
        if brand==nil{
            HUD.showText("请选择品牌!")
            return
        }
        if type==nil{
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
        if flag3=="N"{
            ExpressNo=tf_expressno.text!
            if ExpressNo.isEmpty{
                HUD.showText("请填写快递单号!")
                return
            }
        }
        Memo=tv_memo.text
        if Memo.isEmpty{
            HUD.showText("请填写安装说明!")
            return
        }
        let d = [
            "TypeID":"2",
            "TypeName":"安装",
            "UserID":UserID!,
            "BrandID":brand.FBrandID,
            "BrandName":brand.FBrandName!,
            "CategoryID":type.CategoryID,
            "CategoryName":type.CategoryName!,
            "SubCategoryID":type.CategoryID,
            "SubCategoryName":type.CategoryName!,
            "ProductTypeID":type.ProductTypeID, //三级
            "ProductType":type.ProductTypeName!,
            "ProvinceCode":provinceCode!,
            "CityCode":cityCode!,
            "AreaCode":areaCode!,
            "DistrictCode":streetCode!,
            "Address":"\(addr!)\(addr_detail!)",
            "UserName":name!,
            "Phone":phone!,
            "Memo":Memo!,
            "RecycleOrderHour":"48",
            "Guarantee":Guarantee,
            "Extra":Extra,
            "ExtraTime":ExtraTime,
            "ExtraFee":ExtraFee,
            "Num":Num,
            "IsRecevieGoods":flag3,
            "ExpressNo":ExpressNo,
            "MallID":"123456789",
            "OrderSource":"IOS厂商端"
            ] as [String : Any]
        print(d)
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
//MARK:选择品牌
extension Install_SendOrderViewController{
    @objc func getFactoryBrandByUserID(){
        let d = ["UserID":UserID!]
        AlamofireHelper.post(url: GetFactoryBrandByUserID, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.popviewOfBrand = ZXPopView.init(frame: ss.view.bounds)
            ss.chooseBrandView=Bundle.main.loadNibNamed("ChooseBrandView", owner: nil, options: nil)?[0] as? ChooseBrandView
            ss.chooseBrandView.brandList=res["Data"].arrayValue.compactMap({ BrandOfxgy(json: $0)})
            ss.chooseBrandView.tableview.reloadData()
            ss.chooseBrandView.tableview.separatorStyle = .none
            ss.chooseBrandView.brandSelect={ (brand:BrandOfxgy) -> Void in
                ss.brand=brand
                ss.lb_brand.text=brand.FBrandName
                ss.type=nil
                ss.lb_type.text=""
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
//MARK:选择型号
extension Install_SendOrderViewController{
    @objc func getType(){
        if brand==nil {
            HUD.showText("请先选择品牌！")
            return
        }
        let d = ["UserID":UserID!,
                 "BrandID":"\(brand.FBrandID)",
        ]
        AlamofireHelper.post(url: GetBrandWithCategory, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.popviewOfType = ZXPopView.init(frame: ss.view.bounds)
            ss.chooseTypeView=Bundle.main.loadNibNamed("ChooseTypeView", owner: nil, options: nil)?[0] as? ChooseTypeView
            ss.chooseTypeView.cateList=res["Data"]["Item2"].arrayValue.compactMap({ CateOfxgy(json: $0)})
            ss.chooseTypeView.tableview.reloadData()
            ss.chooseTypeView.tableview.separatorStyle = .none
            ss.chooseTypeView.cateSelect={ (cate:CateOfxgy) -> Void in
                ss.type=cate
                ss.lb_type.text="\(cate.CategoryName!)/\(cate.SubCategoryName!)/\(cate.ProductTypeName!)"
                ss.popviewOfType.dismissView()
            }
            ss.chooseTypeView.clipsToBounds=true
            ss.chooseTypeView.layer.cornerRadius=10
            ss.popviewOfType.contenView = ss.chooseTypeView
            ss.popviewOfType.anim = 0
            ss.chooseTypeView.snp.makeConstraints { (make) in
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
