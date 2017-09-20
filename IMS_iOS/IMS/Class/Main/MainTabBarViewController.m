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

@interface MainTabBarViewController ()<AVMetadataDelegate,UITabBarDelegate>


@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
        AVMetadataController *scan = [[AVMetadataController alloc] init];
        [scan setDelegate:self];
        [self presentViewController:scan animated:NO completion:nil];

    }
}

- (NSString *)title {
    return @"标题";
}



@end
