//
//  WKWebViewController.m
//  JS_OC_URL
//
//  Created by Harvey on 16/8/4.
//  Copyright © 2016年 Haley. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <AVFoundation/AVFoundation.h>

#import "WKWebViewController.h"

@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (strong, nonatomic)   WKWebView                   *webView;
@property (strong, nonatomic)   UIProgressView              *progressView;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"WKWebView拦截URL";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self initWKWebView];
    
    [self initProgressView];
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)initWKWebView
{
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userCtrl = [WKUserContentController new];
    [userCtrl addScriptMessageHandler:self name:@"sayhello"];
    configuration.userContentController = userCtrl;
    
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 30.0;
    configuration.preferences = preferences;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    
    
//    NSString *urlStr = @"http://www.baidu.com";
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    [self.webView loadRequest:request];
    
    NSString *urlStr = [[NSBundle mainBundle] pathForResource:@"index.html" ofType:nil];
    NSURL *fileURL = [NSURL fileURLWithPath:urlStr];
    [self.webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL];
//    NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSMutableString * cookieString = [[NSMutableString alloc]init];
//    for (NSHTTPCookie*cookie in [cookieJar cookies]) {
//        [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
//    }
//    
//    //删除最后一个“；”
//    [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
//    [request addValue:cookieString forHTTPHeaderField:@"Cookie"];
//    [self.webView loadRequest:request];
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
}

- (void)initProgressView
{
    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
    progressView.tintColor = [UIColor redColor];
    progressView.trackTintColor = [UIColor lightGrayColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
}

- (void)rightClick
{
    [self goBack];
}

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - private method
- (void)handleCustomAction:(NSURL *)URL
{
    NSString *host = [URL host];
    if ([host isEqualToString:@"scanClick"]) {
        NSLog(@"扫一扫");
    } else if ([host isEqualToString:@"shareClick"]) {
        [self share:URL];
    } else if ([host isEqualToString:@"getLocation"]) {
        [self getLocation];
    } else if ([host isEqualToString:@"setColor"]) {
        [self changeBGColor:URL];
    } else if ([host isEqualToString:@"payAction"]) {
        [self payAction:URL];
    } else if ([host isEqualToString:@"shake"]) {
        [self shakeAction];
    } else if ([host isEqualToString:@"goBack"]) {
        [self goBack];
    }
  
}

- (void)getLocation
{
    // 获取位置信息
    
    // 将结果返回给js
    NSString *jsStr = [NSString stringWithFormat:@"setLocation('%@')",@"广东省深圳市南山区学府路XXXX号"];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
   
}

- (void)share:(NSURL *)URL
{
    NSArray *params =[URL.query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    
    NSString *title = [tempDic objectForKey:@"title"];
    NSString *content = [tempDic objectForKey:@"content"];
    NSString *url = [tempDic objectForKey:@"url"];
    // 在这里执行分享的操作
    
    // 将分享结果返回给js
    NSString *jsStr = [NSString stringWithFormat:@"shareResult('%@','%@','%@')",title,content,url];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}

- (void)changeBGColor:(NSURL *)URL
{
    NSArray *params =[URL.query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
    CGFloat r = [[tempDic objectForKey:@"r"] floatValue];
    CGFloat g = [[tempDic objectForKey:@"g"] floatValue];
    CGFloat b = [[tempDic objectForKey:@"b"] floatValue];
    CGFloat a = [[tempDic objectForKey:@"a"] floatValue];
    
    self.view.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

- (void)payAction:(NSURL *)URL
{
    NSArray *params =[URL.query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSString *paramStr in params) {
        NSArray *dicArray = [paramStr componentsSeparatedByString:@"="];
        if (dicArray.count > 1) {
            NSString *decodeValue = [dicArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [tempDic setObject:decodeValue forKey:dicArray[0]];
        }
    }
//    NSString *orderNo = [tempDic objectForKey:@"order_no"];
//    long long amount = [[tempDic objectForKey:@"amount"] longLongValue];
//    NSString *subject = [tempDic objectForKey:@"subject"];
//    NSString *channel = [tempDic objectForKey:@"channel"];
    
    // 支付操作
    
    // 将支付结果返回给js
    NSString *jsStr = [NSString stringWithFormat:@"payResult('%@')",@"支付成功"];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}

- (void)shakeAction
{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

- (void)goBack
{
    [self.webView goBack];
}

#pragma mark - KVO
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
            
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"haleyaction"]) {
        
        [self handleCustomAction:URL];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [webView evaluateJavaScript:@"say()" completionHandler:^(id obj, NSError * _Nullable error) {
        NSLog(@"");
    }];
    
//    //取出cookie
//    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    //js函数
//    NSString *JSFuncString =
//    @"function setCookie(name,value,expires)\
//    {\
//    var oDate=new Date();\
//    oDate.setDate(oDate.getDate()+expires);\
//    document.cookie=name+'='+value+';expires='+oDate+';path=/'\
//    }\
//    function getCookie(name)\
//    {\
//    var arr = document.cookie.match(new RegExp('(^| )'+name+'=([^;]*)(;|$)'));\
//    if(arr != null) return unescape(arr[2]); return null;\
//    }\
//    function delCookie(name)\
//    {\
//    var exp = new Date();\
//    exp.setTime(exp.getTime() - 1);\
//    var cval=getCookie(name);\
//    if(cval!=null) document.cookie= name + '='+cval+';expires='+exp.toGMTString();\
//    }";
//    
//    //拼凑js字符串
//    NSMutableString *JSCookieString = JSFuncString.mutableCopy;
//    for (NSHTTPCookie *cookie in cookieStorage.cookies) {
//        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 1);", cookie.name, cookie.value];
//        [JSCookieString appendString:excuteJSString];
//    }
//    //执行js
//    [webView evaluateJavaScript:JSCookieString completionHandler:nil];
    
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - WKUserContentController
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
}

@end
