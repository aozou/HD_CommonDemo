//
//  SecondViewController.m
//  异常捕捉
//
//  Created by  jiangminjie on 2018/7/19.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    NSString *string = @"123";
    NSLog(@"%@",[string substringFromIndex:4]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
