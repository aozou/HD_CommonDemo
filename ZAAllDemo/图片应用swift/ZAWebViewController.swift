//
//  ZAWebViewController.swift
//  图片应用swift
//
//  Created by  jiangminjie on 2018/5/28.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit

class ZAWebViewController: UIViewController {

    lazy var webView:UIWebView = {
        let webView = UIWebView()
        webView.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT-NAV_HEIGHT)
        webView.delegate = self
        webView.backgroundColor = UIColor.gray
        webView.loadRequest(NSURLRequest(url: URL(string: "https://www.jianshu.com/p/7c8cf9bef56f")!) as URLRequest)
        return webView
    }()
    
    lazy var shotBt:UIButton = {
        let shotBt = UIButton()
        shotBt.frame = CGRect(x: 40, y: SCREENHEIGHT-60-NAV_HEIGHT, width: 80, height: 40)
        shotBt.setTitle("截Scrolld", for: .normal)
        shotBt.backgroundColor = UIColor.yellow
        shotBt.addTarget(self, action: #selector(ZAWebViewController.onShotScreenAction), for: .touchUpInside)
        return shotBt
    }()
    
    lazy var clearBt:UIButton = {
        let shotBt = UIButton()
        shotBt.frame = CGRect(x: self.view.bounds.size.width-100, y: self.shotBt.frame.origin.y, width: 80, height: 40)
        shotBt.setTitle("清除", for: .normal)
        shotBt.backgroundColor = UIColor.yellow
        shotBt.addTarget(self, action: #selector(ZAWebViewController.onClearScreenAction), for: .touchUpInside)
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
        self.title = "Web截图"
        // Do any additional setup after loading the view.
        self.view.addSubview(self.webView)
        self.view.addSubview(self.shotBt)
        self.view.addSubview(self.clearBt)
        self.view.addSubview(self.activityView)
        self.view.addSubview(self.shotScrollView)
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

extension ZAWebViewController {
    @objc func onShotScreenAction() {
        self.activityView.isHidden = false
        self.activityView.startAnimating()
        
        weak var weakSelf = self
        self.webView.ZAWebContentScreenSnap { (image) in
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

extension ZAWebViewController:UIWebViewDelegate {
    
    public func webViewDidStartLoad(_ webView: UIWebView) {
        self.activityView.isHidden = false
        self.activityView.startAnimating()
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        self.activityView.isHidden = true
        self.activityView.stopAnimating()
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.activityView.isHidden = true
        self.activityView.stopAnimating()
    }
}
