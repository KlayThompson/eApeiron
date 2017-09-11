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
    
    [self setupPicker];
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
