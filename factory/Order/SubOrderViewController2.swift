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
class SubOrderViewController2: TabmanViewController,PageboyViewControllerDataSource, TMBarDataSource{
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
    var titles = ["30日内","30日以上"]
    //    "急需处理", "待完成", "星标工单"11, "已完成", "质保单"4, "退单处理","所有工单"5
    //    "远程费审核"9,"配件审核"1,"待寄件"10,"留言"15
    //    "30日内"16,"30日以上"17
    //    "待支付"2,"已支付"3
    //    "取消工单"13,"关闭工单"12
    override func viewDidLoad() {
        super.viewDidLoad()
        self.index=0
        vcs.append(V3_OrderTableViewController3(status: 16))
        vcs.append(V3_OrderTableViewController3(status: 17))
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
            button.selectedTintColor = .white
            button.font=UIFont.systemFont(ofSize: 13)
            button.contentInset = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        }
        Tbar.indicator.cornerStyle = .eliptical
        Tbar.indicator.backgroundColor=UIColor.red
        Tbar.layout.contentMode = .intrinsic
        //        Tbar.tintColor = .white
        Tbar.systemBar().backgroundStyle = .blur(style: .dark)
        Tbar.backgroundColor = .white
        //        Tbar.snp.makeConstraints { (make) in
        //            make.height.equalTo(60)
        //        }
        Tbar.layout.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        addBar(Tbar, dataSource: self, at: .top)
        //        addBar(Tbar, dataSource: self, at: .custom(view: bg, layout: nil))
        //        bar.isHidden=true
        //        bg.isHidden=true
        print(kStatusBarHeight)
        //        self.additionalSafeAreaInsets=UIEdgeInsets(top: 110, left: 0, bottom: 0, right: 0)
        print(self.calculateRequiredInsets())
        self.view.backgroundColor=UIColor.white
        self.view.tintColor = .white
    }
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
}

