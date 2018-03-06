//
//  HistoryDetailViewController.m
//  Investigator
//
//  Created by Kim on 2017/9/12.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "HomeRootViewController.h"
#import "IMSAPIManager.h"
#import "HistoryModel.h"
#import "YYModel.h"
#import "UserInfoManager.h"
#import "IssueDetailView.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "ProjectModel.h"
#import "SettingsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ProjectSelectView.h"
#import "AVMetadataController.h"
#import "InputSerialNumberViewController.h"
#import "MarkersInfoModel.h"
#import "ShowMapViewController.h"
#import "NinaPagerView.h"
#import "HomeListViewController.h"
#import "UIColor+Addtions.h"

@interface HomeRootViewController ()<CLLocationManagerDelegate,AVMetadataDelegate> {

    CLLocationManager *_locationManager;
    CLLocation *_loc;
    ProjectSelectView *detail;
    HistoryUnit *selectUnit;
}

@property (nonatomic, strong) NSMutableArray <ProjectModel *>* projectsArray;

/**
 经度
 */
@property (nonatomic, copy) NSString *longitude;

/**
 纬度
 */
@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, strong) SettingsViewController *settingVC;

@property (nonatomic, strong) UIView *bottomBgView;

@property (nonatomic, strong) UIImageView *titleImageView;

/**
 顶部滑动选择视图
 */
@property (nonatomic, strong) NinaPagerView *sliderView;
@end

@implementation HomeRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    
    //_locationManager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    if ([[UIDevice currentDevice].systemVersion floatValue] > 8) {
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
    }
    
    //getProjects
    [self getProjectsFromServer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //每次在Home界面出现时候更新位置
    [_locationManager startUpdatingLocation];
}

- (void)startLocation {
    [_locationManager startUpdatingLocation];
}

#pragma mark - 网络
/**
 获取项目列表
 */
- (void)getProjectsFromServer {
    __weak typeof (self) weakSelf = self;
    [IMSAPIManager ims_getProjectsWithBlock:^(id JSON, NSError *error) {
        if (error) {
            [weakSelf startLocation];
        } else {
            NSDictionary *messageDic = JSON[@"Message"];
            ProjectListModel *listModel = [ProjectListModel yy_modelWithDictionary:messageDic];
            //保存此json，下次进入若auhtoken没过期则直接使用
            UserInfoManager *manager = [UserInfoManager shareInstance];
            manager.projectResultJson = JSON;
            [manager saveUserInfoToLocal];
            manager.projectsListModel = listModel;
            [weakSelf verifyUserSelectProjectStatus];
        }
    }];
}



#pragma mark - Acrions
- (void)showIssueDetailViewWithHistoryUnit:(HistoryUnit *)unit {
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"IssueDetailView" owner:self options:nil];
    id uv = [nib objectAtIndex:0];
    IssueDetailView *detail = uv;
    selectUnit = unit;
    detail.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [detail configIssueDetailViewWith:unit allProjectsArray:self.projectsArray];
    //添加到window上面
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.window addSubview:detail];
    
    //增加个简单动画效果吧
    detail.bgView.backgroundColor = [UIColor clearColor];
    detail.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:.3 animations:^{
        detail.layer.affineTransform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        detail.bgView.backgroundColor = [UIColor blackColor];
    }];
    
    [detail.mapButton addTarget:self action:@selector(jumpToMapDetailView) forControlEvents:UIControlEventTouchUpInside];
}

//跳转到地图界面
- (void)jumpToMapDetailView {
    //
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    for (UIView *subview in app.window.subviews) {
        if ([subview isKindOfClass:[IssueDetailView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    //创建markInfo
    NSMutableArray *markersInfo = [NSMutableArray new];
    MarkersInfoModel *current = [MarkersInfoModel new];
    current.color = @"blue";
    current.lat = self.latitude;
    current.lng = self.longitude;
    current.type = @"current";
    current.zoom = @14;
    
    MarkersInfoModel *expect = [MarkersInfoModel new];
    expect.color = @"red";
    expect.lat = selectUnit.latitude;
    expect.lng = selectUnit.longitude;
    expect.type = @"expect";
    expect.zoom = @14;
    
    [markersInfo addObject:current];
    [markersInfo addObject:expect];
    
    ShowMapViewController *showMap = [[ShowMapViewController alloc] initWithNibName:@"ShowMapViewController" bundle:nil];
    showMap.markersInfo = markersInfo;
    showMap.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:showMap animated:true];
}

- (void)settingButtonClick:(id)sender {
    
//    UIButton *button = (UIButton *)sender;
//    if (button.selected) {
//        //hide
//        [self hideSettingVc];
//    } else {
//        //show
//        [self showSettingVc];
//    }
//    button.selected = !button.selected;
    [self.navigationController pushViewController:self.settingVC animated:YES];
}

- (void)showSettingVc {
    CGFloat heightOfStatusbar = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    CGFloat heightOfNavigationbar = self.navigationController.navigationBar.frame.size.height;
    CGFloat height = heightOfStatusbar + heightOfNavigationbar;
    [UIView animateWithDuration:.3 animations:^{
        self.settingVC.view.frame = CGRectMake(ScreenWidth - (ScreenWidth * 3 / 5), height, ScreenWidth * 3 / 5, ScreenHeight - height);
    }];
}

- (void)hideSettingVc {
    CGFloat heightOfStatusbar = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    CGFloat heightOfNavigationbar = self.navigationController.navigationBar.frame.size.height;
    CGFloat height = heightOfStatusbar + heightOfNavigationbar;
    [UIView animateWithDuration:.3 animations:^{
        self.settingVC.view.frame = CGRectMake(ScreenWidth, height, ScreenWidth * 3 / 5, ScreenHeight - height);
    }];
}

- (void)scanButtonClick {
    
//    UserInfoManager *manager = [UserInfoManager shareInstance];
//    if (STR_IS_NIL(manager.currentProjectName)) {//为空要选择
//        [self showSelectProjectView];
//    } else {//扫描
//    }
    [self jumpToScan];//在首页时候要进行选择
}

- (void)showSelectProjectView {
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ProjectSelectView" owner:self options:nil];
    id uv = [nib objectAtIndex:0];
    detail = uv;
    detail.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [detail.doneButton addTarget:self action:@selector(doneButtonTap) forControlEvents:UIControlEventTouchUpInside];
    //添加到window上面
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.window addSubview:detail];
}

- (void)doneButtonTap {
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    for (ProjectModel *model in manager.projectsListModel.projects) {
        if (model.didSelected) {//说明选择了她
//            [self jumpToScan];
            
            manager.currentProjectName = model.projectName;
            manager.currentProjectId = model.projectId;
            
            [manager saveUserInfoToLocal];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:IMS_NOTIFICATION_CHANGEPROJECT object:nil];
        }
    }
    
    if (STR_IS_NIL(manager.currentProjectId)) {
        [SVProgressHUD showInfoWithStatus:@"Please choose your project"];
        return;
    }
    [detail removeFromSuperview];
    detail = nil;
    
    [self startLocation];
}

- (void)jumpToScan {
    InputSerialNumberViewController *input = [[InputSerialNumberViewController alloc] initWithNibName:@"InputSerialNumberViewController" bundle:nil];
    [self.navigationController pushViewController:input animated:NO];
    
    AVMetadataController *scan = [[AVMetadataController alloc] init];
    [scan setDelegate:self];
    [self presentViewController:scan animated:NO completion:nil];
}

- (void)verifyUserSelectProjectStatus {
    
    //判断是否选择了Project
    UserInfoManager *manager = [UserInfoManager shareInstance];
    if (STR_IS_NIL(manager.currentProjectId)) {
        //1.如果只有一个Project就直接帮助用户选择
        if (manager.projectsListModel.projects.count == 1) {
            ProjectModel *model = manager.projectsListModel.projects.firstObject;
            manager.currentProjectName = model.projectName;
            manager.currentProjectId = model.projectId;
            [manager saveUserInfoToLocal];
            [self startLocation];
        } else {
            //2.如果有多个则弹出Project选择框，供用户选择
            [self showSelectProjectView];
        }
    } else {
        [self startLocation];
    }
}

#pragma mark -
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
    //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
    _loc = [locations firstObject];
    DLog(@"纬度=%f，经度=%f",_loc.coordinate.latitude,_loc.coordinate.longitude);
    
    UserInfoManager *userInfo = [UserInfoManager shareInstance];
    userInfo.longitude = [NSString stringWithFormat:@"%f",_loc.coordinate.longitude];
    userInfo.latitude = [NSString stringWithFormat:@"%f",_loc.coordinate.latitude];
    self.longitude = userInfo.longitude;
    self.latitude = userInfo.latitude;
    [manager stopUpdatingLocation];
}

#pragma mark -
- (void)returnSerial:(NSString *)serial covertSerial:(NSString *)covertSerial {
    DLog(@"");
    //如果两个都为空则是点击取消按钮
    if (STR_IS_NIL(serial) && STR_IS_NIL(covertSerial)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IMS_NOTIFICATION_SCANQRCODECANCEL object:nil];
    } else {
        //扫描成功，发送通知，通知CHECKINCIDENT
//        self.serial = serial;
//        self.covertSerial = covertSerial;
        [[NSNotificationCenter defaultCenter] postNotificationName:IMS_NOTIFICATION_SCANQRCODESUCCESS object:serial];
    }
}

#pragma mark - 初始化、设置界面

- (void)setupUI {
    
    //setting Button
    [self setupNaviButton];
    
    //bottom
    self.bottomBgView.hidden = NO;
    
    [self.view addSubview:self.sliderView];
    self.sliderView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    self.longitude = manager.longitude;
    self.latitude = manager.latitude;
    
    self.navigationItem.titleView = self.titleImageView;
    
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)setupNaviButton {
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
    setButton.frame = CGRectMake(10, 0, 70, 30);
    [setButton setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
    [setButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [setButton setImage:[UIImage imageNamed:@"navi_setting"] forState:UIControlStateNormal];
    [setButton setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:setButton];
}

- (NSMutableArray<ProjectModel *> *)projectsArray {
    if (_projectsArray == nil) {
        _projectsArray = [NSMutableArray new];
    }
    return _projectsArray;
}

- (SettingsViewController *)settingVC {
    if (_settingVC == nil) {
        _settingVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
//        CGFloat heightOfStatusbar = [[UIApplication sharedApplication] statusBarFrame].size.height;
//
//        CGFloat heightOfNavigationbar = self.navigationController.navigationBar.frame.size.height;
//        CGFloat height = heightOfStatusbar + heightOfNavigationbar;
//        _settingVC.view.frame = CGRectMake(ScreenWidth + 30, height, ScreenWidth * 3 / 5, ScreenHeight - height);
    }
    return _settingVC;
}

- (UIView *)bottomBgView {
    if (_bottomBgView == nil) {
        _bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 60, ScreenWidth, 60)];
        _bottomBgView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_bottomBgView];
        //button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"camera-3"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(scanButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBgView addSubview:button];
        button.frame = CGRectMake((ScreenWidth / 2) - 42.5, -25, 85, 85);
    }
    return _bottomBgView;
}

- (UIImageView *)titleImageView {
    if (_titleImageView == nil) {
        _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ims_title_logo"]];
        _titleImageView.frame = CGRectMake(0, 0, 50, 20);
    }
    return _titleImageView;
}

- (NinaPagerView *)sliderView {
    if (!_sliderView) {
        NSArray *titleArray = @[@"Assigned", @"Near By", @"Recent"];
        NSMutableArray *vcArray = [NSMutableArray new];
        
        for (int index = 0; index < titleArray.count; index++) {
            HomeListViewController *list = [[HomeListViewController alloc] init];
            switch (index) {
                case 0:
                    list.historyType = HistoryTypeAssigned;
                    break;
                case 1:
                    list.historyType = HistoryTypeNearBy;
                    break;
                case 2:
                    list.historyType = HistoryTypeRecent;
                    break;
                    
                default:
                    break;
            }
            [vcArray addObject:list];
        }
        
        _sliderView = [[NinaPagerView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight)
                                                WithTitles:titleArray
                                               WithObjects:vcArray];
        _sliderView.topTabHeight = 35;
        _sliderView.ninaPagerStyles = NinaPagerStyleStateNormal;
        _sliderView.selectTitleColor = [UIColor ims_colorWithHex:0x129aee];
        _sliderView.unSelectTitleColor = [UIColor ims_colorWithHex:0x222222];
    }
    return _sliderView;
}

@end
