//
//  TabBarViewController.swift
//  高仿MONO
//
//  Created by  jiangminjie on 2018/6/6.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit

let IS_IPHONE_X  = (UIScreen.main.bounds.width == 812 ? true : false)

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.onSetupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    fileprivate func onSetupUI() {
        let home = HomeViewController()
        self.onSetViewController(ctrl: home, title: "首页", imgNorName: "tab_home_nor", imgHightName: "tab_home_press")
        
        let finder = FinderViewController()
        self.onSetViewController(ctrl: finder, title: "查询", imgNorName: "tab_address_nor", imgHightName: "tab_address_press")
        
        let news = NewsViewController()
        self.onSetViewController(ctrl: news, title: "消息", imgNorName: "tab_new_nor", imgHightName: "tab_new_press")
        
        let mine = MineViewController()
        self.onSetViewController(ctrl: mine, title: "我的", imgNorName: "tab_mine_nor", imgHightName: "tab_mine_press")
        
        let tabbarView = TabBarView()
        tabbarView.selectCenterBtBlock =  {
            (name:String)->Void in
            let showView = ShowSelectView()
            showView.show()
        }
        self.setValue(tabbarView, forKey: "tabBar")
    }
    
    fileprivate func onSetViewController(ctrl:UIViewController,title:String,imgNorName:String,imgHightName:String) {
        let nav = NavigationViewController(rootViewController: ctrl)
        self.addChildViewController(nav)
        
        ctrl.tabBarItem.title = title
        ctrl.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: (IS_IPHONE_X ? -20 : -5))
        ctrl.tabBarItem.image = UIImage(named: imgNorName)
        ctrl.tabBarItem.selectedImage = UIImage(named: imgHightName)
        ctrl.navigationItem.title = title + NSStringFromClass(ctrl.classForCoder)
        
    }

}
