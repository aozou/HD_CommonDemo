//
//  TabBarView.swift
//  高仿MONO
//
//  Created by  jiangminjie on 2018/6/6.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit

public typealias SelectBtBlock = (_ selectString : String) -> Void

class TabBarView: UITabBar {

    public var selectCenterBtBlock:SelectBtBlock?
    
    public var centBt: UIButton = {
       let centBt = UIButton()
        let item_Width:CGFloat = SCREENWIDTH/5.0
        centBt.frame = CGRect(x: item_Width*2, y: -10 , width: item_Width, height: 50)
        centBt.setImage(UIImage(named: "tab_center"), for: .normal)
        centBt.setImage(UIImage(named: "tab_center"), for: .selected)
        centBt.setImage(UIImage(named: "tab_center"), for: .highlighted)
        centBt.addTarget(self, action: #selector(onSelectItemAction), for: .touchUpInside)
        return centBt
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.centBt)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let subViews:[UIView] = self.subviews
        var itemCurrent:Int = 0
        let item_Width:CGFloat = SCREENWIDTH/5.0
        
        for i in 0..<subViews.count {
            let itemBt = subviews[i];
            if itemBt.isKind(of: NSClassFromString("UITabBarButton")!) {
                
                if itemCurrent == 2 {
                    itemCurrent = 3
                }
                
                itemBt.frame = CGRect(x: CGFloat(itemCurrent) * item_Width, y: 0, width: item_Width, height: self.bounds.height)
                
                for j in 0..<itemBt.subviews.count {
                    let btLabel = itemBt.subviews[j]
                    if btLabel.isKind(of: NSClassFromString("UITabBarButtonLabel")!) {
                        btLabel.backgroundColor = UIColor.clear
                    } else {
                        btLabel.backgroundColor = UIColor.clear
                    }
                }
                
                itemCurrent += 1
            }
        }
    }
}

extension TabBarView {
    @objc public func onSelectItemAction() {
        if (self.selectCenterBtBlock != nil) {
            self.selectCenterBtBlock!("123")
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let newPoint = self.centBt.convert(point, from: self)
        if CGRect(x: 0, y: 0, width: self.centBt.frame.width, height: self.centBt.frame.height).contains(newPoint) {
            return self.centBt
        }
        
        return super.hitTest(point, with: event)
        
    }
}

