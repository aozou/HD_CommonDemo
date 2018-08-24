//
//  ViewController.m
//  画布练习
//
//  Created by  jiangminjie on 2018/1/26.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "CGViewController.h"
#import "CGSecondViewController.h"

@interface CGViewController ()

@end

@implementation CGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//截屏
- (IBAction)onBt1Action:(id)sender {
    CGSecondViewController *ctrl = [[CGSecondViewController alloc]init];
    ctrl.type = coreType_screenshots_all;
    [self.navigationController pushViewController:ctrl animated:YES];
}
//指定尺寸截图
- (IBAction)onBt2Action:(id)sender {
    CGSecondViewController *ctrl = [[CGSecondViewController alloc]init];
    ctrl.type = coreType_screenshots_rect;
    [self.navigationController pushViewController:ctrl animated:YES];
}

//颜色生成图片
- (IBAction)onBt3Action:(id)sender {
    CGSecondViewController *ctrl = [[CGSecondViewController alloc]init];
    ctrl.type = coreType_colorCreatePicture;
    [self.navigationController pushViewController:ctrl animated:YES];
}
//图片拉伸
- (IBAction)onBt4Action:(id)sender {
    CGSecondViewController *ctrl = [[CGSecondViewController alloc]init];
    ctrl.type = coreType_pictureStretch;
    [self.navigationController pushViewController:ctrl animated:YES];
}
//马赛克图片
- (IBAction)onBt5Action:(id)sender {
    CGSecondViewController *ctrl = [[CGSecondViewController alloc]init];
    ctrl.type = coreType_mskPicture;
    [self.navigationController pushViewController:ctrl animated:YES];
}
//压缩图片不变形
- (IBAction)onBt6Actiion:(id)sender {
    CGSecondViewController *ctrl = [[CGSecondViewController alloc]init];
    ctrl.type = coreType_compression;
    [self.navigationController pushViewController:ctrl animated:YES];
}

@end
