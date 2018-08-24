//
//  AppDelegate.m
//  SignerTest
//
//  Created by  jiangminjie on 2018/1/30.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"

@interface AppDelegate ()

@property(nonatomic,strong) MasterViewController *masterViewCtrl;

@property (strong) IBOutlet NSWindow *window;



@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    self.masterViewCtrl = [[MasterViewController alloc]initWithNibName:@"MasterViewController" bundle:nil];
    [self.window.contentView addSubview:self.masterViewCtrl.view];
    self.masterViewCtrl.view.frame = self.window.contentView.bounds;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
