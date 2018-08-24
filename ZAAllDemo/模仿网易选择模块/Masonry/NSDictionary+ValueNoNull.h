//
//  NSDictionary+ValueNoNull.h
//  RenRenZhuan
//
//  Created by wutan on 15/9/21.
//  Copyright © 2015年 leAppSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ValueNoNull)

/**
 获取String类型value，如果value为空返回@""
 */
-(nonnull NSString*)getStringValueForKey:(nonnull id)key;

/**
 获取Integer类型value，如果value为空返回0
 */
-(NSInteger)getIntegerValueForKey:(nonnull id)key;

/**
 获取double类型value，如果value为空返回0.0
 */
-(double)getDoubleValueForKey:(nonnull id)key;

/**
 获取float类型value，如果value为空返回0.0
 */
-(float)getFloatValueForKey:(nonnull id)key;

/**
 获取array类型value，如果value为空返回@[]
 */
-(nonnull NSArray*)getArrayValueForKey:(nonnull id)key;

/**
 获取dictionary类型value，日过value为空返回@{}
 */
-(nonnull NSDictionary*)getDictionaryValueForKey:(nonnull id)key;

-(nonnull NSNumber*)getNumberValueForKey:(nonnull id)key;

@end
