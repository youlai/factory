//
//  MsgViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/2.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import PPBadgeViewSwift

class MsgViewController: UIViewController {
    @IBOutlet weak var uv_chat: UIView!
    @IBOutlet weak var uv_order: UIView!
    @IBOutlet weak var uv_deal: UIView!
    @IBOutlet weak var uv_system: UIView!
    @IBOutlet weak var uv_inchat: UIView!
    @IBOutlet weak var uv_inorder: UIView!
    @IBOutlet weak var uv_indeal: UIView!
    @IBOutlet weak var uv_insystem: UIView!
    @IBOutlet weak var uv_back: UIView!
    
    @IBOutlet weak var iv_go_order: UIImageView!
    @IBOutlet weak var iv_go_deal: UIImageView!
    @IBOutlet weak var iv_go_system: UIImageView!
    @IBOutlet weak var iv_go_chat: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        uv_back.addOnClickListener(target: self, action: #selector(back))
        uv_chat.addOnClickListener(target: self, action: #selector(chat))
        uv_order.addOnClickListener(target: self, action: #selector(order))
        uv_deal.addOnClickListener(target: self, action: #selector(deal))
        uv_system.addOnClickListener(target: self, action: #selector(system))
        uv_chat.layer.cornerRadius=5
        uv_order.layer.cornerRadius=5
        uv_deal.layer.cornerRadius=5
        uv_system.layer.cornerRadius=5
        uv_inchat.layer.cornerRadius=5
        uv_inorder.layer.cornerRadius=5
        uv_indeal.layer.cornerRadius=5
        uv_insystem.layer.cornerRadius=5
        
        getOrderMsgCount()
        getDealMsgCount()
        getNewsLeaveMessage()
        //MARK:接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("已读"), object: nil)
    }
    //MARK:接收通知刷新接单列表
    @objc func reload(noti:Notification){
        getOrderMsgCount()
        getDealMsgCount()
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
