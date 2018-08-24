//
//  ZAScreenShotViewController.swift
//  图片应用swift
//
//  Created by  jiangminjie on 2018/5/25.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit

class ZAScreenShotViewController: UIViewController {

    lazy var topView:UIImageView = {
        let topView = UIImageView()
        topView.frame = CGRect(x: 40, y: 40, width: 80, height: 80)
        topView.image = UIImage(named: "my")
        topView.contentMode = .scaleAspectFit
        return topView
    }()
    
    lazy var bottomView : UIView = {
        let bottmView = UIView()
        bottmView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        bottmView.center = CGPoint(x: self.view.center.x, y: self.view.center.y+10)
        bottmView.backgroundColor = UIColor.purple
        return bottmView
    }()
    
    lazy var shotView:UIImageView = {
        let topView = UIImageView()
        topView.frame = CGRect(x: 60, y: 60, width: self.view.bounds.size.width-120, height: 280)
        topView.backgroundColor = UIColor.gray
        topView.contentMode = .scaleAspectFit
        topView.alpha = 0
        return topView
    }()
    
    lazy var shotBt:UIButton = {
        let shotBt = UIButton()
        shotBt.frame = CGRect(x: 40, y: SCREENHEIGHT-60-NAV_HEIGHT, width: 80, height: 40)
        shotBt.setTitle("截整个屏", for: .normal)
        shotBt.backgroundColor = UIColor.yellow
        shotBt.addTarget(self, action: #selector(onShotScreenAction), for: .touchUpInside)
        return shotBt
    }()
    
    lazy var clearBt:UIButton = {
        let shotBt = UIButton()
        shotBt.frame = CGRect(x: self.view.bounds.size.width-100, y: self.shotBt.frame.origin.y, width: 80, height: 40)
        shotBt.setTitle("清除", for: .normal)
        shotBt.backgroundColor = UIColor.yellow
        shotBt.addTarget(self, action: #selector(onClearScreenAction), for: .touchUpInside)
        return shotBt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "View截屏"
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        self.view.addSubview(self.topView)
        self.view.addSubview(self.bottomView)
        self.view.addSubview(self.shotBt)
        self.view.addSubview(self.clearBt)
        self.view.addSubview(self.shotView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//MARK: - 扩展
extension ZAScreenShotViewController {
    
    @objc func onShotScreenAction() {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, false, UIScreen.main.scale)
        //方法1
//        let ctx:CGContext = UIGraphicsGetCurrentContext()!
//        self.view.layer.render(in: ctx)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        //方法2
        let snapView = self.view.snapshotView(afterScreenUpdates: true)!
        self.view.drawHierarchy(in: snapView.frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        self.shotView.image = image
        self.shotView.alpha = 1
    }
    
    @objc func onClearScreenAction() {
        self.shotView.image = UIImage.init()
        self.shotView.alpha = 0
    }
}
