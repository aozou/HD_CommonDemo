//
//  main.m
//  异常捕捉
//
//  Created by  jiangminjie on 2018/7/19.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @try {
        @autoreleasepool {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
    } @catch (NSException *exception) {
        NSLog(@"");
    }
}
