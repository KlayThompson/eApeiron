//
//  HistoryDetailViewController.m
//  Investigator
//
//  Created by Kim on 2017/9/12.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import "IMSAPIManager.h"
#import "HistoryModel.h"
#import "YYModel.h"
#import "RecentIssueCell.h"
#import "NearbyIssueCell.h"
#import "UserInfoManager.h"
#import "IssueDetailView.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"

static NSString *recentCellId = @"RecentIssueCell";
static NSString *nearbyCellId = @"NearbyIssueCell";

@interface HistoryDetailViewController ()<UITableViewDelegate,UITableViewDataSource> {

    NSInteger sectionState[19];

}

@property (weak, nonatomic) IBOutlet UITableView *uTableView;

@property (nonatomic, strong) NSMutableArray <HistoryUnit *>* issuesRecentArray;

@property (nonatomic, strong) NSMutableArray <HistoryUnit *>* issuesNearbyArray;
/**
 经度
 */
@property (nonatomic, copy) NSString *longitude;

/**
 纬度
 */
@property (nonatomic, copy) NSString *latitude;

@end

@implementation HistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    [self loadHistoryFromServer];
}

#pragma mark - 网络
- (void)loadHistoryFromServer {
    
    if (STR_IS_NIL(self.latitude) && STR_IS_NIL(self.longitude)) {
        [SVProgressHUD showInfoWithStatus:@"Unable to determine your location. \n Please check your device's location settings"];
        return;
    }

    
    [SVProgressHUD showWithStatus:IMS_LOADING_MESSAGE];
    __weak typeof(self) weakSelf = self;
    [IMSAPIManager ims_getHistoryWithLatitude:self.latitude
                                    longitude:self.longitude
                                        limit:@"10"
                                     deviceId:[OpenUDID value]
                                        Block:^(id JSON, NSError *error) {
                                            [SVProgressHUD dismiss];
                                            if (error) {
                                                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                            } else {
                                                HistoryModel *model = [HistoryModel yy_modelWithDictionary:JSON];
                                                weakSelf.issuesRecentArray = model.issuesByTime;
                                                weakSelf.issuesNearbyArray = model.issuesByProx;
                                                [weakSelf.uTableView reloadData];
                                                //将Project字典存储
//                                                UserInfoManager *manager = [UserInfoManager shareInstance];
//                                                manager.projectDic = model.projects;
                                            }
        
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (sectionState[section]) {
        //此处判断：逻辑是有数据显示数据，没数据提示没有数据，故也需要一行
        if (section == 0) {//第一行，issuesRecent
            if (ARRAY_IS_NIL(self.issuesRecentArray)) {
                return 1;
            } else {
                return self.issuesRecentArray.count;
            }
        } else if (section == 1) {//issuesNearby，逻辑同上
            if (ARRAY_IS_NIL(self.issuesNearbyArray)) {
                return 1;
            } else {
                return self.issuesNearbyArray.count;
            }
        }
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {//recentIssue
        
        RecentIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:recentCellId forIndexPath:indexPath];
        
        if (ARRAY_IS_NIL(self.issuesRecentArray)) {
            cell.timeLabel.text = @"NO Issues";
            cell.titleLabel.hidden = YES;
            cell.lineView.hidden = YES;
            cell.isusseIdLabel.hidden = YES;
        } else {
            cell.titleLabel.hidden = NO;
            cell.lineView.hidden = NO;
            cell.isusseIdLabel.hidden = NO;
            [cell configCellDataWith:[self.issuesRecentArray objectAtIndex:indexPath.row]];
        }
        
        return cell;
    } else if (indexPath.section == 1) {//nearbyIssue
        
        NearbyIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:nearbyCellId forIndexPath:indexPath];
        
        if (ARRAY_IS_NIL(self.issuesNearbyArray)) {
            cell.distanceLabel.text = @"No Issues";
            cell.lineView1.hidden = YES;
            cell.lineView2.hidden = YES;
            cell.timeLabel.hidden = YES;
            cell.isusseIdLabel.hidden = YES;
        } else {
            [cell configCellDataWith:[self.issuesNearbyArray objectAtIndex:indexPath.row]];
            cell.lineView1.hidden = NO;
            cell.lineView2.hidden = NO;
            cell.timeLabel.hidden = NO;
            cell.isusseIdLabel.hidden = NO;
        }
        
        return cell;
    }
    return [UITableViewCell new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    //返回一个button吧
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, ScreenWidth, 30);
    button.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [button addTarget:self action:@selector(sectionTap:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.tag = 101 + section;
    if (section == 0) {
        [button setTitle:@"Recent Issues" forState:UIControlStateNormal];
        if (sectionState[section] != 0) {
            [button setImage:[UIImage imageNamed:@"issues_on"] forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -133, 0, 0)];
        } else {
            [button setImage:[UIImage imageNamed:@"issues_off"] forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -140, 0, 0)];
        }
    } else if (section == 1) {
        [button setTitle:@"Nearby Issues" forState:UIControlStateNormal];
        if (sectionState[section] != 0) {
            [button setImage:[UIImage imageNamed:@"issues_on"] forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -133, 0, 0)];
        } else {
            [button setImage:[UIImage imageNamed:@"issues_off"] forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -140, 0, 0)];
        }
    } else {
        return [UIView new];
    }
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -150, 0, 0)];
    return button;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && !ARRAY_IS_NIL(self.issuesRecentArray)) {//Recent
        
        HistoryUnit *unit = [self.issuesRecentArray objectAtIndex:indexPath.row];
        [self showIssueDetailViewWithHistoryUnit:unit];
        
    } else if (indexPath.section == 1 && !ARRAY_IS_NIL(self.issuesNearbyArray)) {//Nearby
        
        HistoryUnit *unit = [self.issuesNearbyArray objectAtIndex:indexPath.row];
        [self showIssueDetailViewWithHistoryUnit:unit];
    }
    //donothing
}

#pragma mark - Acrions
- (void)sectionTap:(UIButton *)button {

    NSInteger section = button.tag - 101;
    
    sectionState[section] = !sectionState[section];
    
    [self.uTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)showIssueDetailViewWithHistoryUnit:(HistoryUnit *)unit {
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"IssueDetailView" owner:self options:nil];
    id uv = [nib objectAtIndex:0];
    IssueDetailView *detail = uv;
    
    detail.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    [detail configIssueDetailViewWith:unit];
    //添加到window上面
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.window addSubview:detail];
    
    //增加个简单动画效果吧
    detail.bgView.backgroundColor = [UIColor clearColor];
    detail.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:.3 animations:^{
        detail.layer.affineTransform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        detail.bgView.backgroundColor = [UIColor blackColor];
    }];
}

#pragma mark - 初始化、设置界面

- (void)setupUI {

    [self.uTableView registerNib:[UINib nibWithNibName:@"RecentIssueCell" bundle:nil] forCellReuseIdentifier:recentCellId];
    [self.uTableView registerNib:[UINib nibWithNibName:@"NearbyIssueCell" bundle:nil] forCellReuseIdentifier:nearbyCellId];
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    self.longitude = manager.longitude;
    self.latitude = manager.latitude;
}

- (NSMutableArray<HistoryUnit *> *)issuesRecentArray {
    
    if (_issuesRecentArray == nil) {
        _issuesRecentArray = [NSMutableArray new];
    }
    return _issuesRecentArray;
}

- (NSMutableArray<HistoryUnit *> *)issuesNearbyArray {
    
    if (_issuesNearbyArray == nil) {
        _issuesNearbyArray = [NSMutableArray new];
    }
    return _issuesNearbyArray;
}
- (NSString *)title {
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    return manager.appName;
}

@end
