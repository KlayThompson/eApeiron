//
//  UpdateAccountViewController.m
//  Investigator
//
//  Created by Kim on 2017/11/27.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "UpdateAccountViewController.h"
#import "SVProgressHUD.h"
#import "YYModel.h"
#import "CommonModel.h"
#import "IMSAPIManager.h"
#import "LoginViewController.h"
#import "UserInfoManager.h"
#import "MainNavigationController.h"
#import "RegExCategories.h"

@interface UpdateAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextfield;


@end

@implementation UpdateAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.okButton.layer.cornerRadius = 5;
    self.okButton.layer.masksToBounds = true;
    self.okButton.layer.borderWidth = 1;
    self.okButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.emailLabel.hidden = YES;
    self.emailTextField.hidden = YES;
    if (self.forChangePassword) {
        self.noteLabel.text = @"NOTE: you need change your password";
    } else {
//        self.emailTextField.hidden = NO;
//        self.emailLabel.hidden = NO;
        self.noteLabel.text = @"";
    }

    [self.oldPasswordTextfield becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)okButtonClick:(id)sender {
    
//    if (STR_IS_NIL(self.passwordTextfield.text) && STR_IS_NIL(self.emailTextField.text)) {
//        [SVProgressHUD showInfoWithStatus:@"at least one of the arguments shall be provided"];
//        return;
//    }
    
    //check user input current password
    UserInfoManager *manager = [UserInfoManager shareInstance];
    if (STR_IS_NIL(self.oldPasswordTextfield.text)) {
        [SVProgressHUD showInfoWithStatus:@"please enter your current password"];
        return;
    } else if(![self.oldPasswordTextfield.text isEqualToString:manager.currentUserPassword]) {
        [SVProgressHUD showInfoWithStatus:@"current password error"];
        return;
    } else {
        //to be continue
    }
    
    if (STR_IS_NIL(self.passwordTextfield.text)) {
        [SVProgressHUD showInfoWithStatus:@"please enter your new password"];
        return;
    }
    
    if (self.passwordTextfield.text.length < 6) {
        [SVProgressHUD showInfoWithStatus:@"the password must length > 5"];
        return;
    }
    
    //verify newpassword correct
    if (![self.passwordTextfield.text isMatch:RX(@"^(?=.*[0-9].*)(?=.*[A-Z].*)(?=.*[a-z].*)")]) {
        [SVProgressHUD showInfoWithStatus:@"the password must contain at least one uppercase letter one lower case letter and one number"];
        return;
    }
    
    [self.view endEditing:YES];
    
    NSString *newEmail = @"";
    NSString *newPwd = @"";
    if (STR_IS_NIL(self.passwordTextfield.text)) {
        newPwd = nil;
    } else {
        newPwd = self.passwordTextfield.text;
    }
    
    if (STR_IS_NIL(self.emailTextField.text)) {
        newEmail = nil;
    } else {
        newEmail = self.emailTextField.text;
    }
    __weak typeof (self) weakSelf = self;
    [SVProgressHUD showWithStatus:IMS_LOADING_MESSAGE];
    [IMSAPIManager ims_userUpdateAccountNewPassword:newPwd newEmail:newEmail WithBlock:^(id JSON, NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [SVProgressHUD showErrorWithStatus:IMS_ERROR_MESSAGE];
        } else {
            CommonModel *model = [CommonModel yy_modelWithDictionary:JSON];
            if (model.ErrCode.integerValue == 0) {//成功
                [SVProgressHUD showSuccessWithStatus:model.Message];
                [weakSelf userLogout];
            } else {//失败
                [SVProgressHUD showErrorWithStatus:model.Message];
            }
        }
    }];
    
}

- (void)userLogout {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [SVProgressHUD showWithStatus:IMS_LOADING_MESSAGE];
        [IMSAPIManager ims_userLogoutWithBlock:^(id JSON, NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                [SVProgressHUD showErrorWithStatus:IMS_ERROR_MESSAGE];
            } else {
                CommonModel *model = [CommonModel yy_modelWithDictionary:JSON];
                if (model.code.integerValue == 200) {
                    //退出登录成功
                    [SVProgressHUD showSuccessWithStatus:model.response];
                    UserInfoManager *manager = [UserInfoManager shareInstance];
                    [manager clearUserInfo];
                    
                    //显示登录页面
                    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                    MainNavigationController *navi = [[MainNavigationController alloc] initWithRootViewController:login];
                    [[UIApplication sharedApplication].keyWindow setRootViewController:navi];
                } else {
                    //失败
                    [SVProgressHUD showErrorWithStatus:model.response];
                }
            }
        }];
    });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
