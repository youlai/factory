//
//  V3_OrderViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/20.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit
import Tabman
import Pageboy
class SubOrderViewController: TabmanViewController,PageboyViewControllerDataSource, TMBarDataSource{
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return vcs.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return vcs[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return PageboyViewController.Page.at(index: self.index)
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return TMBarItem(title: titles[index])
    }
    
    
    //    init(index:Int){
    //        super.init(nibName: nil, bundle: nil)
    //        self.index=index
    //    }
    //
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    var vcs:[UIViewController]! = []
    var index:Int!
    var titles = ["远程费审核","配件审核", "待寄件", "留言"]
    let statuses = [9,1,2,3]
    /*
     * 师傅端获取工单列表新接口
     * 师傅端state
     9、远程费申请待确认
     0、待接单
     1、已接待预约
     2、服务中
     3、返件单
     4、质保单
     5、完成待取机
     6、已完成
     7、预约不成功
     8、配件单
     * */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.index=0
        vcs.append(V3_OrderTableViewController3(status: 11))
        vcs.append(V3_OrderTableViewController3(status: 8))
        vcs.append(V3_OrderTableViewController3(status: 12))
        vcs.append(V3_OrderTableViewController3(status: 6))
        self.dataSource = self
        // Create bar
        let Tbar = TMBarView<TMHorizontalBarLayout, TMLabelBarButton, TMBlockBarIndicator>()
        
        Tbar.layout.transitionStyle = .none // Customize
        // Add to view
        //        addBar(Tbar, dataSource: self, at: .custom(view: bg, layout: { (bar) in
        //            bar.translatesAutoresizingMaskIntoConstraints = false
        //            NSLayoutConstraint.activate([
        //                bar.topAnchor.constraint(equalTo: bg.topAnchor),
        //                bar.centerXAnchor.constraint(equalTo: bg.centerXAnchor)
        //                ])
        //        }))
        Tbar.buttons.customize { (button) in
            button.tintColor = .black
            button.selectedTintColor = "#048CFF".color()
            button.font=UIFont.systemFont(ofSize: 13)
        }
        Tbar.indicator.cornerStyle = .eliptical
        Tbar.layout.contentMode = .intrinsic
        //        Tbar.tintColor = .white
        Tbar.systemBar().backgroundStyle = .blur(style: .dark)
        Tbar.backgroundColor = .white
        //        Tbar.snp.makeConstraints { (make) in
        //            make.height.equalTo(60)
        //        }
        Tbar.layout.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        addBar(Tbar, dataSource: self, at: .top)
        //        addBar(Tbar, dataSource: self, at: .custom(view: bg, layout: nil))
        //        bar.isHidden=true
        //        bg.isHidden=true
        print(kStatusBarHeight)
        //        self.additionalSafeAreaInsets=UIEdgeInsets(top: 110, left: 0, bottom: 0, right: 0)
        print(self.calculateRequiredInsets())
        self.view.backgroundColor=UIColor.white
        self.view.tintColor = .white
        //MARK:接收通知
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("接单成功"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("预约成功"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("预约不成功"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("已完成"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("待返件"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("待审核"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("工单数量"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload(noti:)), name: NSNotification.Name("确认收货"), object: nil)
    }
    //MARK:接收通知刷新接单列表
    @objc func reload(noti:Notification){
        if noti.name.rawValue=="确认收货"{
            self.index=0
        }
        if noti.name.rawValue=="接单成功"{
            self.index=1
        }
        if noti.name.rawValue=="待审核"{
            self.index=2
        }
        if noti.name.rawValue=="预约成功"{
            self.index=2
        }
        if noti.name.rawValue=="工单数量"{
            let orderStatus=noti.object as! Int
            switch orderStatus {
            case 13:
                self.index=0
            case 14:
                self.index=0
            case 15:
                self.index=0
            case 1:
                self.index=1
            case 16:
                self.index=1
            case 2:
                self.index=2
            case 11:
                self.index=3
            case 8:
                self.index=4
            case 12:
                self.index=5
            case 6:
                self.index=6
            default:
                self.index=0
            }
        }
        vcs.removeAll()
        vcs.append(V3_OrderTableViewController3(status: 11))
        vcs.append(V3_OrderTableViewController3(status: 8))
        vcs.append(V3_OrderTableViewController3(status: 12))
        vcs.append(V3_OrderTableViewController3(status: 6))
        self.reloadData()
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
}

