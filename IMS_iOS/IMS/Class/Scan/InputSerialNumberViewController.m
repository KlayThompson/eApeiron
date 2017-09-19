//
//  InputSerialNumberViewController.m
//  Investigator
//
//  Created by Kim on 2017/9/18.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "InputSerialNumberViewController.h"
#import "IMSAPIManager.h"
#import "UserInfoManager.h"
#import "YYModel.h"
#import "CheckIncidentModel.h"
#import "MainTabBarViewController.h"

@interface InputSerialNumberViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@property (weak, nonatomic) IBOutlet UITextField *serialNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *creatRecordButton;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (nonatomic, assign) BOOL checkState;

@end

@implementation InputSerialNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - Network
- (void)checkIncidentFromServer {

    [Hud start];
    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    NSString *check = self.checkState ? @"1" : @"0";
    __weak typeof (self) weakSelf = self;
    [IMSAPIManager ims_checkIncidentWithProjectId:manager.currentProjectId
                                         deviceId:[OpenUDID value]
                                     serialNumber:self.serialNumberTextField.text
                                         latitude:manager.latitude
                                        longitude:manager.longitude
                                            check:check Block:^(id JSON, NSError *error) {
                                                [Hud stop];
                                                CheckIncidentModel *model = [CheckIncidentModel yy_modelWithDictionary:JSON];
                                                
                                                weakSelf.titleLabel.text = model.title;
                                            }];
    
}

#pragma mark - Actions
- (IBAction)creatRecordButtonTap:(id)sender {
    
    [self.view endEditing:YES];
    
    NSString *tipString = [self checkUserInputState];
    if (!STR_IS_NIL(tipString)) {
        [self showTipAlert:tipString];
        return;
    }
    
    [self checkIncidentFromServer];
}

//点击显示地图
- (IBAction)mapButtonTap:(id)sender {
    MainTabBarViewController *main = (MainTabBarViewController *)self.tabBarController;
    DLog(@"");
}

/**
 检查用户输入用户名密码状态
 
 @return 提示信息
 */
- (NSString *)checkUserInputState {
    
    if ([self.serialNumberTextField.text isEqualToString:@""]) {
        return @"Please enter your Serial Number";
    }
    
    UserInfoManager *manager = [UserInfoManager shareInstance];

    if (STR_IS_NIL(manager.currentProjectId)) {
        return @"Please select a project first";
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

#pragma mark - UI
- (void)setupUI {
    
    self.creatRecordButton.layer.cornerRadius = 5;
    self.creatRecordButton.layer.masksToBounds = true;
    self.creatRecordButton.layer.borderWidth = 1;
    self.creatRecordButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.mapButton.layer.cornerRadius = 5;
    self.mapButton.layer.masksToBounds = true;
    self.mapButton.layer.borderWidth = 1;
    self.mapButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
}


@end
