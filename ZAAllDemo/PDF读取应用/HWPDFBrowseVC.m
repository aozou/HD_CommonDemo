//
//  HWPDFBrowseVC.m
//  HWPDFTest
//
//  Created by sxmaps_w on 2017/12/27.
//  Copyright © 2017年 wqb. All rights reserved.
//

#import "HWPDFBrowseVC.h"
#import "HWPDFBrowseView.h"
#import "HWPDFBrowseToolBar.h"
#import "HWPDFBrowseScrollView.h"

#define KPicMaxScale 3.0
#define KMainW [UIScreen mainScreen].bounds.size.width
#define KMainH [UIScreen mainScreen].bounds.size.height

@interface HWPDFBrowseVC ()<UIScrollViewDelegate, HWPDFBroeseToolBarDelegate>

@property (nonatomic, weak) HWPDFBrowseScrollView *scrollView;
@property (nonatomic, weak) HWPDFBrowseView *browseView;
@property (nonatomic, weak) HWPDFBrowseToolBar *toolBar;
@property (nonatomic, assign) CGFloat minZoomScale;
@property (nonatomic, assign) CGFloat lastScrContX;

@end

@implementation HWPDFBrowseVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _fileName;
    
    //创建控件
    [self creatControl];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //防止隐藏导航时，左滑返回导航消失
    CGRect temNavBarFrame = self.navigationController.navigationBar.frame;
    temNavBarFrame.origin.y = 20;
    self.navigationController.navigationBar.frame = temNavBarFrame;
}

- (void)creatControl
{
    //导航右侧按钮
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(9, 0, 40, 40)];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [deleteBtn setTitle:@"跳页" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(navBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightView addSubview:deleteBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    //scrollView
    HWPDFBrowseScrollView *scrollView = [[HWPDFBrowseScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.maximumZoomScale = KPicMaxScale;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    //pdf视图
    HWPDFBrowseView *browseView = [[HWPDFBrowseView alloc] initWithFilePath:_filePath];
    [scrollView addSubview:browseView];
    _browseView = browseView;
    
    //绘制pdf视图后缩放至屏幕完全居中显示
    CGRect frame = browseView.frame;
    frame.size.width = browseView.frame.size.width > KMainW ? KMainW : browseView.frame.size.width;
    frame.size.height = frame.size.width * (browseView.frame.size.height / browseView.frame.size.width);
    if (frame.size.height > KMainH) {
        frame.size.height = KMainH;
        frame.size.width = KMainH * (browseView.frame.size.width / browseView.frame.size.height);
    }
    
    //根据缩放调整
    _minZoomScale = frame.size.width / browseView.frame.size.width;
    scrollView.allowScrollScale = _minZoomScale;
    scrollView.minimumZoomScale = _minZoomScale;
    scrollView.zoomScale = _minZoomScale;
    
    //底部工具栏
    HWPDFBrowseToolBar *toolBar = [[HWPDFBrowseToolBar alloc] initWithFrame:CGRectMake(0, KMainH - 49, KMainW, 49) currentPage:_browseView.currentPage totalPage:_browseView.totalPages];
    toolBar.delegate = self;
    [self.view addSubview:toolBar];
    _toolBar = toolBar;
    
    //单击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [scrollView addGestureRecognizer:tap];
    
    //双击
    UITapGestureRecognizer *tapDouble = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick)];
    tapDouble.numberOfTapsRequired = 2;
    [scrollView addGestureRecognizer:tapDouble];
    [tap requireGestureRecognizerToFail:tapDouble];
    
    //右滑手势
    UISwipeGestureRecognizer *rightSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextPage)];
    rightSwip.direction = UISwipeGestureRecognizerDirectionLeft;
    [scrollView addGestureRecognizer:rightSwip];
    
    //左滑手势
    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(forwardPage)];
    leftSwip.direction = UISwipeGestureRecognizerDirectionRight;
    [scrollView addGestureRecognizer:leftSwip];
}

- (void)navBtnOnClick
{
    [_toolBar showWindow];
}

//单击屏幕显示隐藏菜单
- (void)click
{
    CGFloat navBarY = _toolBar.frame.origin.y == KMainH - 49 ?  -64 : 20;
    CGFloat toolBarY = _toolBar.frame.origin.y == KMainH - 49 ?  KMainH : KMainH - 49;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect temNavBarFrame = self.navigationController.navigationBar.frame;
        temNavBarFrame.origin.y = navBarY;
        self.navigationController.navigationBar.frame = temNavBarFrame;
        CGRect temToolBarFrame = _toolBar.frame;
        temToolBarFrame.origin.y = toolBarY;
        _toolBar.frame = temToolBarFrame;
    }];
}

//双击屏幕放大缩小图片
- (void)doubleClick
{
    [UIView animateWithDuration:0.25f animations:^{
        _scrollView.zoomScale = _scrollView.zoomScale == _minZoomScale ? KPicMaxScale : _minZoomScale;
    }];
}

//左滑事件
- (void)nextPage
{
    [_browseView nextPage];
    _toolBar.currentPage = _browseView.currentPage;
}

//右滑事件
- (void)forwardPage
{
    [_browseView prePage];
    _toolBar.currentPage = _browseView.currentPage;
}

#pragma mark - UICouseBrowseToolBarDelegate
- (void)browseToolBar:(HWPDFBrowseToolBar *)browseToolBar didClickFinishButtonWithPage:(NSString *)page
{
    _browseView.currentPage = [page integerValue];
    [_browseView reloadView];
    [_toolBar dismissKeyboard];
    _scrollView.zoomScale = _minZoomScale;
}

- (void)browseToolBar:(HWPDFBrowseToolBar *)browseToolBar didPageButtonWithAction:(BOOL)nextPage
{
    if (nextPage) {
        [self nextPage];
    }else {
        [self forwardPage];
    }
    _scrollView.zoomScale = _minZoomScale;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _browseView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY - 64);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _browseView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isZooming) return;
    
    //允许翻页的偏移量
    CGFloat movePadding = 70.f;
    
    //仿苹果原生相册，图片放大后，滑动前在边界时在可以翻页，这里加了±10的偏移量
    if (scrollView.contentOffset.x < - movePadding && _lastScrContX < 10) {
        _scrollView.zoomScale = _minZoomScale;
        [self forwardPage];
    }
    
    if (scrollView.contentSize.width - scrollView.contentOffset.x < KMainW - movePadding && scrollView.contentSize.width != 0 && fabsf(_lastScrContX + KMainW - scrollView.contentSize.width) < 10) {
        _scrollView.zoomScale = _minZoomScale;
        [self nextPage];
    }
}

//滑动自然停止时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _lastScrContX = scrollView.contentOffset.x;
}

//滑动手动停止时调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _lastScrContX = scrollView.contentOffset.x;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
