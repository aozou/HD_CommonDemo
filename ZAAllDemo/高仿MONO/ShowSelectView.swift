//
//  ShowSelectView.swift
//  高仿MONO
//
//  Created by  jiangminjie on 2018/6/7.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit

@objc
protocol ShowSelectViewDelegate:NSObjectProtocol {
    @objc optional func onSelectItemForPushController(selectView:ShowSelectView)
}

class ShowSelectView: UIView {

    public var buttonMutArray:[UIButton] = NSMutableArray() as! [UIButton]
    public let item_leftMarg:CGFloat = 20.0
    public let item_topMarg:CGFloat = 140.0
    public var item_width:CGFloat = 0
    public var item_height:CGFloat = 0
    private var item_count :Int = 5
    fileprivate var item_len:Int = 6
    weak var delegate:ShowSelectViewDelegate?
    
    public var showWindow : UIWindow = {
       let windows = UIWindow()
        windows.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        windows.windowLevel = 10086
        windows.backgroundColor = UIColor.clear
        windows.isUserInteractionEnabled = true
        windows.becomeKey()
        windows.makeKeyAndVisible()
        windows.isHidden = false
        return windows
    }()
    
    public var backBt:UIButton = {
       let backBt = UIButton()
        backBt.frame = CGRect(x: SCREENWIDTH-90, y: (IS_IPHONE_X ? 70 : 30), width: 80, height: 80)
        backBt.setTitle("X", for: .normal)
        backBt.setTitleColor(UIColor.black, for: .normal)
        backBt.addTarget(self, action: #selector(ShowSelectView.onHideTapAction), for: .touchUpInside)
        return backBt
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        item_width = (SCREENWIDTH - CGFloat(self.item_leftMarg * 4)) / 3.0
        item_height = item_width
        
        self.backgroundColor = UIColor.white
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ShowSelectView.onHideTapAction)))
        self.addSubview(self.backBt)
        self.onCreateAllButtonAction()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ShowSelectView {
    @objc public func show() {
        self.showWindow.addSubview(self)
        self.frame = (self.showWindow.bounds)
        
        self.onShowAnimation()
    }

    @objc public func onPushViewController(button:UIButton) {
        self.onHideTapAction()
    }
}

extension ShowSelectView {
    
    fileprivate func onCreateAllButtonAction() {
        for i in 0..<6 {
            let bt = UIButton()
            bt.frame = CGRect(x: (SCREENWIDTH-item_width)/2.0, y: SCREENHEIGHT, width: item_width, height: item_height)
            bt.setTitle(String(format: "第"+"%d"+"个", arguments: [i]), for: .normal)
            bt.setTitleColor(UIColor.purple, for: .normal)
            bt.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            bt.tag = 900+i
            bt.backgroundColor = UIColor.gray
            bt.layer.cornerRadius = item_height/2.0
            bt.layer.masksToBounds = true
            bt.addTarget(self, action: #selector(ShowSelectView.onPushViewController(button:)), for: .touchUpInside)
            self.addSubview(bt)
            self.buttonMutArray.append(bt)
        }
    }
    
    
    fileprivate func onShowAnimation() {
        self.alpha = 0
        UIView.animate(withDuration: 0.35) {
            self.alpha = 1
            self.onShowButtonAnimation()
        }
    }
    
    fileprivate func onShowButtonAnimation() {
        
        for i in 0..<self.buttonMutArray.count {
            let l:CGFloat = CGFloat(i % 3)
            let h:CGFloat = CGFloat(i / 3)
            let bt = self.buttonMutArray[i]
            bt.frame = CGRect(x: item_leftMarg + (item_width + item_leftMarg) * l, y: item_topMarg + h * (item_height + item_topMarg), width: item_width, height: item_height)
            
            let animation = CAKeyframeAnimation()
            animation.keyPath = "frame"
            animation.values = [CGRect(x: (SCREENWIDTH-item_width)/2.0, y: SCREENHEIGHT, width: item_width, height: item_height),bt.frame]
            animation.keyTimes = [1.5,3.0]
            
            let animation1 = CAKeyframeAnimation()
            animation1.keyPath = "transform.scale"
            animation1.values = [0.8,1.2]
            animation1.keyTimes = [1.3,3.0]
            
            let group = CAAnimationGroup()
            group.duration = 0.35
            group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            group.animations = [animation,animation1]
            bt.layer.add(group, forKey:String(format:"group"+"%d", i))
            
        }
    }
    
    fileprivate func onHideAnimation() {
        self.alpha = 1
        UIView.animate(withDuration: 0.35) {
            self.alpha = 0
        }
    }
    
    @objc func onHideTapAction() {
        self.onHideAnimation()
        
       self.showWindow.resignKey()
        self.showWindow.isHidden = true
    }
}

