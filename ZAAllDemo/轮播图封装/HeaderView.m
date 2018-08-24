//
//  HeaderView.m
//  lunbo
//
//  Created by  jiangminjie on 2017/8/31.
//  Copyright © 2017年 SeaHot. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()<UIScrollViewDelegate> {
    NSMutableArray          *_mutArr;
    UIScrollView            *_mainScrollView;
    UIPageControl           *_pageCtrl;
    NSUInteger              currentPage;
    
    NSTimer                 *_timer;
    
}

@end
@implementation HeaderView

-(instancetype)initWithFrame:(CGRect)frame withData:(NSArray *)imgArr
{
    self = [super initWithFrame:frame];
    if (self) {
        _mutArr = [[NSMutableArray alloc]initWithArray:imgArr];
        [_mutArr insertObject:[imgArr lastObject] atIndex:0];
        [_mutArr addObject:[imgArr firstObject]];
        
        [self onCreateUI];
    }
    return self;
}

- (void)onCreateUI
{
    _mainScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width*_mutArr.count, 0);
    _mainScrollView.delegate = self;
    [_mainScrollView setContentOffset:CGPointMake(_mainScrollView.frame.size.width, 0) animated:YES];
    [self addSubview:_mainScrollView];
    
    for (int i=0; i<_mutArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(_mainScrollView.frame.size.width*i, 0, _mainScrollView.frame.size.width, _mainScrollView.frame.size.height)];
        imgView.image = [UIImage imageNamed:[_mutArr objectAtIndex:i]];
        [_mainScrollView addSubview:imgView];
    }
    
    _pageCtrl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxX(_mainScrollView.frame), _mainScrollView.frame.size.width, 20)];
    _pageCtrl.backgroundColor = [UIColor orangeColor];
    _pageCtrl.numberOfPages = _mutArr.count-2;
    _pageCtrl.currentPage = 0;
    [self addSubview:_pageCtrl];
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onChangePic) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)onChangePic
{
    NSInteger pageNum =  _pageCtrl.currentPage;
    CGRect rect = CGRectMake((pageNum + 2) * _mainScrollView.frame.size.width, 0, _mainScrollView.frame.size.width, _mainScrollView.frame.size.height);
    [_mainScrollView setContentOffset:rect.origin animated:YES];
    pageNum++;
    if (pageNum == _mutArr.count - 2) {
        [_mainScrollView setContentOffset:CGPointMake(0, 0)];
    }
}

#pragma mark - UIScrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = floor((scrollView.contentOffset.x)/scrollView.frame.size.width);
    NSLog(@"当前page:%d",page);
    currentPage = page;
    
    _pageCtrl.currentPage = page-1;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (currentPage == 0) {
        [scrollView setContentOffset:CGPointMake(_mainScrollView.frame.size.width*([_mutArr count]-2), 0) animated:NO];
    }
    else if (currentPage == _mutArr.count-1) {
        [scrollView setContentOffset:CGPointMake(_mainScrollView.frame.size.width, 0) animated:NO];
    }
}

@end
