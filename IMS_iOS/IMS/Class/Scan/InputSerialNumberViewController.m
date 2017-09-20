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

@property (weak, nonatomic) IBOutlet UILabel *productDetailLabel;

/**
 只有扫描成功才是YES，其余全部为NO
 */
@property (nonatomic, assign) BOOL checkState;

@end

@implementation InputSerialNumberViewController

- (void)dealloc {

    //remove notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMS_NOTIFICATION_SCANQRCODESUCCESS object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanSuccessNotifi:) name:IMS_NOTIFICATION_SCANQRCODESUCCESS object:nil];
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
                                                
                                                [weakSelf redrawUIWhenNetworkFinishWith:model];
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
    DLog(@"");
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
    
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.authority.product_image]];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.productImageView.image = [UIImage imageWithData:data];
        });
    });
    
    //更改checkState状态
    if (self.checkState) { //说明是扫码成功进入，需要设置createRecord按钮状态
        self.checkState = NO;
        
        if (model.incident_type.integerValue != 0) {
            self.creatRecordButton.enabled = YES;
        } else {
            self.creatRecordButton.enabled = NO;
        }
    } else {
        
    }
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
}


@end
