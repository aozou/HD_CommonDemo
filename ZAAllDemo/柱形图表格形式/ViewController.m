//
//  ViewController.m
//  柱形图表格形式
//
//  Created by  jiangminjie on 2018/1/25.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "ViewController.h"
#import "TXChartView.h"

@interface ViewController ()
@property (nonatomic,strong)TXChartView *chart;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setView];//添加视图
    [self setData];//添加数据源
}
- (void)setView{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat top = [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.chart = [[TXChartView alloc]initWithFrame:CGRectMake(0, top, w, 500)];
    [self.view addSubview:self.chart];
}
- (void)setData{
    self.chart.titleSource = [NSMutableArray arrayWithArray:@[@"Pate",@"Any",@"Marry",@"Audo",@"Rudy",@"Pate",@"Any",@"Marry",@"Audo",@"Rudy",@"Pate",@"Any",@"Marry",@"Audo",@"Rudy"]];
    self.chart.valueSource = [NSMutableArray arrayWithArray:@[@"10",@"30",@"33",@"15",@"25",@"10",@"30",@"33",@"15",@"25",@"10",@"30",@"33",@"15",@"25"]];
    [self.chart reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
