//
//  SectionModel.m
//  CCTagSelection
//
//  Created by YSCC on 2017/6/1.
//  Copyright © 2017年 YSCC. All rights reserved.
//

#import "SectionModel.h"

@implementation SectionModel

+(instancetype)sectionWithTitle:(NSString *)title cells:(NSArray *)cells
{
    SectionModel *section = [[SectionModel alloc] init];
    section.title = title;
    section.cells = cells;
    return section;
}

@end
