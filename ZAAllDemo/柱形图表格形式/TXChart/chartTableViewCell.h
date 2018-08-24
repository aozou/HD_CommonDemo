//
//  chartTableViewCell.h
//  tableChart
//
//  Created by iOS on 2017/12/26.
//  Copyright © 2017年 htx QQ:419231612. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDAutoLayout.h"
@interface chartTableViewCell : UITableViewCell
/** 值 */
@property (nonatomic,strong)UILabel *valueLabel;
/** 柱子 */
@property (nonatomic,strong)UILabel *chartLabel;
/** 标题 */
@property (nonatomic,strong)UILabel *titleLabel;
@end
