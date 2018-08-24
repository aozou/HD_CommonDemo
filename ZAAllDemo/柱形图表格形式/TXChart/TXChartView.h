//
//  TXChartView.h
//  tableChart
//
//  Created by iOS on 2017/12/26.
//  Copyright © 2017年 htx QQ:419231612. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXChartView : UIView
@property (nonatomic,strong)NSMutableArray *titleSource;
@property (nonatomic,strong)NSMutableArray *valueSource;
@property (nonatomic,strong)UILabel *rightMarkLabel;
- (void)reloadData;
@end
