//
//  ViewController.swift
//  CycleScroller
//
//  Created by  jiangminjie on 2018/4/9.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var asd: UISegmentedControl!
    @IBOutlet var sda: UISegmentedControl!
    let adArray = ["ad_1", "ad_2", "ad_3"]
    let adArray2 = ["ad_4", "ad_5", "ad_6"]
    let adArray3 = ["ad_5", "ad_6", "ad_7"]
    let adArray4 = ["ad_1", "ad_2", "ad_3", "ad_4", "ad_5", "ad_6", "ad_7"]
    
    let netAdArray = ["http://pic2.16pic.com/00/10/46/16pic_1046407_b.jpg",
                      "http://pic.58pic.com/58pic/14/34/62/39S58PIC9jV_1024.jpg",
                      "http://pic.qiantucdn.com/58pic/17/70/72/02U58PICKVg_1024.jpg",
                      "http://pic.58pic.com/58pic/16/73/95/63E58PICQh7_1024.jpg"]
    
    lazy var scrollview:UIScrollView = {
        let scrollView = UIScrollView(frame:CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = UIColor.clear
        return scrollView
    }()
    
    lazy var cycleScrollerView1: CycleScrollerView = {
        let cycleview = CycleScrollerView.cycle(frame: CGRect(x: 0, y: 20, width: self.scrollview.bounds.width, height: 180))
        cycleview.localizationImageNameArray = adArray
        return cycleview
    }()
    
    lazy var cycleScrollerView2: CycleScrollerView = {
        let cycleview = CycleScrollerView.cycleImage(imageUrlStrArray: netAdArray, placeholdImage: UIImage.init(named: "ad_placeholder"), frame: CGRect(x: 0, y: self.cycleScrollerView1.frame.maxY+20, width: self.cycleScrollerView1.bounds.width, height: 140))
        cycleview.autoScrollTimeInterval = 2.0
        cycleview.scrollDirection = .vertical
        
        cycleview.pageControlAligment = .right
        cycleview.currentPageDotColor = UIColor.red
        cycleview.pageDotColor = UIColor.white
        cycleview.pageControlDotSize = CGSize(width: 15, height: 15)
        cycleview.pageControlMargin = 15
        cycleview.customDotViewType = .solid
        cycleview.currentPageDotEnlargeTimes = 1.0
        
        return cycleview
    }()
    
    lazy var cycleScrollerView3: CycleScrollerView = {
       let cycleview = CycleScrollerView.cycleImage(localizationImageNameArray: adArray3, frame: CGRect(x: 0, y: self.cycleScrollerView2.frame.maxY + 20, width: self.view.frame.width, height: 180))
        cycleview.setupDotImage(pageDotImage: UIImage(named: "pageControlDot")!, currentPageDotImage: UIImage(named: "pageControlCurrentDot")!)
        cycleview.autoScrollTimeInterval = 2.5
        return cycleview
    }()
    
    /// 例四：加载网络图片、自定义空心分页控件
    lazy var cycleScrollerView4: CycleScrollerView = {
        
        let cycleScrollView = CycleScrollerView.cycleImage(imageUrlStrArray: netAdArray, placeholdImage: UIImage(named: "ad_placeholder"), frame: CGRect(x: 0, y: self.cycleScrollerView3.frame.maxY + 20, width: self.view.frame.width, height: 140))
        cycleScrollView.currentPageDotEnlargeTimes = 1.2
        cycleScrollView.customDotViewType = .hollow
        cycleScrollView.pageDotColor = UIColor.white
        cycleScrollView.currentPageDotColor = UIColor.white
        cycleScrollView.pageControlDotSize = CGSize(width: 10, height: 10)
        cycleScrollView.autoScrollTimeInterval = 2.0

        return cycleScrollView
    }()
    
    /// 例五：默认分页控件
    lazy var cycleScrollerView5: CycleScrollerView = {
        
        let cycleScrollView = CycleScrollerView.cycleImage(localizationImageNameArray: adArray4, frame: CGRect(x: 0, y: self.cycleScrollerView4.frame.maxY + 20, width: self.view.frame.width, height: 140))
        cycleScrollView.pageControlType = .classic
        cycleScrollView.pageDotColor = UIColor.lightGray
        cycleScrollView.currentPageDotColor = UIColor.yellow
        cycleScrollView.pageControlDotSize = CGSize(width: 12, height: 12)
        cycleScrollView.autoScrollTimeInterval = 2.0

        return cycleScrollView
    }()
    
    /// 例六：轮播自定义视图
    lazy var cycleScrollerView6: CycleScrollerView = {
        
        let customViewArray = [self.setupUIView(index: 0),
                               self.setupUIView(index: 1),
                               self.setupUIView(index: 2),
                               self.setupUIView(index: 3),
                               self.setupUIView(index: 4)]
        
        let cycleScrollView = CycleScrollerView.cycleView(viewArray: customViewArray, frame:  CGRect(x: 0, y: self.cycleScrollerView5.frame.maxY + 20, width: self.view.frame.width, height: 140))
        cycleScrollView.currentPageDotEnlargeTimes = 1.0
        cycleScrollView.customDotViewType = .hollow
        cycleScrollView.pageDotColor = UIColor.red
        cycleScrollView.currentPageDotColor = UIColor.red
        cycleScrollView.pageControlDotSize = CGSize(width: 12, height: 12)
        cycleScrollView.autoScrollTimeInterval = 2.0
        return cycleScrollView
    }()
    
    /// 例七：轮播自定义视图
    lazy var cycleScrollerView7: CycleScrollerView = {
        
        let customViewArray = [self.setupUIView2(index: 0),
                               self.setupUIView2(index: 1),
                               self.setupUIView2(index: 2),
                               self.setupUIView2(index: 3),
                               self.setupUIView2(index: 4)]
        
        let cycleScrollView = CycleScrollerView.cycleView(viewArray: customViewArray, frame:  CGRect(x: 0, y: self.cycleScrollerView6.frame.maxY + 20, width: self.view.frame.width, height: 30))
        cycleScrollView.pageControlType = .none
        cycleScrollView.scrollDirection = .vertical
        cycleScrollView.autoScrollTimeInterval = 2.0

        return cycleScrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(self.scrollview)
        
        self.scrollview.addSubview(self.cycleScrollerView1)
        self.scrollview.addSubview(self.cycleScrollerView2)
        self.scrollview.addSubview(self.cycleScrollerView3)
        self.scrollview.addSubview(self.cycleScrollerView4)
        self.scrollview.addSubview(self.cycleScrollerView5)
        self.scrollview.addSubview(self.cycleScrollerView6)
        self.scrollview.addSubview(self.cycleScrollerView7)
        
        self.scrollview.contentSize = CGSize(width: self.view.bounds.width, height: self.cycleScrollerView7.frame.maxY + 20)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupUIView(index: Int) -> UILabel {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 140))
        label.backgroundColor = UIColor(red: CGFloat(arc4random()%256)/255.0, green: CGFloat(arc4random()%256)/255.0, blue: CGFloat(arc4random()%256)/255.0, alpha: 1.0)
        label.textColor = UIColor.white
        label.text = "第 \(index + 1) 张自定义视图"
        label.textAlignment = .center
        return label
    }

    func setupUIView2(index: Int) -> UILabel {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        label.backgroundColor = UIColor.lightGray
        label.textColor = UIColor.white
        label.text = "第 \(index + 1) 张自定义视图"
        return label
    }
}

