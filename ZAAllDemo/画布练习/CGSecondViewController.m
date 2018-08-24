//
//  SecondViewController.m
//  画布练习
//
//  Created by  jiangminjie on 2018/1/26.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "CGSecondViewController.h"
#import "AppDelegate.h"
#import "MosaicView.h"

@interface CGSecondViewController () {
    UIImageView         *_bgImgView;
    UIWindow            *_keyWindow;
    MosaicView          *_mosaicImagView;
}

@property (strong, nonatomic)  UIImageView *topImgView;
@property (strong, nonatomic)  UIImageView *bottomImgView;

@end

@implementation CGSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self onCreateUIForView];
    
    [self onCreateUIForData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCreateUIForView
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    CGFloat height = 0;
    if (self.type == coreType_mskPicture) {
        UIImage *image = [UIImage imageNamed:@"003"];
        _mosaicImagView = [[MosaicView alloc] initWithFrame:CGRectMake((size.width-240)/2., 100, 240, 240)];
        _mosaicImagView.surfaceImage = image;
        _mosaicImagView.mosaicImage = [CGSecondViewController mosaicImage:image level:0];
        [self.view addSubview:_mosaicImagView];

        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(0, CGRectGetMaxY(_mosaicImagView.frame), size.width/2.0, 40);
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:saveBtn];
        
        UIButton *recoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        recoverBtn.frame = CGRectMake(size.width/2.0, CGRectGetMinY(saveBtn.frame), size.width/2.0, 40);
        [recoverBtn setTitle:@"复原" forState:UIControlStateNormal];
        [recoverBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [recoverBtn addTarget:self action:@selector(recover) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:recoverBtn];
        
        height = CGRectGetMaxY(recoverBtn.frame);
    } else {
        
        self.topImgView = [[UIImageView alloc]initWithFrame:CGRectMake((size.width-240)/2., 100, 240, 240)];
        self.topImgView.backgroundColor = [UIColor greenColor];
        self.topImgView.userInteractionEnabled = YES;
        self.topImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:self.topImgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBecomeBigAction:)];
        [self.topImgView addGestureRecognizer:tap];
        
        height = CGRectGetMaxY(self.topImgView.frame)+40;
    }

    
    self.bottomImgView = [[UIImageView alloc]initWithFrame:CGRectMake((size.width-240)/2., height, 240, 240)];
    self.bottomImgView.backgroundColor = [UIColor greenColor];
    self.bottomImgView.userInteractionEnabled = YES;
    self.bottomImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.bottomImgView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBecomeBigAction1:)];
    [self.bottomImgView addGestureRecognizer:tap1];
}

- (void)onCreateUIForData
{
    switch (self.type) {
        case coreType_screenshots_all:
        {
            self.title = @"全屏截屏";
            
            UIGraphicsBeginImageContext([UIScreen mainScreen].bounds.size);
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            [[UIApplication sharedApplication].delegate.window.layer renderInContext:ctx];
            
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            self.topImgView.image = img;
            UIGraphicsEndImageContext();
            
            UIGraphicsBeginImageContext(self.view.bounds.size);
            ctx = UIGraphicsGetCurrentContext();
            [self.view.layer renderInContext:ctx];
            UIImage *img1 = UIGraphicsGetImageFromCurrentImageContext();
            self.bottomImgView.image = img1;
            UIGraphicsEndImageContext();
        }
            break;
        case coreType_screenshots_rect:
        {
            self.title = @"指定尺寸截图";
            UIImage *img = [UIImage imageNamed:@"003"];
            self.topImgView.image = img;
            
            CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height/2.);
            
            UIGraphicsBeginImageContext(rect.size);
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGImageRef imgRef = CGImageCreateWithImageInRect(self.topImgView.image.CGImage, rect);
            CGContextScaleCTM(ctx, 1., -1.);
            CGContextTranslateCTM(ctx, 0, -rect.size.height);
            CGContextDrawImage(ctx, rect, imgRef);
            UIImage *imge = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.bottomImgView.image = imge;
        }
            break;
        case coreType_colorCreatePicture:
        {
            self.title = @"颜色生成图片";
            
            self.topImgView.backgroundColor = [UIColor yellowColor];
            
            CGRect rect = CGRectMake(0, 0, 1., 1.);
            UIGraphicsBeginImageContext(rect.size);
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(ctx, self.topImgView.backgroundColor.CGColor);
            CGContextFillRect(ctx, rect);
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.bottomImgView.image = img;
        }
            break;
        case coreType_pictureStretch:
        {
            self.title = @"图片拉伸";
            UIImage *img = [UIImage imageNamed:@"icon_layer"];//20 40
            self.topImgView.image = img;
            
//            img = [img stretchableImageWithLeftCapWidth:5 topCapHeight:5];
            //CGFloat top; // 顶端盖高度 受保护不会变化
            //CGFloat bottom; // 底端盖高度 受保护不会变化
            //CGFloat left; // 左端盖宽度 受保护不会变化
            //CGFloat right; // 右端盖宽度 受保护不会变化
            //UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
            
            
//            img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(60, 10, 10, 20) resizingMode:UIImageResizingModeStretch];
            self.bottomImgView.contentMode = UIViewContentModeScaleToFill;
            self.bottomImgView.image = img;
        }
            break;
        case coreType_mskPicture:
        {
            self.title = @"马赛克图片";
        }
            break;
        case coreType_compression:
        {
            self.title = @"图片压缩不变形";
            
            UIImage *img = [UIImage imageNamed:@"003"];
            self.topImgView.image = img;
            
            self.bottomImgView.frame = CGRectMake(self.bottomImgView.frame.origin.x, self.bottomImgView.frame.origin.y, self.bottomImgView.frame.size.width*3/5., self.bottomImgView.frame.size.height);
            self.bottomImgView.image = [CGSecondViewController compressImage:img fortargetSize:self.bottomImgView.frame.size withIsTop:YES];
        }
            break;
            
        default:
            break;
    }
}

//复原图片
- (void)recover{
    [_mosaicImagView recover];
}
//保存图片
- (void)save{
    UIGraphicsBeginImageContextWithOptions(_mosaicImagView.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_mosaicImagView.layer renderInContext:context];
    UIImage *saveImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _bottomImgView.image = saveImage;
}

- (void)onBecomeBigAction:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView *)tap.view;
        [self onShowViewInWindow:imgView];
    }
}

- (void)onBecomeBigAction1:(UITapGestureRecognizer *)tap
{
    if ([tap.view isKindOfClass:[UIImageView class]]) {
        UIImageView *imgView = (UIImageView *)tap.view;
        [self onShowViewInWindow:imgView];
    }
}

- (void)onShowViewInWindow:(UIImageView *)imgView
{
    if (!_keyWindow) {
        _keyWindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _keyWindow.backgroundColor = [UIColor whiteColor];
        [_keyWindow makeKeyAndVisible];
    }
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _bgImgView.userInteractionEnabled = YES;
        _bgImgView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onRemoveAction:)];
        [_bgImgView addGestureRecognizer:tap1];
    }
    _bgImgView.image = imgView.image;
    [_keyWindow addSubview:_bgImgView];
    
    CGRect rect = [self.view convertRect:imgView.frame toView:_keyWindow];
    _bgImgView.frame = rect;
    [UIView animateWithDuration:2.35 animations:^{
        _bgImgView.frame = _keyWindow.bounds;
    }];
}

- (void)onRemoveAction:(UITapGestureRecognizer *)tap
{
    NSMutableArray *windows = [UIApplication sharedApplication].windows.mutableCopy;
    [windows removeObject:_keyWindow];
    [_bgImgView removeFromSuperview];
    _keyWindow = nil;
    [windows enumerateObjectsUsingBlock:^(UIWindow *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIWindow class]]) {
            [obj makeKeyAndVisible];
        }
    }];
}

/**图片马赛克*/
+ (UIImage *)mosaicImage:(UIImage *)image level:(NSInteger)level{
    
    if(!image){
        return nil;
    }
    
    CGImageRef imageRef = image.CGImage;
    NSUInteger imageW = CGImageGetWidth(imageRef);
    NSUInteger imageH = CGImageGetHeight(imageRef);
    //创建颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char *)calloc(imageH*imageW*4, sizeof(unsigned char));
    CGContextRef contextRef = CGBitmapContextCreate(rawData, imageW, imageH, 8, imageW*4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, imageW, imageH), imageRef);
    
    unsigned char *bitMapData = CGBitmapContextGetData(contextRef);
    NSUInteger currentIndex,preCurrentIndex;
    NSUInteger sizeLevel = level == 0 ? MIN(imageW, imageH)/20.0 : level;
    //像素点默认是4个通道
    unsigned char *pixels[4] = {0};
    for (int i = 0; i < imageH; i++) {
        for (int j = 0; j < imageW; j++) {
            currentIndex = imageW*i + j;
            NSUInteger red = rawData[currentIndex*4];
            NSUInteger green = rawData[currentIndex*4+1];
            NSUInteger blue = rawData[currentIndex*4+2];
            NSUInteger alpha = rawData[currentIndex*4+3];
            if (red+green+blue == 0 && (alpha/255.0 <= 0.5)) {
                rawData[currentIndex*4] = 255;
                rawData[currentIndex*4+1] = 255;
                rawData[currentIndex*4+2] = 255;
                rawData[currentIndex*4+3] = 0;
                continue;
            }
            /*
             memcpy指的是c和c++使用的内存拷贝函数，memcpy函数的功能是从源src所指的内存地址的起始位置开始拷贝n个字节到目标dest所指的内存地址的起始位置中。
             strcpy和memcpy主要有以下3方面的区别。
             1、复制的内容不同。strcpy只能复制字符串，而memcpy可以复制任意内容，例如字符数组、整型、结构体、类等。
             2、复制的方法不同。strcpy不需要指定长度，它遇到被复制字符的串结束符"\0"才结束，所以容易溢出。memcpy则是根据其第3个参数决定复制的长度。
             3、用途不同。通常在复制字符串时用strcpy，而需要复制其他类型数据时则一般用memcpy
             */
            if (i % sizeLevel == 0) {
                if (j % sizeLevel == 0) {
                    memcpy(pixels, bitMapData+4*currentIndex, 4);
                }else{
                    //将上一个像素点的值赋给第二个
                    memcpy(bitMapData+4*currentIndex, pixels, 4);
                }
            }else{
                preCurrentIndex = (i-1)*imageW+j;
                memcpy(bitMapData+4*currentIndex, bitMapData+4*preCurrentIndex, 4);
            }
        }
    }
    //获取图片数据集合
    NSUInteger size = imageW*imageH*4;
    CGDataProviderRef providerRef = CGDataProviderCreateWithData(NULL, bitMapData, size, NULL);
    //创建马赛克图片，根据变换过的bitMapData像素来创建图片
    CGImageRef mosaicImageRef = CGImageCreate(imageW, imageH, 8, 4*8, imageW*4, colorSpace, kCGBitmapByteOrderDefault, providerRef, NULL, NO, kCGRenderingIntentDefault);//Creates a bitmap image from data supplied by a data provider.
    //创建输出马赛克图片
    CGContextRef outContextRef = CGBitmapContextCreate(bitMapData, imageW, imageH, 8, imageW*4, colorSpace, kCGImageAlphaPremultipliedLast);
    //绘制图片
    CGContextDrawImage(outContextRef, CGRectMake(0, 0, imageW, imageH), mosaicImageRef);
    
    CGImageRef resultImageRef = CGBitmapContextCreateImage(contextRef);
    UIImage *mosaicImage = [UIImage imageWithCGImage:resultImageRef];
    //释放内存
    CGImageRelease(resultImageRef);
    CGImageRelease(mosaicImageRef);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(providerRef);
    CGContextRelease(outContextRef);
    return mosaicImage;
}

/**
 *图片压缩不变形
 *isTop YES:填充 不压缩尺寸截图 NO:居中 按比例压缩
 */
+ (UIImage*)compressImage:(UIImage*)image fortargetSize:(CGSize)targetSize withIsTop:(BOOL)isTop
{
    if(!image){
        return nil;
    }
    
    //图片原尺寸
    CGFloat imgWidth = image.size.width;
    CGFloat imgHeight = image.size.height;
    //目标尺寸
    CGFloat imageWidth = targetSize.width;
    CGFloat imageHeight = targetSize.height;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    CGFloat newWidth = 0;
    CGFloat newHeight = 0;
    float chats = MIN(imgWidth/imgHeight*1.00, imageWidth/imageHeight*1.00);
    if (imgWidth/imgHeight*1.00 == chats) {
        //目标宽度较长 填充模式:已宽度为标准 居中模式:已高度为标准
        newWidth = isTop ? imgWidth : imgHeight*imageWidth/imageHeight;
        newHeight = isTop ? imgWidth*imageHeight/imageWidth: imgHeight;
    }else{
        //目标高度较长 填充模式:已高度为标准 居中模式:已宽度为标准
        newHeight = isTop ? imgHeight : imgWidth/chats;
        newWidth = isTop ? imgHeight*chats : imgWidth;
    }

    
    thumbnailPoint = isTop ? CGPointMake((imgWidth-newWidth)/2.,(imgHeight-newHeight)/2.) : CGPointMake(0,0);
//    thumbnailPoint = CGPointMake(0, 0);
    
    UIGraphicsBeginImageContext(targetSize);//开始剪切
    CGRect thumbnailRect = CGRectZero;//剪切起点(0,0)
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = newWidth;
    thumbnailRect.size.height = newHeight;
//    [image drawInRect:thumbnailRect];
    CGImageRef imgRef = CGImageCreateWithImageInRect(image.CGImage, thumbnailRect);
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();//截图拿到图片
    UIImage *newImage = [UIImage imageWithCGImage:imgRef];
    return newImage;
}

@end
