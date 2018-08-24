//
//  CCTagSelectController.m
//  CCTagSelection
//
//  Created by YSCC on 2017/6/1.
//  Copyright © 2017年 YSCC. All rights reserved.
//

#import "CCTagSelectController.h"
#import "CCTagCollectionLayout.h"
#import "CCTagSelectSectionHeaderView.h"
#import "Masonry.h"
#import "SectionModel.h"
#import "CCTagModel.h"
#import "MJExtension.h"
#import "Definition.h"

NSString *const kLabelSelectionCellIdentifier = @"kLabelSelectionCellIdentifier";
NSString *const kLabelSelectionHeaderIdentifier = @"kLabelSelectionHeaderIdentifier";

@interface CCTagSelectController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property(nonatomic,strong) UIVisualEffectView *effectView;

@property(nonatomic,strong) UICollectionView *collectionView;
@property(nonatomic,retain) NSMutableArray *dataArray;
//@property(nonatomic, strong) UIButton *rightBtn;

@property(nonatomic, assign)BOOL isExist;

@end

@implementation CCTagSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeComponent];
    
}

+(void)modalInViewContrller:(UIViewController *)vc{
    [self modalInViewContrller:vc completion:nil];
}

+(void)modalInViewContrller:(UIViewController *)vc completion: (callBack )completion{
    
    CCTagSelectController *labelVC = [CCTagSelectController new];
    labelVC.callBack = completion;
    labelVC.view.backgroundColor = [UIColor colorWithPatternImage:[labelVC captureWith: vc.view]];
    [vc presentViewController:labelVC animated:NO completion:nil];
    
}

- (UIImage *)captureWith: (UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


-(void)initializeComponent
{
    self.title = @"编辑频道";
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.effectView.frame = self.view.bounds;
    self.effectView.userInteractionEnabled = YES;
    [self.view addSubview:self.effectView];
    
    _dataArray = [NSMutableArray array];
    [self loaderData];
    
    CCTagCollectionLayout *layout = [[CCTagCollectionLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 8;//列
    layout.minimumLineSpacing = 10;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(cancelEidtTag) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"main_closeTag"] forState:UIControlStateNormal];
    [self.view addSubview:btn];

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero  collectionViewLayout:layout];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kLabelSelectionCellIdentifier];
    [_collectionView registerClass:[CCTagSelectSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLabelSelectionHeaderIdentifier];
    [self.view addSubview:_collectionView];
    
    UIButton *okBtn = [UIButton new];
    okBtn.backgroundColor = [UIColor clearColor];
    [okBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setTitle:@"完成" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage imageNamed:@"main_overTagEdit"] forState:UIControlStateNormal];
    [okBtn sizeToFit];
    [self.view addSubview:okBtn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerY.equalTo(titleLb.mas_centerY);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top).offset(30);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(self.view.mas_top).offset(130);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_bottom).offset(-85);
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)cancelEidtTag{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)loaderData{
    
    //创建空的组模型;选中的标签
    SectionModel *section0 = [[SectionModel alloc] init];
    section0.userInfo = [NSNumber numberWithInteger:0];//选中的标签
    section0.title = @"我的频道";
    section0.mutableCells = [NSMutableArray array];
    
    //全部标签
    SectionModel *section1 = [[SectionModel alloc] init];
    section1.userInfo = [NSNumber numberWithInteger:1];//全部标签
    section1.title = @"推荐频道";
    section1.mutableCells = [NSMutableArray array];
    
    [_dataArray addObject:section0];
    [_dataArray addObject:section1];
    

    NSArray *tags = @[@{@"id" : @"1", @"title" : @"头条", @"isSelect": @"1"},
                       @{@"id" : @"2", @"title" : @"专题", @"isSelect": @"1"},
                       @{@"id" : @"3", @"title" : @"当代艺术", @"isSelect": @"0"},
                       @{@"id" : @"4", @"title" : @"书画", @"isSelect": @"0"},
                       @{@"id" : @"5", @"title" : @"摄影", @"isSelect": @"0"},
                       @{@"id" : @"6", @"title" : @"人物", @"isSelect": @"0"},
    
                      ];
    
    NSArray *tagModels = [CCTagModel mj_objectArrayWithKeyValuesArray:tags];

    for (CCTagModel *model in tagModels) {
        
        if (model.isSelect) {
            [section0.mutableCells addObject:model];
        }else{
            [section1.mutableCells addObject:model];
        }
    }
    [self.collectionView reloadData];

}

#pragma -mark collectionView delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dataArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    SectionModel *s = _dataArray[section];
    return s.mutableCells.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SectionModel *s = _dataArray[indexPath.section];
    NSMutableArray *array = s.mutableCells;
    CCTagModel *tagModel = array[indexPath.row];
    if(!tagModel.title)
    {
        return CGSizeMake(1, 1);
    }
    
    CGFloat width = [tagModel.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}].width;
    if(width > CGRectGetWidth(collectionView.frame) / 2)
    {
        width = CGRectGetWidth(collectionView.frame) / 2;
    }
    return CGSizeMake(width + 36, 28);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(WIDTH, 85);
    return size;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CCTagSelectSectionHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kLabelSelectionHeaderIdentifier forIndexPath:indexPath];
    SectionModel *s = _dataArray[indexPath.section];
    
    UILabel *titleLabel = view.titleLabel;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = s.title;
    return view;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLabelSelectionCellIdentifier forIndexPath:indexPath];
    UIView *backgroundView = cell.backgroundView;
    if(!backgroundView)
    {
        UILabel *ltView = [[UILabel alloc] initWithFrame:cell.bounds];
        ltView.layer.masksToBounds = YES;
        
        ltView.layer.borderWidth = 0.5;
        backgroundView = ltView;
        cell.backgroundView = backgroundView;
    }
    SectionModel *s = _dataArray[indexPath.section];
    NSMutableArray *array = s.mutableCells;
    CCTagModel *tagModel = array[indexPath.row];
    
    UILabel *titleView = (UILabel*)backgroundView;
    titleView.frame = cell.bounds;
    titleView.font = [UIFont systemFontOfSize:15];
    titleView.text = tagModel.title;
    titleView.layer.cornerRadius = 3;
    titleView.textAlignment = NSTextAlignmentCenter;
    
    titleView.textColor = [UIColor blackColor];
    titleView.layer.borderColor = [UIColor blackColor].CGColor;
    titleView.backgroundColor = [UIColor clearColor];

    if ([tagModel.id isEqualToNumber:@1]) {
        titleView.textColor = [UIColor whiteColor];
        titleView.layer.borderColor = [UIColor clearColor].CGColor;
        titleView.backgroundColor = [UIColor blackColor];
    }

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SectionModel *sectionModel = _dataArray[indexPath.section];
    NSMutableArray *array = sectionModel.mutableCells;
    CCTagModel *tagModel = array[indexPath.row];
    
    if ([tagModel.id isEqualToNumber:@1]) {
        return;
    }
    
    if([sectionModel.userInfo isEqual:[NSNumber numberWithInteger:0]])
    {
        
        if(tagModel.id && tagModel.title)
        {
            SectionModel *s;
            NSIndexPath *targetIndexPath;
            
            s = _dataArray[1];
            targetIndexPath = [NSIndexPath indexPathForRow:s.mutableCells.count inSection:1];            [s.mutableCells addObject:tagModel];
            [array removeObjectAtIndex:indexPath.row];
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPath];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
            });
        }
    }
    else
    {
        SectionModel *s0 = _dataArray[0];
        [s0.mutableCells insertObject:tagModel atIndex:s0.mutableCells.count];
        [array removeObjectAtIndex:indexPath.row];
        NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:s0.mutableCells.count-1 inSection:0];
        [collectionView moveItemAtIndexPath:indexPath toIndexPath:targetIndexPath];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_collectionView reloadData];
        });
//        dis
    }
}



#pragma -mark Publish
-(void)publish
{
    
    NSArray *tagArray;
    if (_callBack) {
        _callBack(tagArray);
    }
    
    [self cancelEidtTag];
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
