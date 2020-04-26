//
//  SettingViewController.swift
//  MasterWorker
//
//  Created by Apple on 2019/11/7.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var uv_clean: UIView!
    @IBOutlet weak var uv_update: UIView!
    @IBOutlet weak var uv_logout: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        uv_back.addOnClickListener(target: self, action: #selector(back))
        uv_clean.addOnClickListener(target: self, action: #selector(clean))
        uv_update.addOnClickListener(target: self, action: #selector(update))
        uv_logout.addOnClickListener(target: self, action: #selector(logout))
        // Do any additional setup after loading the view.
    }
    //MARK:返回
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:清除缓存
    @objc func clean(){
        //创建UIAlertController(警告窗口)
        let alert = UIAlertController(title: "确定清除缓存吗？", message: "大小\(fileSizeOfCache())MB", preferredStyle: .alert)
        //创建UIAlertController(动作表单)
        //        let alertB = UIAlertController(title: "Information", message: "sub title", preferredStyle: .actionSheet)
        //创建UIAlertController的Action
        let OK = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in
            self.clearCache()
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
    //MARK:检查更新
    @objc func update(){
        VersionManager.init(appleId: "1509650055")
    }
    //MARK:退出账号
    @objc func logout(){
        UserDefaults.standard.set(nil, forKey: "UserID")
        UserID=nil
        self.navigationController?.popToRootViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //统计缓存文件大小
    func fileSizeOfCache()-> Int {
        
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        //缓存目录路径
        print(cachePath)
        
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        
        //快速枚举出所有文件名 计算文件大小
        var size = 0
        for file in fileArr! {
            
            // 把文件名拼接到路径中
            let path = cachePath?.appendingFormat("/\(file)")
            // 取出文件属性
            let floder = try! FileManager.default.attributesOfItem(atPath: path!)
            // 用元组取出文件大小属性
            for (abc, bcd) in floder {
                // 累加文件大小
                if abc == FileAttributeKey.size {
                    size += (bcd as AnyObject).integerValue
                }
            }
        }
        
        let mm = size / 1024 / 1024
        
        return mm
    }
    //删除缓存文件
    func clearCache() {
        
        // 取出cache文件夹目录 缓存文件都在这个目录下
        let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
        
        // 取出文件夹下所有文件数组
        let fileArr = FileManager.default.subpaths(atPath: cachePath!)
        
        // 遍历删除
        for file in fileArr! {
            
            let path = cachePath?.appendingFormat("/\(file)")
            if FileManager.default.fileExists(atPath: path!) {
                
                do {
                    try FileManager.default.removeItem(atPath: path!)
                } catch {
                    
                }
            }
        }
    }
}
