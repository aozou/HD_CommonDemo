//
//  CyclePageControl.swift
//  CycleScroller
//
//  Created by  jiangminjie on 2018/4/10.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit

class CyclePageControl: UIControl {

    //选中分页控件的颜色
    @objc public var currentPageDotColor = UIColor.white
    //为选中分页控件的颜色
    @objc public var pageDotColor = UIColor.lightGray
    //分页控件图标大小
    @objc public var pageControlDotSize:CGSize = CGSize(width: 10, height: 10)
    //分页
    @objc public var numberOfPages:Int = 0
    //分页控件间的间距
    @objc public var spacingBetweenDots:CGFloat = 8
    
    private var dotViewArray: [CyclePageView] = []
    
    // 只有一项的时候隐藏分页控件
    public var hidesForSinglePage: Bool = true
    
    //当前页码
    @objc public var currentPage:Int = 0 {
        willSet {
            if newValue != currentPage {
                self.changeActivity(active: false, index: currentPage)
                self.changeActivity(active: true, index: newValue)
            }
        }
    }
    
    // 自定义分页控件类型
    public var customDotViewType: CycleDotViewType?
    
    // 未选中分页控件：图片方式
    public var pageDotImage: UIImage?
    // 选中分页控件：图片方式
    public var currentPageDotImage: UIImage?
    
    // 自定义分页控件，选中分页控件放大的倍数
    public var currentPageDotEnlargeTimes: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupUI()
        self.updateDots()
    }
    
    override var frame: CGRect {
        didSet {
            self.setupUI()
            self.updateDots()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("CyclePageControl init not complete")
    }

}

extension CyclePageControl {
    
    private func setupUI() {
        
    }
    
    private func updateDots() {
        if self.numberOfPages == 0 {
            return
        }
        
        for index in 0..<self.numberOfPages {
            var customDotView = CyclePageView()
            if index < self.dotViewArray.count {
                customDotView = self.dotViewArray[index]
            } else {
                customDotView = self.generateDotView()
            }
            self.updateDotFrame(dotView: customDotView, index: index)
        }
        
        self.changeActivity(active: true, index: self.currentPage)
        self.hideForSinglePage()
    }
    
    private func generateDotView() -> CyclePageView {
        
        let customDotView = CyclePageView()
        customDotView.isUserInteractionEnabled = true
        customDotView.pageDotColor = self.pageDotColor
        customDotView.currentPageDotColor = self.currentPageDotColor
        customDotView.customDotViewType = self.customDotViewType
        if self.pageDotImage != nil {
            customDotView.pageDotImage = pageDotImage
        }
        if self.currentPageDotImage != nil {
            customDotView.currentPageDotImage = currentPageDotImage
        }
        if self.currentPageDotEnlargeTimes > 0 {
            customDotView.currentPageDotEnlargeTimes = self.currentPageDotEnlargeTimes
        }
        self.addSubview(customDotView)
        self.dotViewArray.append(customDotView)
        return customDotView
    }
    
    private func updateDotFrame(dotView: CyclePageView, index: Int) {
        
        var w: CGFloat = 0.0
        var h: CGFloat = 0.0
        if self.customDotViewType == .image && self.pageDotImage != nil {
            w = self.pageDotImage!.size.width
            h = self.pageDotImage!.size.height
        } else {
            w = self.pageControlDotSize.width
            h = self.pageControlDotSize.height
        }
        
        let x = w * CGFloat(index) + self.spacingBetweenDots * CGFloat(index)
        let y = (self.frame.height - self.pageControlDotSize.height) / 2
        
        dotView.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    private func changeActivity(active: Bool, index: Int) {
        
        let customDotView: CyclePageView = self.dotViewArray[index]
        customDotView.changeActivityState(active: active)
    }
    
    private func hideForSinglePage() {
        if self.dotViewArray.count == 1 && self.hidesForSinglePage {
            self.isHidden = true
        } else {
            self.isHidden = false
        }
    }
}
