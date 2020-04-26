//
//  popPayPwdView.swift
//  PayPwdDemo
//
//  Created by yaoyunheng on 15/11/2.
//  Copyright © 2015年 yaoyunheng. All rights reserved.
//

let SCREEN_SIZE_WIDTH  = UIScreen.main.bounds.size.width
let SCREEN_SIZE_HEIGHT = UIScreen.main.bounds.size.height

import UIKit

@objc public protocol popPayDelegate {
    // MARK: - Delegate functions
    func compareCode(view:popPayPwdView,payCode: String)
}

public class popPayPwdView: UIView, UITextFieldDelegate {
    
    public init() {
        //可重新定义frame
        super.init(frame: CGRect(x: 40, y: (SCREEN_SIZE_HEIGHT - 190) / 2, width: SCREEN_SIZE_WIDTH - 80, height: 190))
        self.customInit()
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //weak弱引用delegate
    public weak var delegate: popPayDelegate?
    
    var overlayView: UIControl!
    var payCodeTextField: CodeTextField!
    var moneyLabel:UILabel!
    let lineTag = 1000
    let dotTag  = 3000
    //线
    var lineLabel: UILabel?
    //圆点
    var dotLabel: UILabel?
    //密码长度默认6位
    let passWordLength = 6
    var pwdCode = ""
    
    func customInit() {
        self.backgroundColor = UIColor.white
        overlayView = UIControl(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        //        overlayView.addTarget(self, action: "dismiss", forControlEvents: UIControlEvents.TouchUpInside)
        let titleLabel = UILabel(frame: CGRect(x: 40, y: 0, width: self.frame.width - 80, height: 44))
        titleLabel.text = "请输入支付密码"
        titleLabel.textAlignment = .center
        titleLabel.font      = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.black
        self.addSubview(titleLabel)
        
        let lineImageView0   = UIImageView(frame: CGRect(x: 0, y: 44, width: self.frame.width, height: 0.5))
        lineImageView0.image = UIImage(named: "line")
        self.addSubview(lineImageView0)
        
        let cancelBtn = UIButton(frame: CGRect(x: 0, y: 2, width: 40, height: 40))
        cancelBtn.setImage(UIImage(named: "cancel"), for: UIControl.State.normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnPressed), for:UIControl.Event.touchUpInside)
        self.addSubview(cancelBtn)
        
        let withDrawLabel = UILabel(frame: CGRect(x: self.frame.width / 2 - 25, y: 59, width: 50, height: 14))
        withDrawLabel.text = "金额"
        withDrawLabel.textAlignment = .center
        withDrawLabel.font      = UIFont.systemFont(ofSize: 13)
        withDrawLabel.textColor = UIColor.black
        //        self.addSubview(withDrawLabel)
        
        moneyLabel = UILabel(frame: CGRect(x: 0, y: 72, width: self.frame.width, height: 58))
        moneyLabel.text = "￥0.00"
        moneyLabel.textAlignment = .center
        moneyLabel.font      = UIFont.systemFont(ofSize: 40)
        moneyLabel.textColor = UIColor.black
        //        self.addSubview(moneyLabel)
        
        payCodeTextField = CodeTextField(frame: CGRect(x: 12, y: self.frame.height - 51, width: self.frame.width - 24, height: 36))
        payCodeTextField.backgroundColor = UIColor.white
        payCodeTextField.layer.borderColor = UIColor(red: 0xe0/255.0, green: 0xe0/255.0, blue: 0xdf/255.0, alpha: 1.0).cgColor
        payCodeTextField.layer.borderWidth = 0.5
        payCodeTextField.isSecureTextEntry = true
        payCodeTextField.delegate = self
        payCodeTextField.tag = 102
        payCodeTextField.tintColor = UIColor.clear
        payCodeTextField.textColor = UIColor.clear
        payCodeTextField.font = UIFont.systemFont(ofSize: 30)
        payCodeTextField.keyboardType = UIKeyboardType.numberPad
        payCodeTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        payCodeTextField.becomeFirstResponder()
        
        let frame = payCodeTextField.frame
        let perWidth = (frame.size.width - CGFloat(passWordLength) + 1) * 1.0 / CGFloat(passWordLength)
        //遍历密码长度，添加圆点
        for i in 0 ..< passWordLength{
            if i < passWordLength - 1 {
                lineLabel = payCodeTextField.viewWithTag(lineTag + i) as? UILabel
                if !(lineLabel != nil) {
                    lineLabel = UILabel()
                    lineLabel!.tag = lineTag + i
                    payCodeTextField.addSubview(lineLabel!)
                }
                lineLabel!.frame = CGRect(x: perWidth + (perWidth + 1) * CGFloat(i), y: 0, width: 0.5, height: frame.size.height)
                lineLabel!.backgroundColor = UIColor(red: 0xe0/255.0, green: 0xe0/255.0, blue: 0xdf/255.0, alpha: 1.0)
            }
            dotLabel = payCodeTextField.viewWithTag(dotTag + i) as? UILabel
            if !(dotLabel != nil) {
                dotLabel = UILabel()
                dotLabel!.tag = dotTag + i
                payCodeTextField.addSubview(dotLabel!)
            }
            dotLabel!.frame = CGRect(x: (perWidth + 1) * CGFloat(i) + (perWidth - 10) * 0.5, y: (frame.size.height - 10) * 0.5, width: 10, height: 10)
            dotLabel!.layer.masksToBounds = true
            dotLabel!.layer.cornerRadius  = 5
            dotLabel!.backgroundColor = UIColor.black
            dotLabel!.isHidden = true
        }
        self.addSubview(payCodeTextField)
    }
    
    func setMoney(money:String){
        moneyLabel.text=money
    }
    
    @objc func cancelBtnPressed() {
        self.dismiss()
    }
    
    public func fadeIn() {
        UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
            self.frame.origin.y = (SCREEN_SIZE_HEIGHT - self.frame.size.height) / 2 + 30
        }, completion: { (finished: Bool) -> Void in
            UIView.animate(withDuration: 0.1, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.frame.origin.y -= 30
            }, completion: { (finished: Bool) -> Void in
                UIView.animate(withDuration: 0.05, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                    self.frame.origin.y += 10
                }, completion: { (finished: Bool) -> Void in
                    UIView.animate(withDuration: 0.05, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                        self.frame.origin.y -= 5
                    }, completion: { (finished: Bool) -> Void in
                        
                    })
                })
            })
        })
    }
    
    public func fadeOut() {
        UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
            self.frame.origin.y += 30
        }, completion: { (finished: Bool) -> Void in
            UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.frame.origin.y = -self.frame.size.height
                self.overlayView.alpha = 0.01
            }, completion: { (finished: Bool) -> Void in
                if finished {
                    self.payCodeTextField.resignFirstResponder()
                    self.overlayView.removeFromSuperview()
                    self.removeFromSuperview()
                }
            })
        })
    }
    
    public func pop() {
        let keyWindow = UIApplication.shared.keyWindow!
        keyWindow.addSubview(overlayView)
        keyWindow.addSubview(self)
        self.center = CGPoint(x: keyWindow.bounds.size.width / 2.0,
                              y: keyWindow.bounds.size.height / 2.0)
        fadeIn()
    }
    
    public func dismiss() {
        fadeOut()
    }
    
    @objc func textFieldDidChange() {
        let length = payCodeTextField.text!.count
        if length == passWordLength {
            //            dismiss()
            delegate?.compareCode(view: self, payCode: payCodeTextField.text!)
        }
        for i in 0 ..< passWordLength{
            dotLabel = payCodeTextField.viewWithTag(dotTag + i) as? UILabel
            if (dotLabel != nil) {
                dotLabel!.isHidden = length <= i
            }
        }
        payCodeTextField.sendActions(for: .valueChanged)
    }
    @objc func dot_hidden() {
        payCodeTextField.text=""
        for i in 0 ..< passWordLength{
            dotLabel = payCodeTextField.viewWithTag(dotTag + i) as? UILabel
            if (dotLabel != nil) {
                dotLabel!.isHidden = true
            }
        }
    }
}
