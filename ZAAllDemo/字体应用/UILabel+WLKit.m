//
//  UILabel+WLKit.m
//  NSMutableAttributedStringDemo
//
//  Created by wangguoliang on 16/7/27.
//  Copyright © 2016年 wangguoliang. All rights reserved.
//

#import "UILabel+WLKit.h"

@implementation UILabel (WLKit)

+ (instancetype)labelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor alignment:(NSTextAlignment)alignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (font) {
        [label setFont:font];
    }
    if (text && text.length) {
        [label setText:text];
    }
    [label setBackgroundColor:[UIColor clearColor]];
    if (textColor) {
        [label setTextColor:textColor];
    }
    if (alignment) {
        [label setTextAlignment:alignment];
    }
    return label;
}

@end
