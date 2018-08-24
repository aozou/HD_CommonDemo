//
//  HWPDFBrowseView.m
//  HWPDFTest
//
//  Created by sxmaps_w on 2017/12/27.
//  Copyright © 2017年 wqb. All rights reserved.
//

#import "HWPDFBrowseView.h"

@implementation HWPDFBrowseView

- (id)initWithFilePath:(NSString *)filePath
{
    pdfDocumentRef = [self createPDFFromExistFile:filePath];
    
    self = [super initWithFrame:CGPDFPageGetBoxRect(CGPDFDocumentGetPage(pdfDocumentRef, 1), kCGPDFMediaBox)];
    
    return self;
}

- (CGPDFDocumentRef)createPDFFromExistFile:(NSString *)aFilePath
{
    CFStringRef path = CFStringCreateWithCString(NULL, [aFilePath UTF8String], kCFStringEncodingUTF8);
    CFURLRef urlRef = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, NO);
    CFRelease(path);
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL(urlRef);
    CFRelease(urlRef);
    _totalPages = CGPDFDocumentGetNumberOfPages(document);
    _currentPage = 1;
    if (_totalPages == 0) return NULL;
    
    return document;
}

- (void)reloadView
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [[UIColor whiteColor] set];
//    CGContextFillRect(context, rect);
//    CGContextTranslateCTM(context, 0.0, rect.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocumentRef, _currentPage);
//    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, rect, 0, true);
//    CGContextConcatCTM(context, pdfTransform);
//    CGContextDrawPDFPage(context, page);
    
    //********************************************
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor]set];
    CGContextFillRect(ctx, rect);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, 0, -rect.size.height);
    
    CGPDFPageRef page = CGPDFDocumentGetPage(pdfDocumentRef, _currentPage);
    CGContextSaveGState(ctx);
    CGAffineTransform transform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, rect, 0, true);
    CGContextConcatCTM(ctx, transform);
    CGContextDrawPDFPage(ctx, page);
    CGContextRestoreGState(ctx);
}

//上一页
- (void)prePage
{
    if(_currentPage < 2) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经第一页了！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil ];
        [alert show];
        return;
    }
    
    --_currentPage;
    [self reloadView];
    [self transitionWithType:@"pageUnCurl" WithSubtype:kCATransitionFromRight ForView:self];
}

//下一页
- (void)nextPage
{
    if(_currentPage >= _totalPages) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经最后一页了！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil ];
        [alert show];
        return;
    }
    
    ++_currentPage;
    [self reloadView];
    [self transitionWithType:@"pageCurl" WithSubtype:kCATransitionFromRight ForView:self];
}

//设置翻页动画效果
- (void)transitionWithType:(NSString *)type WithSubtype:(NSString *)subtype ForView:(UIView *)view
{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.7f;
    animation.type = type;
    if (subtype) animation.subtype = subtype;
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    [view.layer addAnimation:animation forKey:@"animation"];
}

@end
