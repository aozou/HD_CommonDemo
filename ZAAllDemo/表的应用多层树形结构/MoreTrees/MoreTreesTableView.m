//
//  MoreTreesTableView.m
//  表的应用多层树形结构
//
//  Created by  jiangminjie on 2018/8/23.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "MoreTreesTableView.h"


@interface YKNodeCell : UITableViewCell

@property (nonatomic, strong) MoreTreesModel *node;

@property (nonatomic, strong) UIImageView *leftImage;

@property (nonatomic, strong) UILabel *nodeLabel;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, assign) CGRect rect;

@end


#define RGB(r, g, b, a)         [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define  RandomColor RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), 1.0)

static CGFloat const leftMargin = 30.0; //left indentation
@implementation YKNodeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _leftImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self  addSubview:_leftImage];
        
        _nodeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nodeLabel.font  =[UIFont systemFontOfSize:16];
        [self addSubview:_nodeLabel];
        
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_line];
    }
    return self;
}

- (void)setNode:(MoreTreesModel *)node{
    _node = node;
    
    //set indentation
    CGFloat indentationX = (node.level-1)*leftMargin;
    [self moveNode:indentationX];
    
    //text color
//    CGFloat rgbValue = (node.level-1)*50;
    //    _nodeLabel.textColor  = RGB(rgbValue, rgbValue, rgbValue, 1.0);
    
    
    _nodeLabel.text = node.name;
    if (node.isExpand || node.isLeaf) {
        _leftImage.image = [UIImage imageNamed:@"YK_minus"];
    }else{
        _leftImage.image = [UIImage imageNamed:@"YK_plus"];
    }
    
    //hidden left log for leaf node or not
    // _leftImage.hidden = node.isLeaf;
}

- (void)moveNode:(CGFloat)indentationX{
    
    CGFloat cellHeight = _rect.size.height;
    CGFloat cellWidth  = _rect.size.width;
    
    CGRect frame1 = CGRectMake(0, (cellHeight-leftMargin)/2, leftMargin, leftMargin);
    frame1.origin.x = indentationX;
    _leftImage.frame = frame1;
    
    CGRect frame = CGRectMake(leftMargin, 0, cellWidth-leftMargin, cellHeight);
    frame.origin.x = leftMargin+indentationX;
    _nodeLabel.frame = frame;
    
    CGRect frame2 = CGRectMake(0, cellHeight-1, cellWidth, 1);
    frame2.origin.x = indentationX;
    _line.frame = frame2;
}
@end





@interface MoreTreesTableView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *rootID;

//all models
@property (nonatomic, copy) NSMutableArray *nodes;

//show the last status all child nodes keep when yes, or just show next level child nodes
@property (nonatomic, assign ,getter=isPreservation) BOOL preservation;

//展示的模型数组
@property (nonatomic, strong) NSMutableArray *tempNodes;

//需要展示或隐藏的indexPath数组
@property (nonatomic, strong) NSMutableArray *reloadArray;

@property (nonatomic, copy) MTSelectBlock block;

@end

static CGFloat const cellHeight = 45.0;
@implementation MoreTreesTableView

- (id)initWithFrame:(CGRect)frame nodes:(NSArray*)nodes rootNodeID:(NSString*)rootID needPreservation:(BOOL)need selectBlock:(MTSelectBlock)block
{
    self = [self initWithFrame:frame];
    if (self) {
        self.rootID = rootID ?: @"";
        self.preservation = need;
        self.nodes = [nodes copy];
        self.block = [block copy];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _tempNodes = [NSMutableArray array];
        _reloadArray = [NSMutableArray array];
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle =UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark - Actions
#pragma mark - Private Actions
- (void)setNodes:(NSMutableArray *)nodes{
    _nodes = nodes;
    
    //给所有的模型数据里面添加leaf和root属性值
    [self judgeLeafAndRootNodes];
    
    //更新层次级别值
    [self updateNodesLevel];
    
    //添加根模型
    [self addFirstLoadNodes];
    
    //刷新
    [self reloadData];
}

//给所有的模型数据里面添加leaf和root属性值
- (void)judgeLeafAndRootNodes{
    for (int i = 0 ; i<_nodes.count;i++) {
        MoreTreesModel *node = _nodes[i];
        
        
        BOOL isLeaf = YES;
        BOOL isRoot = YES;
        for (MoreTreesModel *tempNode in _nodes) {
            if ([tempNode.parentID isEqualToString:node.childrenID]) {
                isLeaf = NO;
            }
            if ([tempNode.childrenID isEqualToString:node.parentID]) {
                isRoot = NO;
            }
            if (!isRoot && !isLeaf) {
                break;
            }
        }
        node.leaf = isLeaf;
        node.root = isRoot;
    }
}

//更新层次级别值
- (void)updateNodesLevel{
    [self setDepth:1 parentIDs:@[_rootID] childrenNodes:_nodes];
}

- (void)setDepth:(NSUInteger)level parentIDs:(NSArray*)parentIDs childrenNodes:(NSMutableArray*)childrenNodes{
    
    NSMutableArray *newParentIDs = [NSMutableArray array];
    NSMutableArray *leftNodes = [childrenNodes  mutableCopy];
    
    for (MoreTreesModel *node in childrenNodes) {
        if ([parentIDs containsObject:node.parentID]) {
            node.level = level;
            [leftNodes removeObject:node];
            [newParentIDs addObject:node.childrenID];
        }
    }
    
    if (leftNodes.count>0) {
        level += 1;
        [self setDepth:level parentIDs:[newParentIDs copy] childrenNodes:leftNodes];
    }
}

//添加根模型
- (void)addFirstLoadNodes{
    // add parent nodes on the upper level
    for (int i = 0 ; i<_nodes.count;i++) {
        
        MoreTreesModel *node = _nodes[i];
        if (node.isRoot) {
            [_tempNodes addObject:node];
            
            if (node.isExpand) {
                [self expandNodesForParentID:node.childrenID insertIndex:[_tempNodes indexOfObject:node]];
            }
        }
    }
    [_reloadArray removeAllObjects];
}

#pragma mark - Delegate
#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tempNodes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    YKNodeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YKNodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (_tempNodes.count > indexPath.row) {
        cell.rect  =CGRectMake(0, 0, CGRectGetWidth(self.frame), cellHeight);
        cell.node = [_tempNodes objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MoreTreesModel *currentNode = [_tempNodes objectAtIndex:indexPath.row];
    if (currentNode.isLeaf) {
        self.block(currentNode);
        return;
    }else{
        currentNode.expand = !currentNode.expand;//该值改变会一直保存在全局数据中
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [_reloadArray removeAllObjects];
    if (currentNode.isExpand) {
        //expand 展开根据当前模型childrenID与下一个模型parentID一直即可
        [self expandNodesForParentID:currentNode.childrenID insertIndex:indexPath.row];
        [tableView insertRowsAtIndexPaths:_reloadArray withRowAnimation:UITableViewRowAnimationNone];
    }else{
        //fold 收缩根据层次级别,大于当前选中的模型level
        [self foldNodesForLevel:currentNode.level currentIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:_reloadArray withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)foldNodesForLevel:(NSUInteger)level currentIndex:(NSUInteger)currentIndex{
    
    if (currentIndex+1 < _tempNodes.count) {
        NSMutableArray *tempArr = [_tempNodes copy];
        for (NSUInteger i = currentIndex+1 ; i<tempArr.count;i++) {
            MoreTreesModel *node = tempArr[i];
            if (node.level <= level) {
                break;
            }else{
                if ([_tempNodes containsObject:node]) {
                    [_tempNodes removeObject:node];
                    [_reloadArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];//need reload nodes
                }
            }
        }
    }
}

- (NSUInteger)expandNodesForParentID:(NSString*)parentID insertIndex:(NSUInteger)insertIndex{
    
    for (int i = 0 ; i<_nodes.count;i++) {
        MoreTreesModel *node = _nodes[i];
        if ([node.parentID isEqualToString:parentID]) {
            if (!self.isPreservation) {
                node.expand = NO;
            }
            insertIndex++;
            [_tempNodes insertObject:node atIndex:insertIndex];
            [_reloadArray addObject:[NSIndexPath indexPathForRow:insertIndex inSection:0]];//need reload nodes
            
            if (node.isExpand) {
                insertIndex = [self expandNodesForParentID:node.childrenID insertIndex:insertIndex];
            }
        }
    }
    
    return insertIndex;
}

@end
