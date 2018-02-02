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
#import "SVProgressHUD.h"

@interface ShowMapViewController () {
    NSInteger currentSelectIndex;
}
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (nonatomic, strong) NSMutableArray *urlStringArray;
@property (nonatomic, strong) NSMutableArray *markItems;
@property (nonatomic, strong) NSMutableArray *markArray;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) NSMutableArray <YCXMenuItem *>*markItemArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation ShowMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentSelectIndex = 0;
    
    [self analysisLocationInfo];
    [self setupUI];
    [self getRoadMapWithSelectIndex:0];

}

- (void)analysisLocationInfo {
    if (ARRAY_IS_NIL(self.markersInfo)) {
        return;
    }
    
    [self.markItemArray removeAllObjects];

    
    YCXMenuItem *total = [YCXMenuItem menuItem:@"ALL" image:nil tag:101 userInfo:nil];
    total.title = @"ALL";
    total.foreColor = [UIColor whiteColor];
    total.titleFont = [UIFont boldSystemFontOfSize:20.0f];
    [self.markItemArray addObject:total];
    
   
    
    for (int index = 0; index < self.markersInfo.count; index ++) {
        
        MarkersInfoModel *model = [self.markersInfo objectAtIndex:index];
        
        YCXMenuItem *item = [YCXMenuItem menuItem:model.type image:nil tag:101 + index  userInfo:nil];
        item.title = model.type;
        item.foreColor = [UIColor whiteColor];
        item.titleFont = [UIFont boldSystemFontOfSize:20.0f];
        [self.markItemArray addObject:item];
    }
    
    //创建mapimageArray
    for (int index = 0; index < self.markItemArray.count; index++) {
        [self.imageArray addObject:@0];
    }
}

#pragma mark - 网络
- (void)getRoadMapWithSelectIndex:(NSInteger)index {
    //先判断是否加载过图片，未加载在请求网络
    id image = [self.imageArray objectAtIndex:index];
    if ([image isKindOfClass:[UIImage class]]) {
        self.mapImageView.image = image;
    } else {
        
        NSMutableArray <MarkersInfoModel *>*array = [NSMutableArray new];
        if (index == 0) {//为全部，多个mark
            array = self.markersInfo;
        } else {//为单个mark
            MarkersInfoModel *model = [self.markersInfo objectAtIndex:index - 1];
            [array addObject:model];
        }
        
        NSString *mapSize = [NSString stringWithFormat:@"%.0fx%.0f",ScreenWidth,ScreenHeight - 64];
        __weak typeof (self) weakSelf = self;
        [SVProgressHUD show];
        [IMSAPIManager ims_getRoadMapWithNum:[NSString stringWithFormat:@"%ld",array.count] size:mapSize zoom:@"" marksArray:array Block:^(id JSON, NSError *error) {
            [SVProgressHUD dismiss];
            [weakSelf get_getLocationName];
            if (error) {
                DLog(@"network error");
            } else {
                UIImage *image = (UIImage *)JSON;
                //获取到图片链接，显示图片
                weakSelf.mapImageView.image = image;
                [self.imageArray replaceObjectAtIndex:index withObject:image];
                DLog(@"");
            }
        }];
    }
    
    currentSelectIndex = index;
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
                    if (!STR_IS_NIL(name)) {
                        model.type = name;
                        [weakSelf analysisLocationInfo];
                    }
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
    
    if (currentSelectIndex == index) {
        return;//选择了当前的
    }
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

- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray new];
    }
    return _imageArray;
}

- (NSString *)title {
    return @"Map";
}
@end
