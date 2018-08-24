//
//  ViewController.m
//  毛玻璃效果
//
//  Created by  jiangminjie on 2018/1/29.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "ViewController.h"
#import <Accelerate/Accelerate.h>

@interface ViewController () {
    UIImageView             *_zoomImgView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self onCreateUI];
}

- (void)onCreateUI
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 100, size.width/2.0, 40);
//    [saveBtn setTitle:@"原生" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"icon_appointment_Bg"] forState:0];
    [saveBtn addTarget:self action:@selector(onBt1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
}

- (void)onBt1Action:(UIButton *)sender
{
    UIImageView *img = sender.imageView;
    NSLog(@"img:%@",img);
    
    _zoomImgView = [[UIImageView alloc]initWithFrame:[img convertRect:img.frame toView:[UIApplication sharedApplication].keyWindow]];
    _zoomImgView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:.46];
    [[UIApplication sharedApplication].keyWindow addSubview:_zoomImgView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_zoomImgView];
    _zoomImgView.contentMode = UIViewContentModeScaleAspectFit;
    _zoomImgView.image = [self blurryImage:img.image withBlurLevel:.15];//img.image;
    _zoomImgView.alpha = .4;
    [UIView animateWithDuration:.35 animations:^{
        _zoomImgView.frame = [UIApplication sharedApplication].keyWindow.bounds;
        _zoomImgView.alpha = 1.;
    } completion:^(BOOL finished) {
        //        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        //        visualEffectView.frame = _zoomImgView.frame;
        //        visualEffectView.alpha = 1.;
        //        [[UIApplication sharedApplication].keyWindow addSubview:visualEffectView];
        
    }];
}

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }//判断曝光度
    int boxSize = (int)(blur * 100);//放大100，就是小数点之后两位有效
    boxSize = boxSize - (boxSize % 2) + 1;//如果是偶数，+1，变奇数
    
    CGImageRef img = image.CGImage;//获取图片指针
    
    vImage_Buffer inBuffer, outBuffer;//获取缓冲区
    vImage_Error error;//一个错误类，在后调用画图函数的时候要用
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);//放回一个图片供应者信息
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);//拷贝数据，并转化
    
    inBuffer.width = CGImageGetWidth(img);//放回位图的宽度
    inBuffer.height = CGImageGetHeight(img);//放回位图的高度
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);//放回位图的
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);//填写图片信息
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));//创建一个空间
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,//这个数一定要是奇数的，因此我们一开始的时候需要转化
                                       boxSize,//这个数一定要是奇数的，因此我们一开始的时候需要转化
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //将刚刚得出的数据，画出来。
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
