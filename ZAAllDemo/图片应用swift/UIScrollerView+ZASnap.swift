//
//  UIScrollerView+ZASnap.swift
//  图片应用swift
//
//  Created by  jiangminjie on 2018/5/28.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import Foundation
import UIKit

public extension UIScrollView {
 
    public func ZAContentScrollScreenSnap(_ completeBlock: @escaping(_ screenSmap:UIImage?) -> Void) {
        
        self.isShoting = true
        
        //1.先获取分页数,因为contentsize.height>frame.height
        let page = floorf(Float(self.contentSize.height/self.bounds.height))

        //1.1 在上面添加一个截屏图片 挡住因为位移移动而尴尬的画面
        let snapShotView = self.snapshotView(afterScreenUpdates: true)
        snapShotView?.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: (snapShotView?.frame.width)!, height: (snapShotView?.frame.height)!)
        self.superview?.addSubview(snapShotView!)
        
        let backPoint = self.contentOffset
        UIGraphicsBeginImageContextWithOptions(self.contentSize, false, UIScreen.main.scale)
        self.ZAContentScrollPageDraw(currentNub: 0, maxNub: Int(page)) {
            [weak self] () -> Void in
            
            let strongSelf = self
            
            //3.获取图片,并移除1.1的截屏图片
            let screenShotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            strongSelf?.setContentOffset(backPoint, animated: false)
            snapShotView?.removeFromSuperview()
            
            strongSelf?.isShoting = false
            
            completeBlock(screenShotImage)
        }
    
    }
    
    fileprivate func ZAContentScrollPageDraw(currentNub: Int, maxNub :Int,drawCallBlock:@escaping() -> Void) {
        //2.设置偏移坐标以及尺寸来获取指定尺寸的截屏
        self.setContentOffset(CGPoint(x: 0, y: CGFloat(currentNub) * self.frame.height), animated: false)
        let drawFrame = CGRect(x: 0, y: CGFloat(currentNub) * self.frame.height, width: self.frame.width, height: self.frame.height)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+(0.3+Double(NSEC_PER_SEC)/Double(NSEC_PER_SEC))) {
            () -> Void in
            self.drawHierarchy(in: drawFrame, afterScreenUpdates: true)
            
            if currentNub < maxNub {
                self.ZAContentScrollPageDraw(currentNub: currentNub+1, maxNub: maxNub, drawCallBlock: drawCallBlock)
            } else {
                drawCallBlock()
            }
        }
    }
    
}

public extension UIScrollView {
    
    public func ZAContentScreenShot(_ completeBlock: @escaping(_ snapImage:UIImage) -> Void) {
        
        self.isShoting = true
        //1. 截屏放在superview前面
        let snapShotView = self.snapshotView(afterScreenUpdates: true)
        snapShotView?.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: (snapShotView?.frame.width)!, height: (snapShotView?.frame.height)!)
        self.superview?.addSubview(snapShotView!)
        
        let backFrame = self.frame
        let backPoint = self.contentOffset
        let backSuperView = self.superview
        let backInsertIndex = self.superview?.subviews.index(of: self)
        
        weak var weakSelf = self
        self.ZARenderImageView { (renderImage) in
            //4.将scoll从view移到原来父视图上面,并移除截屏
            weakSelf?.removeFromSuperview()
            weakSelf?.frame = backFrame
            weakSelf?.contentOffset = backPoint
            backSuperView?.insertSubview(weakSelf!, at: backInsertIndex!)
            
            snapShotView?.removeFromSuperview()
            
            weakSelf?.isShoting = false
            
            completeBlock(renderImage!)
            
        }
        
    }
    
    fileprivate func ZARenderImageView(_ completeBlock: @escaping(_ snapImage:UIImage?) -> Void) {
        //2.创建一个新的view,尺寸为scollview.contentSize,并将scroll从原来父视图移到view上面
        let renderView = UIView(frame: CGRect(x: 0, y: 0, width: self.contentSize.width, height: self.contentSize.height))
        self.removeFromSuperview()
        renderView.addSubview(self)
        
        self.contentOffset = CGPoint.zero
        self.frame = renderView.bounds
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+(0.3+Double(NSEC_PER_SEC))/Double(NSEC_PER_SEC)) {
            let bounds = self.bounds
            //3.截屏或者绘制
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
            
            if self.ZAContentWKWebView() {
                self.drawHierarchy(in: bounds, afterScreenUpdates: true)
            } else {
                renderView.layer.render(in: UIGraphicsGetCurrentContext()!)
            }
            
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            completeBlock(image)
        }
    }
    
}
