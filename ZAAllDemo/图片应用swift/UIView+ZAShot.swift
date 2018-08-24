//
//  UIView+ZAShot.swift
//  图片应用swift
//
//  Created by  jiangminjie on 2018/5/28.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import Foundation
import UIKit
import WebKit

private var ZASCREEN_SHOT_KEY_IS_SHOTING = "screen_shot_key_is_shoting"

public extension UIView {
    
    var isShoting:Bool {
        set {
            let num = NSNumber(value: isShoting)
            objc_setAssociatedObject(self, &ZASCREEN_SHOT_KEY_IS_SHOTING, num, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            let num = objc_getAssociatedObject(self, &ZASCREEN_SHOT_KEY_IS_SHOTING)
            guard (num != nil) else {
                return false
            }
            
            if let numObj = num as? NSNumber {
                return numObj.boolValue
            } else {
                return false
            }
        
        }
    }
    
    public func ZAContentWKWebView() -> Bool {
        
        if self.isKind(of: WKWebView.self) {
            return true
        }
        
        for subiews in self.subviews {
            if (subiews.ZAContentWKWebView()) {
                return true
            }
        }
        return false
        
    }
    
}
