//
//  ViewController.m
//  代码混淆
//
//  Created by  jiangminjie on 2018/8/21.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showName_one = @"11";
    self.showName_two = @"12";
    _showName_three = @"13";
    self.inputName_one = @"21";
    self.inputName_two = @"22";
    _inputName_three = @"23";
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onShowAction_one
{
    NSLog(@"test show");
}

- (void)onShowAction_two
{
    NSLog(@"test show");
}

- (void)onShowAction_three
{
    NSLog(@"test show");
}

- (void)onInputAction_one
{
    NSLog(@"test show");
}

@end
