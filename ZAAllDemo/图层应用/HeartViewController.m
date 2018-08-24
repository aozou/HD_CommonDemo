//
//  HeartViewController.m
//  图层应用
//
//  Created by  jiangminjie on 2018/1/25.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "HeartViewController.h"
#import "heartView.h"

@interface HeartViewController ()
@property (weak, nonatomic) IBOutlet heartView *hearV;

@end

@implementation HeartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    {
        self.hearV.backgroundColor = [UIColor clearColor];
        [self.hearV animate:YES];
    }
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
