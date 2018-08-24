//
//  MoreTreesModel.m
//  表的应用多层树形结构
//
//  Created by  jiangminjie on 2018/8/23.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "MoreTreesModel.h"

@implementation MoreTreesModel

+ (instancetype)nodeWithParentID:(NSString *)parentID name:(NSString *)name childrenID:(NSString *)childrenID isExpand:(BOOL)bol{
    return [self nodeWithParentID:parentID name:name childrenID:childrenID level:-1 isExpand:bol];
}

+ (instancetype)nodeWithParentID:(NSString*)parentID name:(NSString*)name childrenID:(NSString*)childrenID level:(NSUInteger)level isExpand:(BOOL)bol{
    
    MoreTreesModel *node = [[MoreTreesModel alloc] init];
    node.parentID = parentID;
    node.name = name;
    node.childrenID = childrenID;
    node.level = level;
    node.expand = bol;
    
    return node;
}


@end
