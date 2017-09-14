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
    [Hud start];
    __weak typeof(self) weakSelf = self;
    [IMSAPIManager ims_getHistoryWithLatitude:self.latitude
                                    longitude:self.longitude
                                        limit:@"10"
                                     deviceId:[OpenUDID value]
                                        Block:^(id JSON, NSError *error) {
                                            [Hud stop];
                                            if (error) {
                                                [Hud showMessage:IMS_ERROR_MESSAGE];
                                            } else {
                                                HistoryModel *model = [HistoryModel yy_modelWithDictionary:JSON];
                                                weakSelf.issuesRecentArray = model.issuesByTime;
                                                weakSelf.issuesNearbyArray = model.issuesByProx;
                                                [weakSelf.uTableView reloadData];
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
        } else {
            [cell configCellDataWith:[self.issuesRecentArray objectAtIndex:indexPath.row]];
        }
        
        return cell;
    } else if (indexPath.section == 1) {//nearbyIssue
        
        NearbyIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:nearbyCellId forIndexPath:indexPath];
        
        if (ARRAY_IS_NIL(self.issuesNearbyArray)) {
            cell.distanceLabel.text = @"No Issues";
        } else {
            [cell configCellDataWith:[self.issuesNearbyArray objectAtIndex:indexPath.row]];
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
        if (sectionState[section] != 0) {
            [button setTitle:@"Recent Issues On" forState:UIControlStateNormal];
        } else {
            [button setTitle:@"Recent Issues Off" forState:UIControlStateNormal];
        }
    } else if (section == 1) {
        if (sectionState[section] != 0) {
            [button setTitle:@"Nearby Issues On" forState:UIControlStateNormal];
        } else {
            [button setTitle:@"Nearby Issues Off" forState:UIControlStateNormal];
        }
    } else {
        return [UIView new];
    }
    
    
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
    
    
}

#pragma mark - Acrions
- (void)sectionTap:(UIButton *)button {

    NSInteger section = button.tag - 101;
    
    sectionState[section] = !sectionState[section];
    
    [self.uTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - 初始化、设置界面

- (void)setupUI {

    [self.uTableView registerNib:[UINib nibWithNibName:@"RecentIssueCell" bundle:nil] forCellReuseIdentifier:recentCellId];
    [self.uTableView registerNib:[UINib nibWithNibName:@"NearbyIssueCell" bundle:nil] forCellReuseIdentifier:nearbyCellId];
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    self.longitude = manager.longitude;
    self.latitude = manager.latitude;
    
    if (STR_IS_NIL(self.latitude) && STR_IS_NIL(self.longitude)) {
        [Hud showMessage:@"Unable to determine your location. \n Please check your device's location settings"];
    }
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

@end
