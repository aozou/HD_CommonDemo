//
//  UIWebView+ZASnap.swift
//  图片应用swift
//
//  Created by  jiangminjie on 2018/5/28.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import Foundation
import UIKit

public extension UIWebView {
    
    public func ZAWebContentScreenSnap(_ completeBlock: @escaping(_ snapImage:UIImage) -> Void) {
        self.scrollView.ZAContentScreenShot(completeBlock)
    }
    
    
}
