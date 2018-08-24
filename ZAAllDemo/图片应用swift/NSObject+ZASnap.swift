//
//  NSObject+ZASnap.swift
//  图片应用swift
//
//  Created by  jiangminjie on 2018/5/29.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import Foundation
import UIKit

class ZAManager: NSObject {
    
    static var share = ZAManager()
    
    public func componseImageWithLog(bgImg:UIImage, imgRect:[CGRect],images:[UIImage], _ complecteBlock: @escaping(_ backImg: UIImage) -> Void) {
        
        let imgRef = bgImg.cgImage
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: (imgRef?.width)!, height: (imgRef?.height)!), false, UIScreen.main.scale)
        
        bgImg.draw(in: CGRect(x: 0, y: 0, width: (imgRef?.width)!, height: (imgRef?.height)!), blendMode: CGBlendMode.normal, alpha: 1)
        
        for i in 0..<images.count {
            images[i].draw(in: CGRect(x: imgRect[i].origin.x, y: imgRect[i].origin.y, width: (imgRect[i].size.width), height: (imgRect[i].size.height)), blendMode: CGBlendMode.normal, alpha: 1)
        }
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        complecteBlock(newImg!)
    }
    
}
