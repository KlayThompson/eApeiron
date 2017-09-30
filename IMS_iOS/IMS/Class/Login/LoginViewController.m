//
//  LoginViewController.m
//  Investigator
//
//  Created by Kim on 2017/9/8.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import "IMSAPIManager.h"
#import "UserInfoManager.h"
#import "ProjectModel.h"
#import "YYModel.h"
#import "SVProgressHUD.h"

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
    
    [self.view endEditing:YES];
    
    NSString *tipString = [self checkUserInputState];
    if (!STR_IS_NIL(tipString)) {
        [self showTipAlert:tipString];
        return;
    }
    
    [SVProgressHUD showWithStatus:IMS_LOADING_MESSAGE];
    __weak typeof (self) weakSelf = self;
    [IMSAPIManager ims_getAuthTokenWithUsername:self.usernameTextField.text
                                       password:self.passwordTextField.text
                                          Block:^(id JSON, NSError *error) {
                                              [SVProgressHUD dismiss];
                                              if (error) {
                                                  [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                              } else {
                                                  [SVProgressHUD showSuccessWithStatus:@"Login Success"];

                                                  [weakSelf doSomeWorkWhenLoginSuccess];
                                              }
                                          }];
    
}

/**
 检查用户输入用户名密码状态

 @return 提示信息
 */
- (NSString *)checkUserInputState {
    
    if ([self.usernameTextField.text isEqualToString:@""]) {
        return @"Please enter your username";
    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
        return @"Please enter your password";
    }
    return @"";
}

//提示填写信息弹窗
- (void)showTipAlert:(NSString *)message {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 登录成功后做一些操作
 */
- (void)doSomeWorkWhenLoginSuccess {
    //更换rootViewController
    MainTabBarViewController *tabbar = [[MainTabBarViewController alloc] init];
    [UIApplication.sharedApplication.keyWindow setRootViewController:tabbar];
    [tabbar setRootViewController];
    
    [self getProects];
}

/**
 获取项目列表
 */
- (void)getProects {
    
    [IMSAPIManager ims_getProjectsWithBlock:^(id JSON, NSError *error) {
        if (error) {
        } else {
            ProjectModel *model = [[ProjectModel alloc] init];
            //保存此json，下次进入若auhtoken没过期则直接使用
            UserInfoManager *manager = [UserInfoManager shareInstance];
            manager.projectResultJson = JSON;
            [manager saveUserInfoToLocal];
            [model encodeDataWithJson:JSON];
            //通知获取projects成功，刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:IMS_NOTIFICATION_GETPROJECSSUCCESS object:nil];
        }
    }];
}

- (NSString *)title {
    UserInfoManager *manager = [UserInfoManager shareInstance];
    return manager.appName;
}

@end
