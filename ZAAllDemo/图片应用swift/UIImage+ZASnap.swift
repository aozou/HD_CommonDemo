//
//  UIImage+ZASnap.swift
//  图片应用swift
//
//  Created by  jiangminjie on 2018/5/29.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    public func componseImageWithLog(logImg:UIImage,logFrame:CGRect,_ completeBlock: @escaping(_ newImg:UIImage) -> Void){
        
        let imgRef = self.cgImage
        UIGraphicsBeginImageContextWithOptions(CGSize(width: (imgRef?.width)!, height: (imgRef?.height)!), false, UIScreen.main.scale)
        
        self.draw(in: CGRect(x: 0, y: 0, width: (imgRef?.width)!, height: (imgRef?.height)!), blendMode: CGBlendMode.normal, alpha: 1)
        logImg.draw(in: logFrame, blendMode: CGBlendMode.normal, alpha: 1)
        
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        completeBlock(newImg!)
    }
    
}
