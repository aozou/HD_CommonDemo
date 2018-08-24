//
//  ViewController.swift
//  startAnimation
//
//  Created by  jiangminjie on 2018/4/17.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit

let TABBARHIEHT:CGFloat = (UIApplication.shared.statusBarFrame.height > 20 ? 88 : 44)

class ViewController: UIViewController {

    lazy var segementView:UISegmentedControl = {
        let segementView = UISegmentedControl(frame: CGRect(x: 40, y: 30+TABBARHIEHT, width: self.view.bounds.width-80, height: 40))
        segementView.insertSegment(withTitle: "一星", at: 0, animated: true)
        segementView.insertSegment(withTitle: "半星", at: 1, animated: true)
        segementView.insertSegment(withTitle: "随意", at: 2, animated: true)
        segementView.selectedSegmentIndex = 0
        segementView.addTarget(self, action: #selector(segemClickAction), for: .valueChanged)
        return segementView
    }()
    
    lazy public var starV:startView = {
        let startV = startView.init(frame: CGRect.init(x: (UIScreen.main.bounds.width - 320)/2, y: 60+self.segementView.frame.maxY, width: 320, height: 100), starCount: 8, currentStar: 2, rateStyle: .half, complete: { (index) in
            print("\(index)")
        })
        return startV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(self.segementView)
        self.view.addSubview(self.starV)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {
    @objc func segemClickAction(_ sender:UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.starV.selectStarUnit = .all
            break
        case 1:
            self.starV.selectStarUnit = .half
            break
        case 2:
            self.starV.selectStarUnit = .custom
            break
        default:
            break
        }
        self.starV.update()
    }
}

