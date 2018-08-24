//
//  HWPDFBrowseView.h
//  HWPDFTest
//
//  Created by sxmaps_w on 2017/12/27.
//  Copyright © 2017年 wqb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWPDFBrowseView : UIView{
    CGPDFDocumentRef pdfDocumentRef;
}

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;

- (id)initWithFilePath:(NSString *)filePath;
- (void)reloadView;
- (void)prePage;
- (void)nextPage;

@end

