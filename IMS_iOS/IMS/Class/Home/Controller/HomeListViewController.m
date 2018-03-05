//
//  HomeListViewController.m
//  Investigator
//
//  Created by Kim on 2018/3/2.
//  Copyright © 2018年 kodak. All rights reserved.
//

#import "HomeListViewController.h"
#import "SVProgressHUD.h"
#import "UserInfoManager.h"
#import "IMSAPIManager.h"
#import "NearbyIssueCell.h"
#import "HistoryModel.h"
#import "YYModel.h"
#import "DetailIssueView.h"
#import "AppDelegate.h"
#import "ShowMapViewController.h"

static NSString *nearbyCellId = @"NearbyIssueCell";

@interface HomeListViewController ()<UITableViewDelegate,UITableViewDataSource> {
 

}

@property (nonatomic, strong) UITableView *uTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    [self loadHistoryFromServer];
}

#pragma mark - 网络
- (void)loadHistoryFromServer {
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    if (STR_IS_NIL(manager.latitude) && STR_IS_NIL(manager.longitude)) {
        [SVProgressHUD showInfoWithStatus:@"Unable to determine your location. \n Please check your device's location settings"];
        return;
    }
    NSString *pId = manager.currentProjectId;
    if (STR_IS_NIL(pId)) {
        pId = @"";
    }
    
    NSString *type = @"";
    switch (self.historyType) {
        case 0:
            type = @"assigned";
            break;
        case 1:
            type = @"nearby";
            break;
        case 2:
            type = @"recent";
            break;
            
        default:
            break;
    }
    
    [SVProgressHUD showWithStatus:IMS_LOADING_MESSAGE];
    __weak typeof(self) weakSelf = self;
    [IMSAPIManager ims_getHistoryWithLatitude:manager.latitude
                                    longitude:manager.longitude
                                        limit:@"10"
                                          pId:pId
                                       offset:@"0"
                                         type:type
                                        Block:^(id JSON, NSError *error) {
                                            [SVProgressHUD dismiss];
                                            if (error) {
                                                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                            } else {
                                                if (!DICT_IS_NIL(JSON)) {
                                                    [weakSelf praseJsonDataWith:JSON];
                                                } else {
                                                    NSAssert(0, @"");
                                                }
                                            }
                                            
                                        }];
}

- (void)praseJsonDataWith:(NSDictionary *)json {
    
    NSDictionary *messageDic = json[@"Message"];
    NSDictionary *dataDic = [NSDictionary new];
    switch (self.historyType) {
        case 0:
            dataDic = messageDic[@"assignedIncidents"];
            break;
        case 1:
            dataDic = messageDic[@"nearbyIncidents"];
            break;
        case 2:
            dataDic = messageDic[@"recentIncidents"];
            break;
            
        default:
            break;
    }
    
    if (DICT_IS_NIL(dataDic)) {
        return;
    }
    
    HistoryModel *model = [HistoryModel yy_modelWithDictionary:dataDic];
    self.dataArray = [model.data mutableCopy];
    [self.uTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (ARRAY_IS_NIL(self.dataArray)) {
        return 0;
    } else {
        return self.dataArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NearbyIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:nearbyCellId forIndexPath:indexPath];
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    [cell configCellDataWith:dict];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
    [self showDetailIssueViewWith:dic];
}

#pragma mark - Custom Method & Action
- (void)showDetailIssueViewWith:(NSDictionary *)dict {
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"DetailIssueView" owner:self options:nil];
    id uv = [nib objectAtIndex:0];
    
    DetailIssueView *issueView = uv;
    [issueView configDetailIssueViewWith:dict];
    
    issueView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    //添加到window上面
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [app.window addSubview:issueView];
    
    [issueView.mapButton addTarget:self action:@selector(jumpToMapDetailView) forControlEvents:UIControlEventTouchUpInside];
}

//跳转到地图界面
- (void)jumpToMapDetailView {
    UserInfoManager *manager = [UserInfoManager shareInstance];

    NSString *expectLat = @"";
    NSString *expectLng = @"";
    //
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    for (UIView *subview in app.window.subviews) {
        if ([subview isKindOfClass:[DetailIssueView class]]) {
            DetailIssueView *issueView = (DetailIssueView *)subview;
            expectLat = issueView.lat;
            expectLng = issueView.lng;
            [subview removeFromSuperview];
        }
    }
    
    //创建markInfo
    NSMutableArray *markersInfo = [NSMutableArray new];
    MarkersInfoModel *current = [MarkersInfoModel new];
    current.color = @"blue";
    current.lat = manager.latitude;
    current.lng = manager.longitude;
    current.type = @"current";
    current.zoom = @14;
    
    MarkersInfoModel *expect = [MarkersInfoModel new];
    expect.color = @"red";
    expect.lat = expectLat;
    expect.lng = expectLng;
    expect.type = @"expect";
    expect.zoom = @14;
    
    [markersInfo addObject:current];
    [markersInfo addObject:expect];
    
    ShowMapViewController *showMap = [[ShowMapViewController alloc] initWithNibName:@"ShowMapViewController" bundle:nil];
    showMap.markersInfo = markersInfo;
    showMap.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:showMap animated:true];
}

#pragma mark - UI
- (void)setupUI {
    
    [self.view addSubview:self.uTableView];
}

#pragma mark - 初始化
- (UITableView *)uTableView {
    
    if (_uTableView == nil) {
        _uTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _uTableView.delegate = self;
        _uTableView.dataSource = self;
        [_uTableView registerNib:[UINib nibWithNibName:@"NearbyIssueCell" bundle:nil] forCellReuseIdentifier:@"NearbyIssueCell"];
    }
    return _uTableView;
}

@end
