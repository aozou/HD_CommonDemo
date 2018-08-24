//
//  ViewController.swift
//  图片应用swift
//
//  Created by  jiangminjie on 2018/5/24.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit

let SCREENWIDTH = Int(UIScreen.main.bounds.width)
let SCREENHEIGHT = Int(UIScreen.main.bounds.height)
let HEDERVIEWHEIHT = SCREENWIDTH*503/496
let IS_PHONEX = (SCREENHEIGHT == 812 ? true : false)
let NAV_HEIGHT = (IS_PHONEX ? 88 : 64)


class ViewController: UIViewController {

    lazy var mainTableView:UITableView = {
        let tableView = UITableView.init(frame: self.view.bounds, style: .plain);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = UIColor.red
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell");
        tableView.addSubview(self.headerView)
        tableView.contentInset = UIEdgeInsetsMake(CGFloat(HEDERVIEWHEIHT), 0, 0, 0)
        return tableView;
    }()
    
    lazy var headerView:UIImageView = {
        let headerView = UIImageView.init(frame: CGRect(x: 0, y: -HEDERVIEWHEIHT, width: SCREENWIDTH, height: HEDERVIEWHEIHT))
        let image = UIImage(named: "my")
        headerView.image = image
        return headerView
    }()
    
    lazy var navView :UIView = {
        let navView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: NAV_HEIGHT))
        navView.backgroundColor = UIColor.green
        navView.alpha = 0
        
        let lbale = UILabel.init(frame: navView.bounds)
        lbale.text = "测试用例"
        lbale.font = UIFont.boldSystemFont(ofSize: 15)
        lbale.textColor = UIColor.white
        lbale.textAlignment = .center
        navView.addSubview(lbale)
        
        return navView
    }()
    
    var dataSource = ["view截屏",
                      "scollView 截屏(长图)",
                      "web 截屏(长图)",
                      "wkWebView 截图（生成长图）",
                      "多图片图片合成（在图片上加logo)",
                      "给截图打上标签，文本，裁剪，圆角",
                      "截取图片的任意部分",
                      "图片擦除😜",
                      "图片滤镜--怀旧，黑白，岁月，烙黄，冲印,...",
                      "图片滤镜(高级)--饱和度，高斯模糊，老电影",
                      "导航栏1",
                      "导航栏2",
                      "导航栏3",
                      "导航栏4",
                      "导航栏5",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "图片应用展示"
        self.navigationController?.navigationBar.isTranslucent = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = .top
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(self.mainTableView)
        self.view.addSubview(self.navView)
        
        NSLog("123")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), for: .default)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let shotView = ZAScreenShotViewController()
            self.navigationController?.pushViewController(shotView, animated: true)
        case 1:
            let shotView = ZAScrollShotViewController()
            self.navigationController?.pushViewController(shotView, animated: true)
        case 2:
            let shotView = ZAWebViewController()
            self.navigationController?.pushViewController(shotView, animated: true)
        case 3:
            let shotView = ZAWKWebViewController()
            self.navigationController?.pushViewController(shotView, animated: true)
        case 4:
            let shotView = ZAImageComponseViewController()
            self.navigationController?.pushViewController(shotView, animated: true)
        case 8:
            let shotView = ZAImageMaskViewController()
            self.navigationController?.pushViewController(shotView, animated: true)
        default:
            NSLog("wwww")
        }
    }
 
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

extension ViewController:UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = self.dataSource[indexPath.row]
        return cell
    }
}

extension ViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY < (CGFloat(-HEDERVIEWHEIHT)) {
            self.navView.alpha = 0
            let origin_y = contentOffsetY
            let size_height = -contentOffsetY
            let size_width = -contentOffsetY*CGFloat(SCREENWIDTH)/CGFloat(HEDERVIEWHEIHT)
            let origin_x = -(size_width-CGFloat(SCREENWIDTH))/2.0
            self.headerView.frame = CGRect(x: origin_x, y: origin_y, width: size_width, height: size_height)
        }
        else if contentOffsetY < (CGFloat(-NAV_HEIGHT)+20) {
            let alpha_value = -CGFloat(NAV_HEIGHT)/CGFloat(contentOffsetY)
            self.navView.alpha = alpha_value
        }
        else {
            self.navView.alpha = 1.0
        }
    }
}
