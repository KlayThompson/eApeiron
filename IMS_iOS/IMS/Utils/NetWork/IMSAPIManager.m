//
//  IMSAPIManager.m
//  Investigator
//
//  Created by Kim on 2017/9/11.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "IMSAPIManager.h"
#import "NetworkAPIManager.h"
#import "AppDelegate.h"
#import "UserInfoManager.h"

@implementation IMSAPIManager

+ (instancetype)sharedManager {
    static IMSAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - 获取requestAccessTokenWithRefresh_token
+ (void)ims_requestAccessTokenWithRefresh_tokenBlock:(void(^)(id JSON, NSError *error))block {
    
    NetworkAPIManager *api = [NetworkAPIManager shareManager];
    UserInfoManager *manager = [UserInfoManager shareInstance];

    NSString *token = [NSString stringWithFormat:@"Bearer %@",manager.refresh_token];
    [api.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"2",@"client_id",
                                @"Z9kI6MMJ652UFweOJTWYjhGFGwm5RLHY3Q7T7nSm",@"client_secret",
                                nil];
    [[NetworkAPIManager shareManager] requestJsonDataWithPath:@"auth/login/refresh"
                                                   withParams:parameters
                                               withMethodType:Post
                                                     andBlock:^(id data, NSError *error) {
                                                         if (error) {
                                                             block(nil, error);
                                                         } else {
                                                             
                                                             block(data, nil);
                                                         }
                                                     }];
}



#pragma mark - 获取AuthToken
+ (void)ims_getAuthTokenWithUsername:(NSString *)username
                            password:(NSString *)password
                               Block:(void(^)(id JSON, NSError *error))block {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                username,@"username",
                                password,@"password",
                                @"2",@"client_id",
                                @"Z9kI6MMJ652UFweOJTWYjhGFGwm5RLHY3Q7T7nSm",@"client_secret",
//                                csrfToken,@"fuel_csrf_token",
                                nil];
    
    [[NetworkAPIManager shareManager] requestJsonDataWithPath:@"auth/login"
                                                   withParams:parameters
                                               withMethodType:Post
                                                     andBlock:^(id data, NSError *error) {
                                                         if (error) {
                                                             block(nil, error);
                                                         } else {
                                                             if (!DICT_IS_NIL(data)) {
                                                                 UserInfoManager *manager = UserInfoManager.shareInstance;
                                                                 manager.currentUsername = username;
                                                                 [manager encodeLoginAndRefreshTokenData:data];
                                                             }
                                                             block(data, nil);
                                                         }
                                                     }];
//    [self ims_getCSRFTokenWithBlock:^(id JSON, NSError *error) {
//        if (!DICT_IS_NIL(JSON)) {
//            NSString *csrfToken = JSON[@"csrfToken"];
//
//        } else {
//            block(nil,error);
//        }
//    }];
    
}

//获取工程名
+ (void)ims_getProjectsWithBlock:(void(^)(id JSON, NSError *error))block {

    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    //check need request refresh_token
    if ([manager checkUserShouldRequestRefresh_token]) {
        //
        [self ims_requestAccessTokenWithRefresh_tokenBlock:^(id JSON, NSError *error) {
            if (error) {
                block(nil,error);
            } else {
                UserInfoManager *manager = UserInfoManager.shareInstance;
                [manager encodeLoginAndRefreshTokenData:JSON];
                NetworkAPIManager *api = [NetworkAPIManager shareManager];
                
                NSString *token = [NSString stringWithFormat:@"Bearer %@",manager.authToken];
                [api.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
                
                [[NetworkAPIManager shareManager] requestJsonDataWithPath:@"IMS/service/projects"
                                                               withParams:nil
                                                           withMethodType:Get
                                                                 andBlock:^(id data, NSError *error) {
                                                                     if (error) {
                                                                         block(nil, error);
                                                                     } else {
                                                                         block(data, nil);
                                                                     }
                                                                 }];
            }
        }];
    } else {
        NetworkAPIManager *api = [NetworkAPIManager shareManager];
        
        NSString *token = [NSString stringWithFormat:@"Bearer %@",manager.authToken];
        [api.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        
        [[NetworkAPIManager shareManager] requestJsonDataWithPath:@"IMS/service/projects"
                                                       withParams:nil
                                                   withMethodType:Get
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 block(nil, error);
                                                             } else {
                                                                 block(data, nil);
                                                             }
                                                         }];
    }
}

//获取History
+ (void)ims_getHistoryWithLatitude:(NSString *)latitude
                         longitude:(NSString *)longitude
                             limit:(NSString *)limit
                          deviceId:(NSString *)deviceId
                             Block:(void(^)(id JSON, NSError *error))block {
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    //check need request refresh_token
    if ([manager checkUserShouldRequestRefresh_token]) {
        //
        [self ims_requestAccessTokenWithRefresh_tokenBlock:^(id JSON, NSError *error) {
            if (error) {
                block(nil,error);
            } else {
                UserInfoManager *manager = UserInfoManager.shareInstance;
                [manager encodeLoginAndRefreshTokenData:JSON];
                NetworkAPIManager *api = [NetworkAPIManager shareManager];
                
                NSString *token = [NSString stringWithFormat:@"Bearer %@",manager.authToken];
                [api.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
                
                NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                            //                                manager.authToken,@"authToken",
                                            latitude,@"lat",
                                            longitude,@"lng",
                                            limit,@"limit",
                                            deviceId,@"d",
                                            nil];
                
                [[NetworkAPIManager shareManager] requestJsonDataWithPath:@"IMS/service/history"
                                                               withParams:parameters
                                                           withMethodType:Get
                                                                 andBlock:^(id data, NSError *error) {
                                                                     if (error) {
                                                                         block(nil, error);
                                                                     } else {
                                                                         
                                                                         block(data, nil);
                                                                     }
                                                                 }];
            }
        }];
    } else {
        NetworkAPIManager *api = [NetworkAPIManager shareManager];
        
        NSString *token = [NSString stringWithFormat:@"Bearer %@",manager.authToken];
        [api.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    //                                manager.authToken,@"authToken",
                                    latitude,@"lat",
                                    longitude,@"lng",
                                    limit,@"limit",
                                    deviceId,@"d",
                                    nil];
        
        [[NetworkAPIManager shareManager] requestJsonDataWithPath:@"IMS/service/history"
                                                       withParams:parameters
                                                   withMethodType:Get
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 block(nil, error);
                                                             } else {
                                                                 
                                                                 block(data, nil);
                                                             }
                                                         }];
    }
}

//create Incident
+ (void)ims_checkIncidentWithProjectId:(NSString *)projectId
                              deviceId:(NSString *)deviceId
                          serialNumber:(NSString *)serialNumber
                              latitude:(NSString *)latitude
                             longitude:(NSString *)longitude
                                 check:(NSString *)check
                                 Block:(void(^)(id JSON, NSError *error))block {
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    //check need request refresh_token
    if ([manager checkUserShouldRequestRefresh_token]) {
        //
        [self ims_requestAccessTokenWithRefresh_tokenBlock:^(id JSON, NSError *error) {
            if (error) {
                block(nil,error);
            } else {
                UserInfoManager *manager = UserInfoManager.shareInstance;
                [manager encodeLoginAndRefreshTokenData:JSON];
                NetworkAPIManager *api = [NetworkAPIManager shareManager];
                
                NSString *token = [NSString stringWithFormat:@"Bearer %@",manager.authToken];
                [api.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
                
                NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                            projectId,@"appid",
                                            deviceId,@"d",
                                            serialNumber,@"s",
                                            latitude,@"lat",
                                            longitude,@"lng",
                                            check,@"check",
                                            nil];
                
                [[NetworkAPIManager shareManager] requestJsonDataWithPath:IMS_CREATE_INCIDENT
                                                               withParams:parameters
                                                           withMethodType:Post
                                                                 andBlock:^(id data, NSError *error) {
                                                                     if (error) {
                                                                         block(nil, error);
                                                                     } else {
                                                                         if (!DICT_IS_NIL(data)) {
                                                                             NSDictionary *json = data[@"Message"];
                                                                             block(json, nil);
                                                                         } else {
                                                                             block(nil,nil);
                                                                         }
                                                                     }
                                                                 }];
            }
        }];
    } else {
        NetworkAPIManager *api = [NetworkAPIManager shareManager];
        
        NSString *token = [NSString stringWithFormat:@"Bearer %@",manager.authToken];
        [api.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                    projectId,@"appid",
                                    deviceId,@"d",
                                    serialNumber,@"s",
                                    latitude,@"lat",
                                    longitude,@"lng",
                                    check,@"check",
                                    nil];
        
        [[NetworkAPIManager shareManager] requestJsonDataWithPath:IMS_CREATE_INCIDENT
                                                       withParams:parameters
                                                   withMethodType:Post
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 block(nil, error);
                                                             } else {
                                                                 if (!DICT_IS_NIL(data)) {
                                                                     NSDictionary *json = data[@"Message"];
                                                                     block(json, nil);
                                                                 } else {
                                                                     block(nil,nil);
                                                                 }
                                                             }
                                                         }];
    }
}
@end
