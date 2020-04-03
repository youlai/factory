//
//  UIWebViewViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/2.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class UIWebViewViewController: UIViewController {
    @IBOutlet weak var uv_close: UIView!
    @IBOutlet weak var uv_back: UIView!
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var webview: UIWebView!
    var headtitle: String!
    var url:String!
    var type:Int!
    init(headtitle:String,url:String,type:Int){
        super.init(nibName: nil, bundle: nil)
        self.headtitle=headtitle
        self.url=url
        self.type=type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lb_title.text=headtitle
        
        // 下面一行代码意思是充满的意思(一定要加，不然也会显示有问题)
        webview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        let mapwayURL = URL(string: url)!
//        String value = "Himall-User=" + userKey;// 键值对拼接成 value
//        var mapwayRequest = URLRequest(url: mapwayURL)
//        mapwayRequest.addValue("Himall-User=\(userkey!)", forHTTPHeaderField: "Cookie")
//        var cookies: [HTTPCookie] = []
//        for i in 0..<1 {
//            var cookieProperties: [HTTPCookiePropertyKey: String] = [:]
//            if i == 0 {
//                cookieProperties[.name] = "Himall-User"
//                cookieProperties[.value] = userkey!
//            }
//            cookieProperties[.path] = "/"
//            cookieProperties[.domain] = "mall.xigyu.com"
//            if let cookie = HTTPCookie.init(properties: cookieProperties) {
//                cookies.append(cookie)
//                HTTPCookieStorage.shared.setCookie(cookie)
//            }
//        }
//        webview.loadRequest(mapwayRequest)
        switch type {
        case 0:
            let mapwayURL = URL(string: url)!
            let mapwayRequest = URLRequest(url: mapwayURL)
            webview.loadRequest(mapwayRequest)
        default:
            webview.loadHTMLString(url, baseURL: nil)
        }
        uv_close.addOnClickListener(target: self, action: #selector(close))
        uv_back.addOnClickListener(target: self, action: #selector(back))
    }
    @objc func close(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func back(){
        if webview.canGoBack{
            webview.goBack()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
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
