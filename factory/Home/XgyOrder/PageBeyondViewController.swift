//
//  PageBeyondViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/21.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class PageBeyondViewController: UIViewController {
    @IBOutlet weak var yes: UIView!
    @IBOutlet weak var no: UILabel!
    @IBOutlet weak var lb_state: UILabel!
    @IBOutlet weak var usv_btn: UIStackView!
    @IBOutlet weak var btn_ok: UIButton!
    @IBOutlet weak var btn_reject: UIButton!
    @IBOutlet weak var iv_img: UIImageView!
    @IBOutlet weak var lb_beyond: UILabel!
    var OrderID:String!
    var BeyondState:String!
    init(OrderID:String){
        super.init(nibName: nil, bundle: nil)
        self.OrderID=OrderID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btn_ok.layer.cornerRadius=5
        btn_reject.layer.cornerRadius=5
        lb_state.clipsToBounds=true
        lb_state.layer.cornerRadius=5
        btn_ok.addOnClickListener(target: self, action: #selector(ok))
        btn_reject.addOnClickListener(target: self, action: #selector(reject))
        getOrderDetail()
        // Do any additional setup after loading the view.
    }
    @objc func ok(){
        //创建UIAlertController(警告窗口)
        let alert = UIAlertController(title: "提示", message: "是否通过远程费？", preferredStyle: .alert)
        //创建UIAlertController(动作表单)
        //        let alertB = UIAlertController(title: "Information", message: "sub title", preferredStyle: .actionSheet)
        //创建UIAlertController的Action
        let OK = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            self.BeyondState="1"
            self.approveBeyondMoney()
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
    @objc func reject(){
        //创建UIAlertController(警告窗口)
        let alert = UIAlertController(title: "提示", message: "是否拒绝远程费？", preferredStyle: .alert)
        //创建UIAlertController(动作表单)
        //        let alertB = UIAlertController(title: "Information", message: "sub title", preferredStyle: .actionSheet)
        //创建UIAlertController的Action
        let OK = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            self.BeyondState="-1"
            self.approveBeyondMoney()
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
    func getOrderDetail(){
        let d = ["OrderID":OrderID]as[String:String]
        AlamofireHelper.post(url: GetOrderInfo, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            let detail=mXgyOrderDetail.init(json: res["Data"])
            if detail.BeyondState!.isEmpty{
                ss.yes.isHidden=true
                ss.no.isHidden=false
            }else{
                ss.yes.isHidden=false
                ss.no.isHidden=true
                if detail.BeyondState=="0"{
                    ss.usv_btn.isHidden=false
                    ss.lb_state.isHidden=true
                }else{
                    ss.usv_btn.isHidden=true
                    ss.lb_state.isHidden=false
                    if detail.BeyondState=="1"{
                        ss.lb_state.text="已通过"
                    }else{
                        ss.lb_state.text="已拒绝"
                    }
                }
            }
            if detail.OrderBeyondImg.count>0{
                ss.iv_img.setImage(path: URL.init(string: "http://47.96.126.145:8820/Pics/OrderByondImg/\(detail.OrderBeyondImg[0].Url!)")!)
            }
            ss.lb_beyond.text="已超出正常范围\(detail.BeyondDistance ?? "")公里"
            
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    func approveBeyondMoney(){
        let d = ["OrderID":OrderID,"BeyondState":BeyondState]as[String:String]
        AlamofireHelper.post(url: ApproveBeyondMoney, parameters: d, successHandler: {[weak self](res)in
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
