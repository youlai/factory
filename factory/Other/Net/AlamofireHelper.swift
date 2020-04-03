//
//  AlamofireHelper.swift
//  DCTT
//
//  Created by wyg on 2018/7/22.
//  Copyright © 2018年 Light.W. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AlamofireHelper: NSObject {
    let base_url = BASE_URL
    static let `default` = AlamofireHelper()
    
    /// Request
    ///
    /// - parameter withUrl:        url
    /// - parameter method:         method
    /// - parameter parameters:     pars
    /// - parameter successHandler: successHandler
    /// - parameter failureHandler: failure
    public func request(url withUrl:String,
                        method:HTTPMethod = .post,
                        parameters:[String:Any]? = nil,
                        encoding: ParameterEncoding = URLEncoding.default,
                        successHandler:((JSON) -> Void)? = nil,
                        failureHandler:((Error?) -> Void)? = nil)
    {
        //    if let delegate = UIApplication.shared.delegate as? AppDelegate{
        //        guard delegate._networkReachabilityManager.isReachable else {HUD.show(info: "unable to connect to the network, please check the network Settings!"); return}
        //    }
        
        
        guard withUrl.lengthOfBytes(using: String.Encoding.utf8) > 0 else { return}
        var header:HTTPHeaders = [:]
        if  (UserID != nil) {
            header["userName"] = UserID
            header["adminToken"] = adminToken
        }
        
        Alamofire.request(withUrl, method: method, parameters: parameters, encoding:encoding, headers: header)
            .validate()
            .responseJSON { (dataResponse) in
                DispatchQueue.main.async {
                    switch dataResponse.result {
                    case .success(let value):
                        let jsonData = JSON.init(value as Any)
                        print(jsonData)
                        if let success = successHandler {
                            success(jsonData);
                        }
//                        let dic=value as! [String:Any]
//                        let error_response=dic["error_response"] as?[String:Any]
//
//                        if error_response == nil {
//                            if let success = successHandler {
//                                success(jsonData);
//                            }
//                        }else{
//                            let sub_msg=error_response!["sub_msg"] as!String
//                            if let failure = failureHandler {
//                                let err = NSError.init(domain: "\(sub_msg)", code:1, userInfo: nil)
//                                failure(err)
//                            }
//                        }
                        break
                        
                    case .failure(let error):
                        if let failure = failureHandler {
                            failure(error)
                        }
                        break
                    }
                }
        }
        
    }
    
    //MARK:- Public Methods
    static public func get(url:String ,
                           parameters:[String:Any]? = nil,
                           successHandler:((JSON) -> Void)? = nil,
                           failureHandler:((Error?) -> Void)? = nil)
    {
        AlamofireHelper.default.request(url: url,method:.get , parameters: parameters, successHandler: successHandler, failureHandler: failureHandler);
    }
    
    static public func post(url:String ,
                            parameters:[String:Any]? = nil,
                            successHandler:((JSON) -> Void)? = nil,
                            failureHandler:((Error?) -> Void)? = nil)
    {
        AlamofireHelper.default.request(url: url,method:.post , parameters: parameters, successHandler: successHandler, failureHandler: failureHandler);
        
    }
    
    //MARK: - upload
    //上传多张图片
    public func upload(to:String,
                       parameters:[String:Any]? = nil,
                       uploadFiles:[Any]? = nil,
                       successHandler:((JSON) -> Void)? = nil,
                       failureHandler:(() -> Void)? = nil)
    {
        var header:HTTPHeaders = [:]
        if  (UserID != nil) {
            header["userName"] = UserID
            header["adminToken"] = adminToken
        }
//        if let token = UserDefaults.standard.value(forKey: "user-token") as? String {
//            header["Authorization"] = token;
//            header["content-type"] = "multipart/form-data"
//        }
        
        Alamofire.upload(multipartFormData: { (multipartData) in
            if let fils = uploadFiles {
                for obj in fils {
                    if obj is UIImage {
                        let ig = obj as! UIImage
                        let data=ig.jpegData(compressionQuality: 0.4)
                        if let d = data {
                            let fileName = Tools.dateToString(Date(), formatter: "yyyyMMddHHmmss").appending("\(arc4random()%10000)")
                            multipartData.append(d, withName: "files[]", fileName: "\(fileName).jpg", mimeType: "image/jpeg");//image/jpeg ，image/png
                        }
                    }else{///
                    }
                }
            }
            
            if let pars = parameters {
                for (k , v) in pars {
                    var data:Data?
                    if v is String {
                        let s = v as! String
                        data = s.data(using: String.Encoding.utf8)
                    }else if v is [Any] {
                        let arr = v as! [Any];
                        if arr.count > 0 {
                            do {
                                data =  try JSONSerialization.data(withJSONObject: arr, options: []);
                            }catch{
                                print(error.localizedDescription);
                            }
                        }
                    } else if v is Data {
                        let d = v as! Data;
                        data = d;
                    }
                    
                    if let d = data {
                        multipartData.append(d, withName: k)
                    }
                }
            }
        }, to: to, headers: header) { (encodingResult) in
            switch encodingResult {
            case .success(request: let upload, streamingFromDisk: _, streamFileURL:_):
                upload.validate().responseJSON(completionHandler: {  (res) in
                    print("111");//判断返回的code-200
                    if let success = successHandler , let value = JSON.init(res.result.value as Any) as? JSON {
                        print(value)
                        success(value);
                    }
                })
                break;
                
            case .failure(let error):
                print("2222")
                if let fail = failureHandler {
                    fail();
                }
                
                print(error.localizedDescription);break
            }
        }
    }
    
    //convenience methods
    static public func upload(to:String,
                              parameters:[String:Any]? = nil,
                              uploadFiles:[Any]? = nil,
                              successHandler:((JSON) -> Void)? = nil,
                              failureHandler:(() -> Void)? = nil)
        
    {
        AlamofireHelper.default.upload(to: to, parameters: parameters, uploadFiles: uploadFiles, successHandler: successHandler, failureHandler: failureHandler);
    }
    
    
}
