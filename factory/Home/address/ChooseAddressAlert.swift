
//
//  ChoseGoodsTypeAlert.swift
//  shoppingcart
//
//  Created by 澜海利奥 on 2018/2/6.
//  Copyright © 2018年 江萧. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChooseAddressAlert: UIView , UITableViewDataSource, UITableViewDelegate{
    
    var view: UIView!
    var bgView: UIView!
    var lb_title: UILabel!//请选择
    var closeview: UIImageView!//关闭
    var lb_province: UILabelPadding!//请选择省
    var lb_city: UILabelPadding!//请选择市
    var lb_area: UILabelPadding!//请选择区
    var lb_street: UILabelPadding!//请选择街道/乡/镇
    var usv: UIStackView!
    var tableview: UITableView!
    
    var dataSource = NSMutableArray()
    var Provincemodel: [Province]!
    var Citymodel: [City]!
    var Areamodel: [Area]!
    var Streetmodel: [Street]!
    var selectProvince: Province!
    var selectCity: City!
    var selectArea: Area!
    var selectStreet: Street!
    var addrStr=""
    var selectAddress: ((_ addressModelBlock: (street:Street,addrStr:String,select:(Province,City,Area,Street))) -> Void)? = nil
    
    init(frame: CGRect, andHeight height: CGFloat) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        view = UIView.init(frame: self.bounds)
        view?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        addSubview(view)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.hideView))
        view.addGestureRecognizer(tap)
        
        bgView = UIView.init(frame: CGRect(x:0,y:screenH,width:screenW,height:height))
        bgView.backgroundColor = UIColor.white
        bgView.isUserInteractionEnabled = true
        bgView.corner(byRoundingCorners: [.topLeft,.topRight], radii: 10)
        addSubview(bgView)

        closeview = UIImageView.init()
        closeview.image=UIImage(named: "cancel")
        bgView.addSubview(closeview)
        closeview.snp.makeConstraints { (mark) in
            mark.width.equalTo(kSize(width: 20))
            mark.height.equalTo(kSize(width: 20))
            mark.right.equalTo(kSize(width: -10))
            mark.top.equalTo(kSize(width: 10))
        }
        
        lb_title = UILabel.init(frame: CGRect(x: 0, y: 0, width: screenW, height: kSize(width: 50)))
        lb_title.text="请选择"
        lb_title.textAlignment = .center
        bgView.addSubview(lb_title)

        lb_province=UILabelPadding.init()
        lb_city=UILabelPadding.init()
        lb_area=UILabelPadding.init()
        lb_street=UILabelPadding.init()
        
        lb_province.text="请选择省"
        lb_city.text="请选择市"
        lb_area.text="请选择区"
        lb_street.text="请选择街道/乡/镇"
        lb_city.isHidden=true
        lb_area.isHidden=true
        lb_street.isHidden=true
        lb_province.backgroundColor="#F7F7F7".color()
        lb_city.backgroundColor="#F7F7F7".color()
        lb_area.backgroundColor="#F7F7F7".color()
        lb_street.backgroundColor="#F7F7F7".color()
        lb_province.paddingLeft=10
        lb_province.paddingTop=10
        lb_province.paddingBottom=5
        lb_city.paddingLeft=10
        lb_city.paddingTop=5
        lb_city.paddingBottom=5
        lb_area.paddingLeft=10
        lb_area.paddingTop=5
        lb_area.paddingBottom=5
        lb_street.paddingLeft=10
        lb_street.paddingTop=5
        lb_street.paddingBottom=10
        lb_province.font = UIFont.systemFont(ofSize: 13)
        lb_city.font = UIFont.systemFont(ofSize: 13)
        lb_area.font = UIFont.systemFont(ofSize: 13)
        lb_street.font = UIFont.systemFont(ofSize: 13)

        usv = UIStackView.init(frame: CGRect(x: 0, y: 0, width: screenW, height: kSize(width: 30)))
        usv.axis = .vertical
        usv.addArrangedSubview(lb_province)
        usv.addArrangedSubview(lb_city)
        usv.addArrangedSubview(lb_area)
        usv.addArrangedSubview(lb_street)
        bgView.addSubview(usv)

        tableview = UITableView.init(frame: CGRect(x:0,y:0,width:screenW,height:0), style: UITableView.Style.plain)
        tableview.sectionHeaderHeight = 0
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.backgroundColor="#F7F7F7".color()
        addSubview(tableview)
        usv.snp.makeConstraints{(mask) in
            mask.top.equalTo(lb_title.snp.bottom)
            mask.left.equalTo(0)
            mask.bottom.equalTo(tableview.snp.top)
            mask.right.equalTo(0)
        }
        tableview.snp.makeConstraints { (mark) in
            mark.width.equalTo(screenW)
            mark.top.equalTo(usv.snp.bottom)
            mark.left.equalTo(0)
            mark.bottom.equalTo(0)
        }
        
        lb_province.addOnClickListener(target: self, action: #selector(province))
        lb_city.addOnClickListener(target: self, action: #selector(city))
        lb_area.addOnClickListener(target: self, action: #selector(area))
        lb_street.addOnClickListener(target: self, action: #selector(street))
        closeview.addOnClickListener(target: self, action: #selector(hideView))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func province() {
        initprovince(addressModel: Provincemodel)
    }
    @objc func city() {
        initcity(addressModel: Citymodel, select: selectProvince)
    }
    @objc func area() {
        initarea(addressModel: Areamodel, select: selectCity)
    }
    @objc func street() {
        initstreet(addressModel: Streetmodel, select: selectArea)
    }
    //消失
    
    @objc func hideView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.center.y = self.bgView.center.y+self.bgView.frame.height
        }) { (true) in
            self.removeFromSuperview()
        }
    }
    //出现
     func showView() {
        self.alpha = 1
        tableview.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.center.y = self.bgView.center.y-self.bgView.frame.height
        }) { (true) in
            self.tableview.alpha = 1
        }
        
    }
    func initprovince(addressModel: [Province]) {
        lb_province.text="请选择省"
        lb_city.isHidden=true
        lb_area.isHidden=true
        lb_street.isHidden=true
        
        Provincemodel = addressModel
        dataSource.removeAllObjects()
        //传入数据源创建多个属性
        dataSource.addObjects(from: Provincemodel)
        tableview.reloadData()
    }
    func initcity(addressModel: [City],select:Province) {
        lb_province.text=select.name
        lb_city.text="请选择市"
        lb_city.isHidden=false
        lb_area.isHidden=true
        lb_street.isHidden=true
        
        selectProvince=select
        Citymodel = addressModel
        dataSource.removeAllObjects()
        //传入数据源创建多个属性
        dataSource.addObjects(from: Citymodel)
        tableview.reloadData()
    }
    func initarea(addressModel: [Area],select:City) {
        lb_city.text=select.name
        lb_area.text="请选择区"
        lb_area.isHidden=false
        lb_street.isHidden=true
        
        selectCity=select
        Areamodel = addressModel
        dataSource.removeAllObjects()
        //传入数据源创建多个属性
        dataSource.addObjects(from: Areamodel)
        tableview.reloadData()
    }
    func initstreet(addressModel: [Street],select:Area) {
        lb_area.text=select.name
        lb_street.text="请选择街道/乡/镇"
        lb_street.isHidden=false
        
        selectArea=select
        Streetmodel = addressModel
        dataSource.removeAllObjects()
        //传入数据源创建多个属性
        dataSource.addObjects(from: Streetmodel)
        tableview.reloadData()
    }

    // MARK: - 代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ID = "reused"
        var cell =  tableView.dequeueReusableCell(withIdentifier: ID)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: ID)
        }
        var str=""
        if dataSource[indexPath.row] is Province{
            str=(dataSource[indexPath.row] as! Province).name!
        }
        if dataSource[indexPath.row] is City{
            str=(dataSource[indexPath.row] as! City).name!
        }
        if dataSource[indexPath.row] is Area{
            str=(dataSource[indexPath.row] as! Area).name!
        }
        if dataSource[indexPath.row] is Street{
            str=(dataSource[indexPath.row] as! Street).name!
        }
        cell?.backgroundColor="#F7F7F7".color()
        cell?.textLabel?.text = str
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource[indexPath.row] is Province{
            getCity(parentcode: String((dataSource[indexPath.row] as! Province).code!), select: (dataSource[indexPath.row] as! Province))
            return
        }
        if dataSource[indexPath.row] is City{
            getArea(parentcode: String((dataSource[indexPath.row] as! City).code!), select: (dataSource[indexPath.row] as! City))
            return
        }
        if dataSource[indexPath.row] is Area{
            getStreet(parentcode: String((dataSource[indexPath.row] as! Area).code!), select: (dataSource[indexPath.row] as! Area))
            return
        }
        if dataSource[indexPath.row] is Street{
            selectStreet=(dataSource[indexPath.row] as! Street)
            addrStr=selectProvince.name!+selectCity.name!+selectArea.name!+selectStreet.name!
            if selectAddress != nil {
                selectAddress!((selectStreet,addrStr,(selectProvince,selectCity,selectArea,selectStreet)))
            }
            hideView()
            return
        }
    }
    func getProvince(){
        AlamofireHelper.post(url: GetProvince, parameters: nil, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            let ProvinceList=res["Data"].arrayValue.compactMap({ Province(json: $0)})
            ss.initprovince(addressModel: ProvinceList)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    func getCity(parentcode:String,select:Province){
        var d = ["parentcode":parentcode]
        AlamofireHelper.post(url: GetCity, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            let CityList=res["Data"]["Item2"].arrayValue.compactMap({ City(json: $0)})
            ss.initcity(addressModel: CityList, select: select)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    func getArea(parentcode:String,select:City){
        var d = ["parentcode":parentcode]
        AlamofireHelper.post(url: GetArea, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            let AreaList=res["Data"]["Item2"].arrayValue.compactMap({ Area(json: $0)})
            ss.initarea(addressModel: AreaList, select: select)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    func getStreet(parentcode:String,select:Area){
        var d = ["parentcode":parentcode]
        AlamofireHelper.post(url: GetDistrict, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            let StreetList=res["Data"]["Item2"].arrayValue.compactMap({ Street(json: $0)})
            ss.initstreet(addressModel: StreetList, select: select)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
struct Province {
    var code: String?
    var name: String?
    var Version: Int = 0
    var Id: String?
    var IsUse: String?
    var parentcode: String?
    
    init(json: JSON) {
        code = json["code"].stringValue
        name = json["name"].stringValue
        Version = json["Version"].intValue
        Id = json["Id"].stringValue
        IsUse = json["IsUse"].stringValue
        parentcode = json["parentcode"].stringValue
    }
}
struct City {
    var code: String?
    var name: String?
    var Version: Int = 0
    var Id: String?
    var IsUse: String?
    var parentcode: String?
    
    init(json: JSON) {
        code = json["code"].stringValue
        name = json["name"].stringValue
        Version = json["Version"].intValue
        Id = json["Id"].stringValue
        IsUse = json["IsUse"].stringValue
        parentcode = json["parentcode"].stringValue
    }
}
struct Area {
    var code: String?
    var name: String?
    var Version: Int = 0
    var Id: String?
    var IsUse: String?
    var parentcode: String?
    
    init(json: JSON) {
        code = json["code"].stringValue
        name = json["name"].stringValue
        Version = json["Version"].intValue
        Id = json["Id"].stringValue
        IsUse = json["IsUse"].stringValue
        parentcode = json["parentcode"].stringValue
    }
}
struct Street {
    var code: String?
    var name: String?
    var Version: Int = 0
    var Id: String?
    var IsUse: String?
    var parentcode: String?
    
    init(json: JSON) {
        code = json["code"].stringValue
        name = json["name"].stringValue
        Version = json["Version"].intValue
        Id = json["Id"].stringValue
        IsUse = json["IsUse"].stringValue
        parentcode = json["parentcode"].stringValue
    }
}
