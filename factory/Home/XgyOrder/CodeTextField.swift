//
//  CodeTextField.swift
//  ZBBuyer
//
//  Created by yaoyunheng on 15/10/6.
//  Copyright © 2015年 ZhaoBu. All rights reserved.
//

import UIKit

class CodeTextField: UITextField {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) || action == #selector(UIResponderStandardEditActions.selectAll(_:)) || action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
