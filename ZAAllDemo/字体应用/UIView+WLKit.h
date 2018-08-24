//
//  UIView+WLKit.h
//  NSMutableAttributedStringDemo
//
//  Created by wangguoliang on 16/7/28.
//  Copyright © 2016年 wangguoliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WLKit)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign, readonly) CGFloat maxX;
@property (nonatomic, assign, readonly) CGFloat maxY;
@end
