//
//  MainNavigationController.m
//  Investigator
//
//  Created by Kim on 2017/9/8.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "MainNavigationController.h"
#import "UserInfoManager.h"
#import "LoginViewController.h"

@interface MainNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needLoginAgain) name:@"IMSNeedLogin" object:nil];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 70, 30);
//    [button setTitle:@"Back" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"navi_home"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
    
    if (self.childViewControllers.count > 1) {
        if (![viewController isKindOfClass:[LoginViewController class]]) {
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            button1.frame = CGRectMake(0, 0, 70, 30);
            [button1 setTitle:@"Back" forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
            [button1 setImage:[UIImage imageNamed:@"goback@2x"] forState:UIControlStateNormal];
            [button1 setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [button1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
        }
    } else {
        if (![viewController isKindOfClass:[LoginViewController class]]) {
            
            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        }
    }

    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)goHome {

    [self popToRootViewControllerAnimated:YES];
}

- (void)goBack {
    [self popViewControllerAnimated:YES];
}

- (void)needLoginAgain {
    UserInfoManager *manager = [UserInfoManager shareInstance];
    [manager clearUserInfo];
    
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    MainNavigationController *navi = [[MainNavigationController alloc] initWithRootViewController:login];
    [[UIApplication sharedApplication].keyWindow setRootViewController:navi];
}

@end
