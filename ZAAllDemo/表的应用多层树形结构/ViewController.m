//
//  ViewController.m
//  表的应用多层树形结构
//
//  Created by  jiangminjie on 2018/8/23.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "ViewController.h"
#import "MoreTreesTableView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect rect = self.view.frame;
    CGRect frame = CGRectMake(20, 20, CGRectGetWidth(rect)-40, CGRectGetHeight(rect)-20);
    MoreTreesTableView *mutableTable = [[MoreTreesTableView alloc] initWithFrame:frame
                                                                                 nodes:[self returnData]
                                                                            rootNodeID:@""
                                                                      needPreservation:YES
                                                                           selectBlock:^(MoreTreesModel *node) {
                                                                               NSLog(@"--select node name=%@", node.name);
                                                                           }];
    [self.view addSubview:mutableTable];
}

- (NSArray*)returnData{
    NSArray *list = @[@{@"parentID":@"", @"name":@"Node1", @"ID":@"1"},
                      @{@"parentID":@"1", @"name":@"Node10", @"ID":@"10"},
                      @{@"parentID":@"1", @"name":@"Node11", @"ID":@"11"},
                      @{@"parentID":@"10", @"name":@"Node100", @"ID":@"100"},
                      @{@"parentID":@"10", @"name":@"Node101", @"ID":@"101"},
                      @{@"parentID":@"11", @"name":@"Node110", @"ID":@"110"},
                      @{@"parentID":@"11", @"name":@"Node111", @"ID":@"111"},
                      @{@"parentID":@"111", @"name":@"Node1110", @"ID":@"1110"},
                      @{@"parentID":@"111", @"name":@"Node1111", @"ID":@"1111"},
                      @{@"parentID":@"1111", @"name":@"Node55555", @"ID":@"1112"},
                      @{@"parentID":@"1112", @"name":@"NodeA", @"ID":@"1113"},
                      @{@"parentID":@"1113", @"name":@"NodeB", @"ID":@"1114"},
                      @{@"parentID":@"", @"name":@"Node2", @"ID":@"2"},
                      @{@"parentID":@"2", @"name":@"Node20", @"ID":@"20"},
                      @{@"parentID":@"20", @"name":@"Node200", @"ID":@"200"},
                      @{@"parentID":@"20", @"name":@"Node101", @"ID":@"201"},
                      @{@"parentID":@"20", @"name":@"Node202", @"ID":@"202"},
                      @{@"parentID":@"2", @"name":@"Node21", @"ID":@"21"},
                      @{@"parentID":@"21", @"name":@"Node210", @"ID":@"210"},
                      @{@"parentID":@"21", @"name":@"Node211", @"ID":@"211"},
                      @{@"parentID":@"21", @"name":@"Node212", @"ID":@"212"},
                      @{@"parentID":@"211", @"name":@"Node2110", @"ID":@"2110"},
                      @{@"parentID":@"211", @"name":@"Node2111", @"ID":@"2111"},];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in list) {
        MoreTreesModel *node  = [MoreTreesModel nodeWithParentID:dic[@"parentID"]
                                                      name:dic[@"name"]
                                                childrenID:dic[@"ID"]
                                                  isExpand:NO];
        [array addObject:node];
    }
    
    return [array copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
