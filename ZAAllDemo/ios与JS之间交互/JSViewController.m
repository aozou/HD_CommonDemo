//
//  ViewController.m
//  ios与JS之间交互
//
//  Created by  jiangminjie on 2018/1/25.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "JSViewController.h"
#import "WebViewController.h"
#import "WKWebViewController.h"
#import "SeondViewController.h"
#import "ThreeViewController.h"
#import "ThreeWKViewController.h"

@interface JSViewController ()

@end

@implementation JSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)onActionToUIWebView
{
    WebViewController *webVC = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)onActionToWKWebView
{
    WKWebViewController *wkWebVC = [[WKWebViewController alloc] init];
    [self.navigationController pushViewController:wkWebVC animated:YES];
}

- (IBAction)onActionToJS:(id)sender {
    SeondViewController *webVC = [[SeondViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)onActionToBridgeForUI:(id)sender {
    ThreeViewController *webVC = [[ThreeViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (IBAction)onActionToBridgeFrWK:(id)sender {
    ThreeWKViewController *webVC = [[ThreeWKViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
