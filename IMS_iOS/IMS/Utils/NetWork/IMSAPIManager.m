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
    
    NSString *client_secret = @"dCqlAdJC2R7VvW9tLD9JLot1ek39vVqeqC3ANWVa";
    NSString *client_id = @"uZn8lvlkg5a0dfe7ae57df6.37079856";
//    if ([manager.serverPathUrl isEqualToString:@"http://www.apeironcloud.com/"]) {
//        client_secret = @"edbsOI10Bbr4llQA5eKXDhz6inLTMT0Ln7TfzPdd";
//        client_id = @"2";
//    } else if ([manager.serverPathUrl isEqualToString:@"http://192.168.0.26/"]) {
//        client_secret = @"yKgDjnGRp0H0GAAPuvnNSXO0BZ7YpIv6gyCW45dn";
//        client_id = @"7";
//    } else if ([manager.serverPathUrl isEqualToString:@"http://192.168.1.199/"]) {
//        client_secret = @"9h2HFsUyozll3YThdYtFAbyCu9JIQVD8EFSHOK9d";
//        client_id = @"5tlUHsftH5a095df31c22b4.87337685";
//    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                client_id,@"client_id",
                                client_secret,@"client_secret",
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
//    UserInfoManager *manager = [UserInfoManager shareInstance];

    NSString *client_secret = @"dCqlAdJC2R7VvW9tLD9JLot1ek39vVqeqC3ANWVa";
    NSString *client_id = @"uZn8lvlkg5a0dfe7ae57df6.37079856";
//    if ([manager.serverPathUrl isEqualToString:@"http://www.apeironcloud.com/"]) {
//        client_secret = @"edbsOI10Bbr4llQA5eKXDhz6inLTMT0Ln7TfzPdd";
//        client_id = @"2";
//    } else if ([manager.serverPathUrl isEqualToString:@"http://192.168.0.26/"]) {
//        client_secret = @"yKgDjnGRp0H0GAAPuvnNSXO0BZ7YpIv6gyCW45dn";
//        client_id = @"7";
//    } else if ([manager.serverPathUrl isEqualToString:@"http://192.168.1.199/"]) {
//        client_secret = @"dCqlAdJC2R7VvW9tLD9JLot1ek39vVqeqC3ANWVa";
//        client_id = @"uZn8lvlkg5a0dfe7ae57df6.37079856";
//    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                username,@"username",
                                password,@"password",
                                client_id,@"client_id",
                                client_secret,@"client_secret",
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
                
                [[NetworkAPIManager shareManager] requestJsonDataWithPath:@"IMS/service/incident"
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
        
        [[NetworkAPIManager shareManager] requestJsonDataWithPath:@"IMS/service/incident"
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

//getRoadMap
+ (void)ims_getRoadMapWithNum:(NSString *)num
                         size:(NSString *)size
                         zoom:(NSString *)zoom
                   marksArray:(NSArray <MarkersInfoModel *>*)marksArray
                        Block:(void(^)(id JSON, NSError *error))block {
    NetworkAPIManager *api = [NetworkAPIManager shareManager];
    api.responseSerializer = [AFImageResponseSerializer serializer];
    
    
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
                
                NSString *token = [NSString stringWithFormat:@"Bearer %@",manager.authToken];
                [api.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
                
                NSMutableDictionary *parameters = [NSMutableDictionary new];
                [parameters setObject:num forKey:@"num"];
                [parameters setObject:size forKey:@"size"];
                
                for (int index = 0; index < marksArray.count; index ++) {
                    MarkersInfoModel *model = [marksArray objectAtIndex:index];
                    NSString *latKey = [NSString stringWithFormat:@"lat%d",index + 1];
                    [parameters setValue:model.lat forKey:latKey];
                    NSString *lngKey = [NSString stringWithFormat:@"lng%d",index + 1];
                    [parameters setValue:model.lng forKey:lngKey];
                    NSString *colorKey = [NSString stringWithFormat:@"color%d",index + 1];
                    [parameters setValue:model.color forKey:colorKey];
                }
                
                if (marksArray.count == 1) {//1才有zoom
                    MarkersInfoModel *model = marksArray.firstObject;
                    [parameters setValue:[NSString stringWithFormat:@"%@",model.zoom] forKey:@"zoom"];
                }
                
                [[NetworkAPIManager shareManager] requestJsonDataWithPath:@"IMS/service/getRoadMap"
                                                               withParams:parameters
                                                           withMethodType:Get
                                                                 andBlock:^(id data, NSError *error) {
                                                                     api.responseSerializer = [AFJSONResponseSerializer serializer];
                                                                     if (error) {
                                                                         block(nil, error);
                                                                     } else {
                                                                         block(data, nil);
                                                                     }
                                                                 }];
            }
        }];
    } else {
        
        NSString *token = [NSString stringWithFormat:@"Bearer %@",manager.authToken];
        [api.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        [parameters setObject:num forKey:@"num"];
        [parameters setObject:size forKey:@"size"];

        for (int index = 0; index < marksArray.count; index ++) {
            MarkersInfoModel *model = [marksArray objectAtIndex:index];
            NSString *latKey = [NSString stringWithFormat:@"lat%d",index + 1];
            [parameters setValue:model.lat forKey:latKey];
            NSString *lngKey = [NSString stringWithFormat:@"lng%d",index + 1];
            [parameters setValue:model.lng forKey:lngKey];
            NSString *colorKey = [NSString stringWithFormat:@"color%d",index + 1];
            [parameters setValue:model.color forKey:colorKey];
        }
        
        if (marksArray.count == 1) {//1才有zoom
            MarkersInfoModel *model = marksArray.firstObject;
            [parameters setValue:[NSString stringWithFormat:@"%@",model.zoom] forKey:@"zoom"];
        }
        
        [[NetworkAPIManager shareManager] requestJsonDataWithPath:@"IMS/service/getRoadMap"
                                                       withParams:parameters
                                                   withMethodType:Get
                                                         andBlock:^(id data, NSError *error) {
                                                             api.responseSerializer = [AFJSONResponseSerializer serializer];
                                                             if (error) {
                                                                 block(nil, error);
                                                             } else {
                                                                 block(data, nil);
                                                             }
                                                         }];
    }
}

//getLocationName
+ (void)ims_getLocationNameWithLatitude:(NSString *)latitude
                              longitude:(NSString *)longitude
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
                                            latitude,@"lat",
                                            longitude,@"lng",
                                            nil];
                
                [[NetworkAPIManager shareManager] requestJsonDataWithPath:@"IMS/service/getLocationName"
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
                                    latitude,@"lat",
                                    longitude,@"lng",
                                    nil];
        
        [[NetworkAPIManager shareManager] requestJsonDataWithPath:@"IMS/service/getLocationName"
                                                       withParams:parameters
                                                   withMethodType:Get
                                                         andBlock:^(id data, NSError *error) {
                                                             if (error) {
                                                                 block(nil, error);
                                                             } else {
                                                                 if (!DICT_IS_NIL(data)) {
                                                                     block(data, nil);
                                                                 } else {
                                                                     block(nil,nil);
                                                                 }
                                                             }
                                                         }];
    }
}
@end
