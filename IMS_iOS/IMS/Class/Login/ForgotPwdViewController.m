//
//  ForgotPwdViewController.m
//  Investigator
//
//  Created by Kim on 2017/11/27.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "ForgotPwdViewController.h"
#import "IMSAPIManager.h"
#import "SVProgressHUD.h"
#import "CommonModel.h"
#import "YYModel.h"

@interface ForgotPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation ForgotPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.layer.masksToBounds = YES;
    
    self.sendButton.layer.borderWidth = 1;
    self.sendButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 70, 30);
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"goback@2x"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (IBAction)sendEmailButtonClick:(id)sender {
    
    if (STR_IS_NIL(self.emailTextfield.text)) {
        [SVProgressHUD showInfoWithStatus:@"please enter the correct mailbox."];
        return;
    }
    
    [IMSAPIManager ims_userForgotPasswordWithEmail:self.emailTextfield.text WithBlock:^(id JSON, NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:IMS_ERROR_MESSAGE];
        } else {
            CommonModel *model = [CommonModel yy_modelWithDictionary:JSON];
            if (model.ErrCode.integerValue == 0) {
                //发送成功
                [SVProgressHUD showSuccessWithStatus:model.Message];
            } else {
                //发送失败
                [SVProgressHUD showErrorWithStatus:model.Message];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goback {
    [self.navigationController popViewControllerAnimated:YES];
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
