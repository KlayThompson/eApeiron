//
//  AppDelegate.m
//  IMS
//
//  Created by Kim on 14/12/19.
//  Copyright (c) 2014年 kodak. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h" 
#import "MainTabBarViewController.h"
#import "ProjectModel.h"
#import "SVProgressHUD.h"
#import "YYModel.h"
#import "IMSAPIManager.h"
#import "MainNavigationController.h"
#import "HomeRootViewController.h"
#import "LoginViewController.h"

@interface AppDelegate () <UIAlertViewDelegate>
{
    BOOL _changeURL;
}
@end

@implementation AppDelegate
//1.1

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    HomeViewController *view = [[HomeViewController alloc] init];
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];

    [self setupAppInfo];
    
    [self checkUserLoginState];
    
    
//    MainTabBarViewController *tabbar = [[MainTabBarViewController alloc] init];
    UserInfoManager *manager = [UserInfoManager shareInstance];
    if (manager.userLogin) {
        HomeRootViewController *detail = [[HomeRootViewController alloc] initWithNibName:@"HistoryDetailViewController" bundle:nil];
        MainNavigationController *navi = [[MainNavigationController alloc] initWithRootViewController:detail];
        [self.window setRootViewController:navi];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
    } else {
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        MainNavigationController *navi = [[MainNavigationController alloc] initWithRootViewController:login];
        [self.window setRootViewController:navi];
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
    }
    
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:3];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
//    [self showLaunchImage];

    return YES;
}

- (void)showLaunchImage
{
    _changeURL = NO;
    
    //
    NSString *imageName = @"";
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, self.window.bounds.size) && [@"Portrait" isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            imageName = dict[@"UILaunchImageName"];
        }
    }
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];

    UIImage *image = [UIImage imageNamed:imageName];
    
    UIImageView *launchImage = [[UIImageView alloc] initWithFrame:self.window.bounds];
    [launchImage setImage:image];
    [launchImage setUserInteractionEnabled:YES];
    [launchImage setTag:11111];
    [self.window insertSubview:launchImage aboveSubview:self.window.rootViewController.view];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeRootURL)];
    [tap setNumberOfTapsRequired:3];
//    [launchImage addGestureRecognizer:tap];
    
    
    //
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!_changeURL) {
            [self removeLaunch];
        }
    });
}
- (void)removeLaunch
{
    UIImageView *launchImage = (UIImageView *)[self.window viewWithTag:11111];
    [launchImage removeFromSuperview];
//    [(HomeViewController *)self.window.rootViewController updateLoad];
}
- (void)changeRootURL
{
    _changeURL = YES;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Change The Default Server Root" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    UITextField *urlField = [alertView textFieldAtIndex:0];
    [urlField setSecureTextEntry:NO];
    urlField.placeholder = @"New Server Root";
    urlField.text = [HostURL defaultManager].hostURL;
    
    [alertView setDelegate:self];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        UITextField *urlField = [alertView textFieldAtIndex:0];
        //TODO
        NSLog(@"url: %@",urlField.text);
        [[HostURL defaultManager] changeHostURL:urlField.text];
    }
    else {
    }
    
    [self removeLaunch];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //是否需要检查有没有超过半小时
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupAppInfo {
    
    //设置server
    UserInfoManager *manager = [UserInfoManager shareInstance];
    [manager getServerPathUrl];
}

/**
 检查用户登录状态
 */
- (void)checkUserLoginState {

    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    [manager getUserInfo];
    
    NSString *authToken = manager.authToken;
    
    if (STR_IS_NIL(authToken) || [manager checkUserShouldLoginAgain]) {
        manager.userLogin = NO;
    } else {
        manager.userLogin = YES;
        //需要解析一下保存在本地的Project信息
        if (!DICT_IS_NIL(manager.projectResultJson)) {
            NSDictionary *message = manager.projectResultJson[@"Message"];
            ProjectListModel *listModel = [ProjectListModel yy_modelWithDictionary:message];
            manager.projectsListModel = listModel;
        }
        
    }
    
}

@end
