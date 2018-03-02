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


@interface HomeListViewController () {
 

}


@end

@implementation HomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
                                                NSDictionary *messageDic = JSON[@"Message"];
                                                NSDictionary *nearbyIncidents = messageDic[@"nearbyIncidents"];
                                                
                                            }
                                            
                                        }];
}


@end
