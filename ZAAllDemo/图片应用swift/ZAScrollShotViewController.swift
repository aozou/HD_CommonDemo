//
//  ZAScrollShotViewController.swift
//  图片应用swift
//
//  Created by  jiangminjie on 2018/5/25.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit

class ZAScrollShotViewController: UIViewController {

    
    lazy var imgView1:UIImageView = {
        let img = UIImage(named: "0")
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: Int(CGFloat(SCREENWIDTH)*(img?.size.height)!/(img?.size.width)!))
        imgView.image = img
        imgView.backgroundColor = UIColor.clear
        return imgView
    }()
    
    lazy var imgView2:UIImageView = {
        let img = UIImage(named: "1")
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: Int(CGFloat(SCREENWIDTH)*(img?.size.height)!/(img?.size.width)!))
        imgView.image = img
        imgView.backgroundColor = UIColor.clear
        return imgView
    }()
    
    lazy var imgView3:UIImageView = {
        let img = UIImage(named: "2")
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: Int(CGFloat(SCREENWIDTH)*(img?.size.height)!/(img?.size.width)!))
        imgView.image = img
        imgView.backgroundColor = UIColor.clear
        return imgView
    }()
    
    lazy var scrollView:UIScrollView = {
        var scrollHeight:CGFloat = 0.0
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: Int(SCREENHEIGHT-NAV_HEIGHT))
        scrollView.backgroundColor = UIColor.gray
        
        scrollHeight += self.imgView1.frame.size.height
        scrollView.addSubview(self.imgView1)
        
        self.imgView2.frame = CGRect(x: self.imgView2.frame.origin.x, y: scrollHeight, width: self.imgView2.frame.size.width, height: self.imgView2.frame.size.height)
        scrollHeight += self.imgView2.frame.size.height
        scrollView.addSubview(self.imgView2)
        
        self.imgView3.frame = CGRect(x: self.imgView3.frame.origin.x, y: scrollHeight, width: self.imgView3.frame.size.width, height: self.imgView3.frame.size.height)
        scrollHeight += self.imgView3.frame.size.height
        scrollView.addSubview(self.imgView3)
        
        if scrollHeight+20 > scrollView.frame.size.height {
            scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollHeight+20)
        }
        
        return scrollView
    }()
    
    lazy var shotScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: CGFloat(SCREENWIDTH)*0.5, height: CGFloat(SCREENHEIGHT)*0.5)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.center = self.view.center
        scrollView.backgroundColor = UIColor.purple
        scrollView.addSubview(self.shotView)
        scrollView.isHidden = true
        return scrollView
    }()
    
    lazy var shotView:UIImageView = {
        let topView = UIImageView()
        topView.frame = CGRect(x: 60, y: 60, width: self.view.bounds.size.width-120, height: 280)
        topView.backgroundColor = UIColor.gray
        topView.contentMode = .scaleAspectFit
        return topView
    }()
    
    lazy var shotBt:UIButton = {
        let shotBt = UIButton()
        shotBt.frame = CGRect(x: 40, y: SCREENHEIGHT-60-NAV_HEIGHT, width: 80, height: 40)
        shotBt.setTitle("截Scrolld", for: .normal)
        shotBt.backgroundColor = UIColor.yellow
        shotBt.addTarget(self, action: #selector(ZAScrollShotViewController.onShotScreenAction), for: .touchUpInside)
        return shotBt
    }()
    
    lazy var clearBt:UIButton = {
        let shotBt = UIButton()
        shotBt.frame = CGRect(x: self.view.bounds.size.width-100, y: self.shotBt.frame.origin.y, width: 80, height: 40)
        shotBt.setTitle("清除", for: .normal)
        shotBt.backgroundColor = UIColor.yellow
        shotBt.addTarget(self, action: #selector(ZAScrollShotViewController.onClearScreenAction), for: .touchUpInside)
        return shotBt
    }()
    
    lazy var activityView:UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.activityIndicatorViewStyle = .gray
        activityView.hidesWhenStopped = true
        activityView.backgroundColor = UIColor .black
        activityView.color = UIColor.green
        return activityView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.shotBt)
        self.view.addSubview(self.clearBt)
        self.view.addSubview(self.shotScrollView)
        self.view.addSubview(self.activityView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - 拓展
extension ZAScrollShotViewController {
    @objc func onShotScreenAction() {
        self.activityView.isHidden = false
        self.activityView.startAnimating()
        weak var weakSelf = self
        //分页截屏展示
        self.scrollView.ZAContentScrollScreenSnap { (image) in

            weakSelf?.shotView.image = image
            weakSelf?.shotView.frame = CGRect(x: 0, y: 0, width: (weakSelf?.shotScrollView.frame.width)!, height: ((weakSelf?.shotScrollView.frame.width)!*(image?.size.height)!/(image?.size.width)!))
            weakSelf?.shotScrollView.contentSize = CGSize(width: (weakSelf?.shotScrollView.frame.width)!, height: (weakSelf?.shotView.frame.height)!)
            weakSelf?.shotScrollView.isHidden = false

            weakSelf?.activityView.isHidden = true
            weakSelf?.activityView.stopAnimating()
        }
        
        //只能截屏当前页面,换句话说如何contentSize.height>frame.height,显示的部分只有frame.height
//        let snapShotView = self.scrollView.snapshotView(afterScreenUpdates: true)!
//        self.shotScrollView.addSubview(snapShotView);
//        self.shotScrollView.contentSize = CGSize(width: (self.shotScrollView.frame.width), height: (snapShotView.frame.height))
//        self.shotScrollView.isHidden = false
//        self.shotScrollView.backgroundColor = UIColor.green
        
    }
    
    @objc func onClearScreenAction() {
        if self.shotScrollView.isHidden == false {
            self.shotScrollView.isHidden = true
            
        }
    }
}
