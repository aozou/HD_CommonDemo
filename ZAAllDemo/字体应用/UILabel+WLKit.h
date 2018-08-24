//
//  UILabel+WLKit.h
//  NSMutableAttributedStringDemo
//
//  Created by wangguoliang on 16/7/27.
//  Copyright © 2016年 wangguoliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (WLKit)
/**
 *  快速创建UILabel
 *
 *  @param frame     UILabel的坐标
 *  @param text      UILabel的内容
 *  @param font      UILabel的字体
 *  @param textColor UILabel的颜色
 *  @param alignment UILabel的对齐方式
 *
 *  @return UILabel
 */
+ (instancetype)labelWithFrame:(CGRect)frame
                          text:(NSString *)text
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
                     alignment:(NSTextAlignment)alignment;

@end
