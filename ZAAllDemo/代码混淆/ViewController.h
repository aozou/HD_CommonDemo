//
//  ViewController.h
//  代码混淆
//
//  Created by  jiangminjie on 2018/8/21.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    NSString    *_showName_three;
    NSString    *_inputName_three;
}

@property (nonatomic,strong)NSString *showName_one;
@property (nonatomic,strong)NSString *showName_two;
@property (nonatomic,strong)NSString *inputName_one;
@property (nonatomic,strong)NSString *inputName_two;

- (void)onShowAction_two;


@end

