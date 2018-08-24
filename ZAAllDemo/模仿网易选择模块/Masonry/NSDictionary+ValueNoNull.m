//
//  NSDictionary+ValueNoNull.m
//  RenRenZhuan
//
//  Created by wutan on 15/9/21.
//  Copyright © 2015年 leAppSoft. All rights reserved.
//

#import "NSDictionary+ValueNoNull.h"

@implementation NSDictionary (ValueNoNull)

-(NSString *)getStringValueForKey:(id)key
{
    NSString *str;
    id value = [self objectForKey:key];
    if(value == nil || [value isEqual:[NSNull null]])
    {
        str = @"";
    }
    if([value isKindOfClass:[NSString class]])
    {
        str = value;
    }
    else
    {
        str = @"";
    }
    return str;
}

-(NSInteger)getIntegerValueForKey:(id)key
{
    NSInteger v = 0;
    id value = [self objectForKey:key];
    if(value != nil && ![value isEqual:[NSNull null]] && [value isKindOfClass:[NSNumber class]])
    {
        v = [value integerValue];
    }
    return v;
}

-(double)getDoubleValueForKey:(id)key
{
    double v = 0.0;
    id value = [self objectForKey:key];
    if(value != nil && ![value isEqual:[NSNull null]] && [value isKindOfClass:[NSNumber class]])
    {
        v = [value doubleValue];
    }
    return v;
}

-(float)getFloatValueForKey:(id)key
{
    float v = 0.0f;
    id value = [self objectForKey:key];
    if(value != nil && ![value isEqual:[NSNull null]] && [value isKindOfClass:[NSNumber class]])
    {
        v = [value floatValue];
    }
    return v;
}

-(NSArray *)getArrayValueForKey:(id)key
{
    NSArray *array;
    id value = [self objectForKey:key];
    if(value != nil && ![value isEqual:[NSNull null]] && [value isKindOfClass:[NSArray class]])
    {
        array = value;
    }
    else
    {
        array = @[];
    }
    return array;
}

-(NSDictionary *)getDictionaryValueForKey:(id)key
{
    NSDictionary *dict;
    id value = [self objectForKey:key];
    if(value != nil && ![value isEqual:[NSNull null]] && [value isKindOfClass:[NSDictionary class]])
    {
        dict = value;
    }
    else
    {
        value = @{};
    }
    return dict;
}

-(NSNumber*)getNumberValueForKey:(id)key
{
    NSNumber *number;
    id value = [self objectForKey:key];
    if(value != nil && ![value isEqual:[NSNull null]] && [value isKindOfClass:[NSNumber class]])
    {
        number = value;
    }
    else
    {
        number = @0;
    }
    return number;
}

@end
