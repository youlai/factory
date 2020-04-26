//
//  PageDetailViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/20.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class PageDetailViewController: UIViewController {
    @IBOutlet weak var uv_error: UIView!
    @IBOutlet weak var btn_refresh: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_phone: UILabel!
    @IBOutlet weak var lb_address: UILabel!
    @IBOutlet weak var lb_createtime: UILabel!
    @IBOutlet weak var uv_service: UIView!
    @IBOutlet weak var lb_status: UILabel!
    @IBOutlet weak var lb_ordernum: UILabel!
    @IBOutlet weak var lb_bxlx: UILabel!
    @IBOutlet weak var lb_gdlx: UILabel!
    @IBOutlet weak var lb_hssj: UILabel!
    @IBOutlet weak var lb_yjhssj: UILabel!
    @IBOutlet weak var lb_smsj: UILabel!
    @IBOutlet weak var lb_sfyfpj: UILabel!
    @IBOutlet weak var lb_brand: UILabel!
    @IBOutlet weak var lb_cate: UILabel!
    @IBOutlet weak var lb_type: UILabel!
    @IBOutlet weak var lb_memo: UILabel!
    @IBOutlet weak var lb_ordermoney: UILabel!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var btn_apply: UIButton!
    var popPayView: popPayPwdView!
    var popview: ZXPopView!
    var orderEvaluateView: OrderEvaluateView!
    var OrderID:String!
    
    var Grade="5.0"
    var Grade1="5.0"
    var Grade2="5.0"
    var Grade3="5.0"
    var appraise:String!
    
    init(OrderID:String){
        super.init(nibName: nil, bundle: nil)
        self.OrderID=OrderID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollview.contentInset=UIEdgeInsets(top: tabOffset, left: 0, bottom: 0, right: 0)
        btn_submit.layer.cornerRadius=5
        btn_apply.layer.cornerRadius=5
        btn_apply.addOnClickListener(target: self, action: #selector(apply))
        btn_submit.addOnClickListener(target: self, action: #selector(ok))
        uv_service.addOnClickListener(target: self, action: #selector(call))
        btn_refresh.addOnClickListener(target: self, action: #selector(getOrderDetail))
        getOrderDetail()
        // Do any additional setup after loading the view.
    }
    //MARK:是否发起质保
    @objc func apply(){
        //创建UIAlertController(警告窗口)
        let alert = UIAlertController(title: "提示", message: "是否发起质保", preferredStyle: .alert)
        //创建UIAlertController(动作表单)
        //        let alertB = UIAlertController(title: "Information", message: "sub title", preferredStyle: .actionSheet)
        //创建UIAlertController的Action
        let OK = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            let d = ["OrderID":self.OrderID]as[String:String]
            AlamofireHelper.post(url: ApplyCustomService, parameters: d, successHandler: {[weak self](res)in
                HUD.dismiss()
                guard let ss = self else {return}
                if res["Data"]["Item1"].boolValue{
                    ss.navigationController?.popViewController(animated: true)
                }else{
                    HUD.showText(res["Data"]["Item2"].stringValue)
                }
            }){[weak self] (error) in
                HUD.dismiss()
                guard let ss = self else {return}
            }
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
    @objc func evaluate(){
        popview = ZXPopView.init(frame: CGRect(x: 0, y: 90, width: screenW, height: screenH-90))
        orderEvaluateView=Bundle.main.loadNibNamed("OrderEvaluateView", owner: nil, options: nil)?[0] as? OrderEvaluateView
        orderEvaluateView.layer.cornerRadius=10
        orderEvaluateView.btn_cancel.layer.cornerRadius=5
        orderEvaluateView.btn_confirm.layer.cornerRadius=5
        orderEvaluateView.uv_content.layer.cornerRadius=5
        orderEvaluateView.srv_total.delegate=self
        orderEvaluateView.srv_smsd.delegate=self
        orderEvaluateView.srv_wxsd.delegate=self
        orderEvaluateView.srv_fwtd.delegate=self
        orderEvaluateView.btn_confirm.addOnClickListener(target: self, action: #selector(ok))
        orderEvaluateView.btn_cancel.addOnClickListener(target: self, action: #selector(ok))
        //        orderEvaluateView.tv
        popview.contenView = orderEvaluateView
        popview.anim = 3
        orderEvaluateView.snp.makeConstraints { (make) in
            make.width.equalTo(screenW-20)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.height.equalTo(470)
            make.center.equalToSuperview()
        }
        popview.showInView(view: self.view)
    }
    @objc func dismissview(){
        popview.dismissView()
    }
    //MARK:是否拨打客服电话
    @objc func call(){
        //创建UIAlertController(警告窗口)
        let alert = UIAlertController(title: "提示", message: "是否拨打电话给客服", preferredStyle: .alert)
        //创建UIAlertController(动作表单)
        //        let alertB = UIAlertController(title: "Information", message: "sub title", preferredStyle: .actionSheet)
        //创建UIAlertController的Action
        let OK = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            // phoneStr:  电话号码
            let phone = "tel://" + "18767773654"
            if UIApplication.shared.canOpenURL(URL(string: phone)!) {
                UIApplication.shared.openURL(URL(string: phone)!)
            }
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
    //MARK:工单详情
    @objc func getOrderDetail(){
        let d = ["OrderID":OrderID]as[String:String]
        AlamofireHelper.post(url: GetOrderInfo, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.uv_error.isHidden=true
            let detail=mXgyOrderDetail.init(json: res["Data"])
            ss.lb_name.text=detail.UserName
            ss.lb_phone.text=detail.Phone
            ss.lb_address.text=detail.Address
            ss.lb_createtime.text=detail.CreateDate?.replacingOccurrences(of: "T", with: " ")
            ss.lb_status.text=detail.StateStr
            ss.lb_ordernum.text="\(detail.OrderID)"
            ss.lb_bxlx.text=detail.GuaranteeStr
            ss.lb_gdlx.text=detail.TypeName
            ss.lb_hssj.text="\(detail.RecycleOrderHour)"
            //当前时间的时间戳
            let timeInterval:TimeInterval = getDateFromTime(time: (detail.CreateDate?.replacingOccurrences(of: "T", with: " "))!).timeIntervalSince1970
            let timeStamp = Int(timeInterval)
            print("当前时间的时间戳：\(timeStamp)")
            
            //转换为时间
            let timeIntervalnew:TimeInterval = TimeInterval(timeStamp+detail.RecycleOrderHour*3600)
            let date = Date(timeIntervalSince1970: timeIntervalnew)
            
            //格式话输出
            let dformatter = DateFormatter()
            dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            print("对应的日期时间：\(dformatter.string(from: date))")
            
            ss.lb_yjhssj.text="注：预计回收时间\(dformatter.string(from: date))"
            if detail.SendOrderList.count>0{
                ss.lb_smsj.text=detail.SendOrderList[0].ServiceDate?.replacingOccurrences(of: "T", with: " ")
            }else{
                ss.lb_smsj.text=""
            }
            ss.lb_sfyfpj.text=detail.AccessorySendStateStr
            ss.lb_brand.text=detail.BrandName
            ss.lb_cate.text=detail.CategoryName
            ss.lb_type.text=detail.SubCategoryName
            ss.lb_memo.text=detail.Memo
            ss.lb_ordermoney.text="￥\(detail.OrderMoney)"
            //MARK:是否确认完结工单
            if (detail.StateStr=="服务完成") {
                if (detail.IsReturn=="1") {
                    if (detail.ReturnAccessoryMsg=="" || detail.ReturnAccessoryMsg == nil) {
                        ss.btn_submit.isHidden=true
                    } else {
                        ss.btn_submit.isHidden=false
                    }
                } else {
                    ss.btn_submit.isHidden=false
                }
            } else {
                ss.btn_submit.isHidden=true
            }
            //MARK:是否发起质保
            if (detail.StateStr=="已完成") {
                ss.btn_apply.isHidden=false
            } else {
                ss.btn_apply.isHidden=true
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.uv_error.isHidden=false
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension PageDetailViewController:JNStarReteViewDelegate,popPayDelegate{
    
    
    func s(label:UILabel,labelScore:UILabel?,count:Float){
        switch count{
        case 1.0:
            label.text="非常差"
            if labelScore != nil {
                labelScore!.text="1分"
                Grade="1.0"
            }
        case 2.0:
            label.text="很差"
            if labelScore != nil {
                labelScore!.text="2分"
                Grade="2.0"
            }
        case 3.0:
            label.text="一般"
            if labelScore != nil {
                labelScore!.text="3分"
                Grade="3.0"
            }
        case 4.0:
            label.text="满意"
            if labelScore != nil {
                labelScore!.text="4分"
                Grade="4.0"
            }
        case 5.0:
            label.text="很棒"
            if labelScore != nil {
                labelScore!.text="5分"
                Grade="5.0"
            }
        default:
            label.text="很棒"
            if labelScore != nil {
                labelScore!.text="5分"
                Grade="5.0"
            }
        }
    }
    func starRate(view starRateView: JNStarRateView, count: Float) {
        if starRateView.isDescendant(of: orderEvaluateView.srv_total){
            s(label: orderEvaluateView.lb_total, labelScore: orderEvaluateView.lb_score, count: count)
        }
        if starRateView.isDescendant(of: orderEvaluateView.srv_smsd){
            Grade1="\(count)"
            s(label: orderEvaluateView.lb_smsd, labelScore:nil, count: count)
        }
        if starRateView.isDescendant(of: orderEvaluateView.srv_wxsd){
            Grade2="\(count)"
            s(label: orderEvaluateView.lb_wxsd, labelScore:nil, count: count)
        }
        if starRateView.isDescendant(of: orderEvaluateView.srv_fwtd){
            Grade3="\(count)"
            s(label: orderEvaluateView.lb_fwtd, labelScore:nil, count: count)
        }
    }
    @objc func ok(){
        //        appraise=orderEvaluateView.tv_content.text
        //        if appraise.isEmpty{
        //            HUD.showText("请输入评价")
        //            return
        //        }
        popPayView = popPayPwdView()
        popPayView.setMoney(money: "￥10")
        popPayView!.delegate = self
        popPayView!.pop()
    }
    @objc func notok(){
        
    }
    
    func compareCode(view:popPayPwdView,payCode: String) {
        nowPayEnSureOrder(PayPassword: payCode)
    }
    func enSureOrder(PayPassword:String){
        let d = ["OrderID":OrderID,
                 "PayPassword":PayPassword,
                 "Grade":Grade,
                 "Grade1":Grade1,
                 "Grade2":Grade2,
                 "Grade3":Grade3,
                 "OrgAppraise":appraise,
            ]as[String:String]
        AlamofireHelper.post(url: EnSureOrder, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                ss.popPayView.dismiss()
                ss.dismissview()
                ss.getOrderDetail()
            }else{
                HUD.showText(res["Data"]["Item2"].stringValue)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:确认完结工单，结算金额
    func nowPayEnSureOrder(PayPassword:String){
        let d = ["OrderID":OrderID,
                 "PayPassword":PayPassword]as[String:String]
        AlamofireHelper.post(url: NowPayEnSureOrder, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                HUD.showText("已成功完结工单")
                ss.popPayView.dismiss()
                ss.getOrderDetail()
            }else{
                HUD.showText(res["Data"]["Item2"].stringValue)
                ss.popPayView.dot_hidden()
                if res["Data"]["Item2"].stringValue=="请设置支付密码"{
                    ss.popPayView.dismiss()
                    ss.navigationController?.pushViewController(ChangePayPwdViewController(), animated: true)
                }
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
