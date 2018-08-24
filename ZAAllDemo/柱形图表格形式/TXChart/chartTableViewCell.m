//
//  chartTableViewCell.m
//  tableChart
//
//  Created by iOS on 2017/12/26.
//  Copyright © 2017年 htx QQ:419231612. All rights reserved.
//

#import "chartTableViewCell.h"
#import "UIColor+get_FFFFFFcolor.h"

@interface chartTableViewCell ()
@property (nonatomic,strong)UILabel *lineLabel;
@end

@implementation chartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
//初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.chartLabel];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.lineLabel];
        [self.contentView addSubview:self.valueLabel];
        [self layout];
    }
    return self;
}
//柱子
- (UILabel *)chartLabel{
    if (!_chartLabel) {
        self.chartLabel = [UILabel new];
        self.chartLabel.backgroundColor = [UIColor colorWithHexString:@"667ECD"];
        self.chartLabel.textAlignment = NSTextAlignmentRight;
        self.chartLabel.font = [UIFont systemFontOfSize:10];
        self.chartLabel.textColor = [UIColor whiteColor];
    }
    return _chartLabel;
}
//标题
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        self.titleLabel = [UILabel new];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}
//标注的值
- (UILabel *)valueLabel{
    if (!_valueLabel) {
        self.valueLabel = [UILabel new];
        self.valueLabel.textColor = [UIColor colorWithHexString:@"999999"];
        self.valueLabel.font = [UIFont systemFontOfSize:10];
    }
    return _valueLabel;
}

//左边的线
- (UILabel *)lineLabel {
    if (!_lineLabel) {
        self.lineLabel = [UILabel new];
        self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"666666"];
    }
    return _lineLabel;
}
//布局
- (void)layout {
    self.titleLabel.sd_layout.topSpaceToView(self.contentView, 0).leftSpaceToView(self.contentView, 5).bottomSpaceToView(self.contentView, 0).widthIs(50);
    
    self.lineLabel.sd_layout.topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0).widthIs(1).leftSpaceToView(self.titleLabel, 0);
    
    self.chartLabel.sd_layout.leftSpaceToView(self.lineLabel, 0).topSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 10);
    
    self.valueLabel.sd_layout.leftSpaceToView(self.chartLabel, 3).topSpaceToView(self.contentView, 10).bottomSpaceToView(self.contentView, 10).rightSpaceToView(self.contentView, 0);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
