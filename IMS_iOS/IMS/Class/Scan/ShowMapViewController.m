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
#import "IMSAPIManager.h"

@interface ShowMapViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (nonatomic, strong) NSMutableArray *urlStringArray;
@property (nonatomic, strong) NSMutableArray *markItems;
@property (nonatomic, strong) NSMutableArray *markArray;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) NSMutableArray <YCXMenuItem *>*markItemArray;

@end

@implementation ShowMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self analysisLocationInfo];
    [self setupUI];
    
//    YCXMenuItem *item = self.markItemArray.firstObject;
//    NSString *mapUrl = item.urlString;
//
//    NSString *mapSize = [NSString stringWithFormat:@"&size=%.0fx%.0f",ScreenWidth,ScreenHeight - 64];
//    mapUrl = [NSString stringWithFormat:@"%@%@",mapUrl,mapSize];
////    [self pickupMarksParamas];
//    mapUrl = [mapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [self.mapImageView yy_setImageWithURL:[NSURL URLWithString:mapUrl] placeholder:[UIImage imageNamed:@""]];
    [self getRoadMapWithSelectIndex:0];
}

- (void)analysisLocationInfo {
    [self.markItemArray removeAllObjects];
//    NSString *totalUrl = self.locationInfo[@"url"];
//    NSDictionary *expectLocationDic = self.locationInfo[@"expectLocation"];
//    NSDictionary *currentLocationDic = self.locationInfo[@"currentLocation"];
    MarkersInfoModel *currentModel = [MarkersInfoModel new];
    MarkersInfoModel *expectModel = [MarkersInfoModel new];
    for (MarkersInfoModel *model in self.markersInfo) {
        if ([model.type isEqualToString:@"current"]) {
            currentModel = model;
        } else if ([model.type isEqualToString:@"expect"]) {
            expectModel = model;
        }
    }
    
    
    NSString *expectUrl = @"";//要拼接
    NSString *expectName = expectModel.name;
    
    NSString *currentUrl = @"";//要拼接
    NSString *currentName = currentModel.name;
    
    if (STR_IS_NIL(expectName)) {
        expectName = @"expectLocation";
    }
    
    if (STR_IS_NIL(currentName)) {
        currentName = @"currentLocation";
    }

    YCXMenuItem *total = [YCXMenuItem menuItem:@"ALL" image:nil tag:101 userInfo:nil];
    total.title = @"ALL";
    total.urlString = @"";//要拼接
    total.foreColor = [UIColor whiteColor];
    total.titleFont = [UIFont boldSystemFontOfSize:20.0f];

    YCXMenuItem *current = [YCXMenuItem menuItem:currentName image:nil tag:102 userInfo:nil];
    current.title = currentName;
    current.urlString = currentUrl;
    current.foreColor = [UIColor whiteColor];
    current.titleFont = [UIFont boldSystemFontOfSize:20.0f];
    
    YCXMenuItem *expect = [YCXMenuItem menuItem:expectName image:nil tag:103 userInfo:nil];
    expect.title = expectName;
    expect.urlString = expectUrl;
    expect.foreColor = [UIColor whiteColor];
    expect.titleFont = [UIFont boldSystemFontOfSize:20.0f];
    
    [self.markItemArray addObject:total];
    [self.markItemArray addObject:current];
    [self.markItemArray addObject:expect];
}

#pragma mark - 网络
- (void)getRoadMapWithSelectIndex:(NSInteger)index {
    
    NSMutableArray <MarkersInfoModel *>*array = [NSMutableArray new];
    if (index == 0) {//为全部，多个mark
        array = self.markersInfo;
    } else {//为单个mark
        MarkersInfoModel *model = [self.markersInfo objectAtIndex:index - 1];
        [array addObject:model];
    }
    
    NSString *mapSize = [NSString stringWithFormat:@"%.0fx%.0f",ScreenWidth,ScreenHeight - 64];
    __weak typeof (self) weakSelf = self;
    [IMSAPIManager ims_getRoadMapWithNum:[NSString stringWithFormat:@"%ld",array.count] size:mapSize zoom:@"" marksArray:array Block:^(id JSON, NSError *error) {
        [weakSelf get_getLocationName];
        if (error) {
            DLog(@"network error");
        } else {
            UIImage *image = (UIImage *)JSON;
            //获取到图片链接，显示图片
            weakSelf.mapImageView.image = image;
        }
    }];
    
}

- (void)get_getLocationName {
    for (MarkersInfoModel *model in self.markersInfo) {
        __weak typeof (self) weakSelf = self;
        [IMSAPIManager ims_getLocationNameWithLatitude:model.lat longitude:model.lng Block:^(id JSON, NSError *error) {
            if (error) {
                DLog(@"network error");
            } else {
                if (!DICT_IS_NIL(JSON)) {
                    NSString *name = JSON[@"name"];
                    model.name =name;
                    [weakSelf analysisLocationInfo];
                }
            }
        }];
    }
    
}

#pragma mark - Action&CustomMethod
- (void)selectMarkAction {
    
    [YCXMenu setTintColor:[UIColor ims_colorWithRed:73 green:73 blue:75]];
    [YCXMenu setSelectedColor:[UIColor ims_colorWithRed:66 green:66 blue:66]];
    if ([YCXMenu isShow]){
        [YCXMenu dismissMenu];
    } else {
        __weak typeof (self) weakSelf = self;
        [YCXMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width - 50, 64, 50, 0) menuItems:self.markItemArray selected:^(NSInteger index, YCXMenuItem *item) {
            NSLog(@"%@",item);
            [weakSelf.rightButton setTitle:item.title forState:UIControlStateNormal];
            [weakSelf changemarkWithSelectIndex:index];
        }];
    }
}

- (void)changemarkWithSelectIndex:(NSInteger)index {
    
    YCXMenuItem *item = [self.markItemArray objectAtIndex:index];
    
    NSString *urlStr = item.urlString;
    NSString *mapSize = [NSString stringWithFormat:@"&size=%.0fx%.0f",ScreenWidth,ScreenHeight - 64];
    urlStr = [NSString stringWithFormat:@"%@%@",urlStr,mapSize];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.mapImageView yy_setImageWithURL:[NSURL URLWithString:urlStr] placeholder:[UIImage imageNamed:@""]];
    
    //获取地图图片
    [self getRoadMapWithSelectIndex:index];
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

- (NSMutableArray<YCXMenuItem *> *)markItemArray {
    if (_markItemArray == nil) {
        _markItemArray = [NSMutableArray new];
    }
    return _markItemArray;
}

- (NSString *)title {
    return @"Map";
}
@end
