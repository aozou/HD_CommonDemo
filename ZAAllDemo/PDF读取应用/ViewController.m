//
//  ViewController.m
//  PDF读取应用
//
//  Created by  jiangminjie on 2018/1/29.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "ViewController.h"
#import "HWPDFBrowseVC.h"

@interface ViewController ()<UIWebViewDelegate> {
    UIWebView       *_webView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"PDF应用";
    // Do any additional setup after loading the view, typically from a nib.
    [self onCreateUI];
}

- (void)onCreateUI
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 100, size.width/2.0, 40);
    [saveBtn setTitle:@"原生" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(onBt1Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    UIButton *recoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recoverBtn.frame = CGRectMake(size.width/2.0, CGRectGetMinY(saveBtn.frame), size.width/2.0, 40);
    [recoverBtn setTitle:@"网页" forState:UIControlStateNormal];
    [recoverBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [recoverBtn addTarget:self action:@selector(onBt2Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recoverBtn];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(saveBtn.frame), size.width, size.height- CGRectGetMaxY(saveBtn.frame))];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor lightGrayColor];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    [self.view addSubview:_webView];
}

//原生
- (void)onBt1Action
{
    HWPDFBrowseVC *vc = [[HWPDFBrowseVC alloc] init];
    vc.filePath = [[NSBundle mainBundle] pathForResource:@"HWTest.pdf" ofType:nil];
    vc.fileName = @"HWTestPDF";
    [self.navigationController pushViewController:vc animated:YES];
}

//网页
- (void)onBt2Action
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HWTest.pdf" ofType:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [_webView loadRequest:request];
}

#pragma mark - Delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
