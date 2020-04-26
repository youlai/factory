//
//  InMsgViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/2.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class InMsgViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,EmptyViewProtocol {
    
    var showEmtpy: Bool{
        get {
            switch type {
            case 3:
                return mLeaveMsgList.count == 0
            case 4:
                return mSystemMsgList.count == 0
            default:
                return mList.count == 0
            }
        }
    }
    func configEmptyView() -> UIView? {
        let view=Bundle.main.loadNibNamed("NoMsgView", owner: nil, options: nil)?[0]as?UIView
        view?.height=tableView.height
        view?.width=screenW
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case 3:
            return mLeaveMsgList.count
        case 4:
            return mSystemMsgList.count
        default:
            return mList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "re") as! MsgTableViewCell
        cell.selectionStyle = .none
        switch type {
        case 3:
            let item=mLeaveMsgList[indexPath.row]
            cell.title.text="工单号：\(item.OrderId)"
            cell.content.text="留言消息：\(item.Content ?? "")"
            cell.time.text="时间：\(item.CreateDate!.replacingOccurrences(of: "T", with: " "))"
            if item.workerIslook=="1"{
                cell.icon.isHidden=false
            }else{
                cell.icon.isHidden=true
            }
            return cell
        case 4:
            let item=mSystemMsgList[indexPath.row]
            cell.title.text=item.Title
            cell.content.isHidden=true
            cell.time.text="时间：\(item.CreateTime!.replacingOccurrences(of: "T", with: " "))"
            cell.icon.isHidden=true
            return cell
        default:
            let item=mList[indexPath.row]
            cell.title.text="工单号：\(item.OrderID)"
            cell.content.text=item.Content
            cell.time.text=item.Nowtime!.replacingOccurrences(of: "T", with: " ")
            if item.IsLook=="1"{
                cell.icon.isHidden=false
            }else{
                cell.icon.isHidden=true
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch type {
        case 3:
            self.navigationController?.pushViewController(LeaveMsgViewController(orderid: "\(mLeaveMsgList[indexPath.row].OrderId)"), animated: true)
        case 4:
            let item=mSystemMsgList[indexPath.row]
            self.navigationController?.pushViewController(UIWebViewViewController(headtitle: item.Title!, url: item.Content!,type:1), animated: true)
        default:
            addOrUpdatemessage(pos: indexPath.row)
        }
    }
    
    @IBOutlet weak var btn_allread: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var lb_title: UILabel!
    var type=1//MARK:2、工单消息1、交易消息3、留言消息4、系统消息
    var subtype=0//MARK:0、工单消息0、交易消息10、配件消息11、审核消息12、投诉消息
    var pageNo=1
    var limit=20
    var dataSource=[mMsg]()//MARK:临时数据
    var mList=[mMsg]()//MARK:累加数据
    var mLeaveMsgDataSource=[mLeaveMsg]()//MARK:临时数据
    var mLeaveMsgList=[mLeaveMsg]()//MARK:累加数据
    var mSystemMsgDataSource=[mSystemMsg]()//MARK:临时数据
    var mSystemMsgList=[mSystemMsg]()//MARK:累加数据
    init(type:Int){
        super.init(nibName: nil, bundle: nil)
        self.type=type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        switch type {
        case 2:
            subtype=0
            lb_title.text="工单消息"
            getmessageListByType()
            btn_allread.isHidden=false
        case 1:
            subtype=0
            lb_title.text="交易消息"
            getmessageListByType()
            btn_allread.isHidden=false
        case 3:
            lb_title.text="留言消息"
            getNewsLeaveMessage()
            btn_allread.isHidden=true
        case 4:
            lb_title.text="系统消息"
            getListCategoryContentByCategoryID()
            btn_allread.isHidden=true
        case 5:
            type=2
            subtype=13
            lb_title.text="上门提醒"
            getmessageListByType()
            btn_allread.isHidden=false
        case 6:
            type=2
            subtype=10
            lb_title.text="配件消息"
            getmessageListByType()
            btn_allread.isHidden=false
        case 7:
            type=2
            subtype=11
            lb_title.text="审核消息"
            getmessageListByType()
            btn_allread.isHidden=false
        case 8:
            type=2
            subtype=12
            lb_title.text="投诉消息"
            getmessageListByType()
            btn_allread.isHidden=false
        default:
            lb_title.text=""
        }
        
        tableView.register(UINib(nibName: "MsgTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        tableView.separatorStyle = .none
        tableView.setEmtpyViewDelegate(target: self)
        uv_back.addOnClickListener(target: self, action: #selector(back))
        btn_allread.addOnClickListener(target: self, action: #selector(allRead))
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNo = 1
            strongSelf.tableView.mj_footer.state = .idle
            strongSelf.tableView.mj_header.endRefreshing()
            switch strongSelf.type {
            case 3:
                strongSelf.getNewsLeaveMessage()
            case 4:
                strongSelf.getListCategoryContentByCategoryID()
            default:
                strongSelf.getmessageListByType()
            }
            
        })
        
        tableView.mj_header = header;
        
        let footer = TTRefreshFooter  {  [weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNo = strongSelf.pageNo + 1
            switch strongSelf.type {
            case 3:
                strongSelf.getNewsLeaveMessage()
            case 4:
                strongSelf.getListCategoryContentByCategoryID()
            default:
                strongSelf.getmessageListByType()
            }
        }
        tableView.mj_footer = footer
        tableView.mj_footer.isHidden = true
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:工单消息，交易消息
    @objc func getmessageListByType(){
        let d = ["UserID":UserID,
                 "Type":"\(type)",
            "SubType":"\(subtype)",
            "limit":"\(limit)",
            "page":"\(pageNo)",
            "IsLook":"1",
            ] as! [String : String]
        print(d)
        AlamofireHelper.post(url: GetmessageListByType, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if ss.pageNo == 1{ ss.mList.removeAll()}
            
            if ss.tableView.mj_footer.isRefreshing() {
                ss.tableView.mj_footer.endRefreshing()
                
            }
            if res["StatusCode"].intValue==200{
                ss.dataSource=res["Data"]["data"].arrayValue.compactMap({ mMsg(json: $0)})
                if ss.dataSource.count>0 {
                    if ss.tableView.mj_footer.isHidden && ss.dataSource.count > 0 {
                        ss.tableView.mj_footer.isHidden = false
                    }
                    ss.mList.insert(contentsOf: ss.dataSource, at: ss.mList.count)
                    if ss.dataSource.count < 20 {
                        ss.tableView.mj_footer.state = .noMoreData
                    }
                }else {
                    ss.tableView.mj_footer.state = .noMoreData
                }
                ss.tableView.reloadData()
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
                 "limit":"\(limit)",
            "page":"\(pageNo)"
            ] as! [String : String]
        print(d)
        AlamofireHelper.post(url: GetNewsLeaveMessage, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if ss.pageNo == 1{ ss.mLeaveMsgList.removeAll()}
            
            if ss.tableView.mj_footer.isRefreshing() {
                ss.tableView.mj_footer.endRefreshing()
                
            }
            if res["StatusCode"].intValue==200{
                ss.mLeaveMsgDataSource=res["Data"]["Item2"]["data"].arrayValue.compactMap({ mLeaveMsg(json: $0)})
                if ss.mLeaveMsgDataSource.count>0 {
                    if ss.tableView.mj_footer.isHidden && ss.mLeaveMsgDataSource.count > 0 {
                        ss.tableView.mj_footer.isHidden = false
                    }
                    ss.mLeaveMsgList.insert(contentsOf: ss.mLeaveMsgDataSource, at: ss.mLeaveMsgList.count)
                    if ss.mLeaveMsgDataSource.count < 20 {
                        ss.tableView.mj_footer.state = .noMoreData
                    }
                }else {
                    ss.tableView.mj_footer.state = .noMoreData
                }
                ss.tableView.reloadData()
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:系统消息
    @objc func getListCategoryContentByCategoryID(){
        let d = ["CategoryID":"3",
                 "limit":"\(limit)",
            "page":"\(pageNo)"
        ]
        print(d)
        AlamofireHelper.post(url: GetListCategoryContentByCategoryID, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if ss.pageNo == 1{ ss.mSystemMsgList.removeAll()}
            
            if ss.tableView.mj_footer.isRefreshing() {
                ss.tableView.mj_footer.endRefreshing()
                
            }
            if res["StatusCode"].intValue==200{
                ss.mSystemMsgDataSource=res["Data"]["data"].arrayValue.compactMap({ mSystemMsg(json: $0)})
                if ss.mSystemMsgDataSource.count>0 {
                    if ss.tableView.mj_footer.isHidden && ss.mSystemMsgDataSource.count > 0 {
                        ss.tableView.mj_footer.isHidden = false
                    }
                    ss.mSystemMsgList.insert(contentsOf: ss.mSystemMsgDataSource, at: ss.mSystemMsgList.count)
                    if ss.mSystemMsgDataSource.count < 20 {
                        ss.tableView.mj_footer.state = .noMoreData
                    }
                }else {
                    ss.tableView.mj_footer.state = .noMoreData
                }
                ss.tableView.reloadData()
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:工单消息，交易消息全部已读
    @objc func allRead(){
        HUD.show()
        let d = ["UserID":UserID,
                 "Type":"\(type)",
            "SubType":"0",
            ] as! [String : String]
        print(d)
        AlamofireHelper.post(url: AllRead, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.getmessageListByType()
            //MARK:发送通知
            NotificationCenter.default.post(name: NSNotification.Name("已读"), object: nil)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:工单消息，交易消息单条点击已读
    func addOrUpdatemessage(pos:Int!){
        HUD.show()
        let item=mList[pos]
        let d = ["MessageID":"\(item.MessageID)",
            "IsLook":"2"
        ]
        print(d)
        AlamofireHelper.post(url: AddOrUpdatemessage, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.getmessageListByType()
            ss.navigationController?.pushViewController(XgyOrderDetailViewController(OrderID: "\(item.OrderID)"), animated: true)
            //MARK:发送通知
            NotificationCenter.default.post(name: NSNotification.Name("已读"), object: nil)
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
struct mMsg {
    var UserID: String?
    var Version: Int = 0
    var IsLook: String?
    var `Type`: Int = 0
    var Nowtime: String?
    var SubType: Int = 0
    var IsUse: String?
    var OrderID: Int = 0
    var MessageID: Int = 0
    var Content: String?
    var Id: Int = 0
    var limit: Int = 0
    var page: Int = 0
    
    init(json: JSON) {
        UserID = json["UserID"].stringValue
        Version = json["Version"].intValue
        IsLook = json["IsLook"].stringValue
        Type = json["Type"].intValue
        Nowtime = json["Nowtime"].stringValue
        SubType = json["SubType"].intValue
        IsUse = json["IsUse"].stringValue
        OrderID = json["OrderID"].intValue
        MessageID = json["MessageID"].intValue
        Content = json["Content"].stringValue
        Id = json["Id"].intValue
        limit = json["limit"].intValue
        page = json["page"].intValue
    }
}
struct mLeaveMsg {
    var Content: String?
    var LeaveMessageId: Int = 0
    var factoryIslook: String?
    var IsUse: String?
    var limit: Int = 0
    var CreateDate: String?
    var Version: Int = 0
    var page: Int = 0
    var UserId: String?
    var OrderId: Int = 0
    var Order: String?
    var platformIslook: String?
    var workerIslook: String?
    var photo: String?
    var `Type`: String?
    var Id: Int = 0
    var UserName: String?
    
    init(json: JSON) {
        Content = json["Content"].stringValue
        LeaveMessageId = json["LeaveMessageId"].intValue
        factoryIslook = json["factoryIslook"].stringValue
        IsUse = json["IsUse"].stringValue
        limit = json["limit"].intValue
        CreateDate = json["CreateDate"].stringValue
        Version = json["Version"].intValue
        page = json["page"].intValue
        UserId = json["UserId"].stringValue
        OrderId = json["OrderId"].intValue
        Order = json["Order"].stringValue
        platformIslook = json["platformIslook"].stringValue
        workerIslook = json["workerIslook"].stringValue
        photo = json["photo"].stringValue
        Type = json["Type"].stringValue
        Id = json["Id"].intValue
        UserName = json["UserName"].stringValue
    }
}
struct mSystemMsg {
    var Content: String?
    var Id: Int = 0
    var Title: String?
    var limit: Int = 0
    var CategoryID: Int = 0
    var Author: String?
    var CategoryContentID: Int = 0
    var IsUse: String?
    var page: Int = 0
    var ParentCategoryID: Int = 0
    var CreateTime: String?
    var Url: String?
    var Version: Int = 0
    var Source: String?
    
    init(json: JSON) {
        Content = json["Content"].stringValue
        Id = json["Id"].intValue
        Title = json["Title"].stringValue
        limit = json["limit"].intValue
        CategoryID = json["CategoryID"].intValue
        Author = json["Author"].stringValue
        CategoryContentID = json["CategoryContentID"].intValue
        IsUse = json["IsUse"].stringValue
        page = json["page"].intValue
        ParentCategoryID = json["ParentCategoryID"].intValue
        CreateTime = json["CreateTime"].stringValue
        Url = json["Url"].stringValue
        Version = json["Version"].intValue
        Source = json["Source"].stringValue
    }
}
