//
//  HWPDFBrowseToolBar.m
//  HWPDFTest
//
//  Created by sxmaps_w on 2017/12/27.
//  Copyright © 2017年 wqb. All rights reserved.
//

#import "HWPDFBrowseToolBar.h"

@interface HWPDFBrowseToolBar ()

@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, weak) UIView *toolBar;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) NSInteger totalPage;

@end

@implementation HWPDFBrowseToolBar

- (instancetype)initWithFrame:(CGRect)frame currentPage:(NSInteger)currentPage totalPage:(NSInteger)totalPage
{
    if (self = [super initWithFrame:frame]) {
        _totalPage = totalPage;
        self.backgroundColor = [UIColor grayColor];
        
        //页码标签
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.text = [NSString stringWithFormat:@"%ld/%ld", currentPage, totalPage];
        label.font = [UIFont systemFontOfSize:15.f];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _label = label;
        
        //上一页、下一页按钮
        CGFloat btnW = 79.f;
        NSArray *titleArray = @[@"上一页", @"下一页"];
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *pageBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width - btnW) * i, 0, btnW, self.bounds.size.height)];
            [pageBtn setTitle:titleArray[i] forState:UIControlStateNormal];
            [pageBtn addTarget:self action:@selector(pageBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:pageBtn];
        }
        
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (void)showWindow
{
    //显示窗口
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor clearColor];
    _window.windowLevel = UIWindowLevelAlert;
    [_window makeKeyAndVisible];
    
    //遮盖视图
    UIView *cover = [[UIView alloc] initWithFrame:_window.bounds];
    cover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer)]];
    [_window addSubview:cover];
    
    //键盘工具条
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 49)];
    toolBar.backgroundColor = [UIColor whiteColor];
    [_window addSubview:toolBar];
    _toolBar = toolBar;
    
    //取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 49)];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:cancelBtn];
    
    //完成按钮
    UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 0, 60, 49)];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [finishBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(finishBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:finishBtn];
    
    //输入框
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 120) * 0.5, 0, 120, 49)];
    UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 49)];
    leftView.text = @"第";
    leftView.font = [UIFont systemFontOfSize:16.f];
    leftView.textAlignment = NSTextAlignmentCenter;
    textfield.leftView = leftView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    UILabel *rightView = [[UILabel alloc] initWithFrame:CGRectMake(textfield.bounds.size.width - 20, 0, 20, 49)];
    rightView.text = @"页";
    rightView.font = [UIFont systemFontOfSize:16.f];
    rightView.textAlignment = NSTextAlignmentCenter;
    textfield.rightView = rightView;
    textfield.rightViewMode = UITextFieldViewModeAlways;
    textfield.textAlignment = NSTextAlignmentCenter;
    textfield.font = [UIFont systemFontOfSize:16.f];
    textfield.returnKeyType = UIReturnKeyDone;
    textfield.keyboardType = UIKeyboardTypeNumberPad;
    textfield.inputAccessoryView = [[UIView alloc] initWithFrame:CGRectZero];
    [textfield addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [textfield addTarget:self action:@selector(done) forControlEvents:UIControlEventEditingDidEndOnExit];
    [toolBar addSubview:textfield];
    [textfield becomeFirstResponder];
    _textField = textfield;
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    
    _label.text = [NSString stringWithFormat:@"%ld/%ld", currentPage, _totalPage];
}

- (void)cancelBtnOnClick
{
    [self dismissKeyboard];
}

- (void)finishBtnOnClick
{
    [self done];
}

- (void)pageBtnOnClick:(UIButton *)pageBtn
{
    if (_delegate && [_delegate respondsToSelector:@selector(browseToolBar:didPageButtonWithAction:)]) {
        [_delegate browseToolBar:self didPageButtonWithAction:[pageBtn.titleLabel.text isEqualToString:@"下一页"]];
    }
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    [UIView animateWithDuration:0.25f animations:^ {
        CGRect frame = _toolBar.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - keyboardRect.size.height - 49;
        _toolBar.frame = frame;
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self dismissWindow];
}

- (void)textFieldEditingChanged:(UITextField *)textField
{
    int length = (int)log10(_totalPage) + 1;
    
    if (textField.text.length > length) {
        textField.text = [textField.text substringToIndex:length];
        return;
    }
}

- (BOOL)isEditing
{
    return _textField.isFirstResponder;
}

- (void)done
{
    if ([_textField.text isEqualToString:@""]) {
        [self dismissKeyboard];
    }else if ([self isAllNumber:_textField.text] && [_textField.text integerValue] <= _totalPage && [_textField.text integerValue] != 0) {
        _label.text = [NSString stringWithFormat:@"%ld/%ld", [_textField.text integerValue], _totalPage];
        if (_delegate && [_delegate respondsToSelector:@selector(browseToolBar:didClickFinishButtonWithPage:)]) {
            [_delegate browseToolBar:self didClickFinishButtonWithPage:_textField.text];
        }
    }else {
        NSLog(@"页码错误，请重新输入~");
        _textField.text = @"";
    }
}

//验证是否是纯数字
- (BOOL)isAllNumber:(NSString *)number
{
    if (number.length == 0) {
        return NO;
    }
    
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:number]) {
        return YES;
    }
    
    return NO;
}

- (void)dismissKeyboard
{
    [_window endEditing:YES];
}

- (void)tapGestureRecognizer
{
    [self dismissKeyboard];
}

- (void)dismissWindow
{
    [UIView animateWithDuration:0.25f animations:^ {
        CGRect frame = _toolBar.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        _toolBar.frame = frame;
    }completion:^(BOOL finished) {
        _window.hidden = YES;
        _window = nil;
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
