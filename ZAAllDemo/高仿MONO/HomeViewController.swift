//
//  HomeViewController.swift
//  高仿MONO
//
//  Created by  jiangminjie on 2018/6/6.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit

enum homeType {
    case homeTy_once
    case homeTy_send
}

class HomeViewController: UIViewController {
    
    public var mainTableView: UITableView?
    public var fontMutArr:[String] = []
    public var dataType:homeType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        // Do any additional setup after loading the view.
        self.onCreateUI()
        self.onGetFontData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func onCreateUI() {
        self.mainTableView = UITableView(frame: CGRect(x: 0, y: 0, width: SCREENWIDTH, height: self.view.frame.height), style: .plain)
        self.mainTableView?.delegate = self
        self.mainTableView?.dataSource = self
        self.mainTableView?.register(UITableViewCell.self, forCellReuseIdentifier: "homeCell")
        self.view.addSubview(self.mainTableView!)
    }
    
    func onGetFontData() {
        let familyNames = UIFont.familyNames
        for name in familyNames {
            let fontNames = UIFont.fontNames(forFamilyName: name)
//            NSLog(name)
            if (name as String).elementsEqual("经典繁淡古") {
                print(fontNames)
            }
            if (name as String).elementsEqual("FZLanTingKanHei-R-GBK") {
                print(fontNames)
            }
            if (name as String).elementsEqual("msyh") {
                print(fontNames)
            }
            for fontName in fontNames {
                fontMutArr.append(fontName)
                NSLog("font-->>%@", fontName)
            }
        }
        NSLog("字体总数:%d", self.fontMutArr.count)
        self.mainTableView?.reloadData()
        
        let infoStr = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let controller:AnyClass = NSClassFromString(infoStr + "." + "HomeViewController")!
        let viController = (controller as! UIViewController.Type).init()
        let sd = String(describing: HomeViewController.self).components(separatedBy: ".").last
        //互斥锁
//        objc_sync_enter(self)
//        执行代码块
//        objc_sync_exit(self)
        
//        //全局队列
//        DispatchQueue.global().async {
//            //主队列
//            DispatchQueue.main.async {
//
//            }
//        }
        
//        let group = DispatchGroup()
//        //添加队列
//        group.enter()
//
//        let queue = DispatchQueue.global()
//        queue.async {
//            for i in 0..<10 {
//                print("\(i)")
//            }
//            group.leave()
//        }
//
////        DispatchQueue(label: <#T##String#>, qos: <#T##DispatchQoS#>, attributes: <#T##DispatchQueue.Attributes#>, autoreleaseFrequency: <#T##DispatchQueue.AutoreleaseFrequency#>, target: <#T##DispatchQueue?#>)
//
//        group.notify(queue: DispatchQueue.main) {
//            print("队列执行完毕")
//        }
        
        
        var dic = ["1":"one"]
        dic.updateValue("1", forKey: "123")
        
        NSLog("123")
        HSLog(message: "5555")
    }
    func HSLog<T>(message:T) {
        
        print("\(message)")
        
    }
}

extension HomeViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.fontMutArr.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)
        if (self.fontMutArr.count) > indexPath.row {
            cell.textLabel?.text = String(format: "%@-%@", self.fontMutArr[indexPath.row],"这是一条测试数据,目的是测试字体的显示情况以及间隙等很多结果,好吧 懒得编了.")
            cell.textLabel?.font = UIFont(name: self.fontMutArr[indexPath.row] , size: 16) ?? UIFont.systemFont(ofSize: 16)
        }
        return cell
    }
}

public extension NSObject {
    public class var nameOfStrng:String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
//    public var nameOfString:String {
//        return NSStringFromClass(self.dyn)
//    }
}
