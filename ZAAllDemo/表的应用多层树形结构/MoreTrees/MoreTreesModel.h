//
//  MoreTreesModel.h
//  表的应用多层树形结构
//
//  Created by  jiangminjie on 2018/8/23.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreTreesModel : NSObject

/*
 * @objc parentID 父类ID
 */
@property (nonatomic, strong) NSString *parentID;

/*
 * @objc childrenID 子类ID
 */
@property (nonatomic, strong) NSString *childrenID;

/*
 * @objc name 当前模型名称
 */
@property (nonatomic, strong) NSString *name;

/*
 * @objc expand 是否支持展开,显示子类
 */
@property (nonatomic, assign, getter=isExpand) BOOL expand;

/*
 * @objc level 层次级别
 */
@property (nonatomic, assign) NSUInteger level;// depth in the tree sturct

/*
 * @objc leaf 是否还有子类
 */
@property (nonatomic, assign, getter=isLeaf) BOOL leaf;

/*
 * @objc root 是否是基类
 */
@property (nonatomic, assign, getter=isRoot) BOOL root;

/**
 *  初始化节点
 *
 *  @param parentID     父类ID
 *  @param name         当前模型名称
 *  @param childrenID   子类ID
 *  @param level        层次级别
 *  @param bol          是否支持展开,显示子类
 */
+ (instancetype)nodeWithParentID:(NSString*)parentID name:(NSString*)name childrenID:(NSString*)childrenID level:(NSUInteger)level isExpand:(BOOL)bol;

+ (instancetype)nodeWithParentID:(NSString*)parentID name:(NSString*)name childrenID:(NSString*)childrenID isExpand:(BOOL)bol;

@end
