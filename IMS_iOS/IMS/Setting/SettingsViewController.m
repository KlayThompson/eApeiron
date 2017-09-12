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

@interface SettingsViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

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
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setupUI];
    [self getProects];
}

#pragma mark - 网络
- (void)getProects {
    
    __weak typeof(self) weakSelf = self;
    [Hud start];
    [IMSAPIManager ims_getProjectsWithBlock:^(id JSON, NSError *error) {
        [Hud stop];
        if (error) {
            [Hud showMessage:@"获取项目列表失败"];
        } else {
            [weakSelf configDataArray];
            [self.projectPicker reloadAllComponents];
        }
    }];
}

/**
 配置项目数组信息
 */
- (void)configDataArray {

    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    for (NSString *value in manager.projectDic.allValues) {
        [self.dataArray addObject:value];
    }
}

#pragma mark - Actions
/**
 选择项目
 */
- (IBAction)chooseProjectButtonTap:(id)sender {
    [self showPicker];
}

/**
 退出登录
 */
- (IBAction)logoutButtonTap:(id)sender {
    
    [Hud start];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [Hud stop];
        
        UserInfoManager *manager = [UserInfoManager shareInstance];
        [manager clearUserInfo];
        
        //显示登录页面
        LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        MainNavigationController *navi = [[MainNavigationController alloc] initWithRootViewController:login];
        [[UIApplication sharedApplication].keyWindow setRootViewController:navi];
    });
}

- (IBAction)doneButtonTap:(id)sender {
    
    NSInteger index = [self.projectPicker selectedRowInComponent:0];
    
    NSString *str = nil;
    
    if (self.dataArray.count > index) {
        str = [self.dataArray objectAtIndex:index];
    }
    DLog(@"--------------%@",str);
    [self hidePicker];
    //改变按钮文字
    [self.chooseProjectButton setTitle:str forState:UIControlStateNormal];
    
    //存储项目名
    UserInfoManager *manager = [UserInfoManager shareInstance];
    manager.currentProjectName = str;
    [manager saveUserInfoToLocal];
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
    
    //添加一个手势，使得再显示选择矿的时候，点击其他地方隐藏Project选择框
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker)];
    [self.view addGestureRecognizer:tap];
    
    [self setupPicker];
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
