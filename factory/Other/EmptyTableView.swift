//
//  EmptyTableView.swift
//  ShopIOS
//
//  Created by Apple on 2019/7/29.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

private let EmptyViewTag = 12345;

protocol EmptyViewProtocol: NSObjectProtocol {
    
    ///用以判断是会否显示空视图
    var showEmtpy: Bool {get}
    
    ///配置空数据提示图用于展示
    func configEmptyView() -> UIView?
}

extension EmptyViewProtocol {
    
    func configEmptyView() -> UIView? {
        return nil
    }
}
//MARK:- ***** Associated Object *****
private struct AssociatedKeys {
    static var tableView_emptyViewDelegate = "tableView_emptyViewDelegate"
    static var colloection_emptyViewDelegate = "colloection_emptyViewDelegate"
}
extension UITableView{
    
    
    func setEmtpyViewDelegate(target: EmptyViewProtocol) {
        self.emptyDelegate = target
        DispatchQueue.once(#function) {
            Tools.exchangeMethod(cls: self.classForCoder, targetSel: #selector(self.layoutSubviews), newSel: #selector(self.re_layoutSubviews))
        }
    }
    
    @objc func re_layoutSubviews() {
        self.re_layoutSubviews()
        if (self.emptyDelegate != nil){
            if self.emptyDelegate!.showEmtpy {
                
                guard let view = self.emptyDelegate?.configEmptyView() else {
                    return;
                }
                
                if let subView = self.viewWithTag(EmptyViewTag) {
                    subView.removeFromSuperview()
                }
                
                view.tag = EmptyViewTag;
                self.addSubview(view)
                
            } else {
                
                guard let view = self.viewWithTag(EmptyViewTag) else {
                    return;
                }
                view .removeFromSuperview()
            }
        }
        
    }
    private var emptyDelegate: EmptyViewProtocol? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tableView_emptyViewDelegate) as? EmptyViewProtocol
        }
        set (newValue){
            objc_setAssociatedObject(self, &AssociatedKeys.tableView_emptyViewDelegate, newValue!, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
extension UICollectionView{
    
    
    func setEmtpyViewDelegate2(target: EmptyViewProtocol) {
        self.emptyDelegate2 = target
        DispatchQueue.once(#function) {
            Tools.exchangeMethod(cls: self.classForCoder, targetSel: #selector(self.layoutSubviews), newSel: #selector(self.re_layoutSubviews2))
        }
    }
    
    @objc func re_layoutSubviews2() {
        self.re_layoutSubviews2()
        if (self.emptyDelegate2 != nil){
            if self.emptyDelegate2!.showEmtpy {
                
                guard let view = self.emptyDelegate2?.configEmptyView() else {
                    return;
                }
                
                if let subView = self.viewWithTag(EmptyViewTag) {
                    subView.removeFromSuperview()
                }
                
                view.tag = EmptyViewTag;
                self.addSubview(view)
                
            } else {
                
                guard let view = self.viewWithTag(EmptyViewTag) else {
                    return;
                }
                view .removeFromSuperview()
            }
        }
        
    }
    private var emptyDelegate2: EmptyViewProtocol? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.colloection_emptyViewDelegate) as? EmptyViewProtocol
        }
        set (newValue){
            objc_setAssociatedObject(self, &AssociatedKeys.colloection_emptyViewDelegate, newValue!, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

