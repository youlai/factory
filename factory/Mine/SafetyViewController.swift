//
//  SafetyViewController.swift
//  MasterWorker
//
//  Created by Apple on 2019/11/7.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SafetyViewController: UIViewController {
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var uv_pwd: UIView!
    @IBOutlet weak var uv_paypwd: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        uv_back.addOnClickListener(target: self, action: #selector(back))
        uv_pwd.addOnClickListener(target: self, action: #selector(pwd))
        uv_paypwd.addOnClickListener(target: self, action: #selector(paypwd))
        // Do any additional setup after loading the view.
    }
    //MARK:返回
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:修改密码
    @objc func pwd(){
        self.navigationController?.pushViewController(ChangePwdViewController(), animated: true)
    }
    //MARK:修改支付密码
    @objc func paypwd(){
        self.navigationController?.pushViewController(ChangePayPwdViewController(), animated: true)
    }
}
