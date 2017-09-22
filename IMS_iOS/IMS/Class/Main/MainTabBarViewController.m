//
//  MainTabBarViewController.m
//  Investigator
//
//  Created by Kim on 2017/9/8.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "LoginViewController.h"
#import "MainNavigationController.h"
#import "HomeViewController.h"
#import "ScanViewController.h"
#import "SettingsViewController.h"
#import "IMSAPIManager.h"
#import "AppDelegate.h"
#import "InputSerialNumberViewController.h"

@interface MainTabBarViewController ()<AVMetadataDelegate,UITabBarDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITabBarControllerDelegate>

@property (nonatomic, strong) UIPickerView *projectPicker;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UILabel *titleLabel;

/**
 项目名称数组
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self setRootViewController];
    
}

- (void)setRootViewController {

    UserInfoManager *manager = UserInfoManager.shareInstance;
    if (manager.userLogin) {
        //显示主界面
        self.tabBar.hidden = NO;
        self.viewControllers = [self setLoginSuccessViewController];
        
    } else {
        //显示登录界面
        LoginViewController *login = [[LoginViewController alloc] init];
        MainNavigationController *navi = [[MainNavigationController alloc] initWithRootViewController:login];
        self.tabBar.hidden = YES;
        self.viewControllers = @[navi];
    }
    
}

- (NSArray<UIViewController *> *)setLoginSuccessViewController {

    //Home
    HomeViewController *home = [[HomeViewController alloc] init];
    home.title = @"Home";
    home.tabBarItem.image = [UIImage imageNamed:@"ic_menu_home"];
    home.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_menu_home_selected"];
    MainNavigationController *homeNavi = [[MainNavigationController alloc] initWithRootViewController:home];

    //Scan
    InputSerialNumberViewController *scan = [[InputSerialNumberViewController alloc] initWithNibName:@"InputSerialNumberViewController" bundle:nil];
    scan.title = @"Scan";
    scan.tabBarItem.image = [UIImage imageNamed:@"ic_scan"];
    scan.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_scan_selected"];
    MainNavigationController *scanNavi = [[MainNavigationController alloc] initWithRootViewController:scan];

    //Setting
    SettingsViewController *setting = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    setting.title = @"Settings";
    setting.tabBarItem.image = [UIImage imageNamed:@"ic_settings"];
    setting.tabBarItem.selectedImage = [UIImage imageNamed:@"ic_settings_selected"];
    MainNavigationController *settingNavi = [[MainNavigationController alloc] initWithRootViewController:setting];

    NSArray *items = @[homeNavi, scanNavi, settingNavi];
    
    return items;
}

- (void)returnSerial:(NSString *)serial covertSerial:(NSString *)covertSerial {
    DLog(@"");
    //如果两个都为空则是点击取消按钮
    if (STR_IS_NIL(serial) && STR_IS_NIL(covertSerial)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IMS_NOTIFICATION_SCANQRCODECANCEL object:nil];
    } else {
        //扫描成功，发送通知，通知CHECKINCIDENT
        self.serial = serial;
        self.covertSerial = covertSerial;
        [[NSNotificationCenter defaultCenter] postNotificationName:IMS_NOTIFICATION_SCANQRCODESUCCESS object:nil];
    }
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if ([item.title isEqualToString:@"Scan"]) {
        UserInfoManager *manager = [UserInfoManager shareInstance];
        if (STR_IS_NIL(manager.currentProjectName)) {
            return;
        } else {
            [self jumpToScan];
        }
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    MainNavigationController *main = (MainNavigationController *)viewController;
    if (!ARRAY_IS_NIL(main.viewControllers)) {
        if ([main.viewControllers.firstObject isKindOfClass: [InputSerialNumberViewController class]]) {
            //先判断是否已经选择Project，未选择弹出提示框选择
            UserInfoManager *manager = [UserInfoManager shareInstance];
            if (STR_IS_NIL(manager.currentProjectName)) {//为空要选择
                [self.dataArray removeAllObjects];
                for (NSString *value in manager.projectDic.allValues) {
                    [self.dataArray addObject:value];
                }
                [self.projectPicker reloadAllComponents];
                self.cancelButton.hidden = NO;
                self.doneButton.hidden = NO;
                self.titleLabel.hidden = NO;
                [self showPicker];
                return NO;
            }
        }
    }
    return YES;
}

#pragma UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (ARRAY_IS_NIL(self.dataArray)) {
        return 0;
    }
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = self.dataArray[row];
    return title;
}

#pragma mark - Picker相关
- (void)showPicker {
    
    [UIView animateWithDuration:0.35 animations:^{
        self.projectPicker.frame = CGRectMake(0, ScreenHeight - 216, ScreenWidth, 216);
        self.cancelButton.frame = CGRectMake(10, ScreenHeight - 216, 70, 35);
        self.doneButton.frame = CGRectMake(ScreenWidth - 10 - 70, ScreenHeight - 216, 70, 35);
        self.titleLabel.frame = CGRectMake(80, ScreenHeight - 216, ScreenWidth - 80*2, 35);
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)hidePickerWithChooseSuccess:(BOOL)chooseSuccess {
    
    [UIView animateWithDuration:0.35 animations:^{
        self.projectPicker.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 216);
        self.cancelButton.frame = CGRectMake(10, ScreenHeight, 70, 35);
        self.doneButton.frame = CGRectMake(ScreenWidth - 10 - 70, ScreenHeight, 70, 35);
        self.titleLabel.frame = CGRectMake(80, ScreenHeight, ScreenWidth - 80*2, 35);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
      
        if (chooseSuccess) {
            self.selectedIndex = 1;
            [self jumpToScan];
        }
    }];
    
}

- (void)doneButtonTap {
    
    NSInteger index = [self.projectPicker selectedRowInComponent:0];
    
    NSString *str = nil;
    
    if (self.dataArray.count > index) {
        str = [self.dataArray objectAtIndex:index];
    } else {
        DLog(@"Array is nil please check the code or server");
        return;
    }
    DLog(@"--------------%@",str);
    [self hidePickerWithChooseSuccess:YES];
    
    //存储项目名
    UserInfoManager *manager = [UserInfoManager shareInstance];
    manager.currentProjectName = str;
    for (NSString *key in manager.projectDic.allKeys) {
        NSString *value = manager.projectDic[key];
        if ([value isEqualToString:str]) {
            manager.currentProjectId = key;
            break;
        }
    }
    [manager saveUserInfoToLocal];
}

- (void)jumpToScan {
    AVMetadataController *scan = [[AVMetadataController alloc] init];
    [scan setDelegate:self];
    [self presentViewController:scan animated:NO completion:nil];
}

#pragma mark - 初始化
- (UIPickerView *)projectPicker {
    
    if (_projectPicker == nil) {
        _projectPicker = [[UIPickerView alloc] init];
        _projectPicker.delegate = self;
        _projectPicker.dataSource = self;
        _projectPicker.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 216);
        _projectPicker.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [self.view addSubview:_projectPicker];
    }
    return _projectPicker;
}

- (UIButton *)cancelButton {
    
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.hidden = YES;
        [_cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _cancelButton.frame = CGRectMake(10, ScreenHeight, 70, 35);
        [_cancelButton addTarget:self action:@selector(hidePickerWithChooseSuccess:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (UIButton *)doneButton {
    
    if (_doneButton == nil) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.hidden = YES;
        [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _doneButton.frame = CGRectMake(ScreenWidth - 10 - 70, ScreenHeight, 70, 35);
        [_doneButton addTarget:self action:@selector(doneButtonTap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_doneButton];
    }
    return _doneButton;
}

- (UILabel *)titleLabel {
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, ScreenHeight, ScreenWidth - 80*2, 35)];
        _titleLabel.text = @"Choose Project";
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_titleLabel];
        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}

- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSString *)title {
    return @"标题";
}



@end
