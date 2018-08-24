//
//  ViewController.m
//  dragView
//
//  Created by  jiangminjie on 2017/9/1.
//  Copyright © 2017年 SeaHot. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    UICollectionView            *_collectionView;
    NSMutableArray              *_mutArr;
    NSMutableArray              *_pathArr;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mutArr = [[NSMutableArray alloc]initWithObjects:@"湖北",@"河南",@"河北",@"湖南",@"广东",@"广西",@"天津",@"北京",@"南京",@"东京",@"护肩",@"户外",@"大爷",@"钟馗", nil];
    _pathArr= [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
    [self onCreateUI];
}

- (void)onCreateUI
{
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((size.width-5*20)/4., 36);
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 0, 20);
    flowLayout.scrollDirection= UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height) collectionViewLayout:flowLayout];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    _collectionView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:.55];
    [self.view addSubview:_collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _mutArr.count;
    
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *view = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    UILabel *title =[[UILabel alloc]initWithFrame:view.bounds];
    title.text = [_mutArr objectAtIndex:indexPath.row];
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor lightGrayColor];
    [view.contentView addSubview:title];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onGesture:)];
    [view addGestureRecognizer:longGesture];
    
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择的:%d",indexPath.row);
}

- (void)onGesture:(UILongPressGestureRecognizer *)gesture
{
    CGPoint localPoint = [gesture locationInView:_collectionView];
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:localPoint];
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
//    NSLog(@"选中的第%d个图片",indexPath.row);
    static UIView *snaptView = nil;
    static NSIndexPath *selectIndex =nil;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            snaptView =[self onGetView:cell];
            [_collectionView addSubview:snaptView];
            selectIndex = indexPath;
            
            cell.alpha = 1.;
            
            [UIView animateWithDuration:.35 animations:^{
                cell.alpha = .17;
                snaptView.center  = localPoint;
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (cell) {
                if (_pathArr.count >= 2) {
                    [_pathArr removeObjectAtIndex:0];
                }
                [_pathArr addObject:indexPath];
                
                if (![indexPath isEqual:selectIndex]) {
                    UICollectionViewCell *selectCell = [_collectionView cellForItemAtIndexPath:selectIndex];
                    selectCell.alpha = 1.;
                    cell.alpha =.17;
                    [_mutArr exchangeObjectAtIndex:selectIndex.row withObjectAtIndex:indexPath.row];
                    [_collectionView moveItemAtIndexPath:selectIndex toIndexPath:indexPath];
                    selectIndex =indexPath;
                }
                
                [UIView animateWithDuration:.35 animations:^{
                    snaptView.center  = localPoint;
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [_pathArr removeAllObjects];
            cell.alpha = 1;
            [_collectionView moveItemAtIndexPath:selectIndex toIndexPath:indexPath];
            [snaptView removeFromSuperview];
            snaptView = nil;
        }
            break;
            
        default:
            break;
    }
    
}

-(UIView *)onGetView:(UIView *)bgView
{
    UIGraphicsBeginImageContext(bgView.frame.size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    [bgView.layer renderInContext:ref];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndPDFContext();
    
    UIImageView *view= [[UIImageView alloc]initWithFrame:bgView.frame];
    view.image =img;
    return view;
}

@end

