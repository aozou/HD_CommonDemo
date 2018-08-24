//
//  GradientViewController.m
//  图层应用
//
//  Created by  jiangminjie on 2018/1/25.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "GradientViewController.h"
#import "gradientView.h"

@interface GradientViewController ()

@end

@implementation GradientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [[UIApplication sharedApplication]statusBarFrame];
    // Do any additional setup after loading the view.
    gradientView *lab1 = [[gradientView alloc]init];
    lab1.frame = CGRectMake(0, CGRectGetMaxY(rect)+50, self.view.frame.size.width, 25);
    lab1.text = @"默认样式，默认样式，默认样式，默认样式，默认样式，默认样式，默认样式，默认样式，默认样式，默认样式，默认样式，默认样式，默认样式，";
    [self.view addSubview:lab1];
    
//    gradientView *lab2 = [[gradientView alloc]init];
//    lab2.frame = CGRectMake(0, 90, self.view.frame.size.width, 25);
//    lab2.textColor = [UIColor clearColor];
//    lab2.DurationTime = 6;
//    lab2.direction = gradientViewDirectionToLeft;
//    lab2.text = @"反向，背景透明，反向，背景透明，反向，背景透明，反向，背景透明，反向，背景透明，反向，背景透明，反向，背景透明，反向，背景透明，反向，背景透明，反向，背景透明，";
//    [self.view addSubview:lab2];
//
//    gradientView *lab3 = [[gradientView alloc]init];
//    lab3.frame = CGRectMake(0, 130, self.view.frame.size.width, 25);
//    lab3.textColor = [UIColor colorWithRed:0.250 green:0.693 blue:0.998 alpha:1.000];
//    lab3.lightColor = [UIColor redColor];
//    lab3.DurationTime = 1;
//    lab3.LightWidth = 80;
//    lab3.text = @"改颜色，改速度，改光束宽度，改颜色，改速度，改光束宽度，改颜色，改速度，改光束宽度，改颜色，改速度，改光束宽度，改颜色，改速度，改光束宽度，改颜色，改速度，改光束宽度，改颜色，改速度，改光束宽度，";
//    [self.view addSubview:lab3];
//
//
//    gradientView *lab4 = [[gradientView alloc]init];
//    lab4.frame = CGRectMake(0, 170, self.view.frame.size.width, 100);
//    lab4.numberOfLines = 0;
//    lab4.direction = gradientViewDirectionToUp;
//    lab4.textAlignment = NSTextAlignmentCenter;
//    lab4.text = @"向上，向上，向上，向上，向上，向上，\n向上，向上，向上，向上，向上，向上，\n向上，向上，向上，向上，向上，向上，\n向上，向上，向上，向上，向上，向上，\n向上，向上，向上，向上，向上，向上，";
//    [self.view addSubview:lab4];
//
//
//    gradientView *lab5 = [[gradientView alloc]init];
//    lab5.frame = CGRectMake(0, 290, self.view.frame.size.width, 100);
//    lab5.numberOfLines = 0;
//    lab5.direction = gradientViewDirectionToDown;
//    lab5.textAlignment = NSTextAlignmentCenter;
//    lab5.text = @"向下，向下，向下，向下，向下，向下，\n向下，向下，向下，向下，向下，向下，\n向下，向下，向下，向下，向下，向下，\n向下，向下，向下，向下，向下，向下，\n向下，向下，向下，向下，向下，向下，";
//    [self.view addSubview:lab5];
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
