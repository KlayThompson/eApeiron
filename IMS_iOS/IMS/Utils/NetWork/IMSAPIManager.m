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


@implementation IMSAPIManager

+ (instancetype)sharedManager {
    static IMSAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - 获取CSrfToken
//+ (void)ims_getCSRFTokenWithBlock:(void(^)(id JSON, NSError *error))block {
//
//    [[NetworkAPIManager shareManager] requestJsonDataWithPath:IMS_GET_CSRF_URL
//                                                   withParams:nil
//                                               withMethodType:Get
//                                                     andBlock:^(id data, NSError *error) {
//                                                         if (error) {
//                                                             block(nil, error);
//                                                         } else {
//
//
//                                                             block(data, nil);
//                                                         }
//                                                     }];
//}

#pragma mark - 获取AuthToken
+ (void)ims_getAuthTokenWithUsername:(NSString *)username
                            password:(NSString *)password
                               Block:(void(^)(id JSON, NSError *error))block {
    
    //需要先请求CSRFToken
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
                                                                 NSDictionary *response = data[@"response"];
                                                                 NSString *access_token = response[@"access_token"];
                                                                 NSNumber *expires_in = response[@"expires_in"];
                                                                 UserInfoManager *manager = UserInfoManager.shareInstance;
                                                                 manager.userLogin = YES;
                                                                 manager.authToken = access_token;
                                                                 manager.expires_in = expires_in;
                                                                 manager.currentUsername = username;
                                                                 //存储用户信息
                                                                 [manager saveUserInfoToLocal];
                                                                 [manager saveCurrentTime];
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
    NetworkAPIManager *api = [NetworkAPIManager shareManager];
    
    NSString *token = [NSString stringWithFormat:@"Bearer %@",manager.authToken];
    [api.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
//                                manager.authToken,@"Authorization",
//                                nil];
    
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

//获取History
+ (void)ims_getHistoryWithLatitude:(NSString *)latitude
                         longitude:(NSString *)longitude
                             limit:(NSString *)limit
                          deviceId:(NSString *)deviceId
                             Block:(void(^)(id JSON, NSError *error))block {
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                manager.authToken,@"authToken",
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

//create Incident
+ (void)ims_checkIncidentWithProjectId:(NSString *)projectId
                              deviceId:(NSString *)deviceId
                          serialNumber:(NSString *)serialNumber
                              latitude:(NSString *)latitude
                             longitude:(NSString *)longitude
                                 check:(NSString *)check
                                 Block:(void(^)(id JSON, NSError *error))block {
    
    //需要先请求CSRFToken
    [self ims_getCSRFTokenWithBlock:^(id JSON, NSError *error) {
        if (!DICT_IS_NIL(JSON)) {
            NSString *csrfToken = JSON[@"csrfToken"];
            UserInfoManager *manager = [UserInfoManager shareInstance];
            
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        projectId,@"appid",
                                        csrfToken,@"fuel_csrf_token",
                                        manager.authToken,@"authToken",
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
        } else {
            block(nil,error);
        }
    }];
}
@end
