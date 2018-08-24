//
//  SecondViewController.h
//  画布练习
//
//  Created by  jiangminjie on 2018/1/26.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,coreType) {
    coreType_screenshots_all = 0,//截屏
    coreType_screenshots_rect ,//截图
    coreType_colorCreatePicture,//颜色生成图片
    coreType_pictureStretch, //图片拉伸
    coreType_mskPicture,//马赛克图片
    coreType_compression,//压缩图片不变形
};

@interface CGSecondViewController : UIViewController

@property (nonatomic,assign)coreType type;

@end
