//
//  CycleImageViewCell.swift
//  CycleScroller
//
//  Created by  jiangminjie on 2018/4/9.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit


class CycleImageViewCell: UICollectionViewCell {
    
    @objc public var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        self.imageView.frame = self.bounds
//        self.imageView.backgroundColor = UIColor.clear
        self.imageView.contentMode = .scaleToFill
        self.addSubview(self.imageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been complete")
    }
    
    @objc open func setupUI(imageName:String?,imageUrl:String?,placeholdImage:UIImage?) {
        if imageName != nil {
            self.imageView.image = UIImage.init(named: imageName!)
        }
        else if imageUrl != nil {
            self.imageView.kf.setImage(with: URL(string: imageUrl!), placeholder: placeholdImage, options: KingfisherEmptyOptionsInfo, progressBlock: nil, completionHandler: nil)
        }
    }
}
