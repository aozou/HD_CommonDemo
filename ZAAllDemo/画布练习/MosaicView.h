//
//  MosaicView.h
//  LWTImageManager
//
//  Created by liaowentao on 17/10/13.
//  Copyright © 2017年 LWT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MosaicView : UIView
/** masoicImage(放在底层) */
@property (nonatomic, strong) UIImage *mosaicImage;
/** surfaceImage(放在顶层) */
@property (nonatomic, strong) UIImage *surfaceImage;
/** 恢复 */
- (void)recover;
@end
