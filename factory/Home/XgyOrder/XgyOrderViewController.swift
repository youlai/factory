//
//  XgyOrderViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/20.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SnapKit
import Tabman
import Pageboy
class XgyOrderViewController: TabmanViewController,PageboyViewControllerDataSource, TMBarDataSource{
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
    
    
    init(index:Int){
        super.init(nibName: nil, bundle: nil)
        self.index=index
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var vcs:[UIViewController]! = []
    var index:Int!
    let titles = ["所有工单","待接单","已接单","待审核","待支付","已完成","质保单","退单处理"]
    let statuses = [5,0,7,1,2,3,4,6]
    override func viewDidLoad() {
        super.viewDidLoad()
        let bar=UIView(frame: CGRect(x: 0, y: 0, width: screenW, height: 50+kStatusBarHeight))
        bar.backgroundColor=UIColor.red
        let uv_back=UIView(frame: CGRect(x: 10, y: bar.frame.height-45, width: 40, height: 40))
        let iv_back=UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iv_back.image=UIImage(named: "back")
        uv_back.addSubview(iv_back)
        bar.addSubview(uv_back)
        let lb_title=UILabel.init()
        lb_title.text="所有工单"
        lb_title.textColor=UIColor.white
        bar.addSubview(lb_title)
        lb_title.snp.makeConstraints { (make) in
            make.centerY.equalTo(uv_back)
            make.centerX.equalTo(bar)
        }
        self.view.addSubview(bar)
        let bg=UIView()
        self.view.addSubview(bg)
        bg.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(bar.snp.bottom)
            make.right.equalTo(0)
            make.height.equalTo(40)
        }

        uv_back.addOnClickListener(target: self, action: #selector(back))
        
        for index in statuses{
            vcs.append(XgyOrderTableViewController(status: index))
        }
        self.dataSource = self
        
        // Create bar
        let Tbar = TMBar.ButtonBar()
        Tbar.layout.transitionStyle = .progressive // Customize
        Tbar.layout.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
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
            button.selectedTintColor = .red
            button.font=UIFont.systemFont(ofSize: 13)
        }
        
        Tbar.indicator.tintColor = .red
        Tbar.layout.contentMode = .intrinsic
        
        addBar(Tbar, dataSource: self, at: .custom(view: bg, layout: nil))
//        bar.isHidden=true
//        bg.isHidden=true
        print(kStatusBarHeight)
        self.additionalSafeAreaInsets=UIEdgeInsets(top: 90, left: 0, bottom: 0, right: 0)
        print(self.calculateRequiredInsets())
        self.view.backgroundColor=UIColor.white
        
        // Do any additional setup after loading the view.
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
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
