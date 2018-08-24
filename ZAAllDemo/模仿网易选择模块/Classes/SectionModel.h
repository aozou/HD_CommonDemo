//
//  SectionModel.h
//  CCTagSelection
//
//  Created by YSCC on 2017/6/1.
//  Copyright © 2017年 YSCC. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface SectionModel : NSObject

@property(nonatomic,retain) NSString *title;
@property(nonatomic,retain) NSArray *cells;
@property(nonatomic,retain) NSMutableArray *mutableCells;
@property(nonatomic,retain) NSObject *userInfo;

+(instancetype)sectionWithTitle:(NSString*)title cells:(NSArray*)cells;

@end
