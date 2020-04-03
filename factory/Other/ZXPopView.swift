//
//  ZXPopView.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/31.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit
protocol dismissViewProtocol: NSObjectProtocol {
    func dismissZXPopView(popview:ZXPopView)
}
class ZXPopView: UIView,UIGestureRecognizerDelegate {
    var zx_delegate:dismissViewProtocol?
    var anim:Int=0
    {
        willSet{
            //为view添加手势。
            var gesture:UITapGestureRecognizer!
            switch newValue {
            case 0:
                gesture=UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
            case 1:
                gesture=UITapGestureRecognizer.init(target: self, action: #selector(topToBottom))
            case 2:
                gesture=UITapGestureRecognizer.init(target: self, action: #selector(leftToRight))
            default:
                gesture=UITapGestureRecognizer.init(target: self, action: #selector(dismissView))
            }
            gesture.delegate=self
            self.addGestureRecognizer(gesture)
        }
    }
    var contenView:UIView?
    {
        didSet{
            setUpContent()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpContent(){
        
        if self.contenView != nil {
            self.addSubview(self.contenView!)
        }
        self.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.4)
        self.isUserInteractionEnabled = true
    }
    
    //上到下消失
    @objc func topToBottom(){
        UIView.animate(withDuration: 0.3, animations: {
            self.contenView?.y = self.height
            self.alpha=0
        }){ (true) in
            self.removeFromSuperview()
            //            self.contenView?.removeFromSuperview()
        }
        zx_delegate?.dismissZXPopView(popview: self)
    }
    //下到上显示
    func bottomToTop(view:UIView){
        if (view == nil && contenView == nil) {
            return
        }
        self.contenView?.y = self.height
        view.addSubview(self)
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
            self.contenView?.y = self.height-(self.contenView?.height)!
        }, completion: nil)
    }
    //直接消失
    @objc func dismissView(){
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha=0
        }){ (true) in
            self.removeFromSuperview()
            //            self.contenView?.removeFromSuperview()
        }
        zx_delegate?.dismissZXPopView(popview: self)
    }
    //直接显示
    func showInView(view:UIView){
        if (view == nil && contenView == nil) {
            return
        }
        view.addSubview(self)
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    //左到右消失
    @objc func leftToRight(){
        UIView.animate(withDuration: 0.3, animations: {
            self.contenView?.x = self.width
            self.alpha = 0
        }){ (true) in
                        self.removeFromSuperview()
            //            self.contenView?.removeFromSuperview()
        }
        zx_delegate?.dismissZXPopView(popview: self)
    }
    //右到左显示
    func rightToLeft(view:UIView){
        if (view == nil && contenView == nil) {
            return
        }
        self.contenView?.x = screenW
        self.contenView?.y = 0
        view.addSubview(self)
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
            self.contenView?.x = screenW/4
        }, completion: nil)
    }
    //在Window上展示，当我们有的界面可能不能获取某个view上的时候，可以Window上展示contentView
    func showInWindow(){
        
        
        UIApplication.shared.keyWindow?.addSubview(self)
        self.contenView?.y = self.height
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
//            self.contenView?.y = screenH/2
            self.contenView?.y = self.height-(self.contenView?.height)!
        }, completion: nil)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view!.isDescendant(of: self.contenView!)){
            return false
        }
        return true
    }
}
