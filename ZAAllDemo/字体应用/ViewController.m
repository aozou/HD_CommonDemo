//
//  ViewController.m
//  字体应用
//
//  Created by  jiangminjie on 2018/1/25.
//  Copyright © 2018年 SeaHot. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+WLAttributedString.h"
#import "UILabel+WLKit.h"
#import "UIView+WLKit.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)UITextView *textView;

@property (nonatomic, strong)NSArray <NSString *> *array;

@end

@implementation ViewController

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        
    }
    return _textView;
}

- (NSArray *)array
{
    if (_array == nil) {
        _array = [[NSArray alloc] initWithObjects:@"姓名", @"年龄", @"出生日期", @"出生地", nil];
    }
    return _array;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"NSMutableAttributedStringDemo";
    self.tableView.height = self.view.height-64.0;
    [self.view addSubview:self.tableView];
    
    NSArray *familyNames = [UIFont familyNames];
    NSLog(@"");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 27;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text = @"字体变大 字体变小";
            [cell.textLabel wl_changeFontWithTextFont:[UIFont systemFontOfSize:30.0] changeText:@"变大"];
            [cell.textLabel wl_changeFontWithTextFont:[UIFont systemFontOfSize:9.0] changeText:@"变小"];
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"字和字之间的间距变大间距变小";
            [cell.textLabel wl_changeSpaceWithTextSpace:10.0 changeText:@"间距变大"];
            [cell.textLabel wl_changeSpaceWithTextSpace:-1.0 changeText:@"间距变小"];
        }
            break;
        case 2:
        {
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = @"行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距行间距";
            [cell.textLabel wl_changeLineSpaceWithTextLineSpace:3.0];
        }
            break;
        case 3:
        {
            cell.textLabel.text = @"红色的字";
            [cell.textLabel wl_changeColorWithTextColor:[UIColor redColor] changeText:@"红色"];
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"红色的字蓝色的字黄色的字";
            [cell.textLabel wl_changeColorWithTextColor:[UIColor redColor] changeText:@"红色"];
            [cell.textLabel wl_changeColorWithTextColor:[UIColor blueColor] changeText:@"蓝色"];
            [cell.textLabel wl_changeColorWithTextColor:[UIColor yellowColor] changeText:@"黄色"];
        }
            break;
        case 5:
        {
            cell.textLabel.text = @"红色的背景蓝色的背景";
            [cell.textLabel wl_changeBgColorWithBgTextColor:[UIColor redColor] changeText:@"红色"];
            [cell.textLabel wl_changeBgColorWithBgTextColor:[UIColor blueColor] changeText:@"蓝色"];
        }
            break;
        case 6:
        {
            cell.textLabel.text = @"wangguoliang";
            [cell.textLabel wl_changeFontWithTextFont:[UIFont fontWithName:@"futura" size:12.0] changeText:@"wangguoliang"];
            [cell.textLabel wl_changeLigatureWithTextLigature:@(1)];
        }
            break;
        case 7:
        {
            cell.textLabel.text = @"字和字之间的间距变大间距变小";
            [cell.textLabel wl_changeKernWithTextKern:@(10.0) changeText:@"间距变大"];
            [cell.textLabel wl_changeKernWithTextKern:@(-1.0) changeText:@"间距变小"];
        }
            break;
        case 8:
        {
            cell.textLabel.text = @"有一根删除线有加粗删除线有两根删除线";
            [cell.textLabel wl_changeStrikethroughStyleWithTextStrikethroughStyle:@(NSUnderlineStyleSingle) changeText:@"一根删除线"];
            [cell.textLabel wl_changeStrikethroughStyleWithTextStrikethroughStyle:@(NSUnderlineStyleThick) changeText:@"加粗删除线"];
            [cell.textLabel wl_changeStrikethroughStyleWithTextStrikethroughStyle:@(NSUnderlineStyleDouble) changeText:@"两根删除线"];
            [cell.textLabel wl_changeStrikethroughColorWithTextStrikethroughColor:[UIColor redColor] changeText:@"删除线"];
        }
            break;
        case 9:
        {
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = @"字下面有一根下划线有加粗下划线有两根下划线";
            [cell.textLabel wl_changeUnderlineStyleWithTextStrikethroughStyle:@(NSUnderlineStyleSingle) changeText:@"一根下划线"];
            [cell.textLabel wl_changeUnderlineStyleWithTextStrikethroughStyle:@(NSUnderlineStyleThick) changeText:@"加粗下划线"];
            [cell.textLabel wl_changeUnderlineStyleWithTextStrikethroughStyle:@(NSUnderlineStyleDouble) changeText:@"两根下划线"];
            [cell.textLabel wl_changeUnderlineColorWithTextStrikethroughColor:[UIColor blueColor] changeText:@"下划线"];
        }
            break;
        case 10:
        {
            cell.textLabel.text = @"红色的描边蓝色的描边";
            [cell.textLabel wl_changeStrokeColorWithTextStrikethroughColor:[UIColor redColor] changeText:@"红色"];
            [cell.textLabel wl_changeStrokeWidthWithTextStrikethroughWidth:@(10.0) changeText:@"红色"];
            [cell.textLabel wl_changeStrokeColorWithTextStrikethroughColor:[UIColor blueColor] changeText:@"蓝色"];
            [cell.textLabel wl_changeStrokeWidthWithTextStrikethroughWidth:@(3.0) changeText:@"蓝色"];
        }
            break;
        case 11:
        {
            cell.textLabel.text = @"红色的阴影蓝色的阴影";
            NSShadow *redShadow = [[NSShadow alloc] init];
            redShadow.shadowOffset = CGSizeMake(1.0, 1.0);
            //shadow.shadowBlurRadius = 0.5;
            redShadow.shadowColor = [UIColor redColor];
            [cell.textLabel wl_changeShadowWithTextShadow:redShadow changeText:@"红色"];
            
            NSShadow *blueShadow = [[NSShadow alloc] init];
            blueShadow.shadowOffset = CGSizeMake(1.0, 1.0);
            //shadow.shadowBlurRadius = 0.5;
            blueShadow.shadowColor = [UIColor redColor];
            [cell.textLabel wl_changeShadowWithTextShadow:blueShadow changeText:@"蓝色"];
        }
            break;
        case 12:
        {
            cell.textLabel.text = @"字体有特殊的效果";
            [cell.textLabel wl_changeTextEffectWithTextEffect:NSTextEffectLetterpressStyle changeText:@"特殊的效果"];
        }
            break;
        case 13:
        {
            cell.textLabel.text = @"红色的描边蓝色的描边";
            [cell.textLabel wl_changeStrokeColorWithTextStrikethroughColor:[UIColor redColor] changeText:@"红色"];
            [cell.textLabel wl_changeStrokeWidthWithTextStrikethroughWidth:@(10.0) changeText:@"红色"];
            [cell.textLabel wl_changeStrokeColorWithTextStrikethroughColor:[UIColor blueColor] changeText:@"蓝色"];
            [cell.textLabel wl_changeStrokeWidthWithTextStrikethroughWidth:@(3.0) changeText:@"蓝色"];
        }
            break;
        case 14:
        {
            //cell.textLabel.text = @"百度的链接";
            //[cell.textLabel wl_changeLinkWithTextLink:@"www.baidu.com" changeText:@"百度"];
            
            self.textView.frame = CGRectMake(20.0, 0.0, self.view.width-25.0, cell.contentView.height);
            self.textView.backgroundColor = [UIColor clearColor];
            self.textView.editable = NO;
            [cell.contentView addSubview:self.textView];
            
            NSString *strLink = @"百度链接点击跳转到百度 淘宝链接点击跳转到淘宝";
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strLink];
            [attributedString addAttributes:@{NSLinkAttributeName:[NSURL URLWithString:@"http://www.baidu.com"], NSFontAttributeName:cell.textLabel.font, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:[strLink rangeOfString:@"百度链接"]];
            
            [attributedString addAttributes:@{NSLinkAttributeName:[NSURL URLWithString:@"http://www.taobao.com"], NSFontAttributeName:cell.textLabel.font, NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:[strLink rangeOfString:@"淘宝链接"]];
            self.textView.attributedText = attributedString;
        }
            break;
        case 15:
        {
            cell.textLabel.text = @"字的基准线向下偏移向上偏移";
            [cell.textLabel wl_changeBaselineOffsetWithTextBaselineOffset:@(-5.0) changeText:@"向下偏移"];
            [cell.textLabel wl_changeBaselineOffsetWithTextBaselineOffset:@(5.0) changeText:@"向上偏移"];
        }
            break;
        case 16:
        {
            cell.textLabel.text = @"字向左倾斜向右倾斜";
            [cell.textLabel wl_changeObliquenessWithTextObliqueness:@(-1.0) changeText:@"向左倾斜"];
            //            [cell.textLabel wl_changeObliquenessWithTextObliqueness:@(1.0) changeText:@"向右倾斜"];
            [cell.textLabel wl_changeObliquenessWithTextObliqueness:@(1.0) changeText:@"向右"];
            [cell.textLabel wl_changeObliquenessWithTextObliqueness:@(2.0) changeText:@"倾斜"];
        }
            break;
        case 17:
        {
            cell.textLabel.text = @"字的加粗加细";
            [cell.textLabel wl_changeExpansionsWithTextExpansion:@(0.5) changeText:@"加粗"];
            [cell.textLabel wl_changeExpansionsWithTextExpansion:@(-0.5) changeText:@"加细"];
        }
            break;
        case 18:
        {
            cell.textLabel.text = @"字方向";
            //[cell.textLabel wl_changeWritingDirectionWithTextExpansion:@[@(1), @(2)] changeText:@"字方向"];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            //书写方向
            paragraphStyle.baseWritingDirection = NSWritingDirectionRightToLeft;
            //连字属性 在iOS，唯一支持的值分别为0和1
            paragraphStyle.hyphenationFactor = 1;
            [cell.textLabel wl_changeParagraphStyleWithTextParagraphStyle:paragraphStyle];
        }
            break;
        case 19:
        {
            //            cell.textLabel.numberOfLines = 0;
            //            cell.textLabel.text = @"字的水平或者竖直";
            //            [cell.textLabel wl_changeVerticalGlyphFormWithTextVerticalGlyphForm:@(1) changeText:@"字的水平或者竖直"];
            UILabel *label = [UILabel labelWithFrame:CGRectMake(30.0, 0.0, 25.0, 200.0) text:@"字的水平或者竖直" font:cell.textLabel.font textColor:cell.textLabel.textColor alignment:NSTextAlignmentLeft];
            label.numberOfLines = 0;
            [cell.contentView addSubview:label];
        }
            break;
        case 20:
        {
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = @"人生若只如初见，何事秋风悲画扇。人生若只如初见，何事秋风悲画扇。\n等闲变却故人心，却道故人心易变。\n骊山语罢清宵半，泪雨霖铃终不怨。\n何如薄幸锦衣郎，比翼连枝当日愿。";
            //[cell.textLabel wl_changeFontWithTextFont:[UIFont systemFontOfSize:30.0] changeText:@"人生若"];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            //行间距
            paragraphStyle.lineSpacing = 10.0;
            //段落间距
            paragraphStyle.paragraphSpacing = 15.0;
            //对齐方式
            paragraphStyle.alignment = NSTextAlignmentJustified;
            //指定段落开始的缩进像素 首行缩进
            paragraphStyle.firstLineHeadIndent = 30.0;
            //调整全部文字的缩进像素
            paragraphStyle.headIndent = 10.0;
            paragraphStyle.tailIndent = -20.0;
            //书写方向
            paragraphStyle.baseWritingDirection = NSWritingDirectionNatural;
            //连字属性 在iOS，唯一支持的值分别为0和1
            paragraphStyle.hyphenationFactor = 1;
            [cell.textLabel wl_changeParagraphStyleWithTextParagraphStyle:paragraphStyle];
        }
            break;
        case 21:
        {
            CGFloat labelY = 5.0;
            for (NSString *str in self.array) {
                UILabel *label = [UILabel labelWithFrame:CGRectMake(30.0, labelY, 70.0, 20.0) text:str font:cell.textLabel.font textColor:cell.textLabel.textColor alignment:NSTextAlignmentLeft];
                CGSize labelSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, label.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
                [cell.contentView addSubview:label];
                CGFloat margin = (label.width-labelSize.width)/(label.text.length-1);
                [label wl_changeCTKernWithTextCTKern:@(margin)];
                labelY += label.height;
                labelY += 5.0;
            }
        }
            break;
        case 22:
        {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"中间有一张图片"];
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
            UIImage *smileImage = [UIImage imageNamed:@"test"];
            textAttachment.image = smileImage;
            
            NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [string insertAttributedString:textAttachmentString atIndex:5];
            cell.textLabel.attributedText = string;
        }
            break;
        case 23:
        {
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
            UIImage *smileImage = [UIImage imageNamed:@"test"];
            textAttachment.image = smileImage;
            cell.textLabel.text = @"123456789101112";
            [cell.textLabel wl_changeAttachmentWithTextAttachment:textAttachment];
        }
            break;
        case 24:
        {
            NSString *str = @"去年今日此门中，人面桃花相映红；人面不知何处去，桃花依旧笑春风。";
            UIFont *font = [UIFont fontWithName:@"Geeza Pro" size:25.0];
            NSMutableArray <NSString *> *textArray = [[NSMutableArray alloc] init];
            NSMutableArray <NSNumber *> *heightArray = [[NSMutableArray alloc] init];
            
            for (NSInteger i = 0; i < 4; i ++) {
                NSString *substr = [str substringWithRange:NSMakeRange(i*8, 8)];
                CGSize size = [substr boundingRectWithSize:CGSizeMake(25.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
                [heightArray addObject:@(size.height)];
                [textArray addObject:substr];
            }
            for (NSInteger i = 0; i < textArray.count; i++) {
                UILabel *label = [UILabel labelWithFrame:CGRectMake(30.0+(25.0+15.0)*i, 10.0, 25.0, [heightArray[i] floatValue]) text:textArray[i] font:font textColor:[UIColor purpleColor] alignment:NSTextAlignmentCenter];
                label.numberOfLines = 0;
                label.shadowColor = [UIColor colorWithWhite:0.4 alpha:0.8];
                label.shadowOffset = CGSizeMake(1.0, 2.0);
                [cell.contentView addSubview:label];
            }
        }
            break;
        case 25:
        {
            NSString *str = @"去年今日此门中，人面桃花相映红；人面不知何处去，桃花依旧笑春风。";
            UIFont *font = [UIFont fontWithName:@"Geeza Pro" size:25.0];
            NSMutableArray <NSString *> *textArray = [[NSMutableArray alloc] init];
            NSMutableArray <NSNumber *> *heightArray = [[NSMutableArray alloc] init];
            
            for (NSInteger i = 0; i < 4; i ++) {
                NSString *substr = [str substringWithRange:NSMakeRange(i*8, 8)];
                CGSize size = [substr boundingRectWithSize:CGSizeMake(25.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
                [heightArray addObject:@(size.height)];
                [textArray addObject:substr];
            }
            for (NSInteger i = 0; i < textArray.count; i++) {
                UILabel *label = [UILabel labelWithFrame:CGRectMake(self.view.width-(25.0+15.0)*(i+1), 10.0, 25.0, [heightArray[i] floatValue]) text:textArray[i] font:font textColor:[UIColor purpleColor] alignment:NSTextAlignmentCenter];
                label.numberOfLines = 0;
                label.shadowColor = [UIColor colorWithWhite:0.4 alpha:0.8];
                label.shadowOffset = CGSizeMake(1.0, 2.0);
                [cell.contentView addSubview:label];
            }
        }
            break;
        case 26:
        {
            NSString *str = @"去年今日此门中，人面桃花相映红；人面不知何处去，桃花依旧笑春风。";
            UIFont *font = [UIFont fontWithName:@"Geeza Pro" size:25.0];
            NSMutableArray <NSString *> *array = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < str.length; i ++) {
                NSString *substr = [str substringWithRange:NSMakeRange(i*1, 1)];
                [array addObject:substr];
            }
            CGFloat labelX = 30.0;
            CGFloat labelY = 10.0;
            for (NSInteger i = 0; i < array.count; i++) {
                UILabel *label = [UILabel labelWithFrame:CGRectMake(labelX, labelY, 25.0, 25.0) text:array[i] font:font textColor:[UIColor purpleColor] alignment:NSTextAlignmentCenter];
                label.numberOfLines = 0;
                label.shadowColor = [UIColor colorWithWhite:0.4 alpha:0.8];
                label.shadowOffset = CGSizeMake(1.0, 2.0);
                [cell.contentView addSubview:label];
                labelY += label.height;
                if (labelY > 260.0) {
                    labelX += label.height;
                    labelX += 15.0;
                    labelY = 10.0;
                }
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        return 80.0;
    }
    if (indexPath.row == 19) {
        return 200.0;
    }
    if (indexPath.row == 20) {
        return 250.0;
    }
    if (indexPath.row == 21) {
        return 110.0;
    }
    if (indexPath.row == 24) {
        return 280.0;
    }
    if (indexPath.row == 25) {
        return 280.0;
    }
    if (indexPath.row == 26) {
        return 300.0;
    }
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0)
{
    NSLog(@"%@",URL);
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
