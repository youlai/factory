//
//  LeaveMsgViewController.swift
//  ShopIOS
//
//  Created by Apple on 2019/8/2.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON
import SKPhotoBrowser
import ZJTableViewManager

class LeaveMsgViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate & UINavigationControllerDelegate,EmptyViewProtocol {
    var showEmtpy: Bool{
        get {
            return mLeaveMsgList.count == 0
        }
    }
    func configEmptyView() -> UIView? {
        let view=Bundle.main.loadNibNamed("NoMsgView", owner: nil, options: nil)?[0]as?UIView
        view?.height=tableView.height
        view?.width=screenW
        return view
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mLeaveMsgList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "re") as! LeaveMsgTableViewCell
        let item=mLeaveMsgList[indexPath.row]
        //        cell.lb_content.attributedText=FuWenBen(str: item.Content,url: "https://img.xigyu.com/Pics/LeaveMessageImg/\(item.photo ?? "")")
        cell.lb_content.text=item.Content
        var s=[Substring]()
        if item.photo!.contains(","){
            s=item.photo!.split(separator: ",")
        }else{
            if item.photo!.isEmpty{
                cell.iv_photo.isHidden=true
            }else{
                cell.iv_photo.isHidden=false
            }
            cell.iv_photo2.isHidden=true
            cell.iv_photo3.isHidden=true
            cell.iv_photo4.isHidden=true
            cell.iv_photo5.isHidden=true
            cell.iv_photo.setImage(path: URL(string: "https://img.xigyu.com/Pics/LeaveMessageImg/\(item.photo ?? "")")!)
        }
        if s.count==2{
            cell.iv_photo.isHidden=false
            cell.iv_photo2.isHidden=false
            cell.iv_photo3.isHidden=true
            cell.iv_photo4.isHidden=true
            cell.iv_photo5.isHidden=true
            cell.iv_photo.setImage(path: URL(string: "https://img.xigyu.com/Pics/LeaveMessageImg/\(s[0])")!)
            cell.iv_photo2.setImage(path: URL(string: "https://img.xigyu.com/Pics/LeaveMessageImg/\(s[1])")!)
        }
        else if s.count==3{
            cell.iv_photo.isHidden=false
            cell.iv_photo2.isHidden=false
            cell.iv_photo3.isHidden=false
            cell.iv_photo4.isHidden=true
            cell.iv_photo5.isHidden=true
            cell.iv_photo.setImage(path: URL(string: "https://img.xigyu.com/Pics/LeaveMessageImg/\(s[0])")!)
            cell.iv_photo2.setImage(path: URL(string: "https://img.xigyu.com/Pics/LeaveMessageImg/\(s[1])")!)
            cell.iv_photo3.setImage(path: URL(string: "https://img.xigyu.com/Pics/LeaveMessageImg/\(s[2])")!)
        }
        else if s.count==4{
            cell.iv_photo.isHidden=false
            cell.iv_photo2.isHidden=false
            cell.iv_photo3.isHidden=false
            cell.iv_photo4.isHidden=false
            cell.iv_photo5.isHidden=true
            cell.iv_photo.setImage(path: URL(string: "https://img.xigyu.com/Pics/LeaveMessageImg/\(s[0])")!)
            cell.iv_photo2.setImage(path: URL(string: "https://img.xigyu.com/Pics/LeaveMessageImg/\(s[1])")!)
            cell.iv_photo3.setImage(path: URL(string: "https://img.xigyu.com/Pics/LeaveMessageImg/\(s[2])")!)
            cell.iv_photo4.setImage(path: URL(string: "https://img.xigyu.com/Pics/LeaveMessageImg/\(s[3])")!)
        }
        else if s.count==5{
            cell.iv_photo.isHidden=false
            cell.iv_photo2.isHidden=false
            cell.iv_photo3.isHidden=false
            cell.iv_photo4.isHidden=false
            cell.iv_photo5.isHidden=false
            cell.iv_photo.setImage(path: URL(string: "https://img.xigyu.com/Pics/LeaveMessageImg/\(s[0])")!)
            cell.iv_photo2.setImage(path: URL(string: "https://img.xigyu.com/Pics/LeaveMessageImg/\(s[1])")!)
            cell.iv_photo3.setImage(path: URL(string: "https://img.xigyu.com/Pics/LeaveMessageImg/\(s[2])")!)
            cell.iv_photo4.setImage(path: URL(string: "https://img.xigyu.com/Pics/LeaveMessageImg/\(s[3])")!)
            cell.iv_photo5.setImage(path: URL(string: "https://img.xigyu.com/Pics/LeaveMessageImg/\(s[4])")!)
        }
        cell.lb_who.text=item.UserName
        cell.lb_time.text=item.CreateDate?.replacingOccurrences(of: "T", with: " ")
        cell.selectionStyle = .none
        let tap1=UITapGestureRecognizer(target: self, action: #selector(biger1(sender:)))
        let tap2=UITapGestureRecognizer(target: self, action: #selector(biger2(sender:)))
        let tap3=UITapGestureRecognizer(target: self, action: #selector(biger3(sender:)))
        let tap4=UITapGestureRecognizer(target: self, action: #selector(biger4(sender:)))
        let tap5=UITapGestureRecognizer(target: self, action: #selector(biger5(sender:)))
        cell.iv_photo.addGestureRecognizer(tap1)
        cell.iv_photo2.addGestureRecognizer(tap2)
        cell.iv_photo3.addGestureRecognizer(tap3)
        cell.iv_photo4.addGestureRecognizer(tap4)
        cell.iv_photo5.addGestureRecognizer(tap5)
        tap1.view!.tag=indexPath.row
        tap2.view!.tag=indexPath.row
        tap3.view!.tag=indexPath.row
        tap4.view!.tag=indexPath.row
        tap5.view!.tag=indexPath.row
        return cell
    }
    //MARK:查看大图
    @objc func biger1(sender:UITapGestureRecognizer!){
        let item=mLeaveMsgList[sender.view!.tag]
        // URL pattern snippet
        var images = [SKPhoto]()
        var photo:SKPhoto
        if item.photo!.contains(","){
            let s=item.photo!.split(separator: ",")
            photo = SKPhoto.photoWithImageURL("https://img.xigyu.com/Pics/LeaveMessageImg/\(s[0])")
        }else{
            photo = SKPhoto.photoWithImageURL("https://img.xigyu.com/Pics/LeaveMessageImg/\(item.photo ?? "")")
        }
        photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        images.append(photo)
        
        // create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        self.present(browser, animated: true, completion: {})
    }
    //MARK:查看大图
    @objc func biger2(sender:UITapGestureRecognizer!){
        let item=mLeaveMsgList[sender.view!.tag]
        // URL pattern snippet
        var images = [SKPhoto]()
        let s=item.photo!.split(separator: ",")
        let photo = SKPhoto.photoWithImageURL("https://img.xigyu.com/Pics/LeaveMessageImg/\(s[1])")
        photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        images.append(photo)
        
        // create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        self.present(browser, animated: true, completion: {})
    }
    //MARK:查看大图
    @objc func biger3(sender:UITapGestureRecognizer!){
        let item=mLeaveMsgList[sender.view!.tag]
        // URL pattern snippet
        var images = [SKPhoto]()
        let s=item.photo!.split(separator: ",")
        let photo = SKPhoto.photoWithImageURL("https://img.xigyu.com/Pics/LeaveMessageImg/\(s[2])")
        photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        images.append(photo)
        
        // create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        self.present(browser, animated: true, completion: {})
    }
    //MARK:查看大图
    @objc func biger4(sender:UITapGestureRecognizer!){
        let item=mLeaveMsgList[sender.view!.tag]
        // URL pattern snippet
        var images = [SKPhoto]()
        let s=item.photo!.split(separator: ",")
        let photo = SKPhoto.photoWithImageURL("https://img.xigyu.com/Pics/LeaveMessageImg/\(s[3])")
        photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        images.append(photo)
        
        // create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        self.present(browser, animated: true, completion: {})
    }
    //MARK:查看大图
    @objc func biger5(sender:UITapGestureRecognizer!){
        let item=mLeaveMsgList[sender.view!.tag]
        // URL pattern snippet
        var images = [SKPhoto]()
        let s=item.photo!.split(separator: ",")
        let photo = SKPhoto.photoWithImageURL("https://img.xigyu.com/Pics/LeaveMessageImg/\(s[4])")
        photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
        images.append(photo)
        
        // create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: images)
        self.present(browser, animated: true, completion: {})
    }
    @IBOutlet weak var btn_order: UIButton!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var btn_addpic: UIButton!
    @IBOutlet weak var tv_content: UITextView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uv_back: UIView!
    
    @IBOutlet weak var bottomTable: UITableView!
    var orderid:String!
    var pageNo=1
    var limit=20
    var mLeaveMsgList=[mLeavemessageList]()
    var detail:mXgyOrderDetail!
    var content:String!
    var photos=[String]()
    var photo:String!
    
    var manager: ZJTableViewManager?
    var section:ZJTableViewSection!
    
    init(orderid:String){
        super.init(nibName: nil, bundle: nil)
        self.orderid=orderid
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLayoutSubviews() {
        print(tableView.y)
        let gradientLayer = CAGradientLayer().rainbowLayer()
        gradientLayer.frame = btn_submit.bounds
        self.btn_submit.layer.insertSublayer(gradientLayer, at: 0)
        self.btn_submit.clipsToBounds=true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "LeaveMsgTableViewCell", bundle: nil), forCellReuseIdentifier: "re")
        tableView.separatorStyle = .none
        tableView.contentInset=UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.setEmtpyViewDelegate(target: self)
        uv_back.addOnClickListener(target: self, action: #selector(back))
        btn_order.addOnClickListener(target: self, action: #selector(toOrderDetail))
        btn_addpic.addOnClickListener(target: self, action: #selector(uploadPic))
        btn_submit.addOnClickListener(target: self, action: #selector(uploadPic))
        btn_submit.layer.cornerRadius=5
        //refresh
        let header = TTRefreshHeader.init(refreshingBlock: {[weak self] in
            guard let strongSelf = self else{return}
            strongSelf.pageNo = 1
            //            strongSelf.tableView.mj_footer.state = .idle
            strongSelf.tableView.mj_header.endRefreshing()
            strongSelf.getOrderInfo()
        })
        
        tableView.mj_header = header;
        
        //        let footer = TTRefreshFooter  {  [weak self] in
        //            guard let strongSelf = self else{return}
        //            strongSelf.pageNo = strongSelf.pageNo + 1
        //            strongSelf.getNewsLeaveMessage()
        //        }
        //        tableView.mj_footer = footer
        //        tableView.mj_footer.isHidden = true
        getOrderInfo()
        
        self.bottomTable.backgroundColor = .white
        self.manager = ZJTableViewManager(tableView: self.bottomTable)
        
        //register cell
        self.manager?.register(ZJPictureTableCell.self, ZJPictureTableItem.self)
        
        //add section
        self.section = ZJTableViewSection(headerHeight: 1, color: UIColor.init(white: 0.9, alpha: 1))
        self.manager?.add(section: section!)
        //添加图片
        let pictureItem = ZJPictureTableItem(maxNumber: 5, column: 5, space: 1, width: self.view.frame.size.width/4*3, superVC: self)
        pictureItem.type = .edit
        section.add(item: pictureItem)
    }
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func toOrderDetail(){
        self.navigationController?.pushViewController(XgyOrderDetailViewController(OrderID: orderid), animated: true)
    }
    //MARK:上传图片
    //    @objc func uploadPic(){
    //        let actionSheet = UIAlertController(title: "上传图片", message: nil, preferredStyle: .actionSheet)
    //        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil)
    //
    //        let takePhotos = UIAlertAction(title: "拍照", style: .destructive, handler: {
    //            (action: UIAlertAction) -> Void in
    //
    //            if UIImagePickerController.isSourceTypeAvailable(.camera) {
    //                let picker = UIImagePickerController()
    //                picker.sourceType = .camera
    //                picker.delegate = self
    //                picker.allowsEditing = true
    //                self.present(picker, animated: true, completion: nil)
    //            }
    //            else
    //            {
    //                print("模拟其中无法打开照相机,请在真机中使用");
    //            }
    //        })
    //        let selectPhotos = UIAlertAction(title: "相册选取", style: .default, handler: {
    //            (action:UIAlertAction)
    //            -> Void in
    //            let picker = UIImagePickerController()
    //            picker.sourceType = .photoLibrary
    //            picker.delegate = self
    //            picker.allowsEditing = true
    //            self.present(picker, animated: true, completion: nil)
    //
    //        })
    //        actionSheet.addAction(cancelBtn)
    //        actionSheet.addAction(takePhotos)
    //        actionSheet.addAction(selectPhotos)
    //        self.present(actionSheet, animated: true, completion: nil)
    //    }
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    //        //        关闭相册界面
    //        picker.dismiss(animated: true, completion: nil)
    //        let type = info[UIImagePickerController.InfoKey.mediaType] as! String
    //        if type == "public.image" {
    //            let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
    //            AlamofireHelper.upload(to: LeaveMessageImg, parameters: ["UserID":UserID!], uploadFiles: [image], successHandler: { [weak self](res) in
    //                HUD.dismiss()
    //                guard let ss = self else {return}
    //                if res["Data"]["Item1"].boolValue{
    //                    HUD.showText("图片上传成功")
    //                    ss.photo=res["Data"]["Item2"].stringValue
    //                    ss.btn_addpic.setImage(image, for: UIControl.State.normal)
    //                }else{
    //                    HUD.showText("图片上传失败")
    //                }
    //            }) {
    //                HUD.dismiss()
    //                HUD.showText("图片上传失败")
    //            }
    //
    //        }
    //    }
    //MARK:上传图片
    @objc func uploadPic(){
        content=tv_content.text
        if content.isEmpty{
            HUD.showText("留言不能为空！")
            return
        }
        photos.removeAll()
        var k=0
        for index in 0..<section.items.count{
            let tableItem=section.items[index]as!ZJPictureTableItem
            print(tableItem.arrPictures)
            if tableItem.arrPictures.count==0{
                self.addLeaveMessageForOrder()
            }else{
                for item in tableItem.arrPictures as! [UIImage]{
                    AlamofireHelper.upload(to: LeaveMessageImg, parameters: ["UserID":UserID!], uploadFiles: [item], successHandler: { [weak self](res) in
                        guard let ss = self else {return}
                        if res["Data"]["Item1"].boolValue{
                            ss.photo=res["Data"]["Item2"].stringValue
                            ss.photos.append(ss.photo)
                            k+=1
                            if k==tableItem.arrPictures.count{
                                ss.photo=""
                                for item in ss.photos {
                                    ss.photo+=item+","
                                }
                                if ss.photo.contains(","){
                                    ss.photo="\(ss.photo.prefix(ss.photo.count-1))"
                                }
                                print(ss.photo!)
                                ss.addLeaveMessageForOrder()
                            }
                        }else{
                            HUD.dismiss()
                            HUD.showText("图片上传失败")
                        }
                    })
                }
                
            }
        }
    }
    //MARK:获取工单详情里面的留言消息
    @objc func getOrderInfo(){
        let d = ["OrderID":orderid!]
        AlamofireHelper.post(url: GetOrderInfo, parameters: d , successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            ss.detail=mXgyOrderDetail.init(json: res["Data"])
            ss.mLeaveMsgList=ss.detail.LeavemessageList
            ss.mLeaveMsgList=ss.mLeaveMsgList.reversed()
            ss.tableView.reloadData()
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
    //MARK:提交留言消息
    @objc func addLeaveMessageForOrder(){
        if photo==nil{
            photo=""
        }
        let d = [
            "UserID":UserID!,
            "Type":"1",
            "OrderID":orderid!,
            "Content":content!,
            "photo":photo!,
        ]
        print(d)
        AlamofireHelper.post(url: AddLeaveMessageForOrder, parameters: d , successHandler: {[weak self](res)in
            HUD.dismiss()
            guard let ss = self else {return}
            if res["Data"]["Item1"].boolValue{
                HUD.showText("提交留言成功")
                ss.photo=nil
                ss.tv_content.text=""
                let tableItem=ss.section.items[0]as!ZJPictureTableItem
                tableItem.arrPictures.removeAll()
                ss.bottomTable.reloadData()
                ss.getOrderInfo()
            }else{
                HUD.showText("留言失败")
            }
            
        }){[weak self] (error) in
            HUD.dismiss()
            guard let ss = self else {return}
        }
    }
}
