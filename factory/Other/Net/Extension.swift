//
//  Extension.swift
//  Toolbox
//
//  Created by gener on 17/10/26.
//  Copyright © 2017年 Light. All rights reserved.
//

import Foundation
import UIKit
//import RxSwift
//import RxCocoa

extension UINavigationController{
    func jumpViewControllerAndCloseSelf(vc:UIViewController){
        var array=[UIViewController]()
        if viewControllers.count>0{
            for index in 0..<viewControllers.count-1{
                array.append(viewControllers[index])
            }
        }
        array.append(vc)
        setViewControllers(array, animated: true)
    }
    
}

extension UIView{
    //任意UIView添加badge
    func showBadgeValue(strBadgeValue: String) -> Void{
        
        let tabBar = UITabBar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        let item = UITabBarItem(title: "", image: nil, tag: 0)
        item.badgeValue = strBadgeValue
        let array = [item]
        
        tabBar.items = array
        for viewTab in tabBar.subviews{
            for subview in viewTab.subviews{
                let strClassName = String(utf8String: object_getClassName(subview))
                if strClassName == "UITabBarButtonBadge" || strClassName == "_UIBadgeView"{
                    let theSubView = subview
                    theSubView.removeFromSuperview()
                    self.addSubview(theSubView)
                    theSubView.frame = CGRect(x: self.frame.size.width - theSubView.frame.size.width, y: 0, width: theSubView.frame.size.width, height: theSubView.frame.size.height)
                    
                }
                
            }
        }
    }
    
    //删除UIView的badge
    func removeBadge() -> Void{
        for subview in self.subviews{
            let strClassName = String(utf8String: object_getClassName(subview))
            if strClassName == "UITabBarButtonBadge" || strClassName == "_UIBadgeView"{
                let theSubView = subview
                theSubView.removeFromSuperview()
            }
        }
    }
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    func corner(byRoundingCorners corners: UIRectCorner, radii: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
extension UIButton{
//    var ex_isEnabled:AnyObserver<Bool>{
//        return UIBindingObserver(UIElement: self) { button, valid in
//            button.isEnabled = valid
//            button.setTitleColor(valid ? UIColor.red:UIColor.lightGray, for: .normal);
//            }.asObserver()
//    }
}

extension UIImageView {
    
    func setImage(path:URL)  {
        self.kf.setImage(with: path)
//        self.kf.setImage(with: path, placeholder: UIImage (named: "default_image2"), options: nil, progressBlock: nil, completionHandler:nil)

    }
    
}

extension String {
    static func isNullOrEmpty(_ any:Any?) -> String {
        guard  let s = any else {return ""}
        if s is NSNull {  return "";  }
        let val = "\(s)".replacingOccurrences(of: "<br/>", with: "")
        
        return val
    }

}


extension Date {
   /// Date类型返回字符串
   ///
   /// - parameter date:          date
   /// - parameter withFormatter: 格式化字符串
   ///
   /// - returns:格式化后的字符串
   public static func stringFromDate(_ date:Date ,withFormatter:String) -> String {
        //"yyyy-MM-dd HH:mm"
        let formatter = DateFormatter.init()
        formatter.dateFormat = withFormatter
        return formatter.string(from: date)
    }
    
   /// 字符串转Date类型
   ///
   /// - parameter str:           日期字符串
   /// - parameter withFormatter: 格式化
   ///
   /// - returns: date
   public static func dateFromString(_ str:String ,withFormatter:String) -> Date? {
        let formatter = DateFormatter.init()
        formatter.timeZone = TimeZone.init(secondsFromGMT: 8);
        formatter.dateFormat = withFormatter
        return formatter.date(from: str)
    }


    /// 根据日期字符串转化为简短日期
    ///
    /// - parameter dateStr: eg"2018-08-23 14:10:00"
    ///
    /// - returns: 格式化后的日期
   public static func dateFormatterWithString(_ dateStr:String) -> String {
        let dateformatter  = DateFormatter.init();
        dateformatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
        dateformatter.timeZone = TimeZone.current
        let date = dateformatter.date(from: dateStr)
        let sec = date?.timeIntervalSinceNow
        
        guard let s = sec , s < 0.0 else {return ""}
        let second = fabs(s)
        
        let mins = second / 60
        if mins < 1 {
            return "刚刚";
        }
        
        let hour = mins / 60
        if hour < 1 {
            let m = Int(mins) % 60
            return "\(m)分钟前"
        }
        
        let day = hour / 24
        if day < 1 {
            let h = Int(hour) % 24
            return "\(h)小时前"
        }
    
        dateformatter.dateFormat = "yyyy-MM-dd"
        return dateformatter.string(from: date!);
    
        /*
        let month = day / 30
        if month < 1 {
            let d = Int(day) % 30
            return "\(d)天前"
        }
        
        let year = month / 12
        if year < 1 {
            let m = Int(month) % 12
            return "\(m)个月前"
        }
        
        let y = Int(year)
        return "\(y)年前"*/
    }
}
extension UITextView {
    private struct RuntimeKey {
        static let hw_placeholderLabelKey = UnsafeRawPointer.init(bitPattern: "hw_placeholderLabelKey".hashValue)
        /// ...其他Key声明
    }
    
    /// 占位文字
    @IBInspectable public var placeholder: String {
        get {
            return self.placeholderLabel.text ?? ""
        }
        set {
            self.placeholderLabel.text = newValue
        }
    }
    
    /// 占位文字颜色
    @IBInspectable public var placeholderColor: UIColor {
        get {
            return self.placeholderLabel.textColor
        }
        set {
            self.placeholderLabel.textColor = newValue
        }
    }
    
    private var placeholderLabel: UILabel {
        get {
            var label = objc_getAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!) as? UILabel
            if label == nil {
                if (self.font == nil) {
                    self.font = UIFont.systemFont(ofSize: 14)
                }
                label = UILabel.init(frame: self.bounds)
                label?.numberOfLines = 0
                label?.font = self.font
                label?.textColor = UIColor.lightGray
                self.addSubview(label!)
                self.setValue(label!, forKey: "_placeholderLabel")
                objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, label!, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                self.sendSubviewToBack(label!)
            }
            return label!
        }
        set {
            objc_setAssociatedObject(self, UITextView.RuntimeKey.hw_placeholderLabelKey!, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension CAGradientLayer {
 
    //获取彩虹渐变层
    func rainbowLayer() -> CAGradientLayer {
        //定义渐变的颜色（7种彩虹色）
        let gradientColors = [UIColor.red.cgColor,UIColor.red.cgColor]
         
        //定义每种颜色所在的位置
        let gradientLocations:[NSNumber] = [0.0, 1.0]
         
        //创建CAGradientLayer对象并设置参数
        self.colors = gradientColors
        self.locations = gradientLocations
         
        //设置渲染的起始结束位置（横向渐变）
        self.startPoint = CGPoint(x: 0, y: 0)
        self.endPoint = CGPoint(x: 1, y: 0)
         
        return self
    }
}
