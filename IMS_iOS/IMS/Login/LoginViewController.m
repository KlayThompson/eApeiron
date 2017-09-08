//
//  LoginViewController.m
//  Investigator
//
//  Created by Kim on 2017/9/8.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarViewController.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

//设置界面
- (void)setupUI {

    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
    
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

//点击登录按钮
- (IBAction)loginButtonTap:(id)sender {
    
    //登录成功更换rootViewController
    MainTabBarViewController *tabbar = [[MainTabBarViewController alloc] init];
    tabbar.userLogin = YES;
    [UIApplication.sharedApplication.keyWindow setRootViewController:tabbar];
    [tabbar setRootViewController];
}


- (NSString *)title {
    return @"登录";
}

@end
