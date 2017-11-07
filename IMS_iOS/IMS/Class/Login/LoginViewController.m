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
#import "ProjectListModel.h"

@interface LoginViewController ()<UIAlertViewDelegate>

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
            NSDictionary *messageDic = JSON[@"Message"];
            ProjectListModel *listModel = [ProjectListModel yy_modelWithDictionary:messageDic];
            //保存此json，下次进入若auhtoken没过期则直接使用
            UserInfoManager *manager = [UserInfoManager shareInstance];
            manager.projectResultJson = JSON;
            [manager saveUserInfoToLocal];
            manager.projectsListModel = listModel;
            //通知获取projects成功，刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:IMS_NOTIFICATION_GETPROJECSSUCCESS object:nil];
        }
    }];
}

- (IBAction)changeServerPathUrl:(id)sender {
    UserInfoManager *manager = [UserInfoManager shareInstance];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Change The Default Server Root" message:@"You need to restart APP" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *urlField = [alert textFieldAtIndex:0];
    urlField.placeholder = @"New Server Root";
    urlField.text = manager.serverPathUrl;

    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        UserInfoManager *manager = [UserInfoManager shareInstance];
        UITextField *urlField = [alertView textFieldAtIndex:0];
        [manager saveServerPathUrlwith:urlField.text];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [SVProgressHUD showSuccessWithStatus:@"Change Success\nPlease restart your APP"];
        });
    }
}

- (NSString *)title {
    UserInfoManager *manager = [UserInfoManager shareInstance];
    return manager.appName;
}

@end
