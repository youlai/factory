//
//  AddTypeViewController.swift
//  factory
//
//  Created by Apple on 2020/4/1.
//  Copyright © 2020 zhkj. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddTypeViewController: UIViewController{
    
    
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var uv_brand: UIView!
    @IBOutlet weak var uv_cate: UIView!
    @IBOutlet weak var uv_type: UIView!
    @IBOutlet weak var tf_brand: UITextField!
    @IBOutlet weak var tf_cate: UITextField!
    @IBOutlet weak var tf_type: UITextField!
    @IBOutlet weak var btn_submit: UIButton!
    
    var popview: ZXPopView!
    var chooseCateView: ChooseCateView!
    
    var popviewOfBrand: ZXPopView!
    var chooseBrandView: ChooseBrandView!
    
    var popviewOfType: ZXPopView!
    var chooseTypeView: ChooseTypeView1!
    
    var popviewOfTime: ZXPopView!
    var chooseTimeView: ChooseTimeView!
    
    var cate: CateOfxgy1!//选中的分类
    var brand: BrandOfxgy!//选中的品牌
    var type: CateOfxgy1!//选中的类型
    
    var ScategoryID:String!//选中的分类ID
    var vc: TypeViewController!
    init(vc:TypeViewController){
        super.init(nibName: nil, bundle: nil)
        self.vc=vc
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_submit.addOnClickListener(target: self, action: #selector(addBrandcategory))
        uv_brand.addOnClickListener(target: self, action: #selector(getFactoryBrandByUserID))
        uv_cate.addOnClickListener(target: self, action: #selector(getFactoryCategory))
        uv_type.addOnClickListener(target: self, action: #selector(getType))
        uv_back.addOnClickListener(target: self, action: #selector(back))
        uv_brand.border(color: .lightGray, width: 0.5, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        uv_cate.border(color: .lightGray, width: 0.5, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        uv_type.border(color: .lightGray, width: 0.5, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        buttonStyle(btn: btn_submit)
    }
    //MARK:按钮样式
    func buttonStyle(btn:UIButton){
        btn.backgroundColor = .red
        btn.border(color: UIColor.red, width: 1, type: UIBorderSideType.UIBorderSideTypeAll, cornerRadius: 5)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.contentEdgeInsets=UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        btn.snp.makeConstraints{(mask) in
            mask.height.equalTo(60)
        }
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:添加型号
    @objc func addBrandcategory(){
        if brand==nil{
            HUD.showText("请选择品牌")
            return
        }
        if cate==nil{
            HUD.showText("请选择分类")
            return
        }
        if type==nil{
            HUD.showText("请选择型号")
            return
        }
        let d = ["BrandID": "\(brand.FBrandID)",
            "CategoryID": "\(cate.ParentID)",
            "SubCategoryID": "\(cate.FCategoryID)",
            "ProductTypeID": "\(type.FCategoryID)"
            //                     "Imge": imgsrc,
        ]
        AlamofireHelper.post(url: AddBrandCategory, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.vc.getBrandWithCategory()
            ss.navigationController?.popViewController(animated: true)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
        
    }
}
//MARK:选择品牌
extension AddTypeViewController{
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
                ss.tf_brand.text=brand.FBrandName
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
//MARK:选择分类
extension AddTypeViewController{
    @objc func getFactoryCategory(){
        let d = ["ParentID":"999",
                 "Type":"F"
        ]
        AlamofireHelper.post(url: GetFactoryCategory, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.popview = ZXPopView.init(frame: ss.view.bounds)
            ss.chooseCateView=Bundle.main.loadNibNamed("ChooseCateView", owner: nil, options: nil)?[0] as? ChooseCateView
            ss.chooseCateView.leftTable.register(UINib(nibName: "LeftTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
            ss.chooseCateView.leftList=res["Data"]["data"].arrayValue.compactMap({ CateOfxgy1(json: $0)})
            ss.chooseCateView.leftTable.reloadData()
            ss.chooseCateView.iv_close.addOnClickListener(target: ss, action: #selector(ss.dismissPop))
            ss.chooseCateView.leftTable.separatorStyle = .none
            ss.chooseCateView.rightTable.separatorStyle = .none
            ss.chooseCateView.cateSelect={ (cate:CateOfxgy1) -> Void in
                ss.cate=cate
                ss.type=nil
                ss.popviewOfType=nil
                ss.tf_type.text=""
                ss.tf_cate.text=cate.FCategoryName
                ss.ScategoryID="\(cate.FCategoryID)"
                ss.popview.topToBottom()
            }
            ss.chooseCateView.clipsToBounds=true
            ss.chooseCateView.layer.cornerRadius=10
            ss.chooseCateView.layer.maskedCorners=CACornerMask(rawValue: CACornerMask.layerMinXMinYCorner.rawValue|CACornerMask.layerMaxXMinYCorner.rawValue)
            ss.popview.contenView = ss.chooseCateView
            ss.popview.anim = 1
            ss.chooseCateView.snp.makeConstraints { (make) in
                make.width.equalTo(screenW)
                make.height.equalTo(screenH-kStatusBarHeight)
                make.bottom.equalTo(0)
            }
            ss.popview.bottomToTop(view: ss.view)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    @objc func dismissPop(){
        popview.topToBottom()
    }
}
//MARK:选择型号
extension AddTypeViewController{
    @objc func getType(){
        if cate==nil {
            HUD.showText("请先选择分类！")
            return
        }
        let d = ["ParentID":"\(cate.FCategoryID)",
            "Type":"F"
        ]
        AlamofireHelper.post(url: GetFactoryCategory, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.popviewOfType = ZXPopView.init(frame: ss.view.bounds)
            ss.chooseTypeView=Bundle.main.loadNibNamed("ChooseTypeView1", owner: nil, options: nil)?[0] as? ChooseTypeView1
            ss.chooseTypeView.cateList=res["Data"]["data"].arrayValue.compactMap({ CateOfxgy1(json: $0)})
            ss.chooseTypeView.tableview.reloadData()
            ss.chooseTypeView.tableview.separatorStyle = .none
            ss.chooseTypeView.cateSelect={ (cate:CateOfxgy1) -> Void in
                ss.type=cate
                ss.tf_type.text="\(cate.FCategoryName!)"
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
