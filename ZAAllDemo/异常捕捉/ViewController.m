//
//  ViewController.m
//  异常捕捉
//
//  Created by  jiangminjie on 2018/7/19.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self onCreateUIForView];
}

- (void)onCreateUIForView
{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(40, 120, 80, 80);
    [bt setTitle:@"生成异常" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(onClickAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
}

- (void)onClickAction
{
    NSArray *array = @[@"1",@"2"];
    NSLog(@"%@",array[3]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
