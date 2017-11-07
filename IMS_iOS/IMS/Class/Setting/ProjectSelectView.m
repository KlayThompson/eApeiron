//
//  ProjectSelectView.m
//  Investigator
//
//  Created by Kim on 2017/9/27.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "ProjectSelectView.h"
#import "ProjectSelectCell.h"
#import "ProjectModel.h"
#import "UserInfoManager.h"

static NSString *cellId = @"ProjectSelectCell";

@interface ProjectSelectView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) NSMutableArray <ProjectModel *>*dataArray;
@end

@implementation ProjectSelectView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    
    [self configSelectView];
    
    //增加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelTap)];
    [self addGestureRecognizer:tap];
    tap.delegate = self;
    
    self.uTableView.delegate = self;
    self.uTableView.dataSource = self;
    self.uTableView.tableFooterView = [UIView new];
    [self.uTableView registerNib:[UINib nibWithNibName:@"ProjectSelectCell" bundle:nil] forCellReuseIdentifier:cellId];
}

- (void)configSelectView {
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    self.dataArray = manager.projectsListModel.projects;
}

- (IBAction)cancelButtonTap:(id)sender {
    //将选择状态恢复到上一次结果
    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    for (ProjectModel *model in manager.projectsListModel.projects) {
        if ([model.projectId isEqualToString:manager.currentProjectId]) {
            model.didSelected = YES;
        } else {
            model.didSelected = NO;
        }
    }
    
    [self removeFromSuperview];
}

- (void)cancelTap {
    //将选择状态恢复到上一次结果
    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    for (ProjectModel *model in manager.projectsListModel.projects) {
        if ([model.projectId isEqualToString:manager.currentProjectId]) {
            model.didSelected = YES;
        } else {
            model.didSelected = NO;
        }
    }
    
    [self removeFromSuperview];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProjectSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    ProjectModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell configCellDataWithProjectModel:model];
    
    __weak typeof (self) weakSelf = self;
    cell.SelectButtonTap = ^{
        [weakSelf.uTableView reloadData];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.bgView]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark -
- (NSMutableArray<ProjectModel *> *)dataArray {
    
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
@end
