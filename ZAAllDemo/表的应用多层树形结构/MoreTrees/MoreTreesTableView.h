//
//  MoreTreesTableView.h
//  表的应用多层树形结构
//
//  Created by  jiangminjie on 2018/8/23.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreTreesModel.h"

typedef void(^MTSelectBlock)(MoreTreesModel *model);

@interface MoreTreesTableView : UITableView

- (id)initWithFrame:(CGRect)frame nodes:(NSArray*)nodes rootNodeID:(NSString*)rootID needPreservation:(BOOL)need selectBlock:(MTSelectBlock)block;

@end
