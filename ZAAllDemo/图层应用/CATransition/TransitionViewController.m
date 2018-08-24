//
//  TransitionViewController.m
//  图层应用
//
//  Created by  jiangminjie on 2018/1/25.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "TransitionViewController.h"

@interface TransitionViewController ()

@property (nonatomic,retain) UILabel * label ;
@property (nonatomic,retain) NSArray * data ;
@property (nonatomic,assign) NSInteger index ;
@property (nonatomic,retain) UIButton * scrButton ;

@end

@implementation TransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 0 ;
    // Do any additional setup after loading the view, typically from a nib.
    self.data = @[@"从前有座山",@"山里有座庙",@"庙里住着一个老和尚和小和尚",@"有一个天老和尚给小和尚讲故事:"];
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 30)];
    
    self.scrButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.scrButton.frame = CGRectMake(0, 200, self.view.frame.size.width, 30) ;
    [self.scrButton setTitle:self.data[0] forState:UIControlStateNormal];
    [self.view addSubview:self.scrButton];
    [self.scrButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    self.scrButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.label];
    self.label.text = self.data[0];
    self.label.textColor = [UIColor redColor];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scroll) userInfo:nil repeats:YES];
    
    UIButton *pushBt = [UIButton buttonWithType:UIButtonTypeCustom];
    pushBt.frame = CGRectMake(100, 300, 80, 30);
    [pushBt setTitle:@"跳转" forState:0];
    [pushBt setTitleColor:[UIColor blackColor] forState:0];
    [pushBt addTarget:self action:@selector(onPushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushBt];
}

- (void)onPushAction
{
    TransitionViewController *ctrl = [[TransitionViewController alloc]init];
    
    //1.初始化
    CATransition  *transition = [CATransition animation];
    //2.设置动画时长,设置代理人
    transition.duration = 1.0f;
    transition.delegate = self;
    //3.设置切换速度效果
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    /*枚举值:
     kCAMediaTimingFunctionLinear
     kCAMediaTimingFunctionEaseIn
     kCAMediaTimingFunctionEaseOut
     kCAMediaTimingFunctionEaseInEaseOut
     kCAMediaTimingFunctionDefault
     */
    //4.动画切换风格
    transition.type = kCATransitionFade;
    /*枚举值:
     kCATransitionFade = 1,     // 淡入淡出
     kCATransitionPush,         // 推进效果
     kCATransitionReveal,       // 揭开效果
     kCATransitionMoveIn,       // 慢慢进入并覆盖效果
     */
    //5.动画切换方向
    transition.subtype = kCATransitionFromTop;//顶部
    /*枚举值:
     kCATransitionFromRight//右侧
     kCATransitionFromLeft//左侧
     kCATransitionFromTop//顶部
     kCATransitionFromBottom//底部
     */
    //6.进行跳转
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:ctrl animated:NO];
    //跳转动画一定设置为NO,不然会两个效果叠加
}

-(void)scroll{
    
    _index += 1;
    if (_index == self.data.count) {
        _index = 0;
    }
    
    
    CATransition *tran = [CATransition animation];
    tran.type = kCATransitionPush;
    tran.subtype = kCATransitionFromTop;
    [self.scrButton.layer addAnimation:tran forKey:@"trans"];
    
    
    CATransition * transition =[CATransition animation];
    [transition setDuration:0.3f];
    transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    transition.type = @"cube";
    transition.subtype =kCATransitionFromTop ;
    [self.label.layer addAnimation:transition forKey:nil];
    
    
    NSInteger idx = _index;
    self.label.text =self.data[idx];
    [self.scrButton setTitle:self.data[idx] forState:UIControlStateNormal];
    
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
