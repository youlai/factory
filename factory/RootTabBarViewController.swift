//
//  RootTabBarViewController.swift
//  factory
//
//  Created by Apple on 2020/4/13.
//  Copyright © 2020 zhkj. All rights reserved.
//

import UIKit

class RootTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        for i in 0..<self.viewControllers.count {
        //2.更改字体颜色
        tabBar.barTintColor = UIColor.white
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.lightGray,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)], for: .normal)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 12)], for: .selected)
        //        }
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
