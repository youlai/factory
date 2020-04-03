//
//  PresentViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/29.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

class PresentViewController: UIViewController {
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var tf_account: UITextField!
    @IBOutlet weak var tf_count: UITextField!
    @IBOutlet weak var tf_memo: UITextField!
    @IBOutlet weak var btn_confirm: UIButton!
    var account:String! //对方账户
    var count:String! //西瓜币数量
    var memo:String! //备注

    override func viewDidLoad() {
        super.viewDidLoad()
        btn_confirm.layer.cornerRadius=5
        uv_back.addOnClickListener(target: self, action: #selector(back))
        btn_confirm.addOnClickListener(target: self, action: #selector(fAddCon))
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func fAddCon(){
        account=tf_account.text
        count=tf_count.text
        memo=tf_memo.text
        if account.isEmpty{
            HUD.showText("请输入对方账号")
            return
        }
        if count.isEmpty{
            HUD.showText("请输入赠送数量")
            return
        }
        if memo.isEmpty{
            HUD.showText("请输入备注")
            return
        }
        let d = ["UserID":UserID!,
                 "ToUserID":account!,
                 "Memo":memo!,
                 "Connum":count!
            ] as [String : Any]
        print(d)
        AlamofireHelper.post(url: FAddCon, parameters: d, successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                HUD.showText(res["Data"]["Item2"].stringValue)
                ss.navigationController?.popViewController(animated: true)
            }else{
                HUD.showText(res["Data"]["Item2"].stringValue)
            }
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
