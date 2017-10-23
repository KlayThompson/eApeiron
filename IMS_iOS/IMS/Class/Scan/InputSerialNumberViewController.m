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
#import "YYWebImage.h"
#import "ProjectModel.h"
#import "UIColor+Addtions.h"
#import "SVProgressHUD.h"
#import "ShowMapViewController.h"

@interface InputSerialNumberViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@property (weak, nonatomic) IBOutlet UITextField *serialNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *creatRecordButton;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *productDetailLabel;

/**
 需要check才是YES
 */
@property (nonatomic, assign) BOOL checkState;

@property (nonatomic, copy) NSString *mapUrl;
@end

@implementation InputSerialNumberViewController

- (void)dealloc {

    //remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMS_NOTIFICATION_SCANQRCODESUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMS_NOTIFICATION_SCANQRCODECANCEL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMS_NOTIFICATION_CHANGEPROJECT object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanSuccessNotifi:) name:IMS_NOTIFICATION_SCANQRCODESUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanCancelNotifi:) name:IMS_NOTIFICATION_SCANQRCODECANCEL object:nil];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.creatRecordButton.enabled = YES;
    self.creatRecordButton.backgroundColor = [UIColor ims_colorWithHex:0xf5f5f5];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - Network
- (void)checkIncidentFromServer {

    [SVProgressHUD showWithStatus:IMS_LOADING_MESSAGE];
    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    NSString *check = self.checkState ? @"1" : @"0";
    __weak typeof (self) weakSelf = self;
    [IMSAPIManager ims_checkIncidentWithProjectId:manager.currentProjectId
                                         deviceId:[OpenUDID value]
                                     serialNumber:self.serialNumberTextField.text
                                         latitude:manager.latitude
                                        longitude:manager.longitude
                                            check:check Block:^(id JSON, NSError *error) {
                                                [SVProgressHUD dismiss];
                                                if (error) {
                                                    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                                } else {
                                                    CheckIncidentModel *model = [CheckIncidentModel yy_modelWithDictionary:JSON];
                                                    [weakSelf redrawUIWhenNetworkFinishWith:model];
                                                }
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
    DLog(@"点击了map");
    ShowMapViewController *showMap = [[ShowMapViewController alloc] initWithNibName:@"ShowMapViewController" bundle:nil];
    showMap.mapUrl = self.mapUrl;
    showMap.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:showMap animated:true];
}

#pragma mark - Custom Methoud
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

//取消扫描处理
- (void)scanCancelNotifi:(NSNotification *)notify {
    
    //设置按钮
    [self.creatRecordButton setTitle:@"Submit" forState:UIControlStateNormal];
    self.checkState = YES;
}

//扫描成功，进行处理
- (void)scanSuccessNotifi:(NSNotification *)notify {
    
    self.checkState = YES;
    //获取tabbar，取得扫描的serial
    MainTabBarViewController *main = (MainTabBarViewController *)self.tabBarController;
    self.serialNumberTextField.text = main.serial;
    //checkIncident
    [self checkIncidentFromServer];
}

//网络加载成功后，进行一些界面上的处理
- (void)redrawUIWhenNetworkFinishWith:(CheckIncidentModel *)model {
    
    self.titleLabel.text = model.title;
    
    self.productDetailLabel.text = model.authority.product_details;
    
    [self.productImageView yy_setImageWithURL:[NSURL URLWithString:model.authority.product_image] placeholder:[UIImage imageNamed:IMS_DEFAULT_IMAGE]];
    //更改checkState状态
    if (self.checkState) {
        
        //无论是扫码成功还是取消，在这统一将按钮文字更改为creatRecord
        [self.creatRecordButton setTitle:@"Create Record" forState:UIControlStateNormal];
        
        self.checkState = NO;
        
        if (model.incident_type.integerValue != 0) {
            self.creatRecordButton.enabled = YES;
            self.creatRecordButton.backgroundColor = [UIColor ims_colorWithHex:0xf5f5f5];
        } else {
            self.creatRecordButton.enabled = NO;//这里禁用了，哪里可以启用？1.每次界面显示的时候 2.输入框重新编辑的时候
            self.creatRecordButton.backgroundColor = [UIColor lightGrayColor];
        }
    } else {
        
    }
    
    //model.url 不为空显示map按钮
    if (STR_IS_NIL(model.url)) {
        self.mapButton.hidden = YES;
    } else {
        self.mapButton.hidden = NO;
    }
    self.mapUrl = model.url;
}

#pragma mark -
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.checkState = YES;
    //开始编辑，按钮可以点击
    self.creatRecordButton.enabled = YES;
    self.creatRecordButton.backgroundColor = [UIColor ims_colorWithHex:0xf5f5f5];
    //更改的话就是自己手动输入，按钮标题需要更改为submit
    [self.creatRecordButton setTitle:@"Submit" forState:UIControlStateNormal];
    return YES;
}
#pragma mark - UI
- (void)setupUI {
    
    self.productDetailLabel.text = @"";
    self.titleLabel.text = @"";
    
    self.creatRecordButton.layer.cornerRadius = 5;
    self.creatRecordButton.layer.masksToBounds = true;
    self.creatRecordButton.layer.borderWidth = 1;
    self.creatRecordButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.mapButton.layer.cornerRadius = 5;
    self.mapButton.layer.masksToBounds = true;
    self.mapButton.layer.borderWidth = 1;
    self.mapButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    [self setupTopImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupTopImage) name:IMS_NOTIFICATION_CHANGEPROJECT object:nil];
}

- (void)setupTopImage {
    
    //    BOOL ss = YYImageWebPAvailable();
    UserInfoManager *manager = [UserInfoManager shareInstance];
    //获取当前Project
    for (ProjectModel *model in manager.projectAllInfoArray) {
        if ([manager.currentProjectId isEqualToString:model.projectId]) {
            [self.topImageView yy_setImageWithURL:[NSURL URLWithString:model.projectDetailModel.mobileLogo] placeholder:[UIImage imageNamed:IMS_DEFAULT_IMAGE]];
        }
    }
}

@end
