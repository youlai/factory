//
//  V3_MsgViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/2.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import PPBadgeViewSwift

class V3_MsgViewController: UIViewController {
    
    @IBOutlet weak var uv_back: UIView!
    
    @IBOutlet weak var uv_system: UIView!//系统通知
    @IBOutlet weak var uv_door: UIView!//上门提醒
    @IBOutlet weak var uv_chat: UIView!//留言消息
    @IBOutlet weak var uv_order: UIView!//工单消息
    @IBOutlet weak var uv_acc: UIView!//配件消息
    @IBOutlet weak var uv_audit: UIView!//审核消息
    @IBOutlet weak var uv_deal: UIView!//交易消息
    @IBOutlet weak var uv_complaints: UIView!//投诉消息
    
    @IBOutlet weak var iv_system: UIImageView!
    @IBOutlet weak var iv_door: UIImageView!
    @IBOutlet weak var iv_chat: UIImageView!
    @IBOutlet weak var iv_order: UIImageView!
    @IBOutlet weak var iv_acc: UIImageView!
    @IBOutlet weak var iv_audit: UIImageView!
    @IBOutlet weak var iv_deal: UIImageView!
    @IBOutlet weak var iv_complaints: UIImageView!
    
    @IBOutlet weak var lb_order: UILabel!
    @IBOutlet weak var lb_acc: UILabel!
    @IBOutlet weak var lb_audit: UILabel!
    @IBOutlet weak var lb_deal: UILabel!
    @IBOutlet weak var lb_complaints: UILabel!
    
    @IBOutlet weak var lb_t_order: UILabel!
    @IBOutlet weak var lb_t_acc: UILabel!
    @IBOutlet weak var lb_t_audit: UILabel!
    @IBOutlet weak var lb_t_deal: UILabel!
    @IBOutlet weak var lb_t_complaints: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uv_back.addOnClickListener(target: self, action: #selector(back))
        
        uv_system.addOnClickListener(target: self, action: #selector(system))
        uv_door.addOnClickListener(target: self, action: #selector(door))
        uv_chat.addOnClickListener(target: self, action: #selector(chat))
        uv_order.addOnClickListener(target: self, action: #selector(order))
        uv_acc.addOnClickListener(target: self, action: #selector(acc))
        uv_audit.addOnClickListener(target: self, action: #selector(audit))
        uv_deal.addOnClickListener(target: self, action: #selector(deal))
        uv_complaints.addOnClickListener(target: self, action: #selector(complaint))
        
        getmessagePag()
//        getOrderMsgCount()
//        getDealMsgCount()
        getNewsLeaveMessage()
        //MARK:接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("已读"), object: nil)
    }
    //MARK:接收通知刷新接单列表
    @objc func reload(noti:Notification){
        getmessagePag()
//        getOrderMsgCount()
//        getDealMsgCount()
        getNewsLeaveMessage()
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func order(){
        self.navigationController?.pushViewController(InMsgViewController(type: 2), animated: true)
    }
    @objc func deal(){
        self.navigationController?.pushViewController(InMsgViewController(type: 1), animated: true)
    }
    @objc func chat(){
        self.navigationController?.pushViewController(InMsgViewController(type: 3), animated: true)
    }
    @objc func system(){
        self.navigationController?.pushViewController(InMsgViewController(type: 4), animated: true)
    }
    @objc func door(){
        self.navigationController?.pushViewController(InMsgViewController(type: 5), animated: true)
    }
    @objc func acc(){
        self.navigationController?.pushViewController(InMsgViewController(type: 6), animated: true)
    }
    @objc func audit(){
        self.navigationController?.pushViewController(InMsgViewController(type: 7), animated: true)
    }
    @objc func complaint(){
        self.navigationController?.pushViewController(InMsgViewController(type: 8), animated: true)
    }
    //MARK:消息数量
    @objc func getmessagePag(){
        let d = ["UserId":UserID] as! [String : String]
        print(d)
        AlamofireHelper.post(url: GetmessagePag, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["StatusCode"].intValue==200{
                ss.iv_order.pp.addBadge(number: res["Data"]["Item2"]["Count2"].intValue)
                ss.iv_acc.pp.addBadge(number: res["Data"]["Item2"]["Count3"].intValue)
                ss.iv_audit.pp.addBadge(number: res["Data"]["Item2"]["Count4"].intValue)
                ss.iv_deal.pp.addBadge(number: res["Data"]["Item2"]["Count5"].intValue)
                ss.iv_complaints.pp.addBadge(number: res["Data"]["Item2"]["Count6"].intValue)
                ss.iv_order.pp.moveBadge(x: -3, y: 3)
                ss.iv_acc.pp.moveBadge(x: -3, y: 3)
                ss.iv_audit.pp.moveBadge(x: -3, y: 3)
                ss.iv_deal.pp.moveBadge(x: -3, y: 3)
                ss.iv_complaints.pp.moveBadge(x: -3, y: 3)
                if res["Data"]["Item2"]["Count2"].intValue>0{
                    ss.lb_order.text=res["Data"]["Item2"]["Data2"]["Content"].stringValue
                    ss.lb_t_order.text=res["Data"]["Item2"]["Data2"]["Nowtime"].stringValue.replacingOccurrences(of: "T", with: " ")
                    ss.lb_t_order.isHidden=false
                }else{
                    ss.lb_order.text="暂无新的工单消息"
                    ss.lb_t_order.isHidden=true
                }
                if res["Data"]["Item2"]["Count3"].intValue>0{
                    ss.lb_acc.text=res["Data"]["Item2"]["Data3"]["Content"].stringValue
                    ss.lb_t_acc.text=res["Data"]["Item2"]["Data3"]["Nowtime"].stringValue.replacingOccurrences(of: "T", with: " ")
                    ss.lb_t_acc.isHidden=false
                }else{
                    ss.lb_acc.text="暂无新的配件消息"
                    ss.lb_t_acc.isHidden=true
                }
                if res["Data"]["Item2"]["Count4"].intValue>0{
                    ss.lb_audit.text=res["Data"]["Item2"]["Data4"]["Content"].stringValue
                    ss.lb_t_audit.text=res["Data"]["Item2"]["Data4"]["Nowtime"].stringValue.replacingOccurrences(of: "T", with: " ")
                    ss.lb_t_audit.isHidden=false
                }else{
                    ss.lb_audit.text="暂无新的审核消息"
                    ss.lb_t_audit.isHidden=true
                }
                if res["Data"]["Item2"]["Count5"].intValue>0{
                    ss.lb_deal.text=res["Data"]["Item2"]["Data5"]["Content"].stringValue
                    ss.lb_t_deal.text=res["Data"]["Item2"]["Data5"]["Nowtime"].stringValue.replacingOccurrences(of: "T", with: " ")
                    ss.lb_t_deal.isHidden=false
                }else{
                    ss.lb_deal.text="暂无新的交易消息"
                    ss.lb_t_deal.isHidden=true
                }
                if res["Data"]["Item2"]["Count6"].intValue>0{
                    ss.lb_complaints.text=res["Data"]["Item2"]["Data6"]["Content"].stringValue
                    ss.lb_t_complaints.text=res["Data"]["Item2"]["Data7"]["Nowtime"].stringValue.replacingOccurrences(of: "T", with: " ")
                    ss.lb_t_complaints.isHidden=false
                }else{
                    ss.lb_complaints.text="暂无新的投诉消息"
                    ss.lb_t_complaints.isHidden=true
                }
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:工单消息
    @objc func getOrderMsgCount(){
        let d = ["UserID":UserID,
                 "Type":"2",
                 "SubType":"0",
                 "limit":"1",
                 "page":"1",
                 "IsLook":"1",
            ] as! [String : String]
        print(d)
        AlamofireHelper.post(url: GetmessageListByType, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["StatusCode"].intValue==200{
                ss.uv_order.pp.addBadge(number: res["Data"]["count"].intValue)
                ss.uv_order.pp.moveBadge(x: -50, y: 35)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:交易消息
    @objc func getDealMsgCount(){
        let d = ["UserID":UserID,
                 "Type":"1",
                 "SubType":"0",
                 "limit":"1",
                 "page":"1",
                 "IsLook":"1",
            ] as! [String : String]
        print(d)
        AlamofireHelper.post(url: GetmessageListByType, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["StatusCode"].intValue==200{
                ss.uv_deal.pp.addBadge(number: res["Data"]["count"].intValue)
                ss.uv_deal.pp.moveBadge(x: -50, y: 35)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:留言消息
    @objc func getNewsLeaveMessage(){
        let d = ["UserID":UserID,
                 "Type":"1",
                 "limit":"1",
                 "page":"1"
            ] as! [String : String]
        print(d)
        AlamofireHelper.post(url: GetNewsLeaveMessage, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["StatusCode"].intValue==200{
                ss.iv_chat.pp.addBadge(number: res["Data"]["Item2"]["NoLeaveMessage"].intValue)
                ss.iv_chat.pp.moveBadge(x: -3, y: 3)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:系统消息
    @objc func getListCategoryContentByCategoryID(){
        let d = ["CategoryID":"3",
                 "limit":"1",
                 "page":"1"
        ]
        print(d)
        AlamofireHelper.post(url: GetListCategoryContentByCategoryID, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["StatusCode"].intValue==200{
                
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
