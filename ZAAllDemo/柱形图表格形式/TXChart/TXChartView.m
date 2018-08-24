//
//  TXChartView.m
//  tableChart
//
//  Created by iOS on 2017/12/26.
//  Copyright © 2017年 htx QQ:419231612. All rights reserved.
//

#import "TXChartView.h"
#import "chartTableViewCell.h"
#import "SDAutoLayout.h"
#import "UIColor+get_FFFFFFcolor.h"

#define YLabel_TOP 8 //组件间隙高度
#define YRightMarkHeight 20 //右标注高度

#define YLabel_Height 20 //Y轴label高度

#define YLeft 55
#define YRight 20

#define YCount 8 //Y隔断数量
@interface TXChartView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel *lineYLabel;

@end
@implementation TXChartView
{
    /** Y轴刻度LABEL */
    CGFloat YLabelTop;
    /** tab Width */
    CGFloat widthChart;
    /** tab Height */
    CGFloat heightChart;
    /** value MAX */
    CGFloat maxValue;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        YLabelTop = YLabel_TOP + YRightMarkHeight + YLabel_TOP;
        widthChart = frame.size.width;
        heightChart = frame.size.height - YLabelTop - YLabel_Height + 3;
        [self config];
        [self setView];
    }
    return self;
}
- (void)config{
    self.backgroundColor = [UIColor whiteColor];
}
- (void)setView{
    [self rightMake];
    [self creatHead];
    [self gridding];
    [self creatTableView];
    [self subLayout];
}
- (void)rightMake{
    [self addSubview:self.rightMarkLabel];
}
- (void)creatHead {
    [self addSubview:self.lineYLabel];
}
- (void)gridding{
    for (float i = 1;i < YCount + 1; i++) {
        UIView *gridView = [UIView new];
        gridView.backgroundColor = [UIColor colorWithHexString:@"D5D5D5"];
        gridView.tag = 300+i;
        [self addSubview:gridView];
        CGFloat gridHeight = 3 + self.valueSource.count*50;
        gridView.sd_layout
        .topSpaceToView(self, YLabel_Height + YLabelTop - 3)
        .widthIs(0.5)
        .heightIs(gridHeight>heightChart?heightChart:gridHeight)
        .leftSpaceToView(self, YLeft+(widthChart - YLeft - YRight)*(i/(YCount + 0.5)));
        UILabel *yLabel = [UILabel new];
        yLabel.textColor = [UIColor colorWithHexString:@"333333"];
        yLabel.font = [UIFont systemFontOfSize:10.f];
        yLabel.tag = 200+i;
        yLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:yLabel];
        yLabel.sd_layout
        .topSpaceToView(self, YLabelTop)
        .centerXEqualToView(gridView)
        .widthIs(40)
        .heightIs(YLabel_Height);
    }
}
- (void)subLayout{
    self.rightMarkLabel.sd_layout
    .topSpaceToView(self, YLabel_TOP)
    .leftSpaceToView(self, 20)
    .rightSpaceToView(self, YRight)
    .heightIs(YRightMarkHeight);
    
    self.lineYLabel.sd_layout
    .topSpaceToView(self, YLabel_Height + YLabelTop)
    .leftSpaceToView(self, YLeft)
    .rightSpaceToView(self, YRight)
    .heightIs(1);
    
    self.tableView.sd_layout
    .topSpaceToView(self.lineYLabel, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .bottomSpaceToView(self, 0);
}
- (void)reloadData{
    maxValue = [self maxValueForCharDataModels];
    [self.tableView reloadData];
    for (int i = 1; i < YCount+1; i++) {
        UILabel *label = [self viewWithTag:200+i];
        UIView *gridV = [self viewWithTag:300+i];
        label.text = [NSString stringWithFormat:@"%d",(int)((maxValue/YCount)*i)];
        CGFloat gridHeight = 3 + self.valueSource.count*50;
        NSLog(@"%f",gridHeight>heightChart?heightChart:gridHeight);
        gridV.sd_layout.heightIs(gridHeight>heightChart?heightChart:gridHeight);
    }
}
/** 返回数组中的最大值 */
- (int)maxValueForCharDataModels {
    CGFloat max = [[self.valueSource valueForKeyPath:@"@max.floatValue"] floatValue]*1.1;
    int value = (int)max;
    
    return value+(YCount-value%YCount);
}
- (UILabel *)rightMarkLabel{
    if (!_rightMarkLabel) {
        self.rightMarkLabel = [UILabel new];
        self.rightMarkLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.rightMarkLabel.font = [UIFont systemFontOfSize:12];
        self.rightMarkLabel.textAlignment = NSTextAlignmentRight;
        self.rightMarkLabel.text = @"上课节数";
    }
    return _rightMarkLabel;
}
- (UILabel *)lineYLabel{
    if (!_lineYLabel) {
        self.lineYLabel = [UILabel new];
        self.lineYLabel.backgroundColor = [UIColor colorWithHexString:@"666666"];
    }
    return _lineYLabel;
}
- (void)creatTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 375, 667 - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.bounces = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[chartTableViewCell class] forCellReuseIdentifier:@"chartTableViewCell"];
    //qu line
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self addSubview:self.tableView];
}
#pragma mark **** UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.valueSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    chartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chartTableViewCell" forIndexPath:indexPath];
    CGFloat w = ( widthChart - YLeft - 1 - YRight)*(YCount/(YCount+0.5))*([self.valueSource[indexPath.row] floatValue]/maxValue);
    cell.valueLabel.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        cell.chartLabel.sd_layout.widthIs(w);
        cell.valueLabel.alpha = 1;
    }];
    cell.titleLabel.text = _titleSource[indexPath.row];
    cell.valueLabel.text = [NSString stringWithFormat:@"%@节",_valueSource[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark **** UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat f = scrollView.contentOffset.y;
    if (f<0) {
        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    }
}
- (NSMutableArray *)titleSource{
    if (!_titleSource) {
        self.titleSource = [NSMutableArray arrayWithCapacity:1];
    }
    return _titleSource;
}

- (NSMutableArray *)valueSource{
    if (!_valueSource) {
        self.valueSource = [NSMutableArray arrayWithCapacity:1];
    }
    return _valueSource;
}
@end
