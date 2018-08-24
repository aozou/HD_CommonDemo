//
//  CCTagCollectionLayout.m
//  CCTagSelection
//
//  Created by YSCC on 2017/6/1.
//  Copyright © 2017年 YSCC. All rights reserved.
//

#import "CCTagCollectionLayout.h"
#import "Definition.h"

@implementation CCTagCollectionLayout


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [[NSMutableArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect]];
    
    CGRect frame;
    
    CGFloat currentY = 0.0f;
    //    NSInteger curCount;
    CGFloat currentWith = 0.0f;
    NSMutableArray *currentAttributes = [NSMutableArray array];
    
    for (UICollectionViewLayoutAttributes *attribute in attributes) {
        
        if (attribute.representedElementKind == UICollectionElementKindSectionHeader) {
            continue;
        }
        
        frame = attribute.frame;
        
        if (currentY == 0) {
            currentY = frame.origin.y;
        }
        
        if (currentY ==  frame.origin.y) {
            [currentAttributes addObject:attribute];
            currentWith += frame.size.width;
        }
        
        if (frame.origin.y > currentY) {//当前行结束
            
            [self refreshCurrentAttributes:currentAttributes currentWith:currentWith];
            [currentAttributes removeAllObjects];//清空数组
            [currentAttributes addObject:attribute];
            currentWith = frame.size.width;
            currentY = frame.origin.y;
            
            if ([attribute isEqual:attributes[attributes.count-3]]) {//最后一个直接算当前行
                [self refreshCurrentAttributes:currentAttributes currentWith:currentWith];
            }
            
        }else{
            
            if ([attribute isEqual:attributes[attributes.count-3]]) {//最后一个直接算当前行
                [self refreshCurrentAttributes:currentAttributes currentWith:currentWith];
            }
        }
    }
    
    return attributes;
}

-(void)refreshCurrentAttributes: (NSMutableArray *)attris currentWith: (CGFloat)currentWidth{
    
    CGFloat curLineMinX = (WIDTH-30-currentWidth-self.minimumInteritemSpacing*(attris.count-1))*0.5;
    
    for (UICollectionViewLayoutAttributes *obj in attris) {
        CGRect f = obj.frame;
        f.origin.x  = curLineMinX;
        obj.frame = f;
        curLineMinX = curLineMinX+obj.frame.size.width+self.minimumInteritemSpacing;
    }
}


@end
