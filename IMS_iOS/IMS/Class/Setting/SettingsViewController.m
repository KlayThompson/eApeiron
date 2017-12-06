//
//  SettingsViewController.m
//  Investigator
//
//  Created by Kim on 2017/9/11.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "SettingsViewController.h"
#import "IMSAPIManager.h"
#import "UserInfoManager.h"
#import "LoginViewController.h"
#import "MainNavigationController.h"
#import "ProjectSelectView.h"
#import "AppDelegate.h"
#import "ProjectModel.h"
#import "SVProgressHUD.h"
#import "UpdateAccountViewController.h"
#import "CommonModel.h"
#import "YYModel.h"
#import "AboutViewController.h"

@interface SettingsViewController ()<UIPickerViewDelegate,UIPickerViewDataSource> {
    
    ProjectSelectView *detail;
}
@property (weak, nonatomic) IBOutlet UIButton *updateAccountButton;

/**
 选择项目按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *chooseProjectButton;

/**
 退出登录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

/**
 项目选择器
 */
@property (weak, nonatomic) IBOutlet UIPickerView *projectPicker;

/**
 项目名称数组
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 项目选择器底部约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerBottomCons;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;


@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setupUI];
    [self configDataArray];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configDataArray) name:IMS_NOTIFICATION_GETPROJECSSUCCESS object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    //设置选择项目按钮标题
    [self.chooseProjectButton setTitle:manager.currentProjectName forState:UIControlStateNormal];
}

/**
 配置项目数组信息
 */
- (void)configDataArray {

    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    for (ProjectModel *model in manager.projectsListModel.projects) {
        [self.dataArray addObject:model.projectName];
    }
    [self.projectPicker reloadAllComponents];
}

#pragma mark - Actions
/**
 选择项目
 */
- (IBAction)chooseProjectButtonTap:(id)sender {
//    [self showPicker];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ProjectSelectView" owner:self options:nil];
    id uv = [nib objectAtIndex:0];
    detail = uv;
    detail.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [detail.doneButton addTarget:self action:@selector(doneButtonTap) forControlEvents:UIControlEventTouchUpInside];
    //添加到window上面
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.window addSubview:detail];
    
}

/**
 退出登录
 */
- (IBAction)logoutButtonTap:(id)sender {
    
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
}

//更新账户信息
- (IBAction)updateAccountButtonClick:(id)sender {
    
    UpdateAccountViewController *update = [[UpdateAccountViewController alloc] initWithNibName:@"UpdateAccountViewController" bundle:nil];
    update.title = @"UpdateAccount";
    update.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:update animated:YES];
}

/**
 About

 @param sender Button
 */
- (IBAction)aboutButtonClick:(id)sender {
    
    AboutViewController *update = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    update.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:update animated:YES];
}

- (void)doneButtonTap {
    
    [detail removeFromSuperview];
    detail = nil;
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    for (ProjectModel *model in manager.projectsListModel.projects) {
        if (model.didSelected) {//说明选择了她
            //改变按钮文字
            [self.chooseProjectButton setTitle:model.projectName forState:UIControlStateNormal];
            manager.currentProjectName = model.projectName;
            manager.currentProjectId = model.projectId;
            
            [manager saveUserInfoToLocal];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:IMS_NOTIFICATION_CHANGEPROJECT object:nil];
        }
    }
}

- (IBAction)doneButtonTap:(id)sender {
    
    NSInteger index = [self.projectPicker selectedRowInComponent:0];
    
    NSString *str = nil;
    
    if (self.dataArray.count > index) {
        str = [self.dataArray objectAtIndex:index];
    } else {
        DLog(@"Array is nil please check the code or server");
        return;
    }
    DLog(@"--------------%@",str);
    [self hidePicker];
    //改变按钮文字
    [self.chooseProjectButton setTitle:str forState:UIControlStateNormal];
    
    //存储项目名
    UserInfoManager *manager = [UserInfoManager shareInstance];
    manager.currentProjectName = str;
    for (ProjectModel *model in manager.projectsListModel.projects) {
        NSString *value = model.projectName;
        if ([value isEqualToString:str]) {
            manager.currentProjectId = model.projectId;
            break;
        }
    }
    [manager saveUserInfoToLocal];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IMS_NOTIFICATION_CHANGEPROJECT object:nil];
}

- (IBAction)cancelButtonTap:(id)sender {
    [self hidePicker];
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (ARRAY_IS_NIL(self.dataArray)) {
        return 0;
    }
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString *title = self.dataArray[row];
    return title;
}

#pragma mark - 设置界面
- (void)setupUI {
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    //设置选择项目按钮标题
    [self.chooseProjectButton setTitle:manager.currentProjectName forState:UIControlStateNormal];
    
    //设置退出按钮标题
    [self.logoutButton setTitle:[NSString stringWithFormat:@"Logout %@",manager.currentUsername] forState:UIControlStateNormal];
    
    [self setupPicker];
    
    self.chooseProjectButton.layer.cornerRadius = 5;
    self.chooseProjectButton.layer.masksToBounds = true;
    self.chooseProjectButton.layer.borderWidth = 1;
    self.chooseProjectButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        
    self.logoutButton.layer.cornerRadius = 5;
    self.logoutButton.layer.masksToBounds = true;
    self.logoutButton.layer.borderWidth = 1;
    self.logoutButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
 
    self.updateAccountButton.layer.cornerRadius = 5;
    self.updateAccountButton.layer.masksToBounds = true;
    self.updateAccountButton.layer.borderWidth = 1;
    self.updateAccountButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.aboutButton.layer.cornerRadius = 5;
    self.aboutButton.layer.masksToBounds = true;
    self.aboutButton.layer.borderWidth = 1;
    self.aboutButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
     
}

- (void)setupPicker {

    self.projectPicker.delegate = self;
    self.projectPicker.dataSource = self;
}

- (void)showPicker {
    
    [UIView animateWithDuration:0.35 animations:^{
        
        self.pickerBottomCons.constant = 0.0f;
        
        [self.view layoutIfNeeded];
        
    } completion:nil];
}

- (void)hidePicker {
    
    [UIView animateWithDuration:0.35 animations:^{
        self.pickerBottomCons.constant = -216;
        [self.view layoutIfNeeded];
    }];
    
}

#pragma mark - 初始化
- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
