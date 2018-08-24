//
//  ZAImageComponseViewController.swift
//  图片应用swift
//
//  Created by  jiangminjie on 2018/5/29.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit

class ZAImageComponseViewController: UIViewController {

    lazy var bgImage : UIImageView = {
       let bgImage = UIImageView()
        bgImage.frame = CGRect(x: 20, y: 20, width: SCREENWIDTH-40, height: SCREENHEIGHT-NAV_HEIGHT-40)
        bgImage.image = UIImage(named: "my")
        return bgImage
    }()
    
    lazy var shotBt:UIButton = {
        let shotBt = UIButton()
        shotBt.frame = CGRect(x: 40, y: SCREENHEIGHT-60-NAV_HEIGHT, width: 80, height: 40)
        shotBt.setTitle("一张合并", for: .normal)
        shotBt.backgroundColor = UIColor.yellow
        shotBt.addTarget(self, action: #selector(ZAImageComponseViewController.onShotScreenAction), for: .touchUpInside)
        return shotBt
    }()
    
    lazy var shotMoreBt:UIButton = {
        let shotBt = UIButton()
        shotBt.frame = CGRect(x: 140, y: SCREENHEIGHT-60-NAV_HEIGHT, width: 80, height: 40)
        shotBt.setTitle("多张合并", for: .normal)
        shotBt.backgroundColor = UIColor.yellow
        shotBt.addTarget(self, action: #selector(ZAImageComponseViewController.onShotMoreScreenAction), for: .touchUpInside)
        return shotBt
    }()
    
    lazy var clearBt:UIButton = {
        let shotBt = UIButton()
        shotBt.frame = CGRect(x: self.view.bounds.size.width-100, y: self.shotBt.frame.origin.y, width: 80, height: 40)
        shotBt.setTitle("清除", for: .normal)
        shotBt.backgroundColor = UIColor.yellow
        shotBt.addTarget(self, action: #selector(ZAImageComponseViewController.onClearScreenAction), for: .touchUpInside)
        return shotBt
    }()
    
    lazy var activityView:UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.frame = CGRect(x: Double(SCREENWIDTH) / 2.0 - 15, y: 70, width: 30, height: 30)
        activityView.activityIndicatorViewStyle = .gray
        activityView.hidesWhenStopped = true
        activityView.backgroundColor = UIColor .black
        activityView.color = UIColor.green
        return activityView
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        // Do any additional setup after loading the view.
        self.title = "多图片合成"
        
        self.view.addSubview(self.bgImage)
        self.view.addSubview(self.shotBt)
        self.view.addSubview(self.shotMoreBt)
        self.view.addSubview(self.clearBt)
        self.view.addSubview(self.activityView)
        self.view.addSubview(self.shotScrollView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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

extension ZAImageComponseViewController {
    @objc func onShotScreenAction() {
        
        self.activityView.isHidden = false
        self.activityView.startAnimating()
        
        weak var weakSelf = self
        self.bgImage.image?.componseImageWithLog(logImg: UIImage(named: "my")!, logFrame: CGRect(x: 80, y: 80, width: 80, height: 80), { (image) in
            weakSelf?.shotView.image = image
            weakSelf?.shotView.frame = CGRect(x: 0, y: 0, width: (weakSelf?.shotScrollView.frame.width)!, height: ((weakSelf?.shotScrollView.frame.width)!*(image.size.height)/(image.size.width)))
            weakSelf?.shotScrollView.contentSize = CGSize(width: (weakSelf?.shotScrollView.frame.width)!, height: (weakSelf?.shotView.frame.height)!)
            weakSelf?.shotScrollView.isHidden = false
            
            weakSelf?.activityView.isHidden = true
            weakSelf?.activityView.stopAnimating()
        })

    }
    
    @objc func onShotMoreScreenAction() {
        self.activityView.isHidden = false
        self.activityView.startAnimating()
        
        weak var weakSelf = self
        ZAManager.share.componseImageWithLog(bgImg: UIImage(named: "my")!,
                                             imgRect: [CGRect(x: 10, y: 10, width: 200, height: 100),
                                                                                     CGRect(x: 30, y: 150, width: 300, height: 100),
                                                                                     CGRect(x: 21, y: 280, width: 200, height: 100),
                                                                                     CGRect(x: 280, y: 280, width: 200, height: 100)],
                                             images: [UIImage(named: "my")!,
                                                      UIImage(named: "my")!,
                                                      UIImage(named: "my")!,
                                                      UIImage(named: "my")!]) { (image) in
                                                        weakSelf?.shotView.image = image
                                                        weakSelf?.shotView.frame = CGRect(x: 0, y: 0, width: (weakSelf?.shotScrollView.frame.width)!, height: ((weakSelf?.shotScrollView.frame.width)!*(image.size.height)/(image.size.width)))
                                                        weakSelf?.shotScrollView.contentSize = CGSize(width: (weakSelf?.shotScrollView.frame.width)!, height: (weakSelf?.shotView.frame.height)!)
                                                        weakSelf?.shotScrollView.isHidden = false
                                                        
                                                        weakSelf?.activityView.isHidden = true
                                                        weakSelf?.activityView.stopAnimating()
        }
    }
    
    @objc func onClearScreenAction() {
        if self.shotScrollView.isHidden == false {
            self.shotScrollView.isHidden = true
        }
    }
}
