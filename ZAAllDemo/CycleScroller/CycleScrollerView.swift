//
//  CycleScrollerView.swift
//  CycleScroller
//
//  Created by  jiangminjie on 2018/4/9.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

import UIKit

let KImageViewCellID = "imageViewCellID"
let KViewCellID = "viewCellID"

/*
 * 分页控件类型,默认为 classic
 *  -none: 无
 *  -classic:系统自带
 *  -custom:自定义
 */
@objc public enum PageControlType:Int {
    case none
    case classic
    case custom
}

/*
 * 自定义分页控件类型,默认hollow
 *  -hollow:空心
 *  -solid:实心
 *  -image:图片
 */
@objc public enum CycleDotViewType:Int {
    case hollow
    case solid
    case image
}

/*
 * 分页控件位置
 *  -center:中偏下位置
 *  -right:右偏下位置
 *  -left:左偏下位置
 */
@objc public enum PageControlAliment:Int {
    case center
    case right
    case left
}

public typealias ItemDidScrollBlock = (_ currentIndex:Int) -> Void
public typealias ItemDidClickBlock = (_ currentIndex:Int) -> Void

class CycleScrollerView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource {

    //MARK: public
    //本地图片
    @objc public var localizationImageNameArray:[String]? {
        didSet{
            self.collectionView.register(CycleImageViewCell.self, forCellWithReuseIdentifier: KImageViewCellID)
            self.sourceArray = localizationImageNameArray as [AnyObject]?
        }
    }
    
    //网络图片
    @objc public var imageUrlStrArray:[String]? {
        didSet{
            self.collectionView.register(CycleImageViewCell.self, forCellWithReuseIdentifier: KImageViewCellID)
            self.sourceArray = imageUrlStrArray as [AnyObject]?
        }
    }
    
    //预加载图片
    @objc public var placeholdImage:UIImage?
    
    //自定义UI
    @objc public var viewArray:[UIView]? {
        didSet{
            self.collectionView.register(CycleCell.self, forCellWithReuseIdentifier: KViewCellID)
            self.sourceArray = imageUrlStrArray as [AnyObject]?
        }
    }
    
    //轮播轮回次数
    @objc public var loopTimes = 100
    
    //轮播图滚动方向
    @objc public var scrollDirection:UICollectionViewScrollDirection = .horizontal
    
    //是否自动轮播
    @objc public var autoScroll = true {
        didSet {
            self.invalidateTime()
            if autoScroll {
                self .setupTimer()
            }
        }
    }
    
    //自动轮播间隔时间
    @objc public var autoScrollTimeInterval:TimeInterval = 5.0 {
        didSet {
            self.invalidateTime()
            if autoScrollTimeInterval > 0 {
                self.setupTimer()
            }
        }
    }
    
    //分页控件
    @objc public var pageControl:UIControl?
    //选中分页控件颜色
    @objc public var currentPageDotColor = UIColor.white {
        didSet {
            self.setupPageControl()
        }
    }
    //为选中分页控件颜色
    @objc public var pageDotColor = UIColor.lightGray {
        didSet {
            self.setupPageControl()
        }
    }
    
    //分页控件类型
    @objc public var pageControlType:PageControlType = .classic {
        didSet {
            self.setupPageControl()
        }
    }
    
    //自定义分页控件类型
    @objc public var customDotViewType:CycleDotViewType = .hollow {
        didSet {
            self.pageControlType = .custom
        }
    }
    
    //分页控件位置
    @objc public var pageControlAligment:PageControlAliment = .center
    
    //分页控件大小
    @objc public var pageControlDotSize:CGSize = CGSize(width: 10, height: 10) {
        didSet {
            self.setupPageControl()
        }
    }
    
    //分页控件边距
    @objc public var pageControlMargin:CGFloat = 10
    
    //分页控件insert值
    @objc public var pageControlInsets:UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
    
    //自定义分页控件,选中分页控件放大倍数
    @objc public var currentPageDotEnlargeTimes:CGFloat = 0.0 {
        didSet {
            self.setupPageControl()
        }
    }
    
    @objc public var itemDicScrollBlock:ItemDidScrollBlock?
    @objc public var itemDidClickBlock:ItemDidClickBlock?
    
    //MARK: private
    //传入的资源
    private var sourceArray:[AnyObject]? {
        didSet{
            self.collectionView.reloadData()
            self.autoScroll = true
            self.pageControlType = .classic
            self.setNeedsLayout()
        }
    }
    
    //传入资源总数
    private var sourceCount:Int {
        if self.localizationImageNameArray != nil {
            return self.localizationImageNameArray!.count
        }
        else if self.imageUrlStrArray != nil {
            return self.imageUrlStrArray!.count
        }
        else if self.viewArray != nil {
            return self.viewArray!.count
        }
        return 0
    }
    
    //item总数
    private var totalItemsCount:Int {
        return self.sourceCount * self.loopTimes
    }
    
    //轮播定时器
    private var rollTime:Timer?
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0
        return flowLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: self.collectionViewFlowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.scrollsToTop = true
        self.addSubview(collectionView)
        return collectionView
    }()

    // 未选中分页控件：图片方式
    private var pageDotImage: UIImage?
    // 选中分页控件：图片方式
    private var currentPageDotImage: UIImage?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.collectionView.frame = self.bounds
        self.collectionViewFlowLayout.itemSize = self.frame.size
        self.collectionViewFlowLayout.scrollDirection = self.scrollDirection
        
        if self.pageControl != nil {
            var pSize = CGSize(width: 0, height: 0)
            if self.pageControl!.isKind(of: UIPageControl.self) {
                pSize = CGSize(width: self.pageControlDotSize.width * CGFloat(self.sourceCount), height: self.pageControlDotSize.height)
            }
            else if self.pageControl!.isKind(of: CyclePageControl.self) {
                var tmpW: CGFloat = 0.0
                var tmpH: CGFloat = 0.0
                if self.customDotViewType == .image && self.pageDotImage != nil {
                    tmpW = CGFloat(self.sourceCount) * self.pageDotImage!.size.width + ((self.pageControl as! CyclePageControl).spacingBetweenDots * CGFloat((self.sourceCount - 1)))
                    tmpH = self.pageDotImage!.size.height
                } else {
                    tmpW = CGFloat(self.sourceCount) * self.pageControlDotSize.width + ((self.pageControl as! CyclePageControl).spacingBetweenDots * CGFloat((self.sourceCount - 1)))
                    tmpH = self.pageControlDotSize.height
                }
                pSize = CGSize(width: tmpW, height: tmpH)
            }
            
            var px:CGFloat = 0
            if self.pageControlAligment == .center {
                px = (self.frame.width-pSize.width)/2
            }
            else if self.pageControlAligment == .left {
                px = self.pageControlMargin + 10
            }
            else if self.pageControlAligment == .right {
                px = self.frame.width - pSize.width - (self.pageControlMargin + 10)
            }
            
            let py = self.frame.height - pSize.height - self.pageControlMargin
            let pageControlFrame = CGRect(x: px+self.pageControlInsets.left-self.pageControlInsets.right, y: py+self.pageControlInsets.top-self.pageControlInsets.bottom, width: pSize.width, height: pSize.height)
            self.pageControl?.frame = pageControlFrame
        }
    }
    
    deinit {
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
    }
}

//MARK:  初始化
extension CycleScrollerView {
    /*
     * 类初始化
     * parameter:
     *   - frame: CycleScrollerView尺寸
     * return: self
     */
    @objc open class func cycle(frame:CGRect) -> CycleScrollerView {
        
        let cycleView = CycleScrollerView(frame:frame)
        cycleView.setupUI(localizationImageNameArray: nil, imageUrlStrArray: nil, placeholdImage: nil, viewArray: nil)
        return cycleView
    }
    
    /*
     * 类的初始化
     * parameter:
     *   -imageUrlStrArray:网络图片url地址
     *   -placeholdImage:预加载图片
     *   -frame:CycleScrollerView尺寸
     * return: self
     */
    @objc open class func cycleImage(imageUrlStrArray:[String]?,placeholdImage:UIImage?,frame:CGRect) -> CycleScrollerView {
        let cycleView = CycleScrollerView(frame:frame)
        cycleView.setupUI(localizationImageNameArray: nil, imageUrlStrArray: imageUrlStrArray, placeholdImage: placeholdImage, viewArray: nil)
        return cycleView
    }
    
    
    /*
     * 类的初始化
     * parameter:
     *   -imageUrlStrArray:网络图片url地址
     *   -placeholdImage:预加载图片
     *   -frame:CycleScrollerView尺寸
     * return: self
     */
    @objc open class func cycleImage(localizationImageNameArray:[String]?,frame:CGRect) -> CycleScrollerView {
        let cycleView = CycleScrollerView(frame:frame)
        cycleView.setupUI(localizationImageNameArray: localizationImageNameArray, imageUrlStrArray: nil, placeholdImage: nil, viewArray: nil)
        return cycleView
    }
    
    @objc open class func cycleView(viewArray: [UIView]?, frame: CGRect) -> CycleScrollerView {
        
        let cycleScrollView = CycleScrollerView(frame: frame)
        cycleScrollView.setupUI(localizationImageNameArray: nil, imageUrlStrArray: nil, placeholdImage: nil, viewArray: viewArray)
        return cycleScrollView
    }
    
    /*
     * 私有方法
     */
    private func setupUI(localizationImageNameArray:[String]?,imageUrlStrArray:[String]?,placeholdImage:UIImage?,viewArray:[UIView]?) {
        self.localizationImageNameArray = localizationImageNameArray
        self.imageUrlStrArray = imageUrlStrArray
        self.placeholdImage = placeholdImage
        self.viewArray = viewArray
    }
    
    /*
     * 设置自定义分页控件类型的图片类型，注意：当设置了该图片后即表明：self.pageControlType = .custom && self.customDotViewType = .image
     * Parameters:
     *   - pageDotImage: 未选中分页控件：图片方式
     *   - currentPageDotImage: 选中分页控件：图片方式
     */
    @objc public func setupDotImage(pageDotImage: UIImage, currentPageDotImage: UIImage) {
        
        self.pageDotImage = pageDotImage
        self.currentPageDotImage = currentPageDotImage
        self.customDotViewType = .image
    }
    
}

//MARK: - UICollectionViewDelegate/UICollectionViewDataSource
extension CycleScrollerView {
 
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.totalItemsCount
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.localizationImageNameArray != nil || self.imageUrlStrArray != nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KImageViewCellID, for: indexPath) as! CycleImageViewCell
            cell.setupUI(imageName: (self.localizationImageNameArray != nil) ? self.localizationImageNameArray![(indexPath.row % self.localizationImageNameArray!.count)] : nil, imageUrl: (self.imageUrlStrArray != nil) ? self.imageUrlStrArray![(indexPath.row % self.imageUrlStrArray!.count)] : nil, placeholdImage: self.placeholdImage)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KViewCellID, for: indexPath) as! CycleCell
            cell.addSubview(self.viewArray![(indexPath.row % self.viewArray!.count)])
            return cell
        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.itemDidClickBlock != nil {
            self.itemDidClickBlock!(indexPath.row % self.sourceCount)
        }
    }
}

//MARK: - 滚动相关
extension CycleScrollerView {
    //计时器相关
    public func setupTimer() {
        self.invalidateTime()
        
        if self.autoScroll {
            self.rollTime = Timer.scheduledTimer(timeInterval: self.autoScrollTimeInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
            RunLoop.main.add(self.rollTime!, forMode: .commonModes)
        }
        
    }
    
    public func invalidateTime() {
        if self.rollTime != nil {
            self.rollTime?.invalidate()
            self.rollTime = nil
        }
    }
    
    @objc private func automaticScroll() {
        if self.autoScroll {
            if self.autoScrollTimeInterval == 0 {
                return
            }
            
            var targetIndex = self.currentIndex()+1
            self.scrollToIndex(targetIndex: &targetIndex)
        }
    }
    
    public func scrollToIndex(targetIndex:inout Int) {
        
        if targetIndex >= self.totalItemsCount {
            if self.loopTimes > 0 {
                targetIndex = self.totalItemsCount/2
                self.startScrollToItem(targetIndex: targetIndex, animation: false)
            }
            return
        }
        self.startScrollToItem(targetIndex: targetIndex, animation: true)
    }
    
    private func startScrollToItem(targetIndex:Int,animation:Bool) {
        if self.scrollDirection == .horizontal {
            self.collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .right, animated: animation)
        } else {
            self.collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .bottom, animated: animation)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.sourceCount == 0 || self.pageControl == nil {
            return
        }
        
        let itemIndex = self.currentIndex()
        let indexOnPageControl = self.pageControlIndex(cellIndex: itemIndex)
        if self.pageControl!.isKind(of: UIPageControl.self) {
            (self.pageControl as! UIPageControl).currentPage = indexOnPageControl
        } else {
            (self.pageControl as! CyclePageControl).currentPage = indexOnPageControl
        }
    }
}

//MARK: - 其他
extension CycleScrollerView {
    private func currentIndex() -> Int {
        if self.collectionView.frame.width == 0 || self.collectionView.frame.height == 0 {
            return 0
        }
        
        var index = 0
        if self.collectionViewFlowLayout.scrollDirection == .horizontal {
            index = Int((self.collectionView.contentOffset.x + self.collectionView.bounds.width * 0.5) / self.collectionView.bounds.width)
        } else {
            index = Int((self.collectionView.contentOffset.y + self.collectionView.bounds.height * 0.5) / self.collectionView.bounds.height)
        }
        return max(0, index)
    }
    
    private func setupPageControl() {
        if self.pageControl != nil {
            self.pageControl?.removeFromSuperview()
        }
        
        switch self.pageControlType {
        case .none:
            self.pageControl = nil
            
        case .classic:
            let tmpPageControl = UIPageControl()
            tmpPageControl.numberOfPages = self.sourceCount
            tmpPageControl.currentPageIndicatorTintColor = self.currentPageDotColor
            tmpPageControl.pageIndicatorTintColor = self.pageDotColor
            tmpPageControl.isUserInteractionEnabled = false
            tmpPageControl.currentPage = self.pageControlIndex(cellIndex: self.currentIndex())
            self.addSubview(tmpPageControl)
            self.pageControl = tmpPageControl
            
        case .custom:
            let tmpPageControl = CyclePageControl()
            tmpPageControl.numberOfPages = self.sourceCount
            tmpPageControl.currentPageDotColor = self.currentPageDotColor
            tmpPageControl.pageDotColor = self.pageDotColor
            tmpPageControl.pageControlDotSize = self.pageControlDotSize
            tmpPageControl.currentPage = self.pageControlIndex(cellIndex: self.currentIndex())
            if self.pageDotImage != nil {
                tmpPageControl.pageDotImage = pageDotImage
            }
            if self.currentPageDotImage != nil {
                tmpPageControl.currentPageDotImage = currentPageDotImage
            }
            if self.currentPageDotEnlargeTimes > 0 {
                tmpPageControl.currentPageDotEnlargeTimes = self.currentPageDotEnlargeTimes
            }
            self.addSubview(tmpPageControl)
            
            self.pageControl = tmpPageControl
        }
    }
    
    private func pageControlIndex(cellIndex:Int) -> Int {
        if self.sourceCount > 0 {
            return cellIndex % self.sourceCount
        } else {
            return 0
        }
    }
    
}
