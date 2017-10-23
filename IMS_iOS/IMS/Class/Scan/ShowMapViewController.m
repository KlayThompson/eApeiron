//
//  ShowMapViewController.m
//  Investigator
//
//  Created by Kim on 2017/10/19.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "ShowMapViewController.h"
#import "YYWebImage.h"
#import "MainNavigationController.h"
#import "YCXMenu.h"
#import "UIColor+Addtions.h"

@interface ShowMapViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (nonatomic, strong) NSMutableArray *urlStringArray;
@property (nonatomic, strong) NSMutableArray *markItems;
@property (nonatomic, strong) NSMutableArray *markArray;
@property (nonatomic, strong) UIButton *rightButton;
@end

@implementation ShowMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    NSString *mapSize = [NSString stringWithFormat:@"&size=%.0fx%.0f",ScreenWidth,ScreenHeight - 64];
    self.mapUrl = [NSString stringWithFormat:@"%@%@",self.mapUrl,mapSize];
    [self pickupMarksParamas];
    self.mapUrl = [self.mapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.mapImageView yy_setImageWithURL:[NSURL URLWithString:self.mapUrl] placeholder:[UIImage imageNamed:@""]];
    
}

#pragma mark - Action&CustomMethod
- (void)pickupMarksParamas {
    
    NSString *string = @"&";
    NSArray *array = [self.mapUrl componentsSeparatedByString:string];
    NSMutableArray *mutableArray = [array mutableCopy];
    for (NSInteger index = mutableArray.count - 1; index >= 0; index--) {
        NSString *str = [mutableArray objectAtIndex:index];
        if ([str hasPrefix:@"markers="]) {
            [self.markArray addObject:str];
            [mutableArray removeObjectAtIndex:index];
        }
    }
    
    //先将完整的加进去
    [self.urlStringArray addObject:self.mapUrl];
    
    //重新拼接成url
    NSString *urlString = [mutableArray componentsJoinedByString:@"&"];
    for (NSString *mark in self.markArray) {
        NSString *str = [NSString stringWithFormat:@"%@&%@",urlString,mark];
        [self.urlStringArray addObject:str];
    }
    DLog(@"");
}

- (void)selectMarkAction {
    
    [YCXMenu setTintColor:[UIColor ims_colorWithRed:73 green:73 blue:75]];
    [YCXMenu setSelectedColor:[UIColor ims_colorWithRed:66 green:66 blue:66]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        __weak typeof (self) weakSelf = self;
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 64, 50, 0) menuItems:self.markItems selected:^(NSInteger index, YCXMenuItem *item) {
            NSLog(@"%@",item);
            [weakSelf.rightButton setTitle:item.title forState:UIControlStateNormal];
            [weakSelf changemarkWithSelectIndex:index];
        }];
    }
}

- (void)changemarkWithSelectIndex:(NSInteger)index {
    
    NSString *urlStr = [self.urlStringArray objectAtIndex:index];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.mapImageView yy_setImageWithURL:[NSURL URLWithString:urlStr] placeholder:[UIImage imageNamed:@""]];
}

#pragma mark - UI
- (void)setupUI {
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
}

#pragma mark - 初始化

- (NSMutableArray *)markItems {
    if (!_markItems) {
        
        NSMutableArray *array = [NSMutableArray new];
        //添加个all
        YCXMenuItem *mark = [YCXMenuItem menuItem:@"ALL" image:nil tag:102 userInfo:nil];
        mark.foreColor = [UIColor whiteColor];
        mark.titleFont = [UIFont boldSystemFontOfSize:20.0f];
        [array addObject:mark];
        for (NSString *markString in self.markArray) {
            
            NSArray *arr = [markString componentsSeparatedByString:@"|"];
            YCXMenuItem *mark = [YCXMenuItem menuItem:arr.lastObject image:nil tag:100 userInfo:nil];
            mark.foreColor = [UIColor whiteColor];
            mark.titleFont = [UIFont boldSystemFontOfSize:20.0f];
            [array addObject:mark];
        }
        _markItems = [array mutableCopy];
    }
    return _markItems;
}
- (NSMutableArray *)urlStringArray {
    if (_urlStringArray == nil) {
        _urlStringArray = [NSMutableArray new];
    }
    return _urlStringArray;
}

- (NSMutableArray *)markArray {
    if (_markArray == nil) {
        _markArray = [NSMutableArray new];
    }
    return _markArray;
}

- (UIButton *)rightButton {
    if (_rightButton == nil) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitle:@"ALL" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor ims_colorWithHex:0x4c4c4c] forState:UIControlStateNormal];
        _rightButton.frame = CGRectMake(0, 0, 130, 30);
        [_rightButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_rightButton addTarget:self action:@selector(selectMarkAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

- (NSString *)title {
    return @"Map";
}
@end
