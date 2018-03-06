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
#import "MJRefresh.h"
#import "UIView+Size.h"
#import "Masonry.h"
#import "AVMetadataController.h"
#import "InputSerialNumberViewController.h"

static NSString *nearbyCellId = @"NearbyIssueCell";
#define PageSize 10
#define BottomViewHeight 60

@interface HomeListViewController ()<UITableViewDelegate,UITableViewDataSource,AVMetadataDelegate> {
 
    NSInteger currentPageIndex;
    NSInteger offset;
}

@property (nonatomic, strong) UITableView *uTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *bottomBgView;

@end

@implementation HomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
}

#pragma mark - 网络
- (void)refreshDataFormServer {
    [self loadHistoryFromServer:1];
}

- (void)loadMoreDataFormServer {
    [self loadHistoryFromServer:currentPageIndex+1];
}

- (void)loadHistoryFromServer:(NSInteger)targetPageIndex {
    
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
    
    if (targetPageIndex == 1) {
        offset = 0;
    }
    
    __weak typeof(self) weakSelf = self;
    [IMSAPIManager ims_getHistoryWithLatitude:manager.latitude
                                    longitude:manager.longitude
                                        limit:[NSString stringWithFormat:@"%d",PageSize]
                                          pId:pId
                                       offset:[NSString stringWithFormat:@"%ld",offset]
                                         type:type
                                        Block:^(id JSON, NSError *error) {
                                            [weakSelf.uTableView.mj_footer endRefreshing];
                                            [weakSelf.uTableView.mj_header endRefreshing];
                                            if (error) {
                                                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
                                            } else {
                                                if (!DICT_IS_NIL(JSON)) {
                                                    [weakSelf praseJsonDataWith:JSON targetPageIndex:targetPageIndex];
                                                } else {
                                                    NSAssert(0, @"");
                                                }
                                            }
                                            
                                        }];
}

- (void)praseJsonDataWith:(NSDictionary *)json targetPageIndex:(NSInteger)targetPageIndex {
    
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
    
    if (targetPageIndex == 1) {
        
        [self.dataArray removeAllObjects];
        self.dataArray = [model.data mutableCopy];
        currentPageIndex = 1;
        offset = self.dataArray.count;
    }else{
        if(!ARRAY_IS_NIL(model.data)){
            
            [self.dataArray addObjectsFromArray:model.data];
            
            currentPageIndex =  targetPageIndex;
            
            offset += model.data.count;
        }else{
            //认为server端没有返回数据
        }
    }
    
    //需要控制上拉更多
    if (model.data && model.data.count < PageSize && model.data.count >0 ) {
        
        self.uTableView.mj_footer = nil;
        
    } else if(model.data.count == PageSize) {
        
        self.uTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataFormServer)];
        self.uTableView.mj_footer.hidden = NO;
    } else if (model.data.count == 0){
        
        self.uTableView.mj_footer = nil;
    } else {
        NSAssert(0, @"程序错误，检查代码！");
    }
    
//    self.dataArray = [model.data mutableCopy];
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
    
    //增加个简单动画效果吧
    issueView.coverView.backgroundColor = [UIColor clearColor];
    issueView.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:.3 animations:^{
        issueView.layer.affineTransform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        issueView.coverView.backgroundColor = [UIColor blackColor];
    }];
    
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

- (void)scanButtonClick {
    
    //    UserInfoManager *manager = [UserInfoManager shareInstance];
    //    if (STR_IS_NIL(manager.currentProjectName)) {//为空要选择
    //        [self showSelectProjectView];
    //    } else {//扫描
    //    }
    [self jumpToScan];//在首页时候要进行选择
}

- (void)jumpToScan {
    InputSerialNumberViewController *input = [[InputSerialNumberViewController alloc] initWithNibName:@"InputSerialNumberViewController" bundle:nil];
    [self.navigationController pushViewController:input animated:NO];
    
    AVMetadataController *scan = [[AVMetadataController alloc] init];
    [scan setDelegate:self];
    [self presentViewController:scan animated:NO completion:nil];
}

#pragma mark - UI
- (void)setupUI {
    
    self.uTableView.tableFooterView = [UIView new];
    self.uTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataFormServer)];
    [self.uTableView.mj_header beginRefreshing];
    
    self.uTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataFormServer)];
    self.uTableView.mj_footer.hidden = YES;
    
    [self.uTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        if (iPhoneX) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-88 - BottomViewHeight);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-64 - BottomViewHeight);
        }
    }];
    
    //bottom
    self.bottomBgView.hidden = NO;
    [self.bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(BottomViewHeight);
        make.right.equalTo(self.view.mas_right);
        if (iPhoneX) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-88);
        } else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-64);
        }
    }];
    
}

#pragma mark - 初始化
- (UITableView *)uTableView {
    
    if (_uTableView == nil) {
        _uTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _uTableView.delegate = self;
        _uTableView.dataSource = self;
        [_uTableView registerNib:[UINib nibWithNibName:@"NearbyIssueCell" bundle:nil] forCellReuseIdentifier:@"NearbyIssueCell"];
        [self.view addSubview:_uTableView];
        _uTableView.contentSize = CGSizeMake(self.view.width, self.view.height);
    }
    return _uTableView;
}


- (UIView *)bottomBgView {
    if (_bottomBgView == nil) {
        _bottomBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomBgView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_bottomBgView];
        //button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"camera-3"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(scanButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBgView addSubview:button];
        button.frame = CGRectMake((ScreenWidth / 2) - 42.5, -25, 85, 85);
    }
    return _bottomBgView;
}

#pragma mark -
- (void)returnSerial:(NSString *)serial covertSerial:(NSString *)covertSerial {
    DLog(@"");
    //如果两个都为空则是点击取消按钮
    if (STR_IS_NIL(serial) && STR_IS_NIL(covertSerial)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:IMS_NOTIFICATION_SCANQRCODECANCEL object:nil];
    } else {
        //扫描成功，发送通知，通知CHECKINCIDENT
        //        self.serial = serial;
        //        self.covertSerial = covertSerial;
        [[NSNotificationCenter defaultCenter] postNotificationName:IMS_NOTIFICATION_SCANQRCODESUCCESS object:serial];
    }
}
@end
