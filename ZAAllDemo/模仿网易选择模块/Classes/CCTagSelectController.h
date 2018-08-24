//
//  CCTagSelectController.h
//  CCTagSelection
//
//  Created by YSCC on 2017/6/1.
//  Copyright © 2017年 YSCC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^callBack)(NSArray *array);

@interface CCTagSelectController : UIViewController

+(void)modalInViewContrller:(UIViewController *)vc completion: (callBack )completion;

@property(nonatomic, copy)callBack callBack;

@end
