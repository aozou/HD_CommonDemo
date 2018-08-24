//
//  ViewController.m
//  ViewControllerTransition
//
//  Created by chavez on 2017/6/27.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "ViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"

#import "CWScrollView.h"

#import "UIViewController+CWLateralSlide.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *datadSource;

@property (nonatomic,weak)CWScrollView * contentScrollView;

@end

@implementation ViewController

- (NSMutableArray *)datadSource {
    if (_datadSource == nil) {
        _datadSource = [NSMutableArray arrayWithArray:@[@"仿QQ左侧划出",@"仿QQ右侧划出",@"左侧划出并缩小",@"右侧划出并缩小",@"遮盖在上面从左侧划出",@"遮盖在上面从右侧划出"]];
    }
    return _datadSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabBarController.view.backgroundColor = [UIColor whiteColor];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self setupNavBarItem];
    
    [self setupScrollView];
    
    // 注册手势驱动
    __weak typeof(self)weakSelf = self;
    [self cw_registerShowIntractiveWithEdgeGesture:NO direction:CWDrawerTransitionDirectionLeft transitionBlock:^{
        [weakSelf leftClick];
    }];
    
}


- (void)setupNavBarItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(leftClick)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(rightClick)];
}

- (void)setupScrollView {
    CGFloat navigationHeight = self.navigationController.navigationBar.bounds.size.height;
    CGFloat tabbarHeight = self.tabBarController.tabBar.bounds.size.height;
    CWScrollView * contentScrollView = [[CWScrollView alloc] init];
    contentScrollView.backgroundColor = [UIColor greenColor];
    contentScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - navigationHeight - tabbarHeight);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.bounces = NO;
    contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * 3, 0);
    [self.view addSubview:contentScrollView];
    _contentScrollView = contentScrollView;
    _contentScrollView.delegate = self;
//    _contentScrollView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < 3; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_contentScrollView.bounds) * i, 0, CGRectGetWidth(_contentScrollView.bounds), CGRectGetHeight(_contentScrollView.bounds)) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [_contentScrollView addSubview:tableView];
    }
}


// 导航栏左边按钮的点击事件
- (void)leftClick {
    // 自己随心所欲创建的一个控制器
    LeftViewController *vc = [[LeftViewController alloc] init];
    // 调用这个方法
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeDefault configuration:nil];

}

- (void)rightClick {
    
    RightViewController *vc = [[RightViewController alloc] init];
    
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0.8 direction:CWDrawerTransitionDirectionRight backImage:[UIImage imageNamed:@"0.jpg"]];
    
    [self cw_showDrawerViewController:vc animationType:0 configuration:conf];

}

- (void)drawerDefaultAnimationleftScaleY {
    RightViewController *vc = [[RightViewController alloc] init];
    
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0.8 direction:CWDrawerTransitionDirectionLeft backImage:[UIImage imageNamed:@"0.jpg"]];
    
    [self cw_showDrawerViewController:vc animationType:0 configuration:conf];
}

- (void)drawerDefaultAnimationRight{
    LeftViewController *vc = [[LeftViewController alloc] init];
    
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0 direction:CWDrawerTransitionDirectionRight backImage:nil];
    
    [self cw_showDrawerViewController:vc animationType:0 configuration:conf];
}


- (void)drawerMaskAnimationLeft{
    
    LeftViewController *vc = [[LeftViewController alloc] init];
    // 调用这个方法
    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeMask configuration:nil];
}

- (void)drawerMaskAnimationRight{
    
    LeftViewController *vc = [[LeftViewController alloc] init];
    
    CWLateralSlideConfiguration *conf = [CWLateralSlideConfiguration configurationWithDistance:0 maskAlpha:0.4 scaleY:0 direction:CWDrawerTransitionDirectionRight backImage:nil];

    [self cw_showDrawerViewController:vc animationType:CWDrawerAnimationTypeMask configuration:conf];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datadSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = self.datadSource[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.imageView.image = [UIImage imageNamed:@"header.jpg"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self leftClick];
            break;
        case 1:
            [self drawerDefaultAnimationRight];
            break;
        case 2:
            [self drawerDefaultAnimationleftScaleY];
            break;
        case 3:
            [self rightClick];
            break;
        case 4:
            [self drawerMaskAnimationLeft];
            break;
        case 5:
            [self drawerMaskAnimationRight];
        default:
            break;
    }
}

@end
