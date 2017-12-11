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

#pragma mark - 获取AuthToken
+ (void)ims_getAuthTokenWithUsername:(NSString *)username
                            password:(NSString *)password
                               Block:(void(^)(id JSON, NSError *error))block {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                username,@"username",
                                password,@"password",
                                IMS_client_id,@"client_id",
                                IMS_client_secret,@"client_secret",
                                nil];
    
    [[NetworkAPIManager shareManager] requestJsonDataWithEffectiveTokenWithPath:@"auth/login"
                                                                     withParams:parameters
                                                                 withMethodType:Post
                                                                       andBlock:^(id data, NSError *error) {
                                                                           if (error) {
                                                                               block(nil, error);
                                                                           } else {
                                                                               if (!DICT_IS_NIL(data)) {
                                                                                   UserInfoManager *manager = UserInfoManager.shareInstance;
                                                                                   manager.currentUsername = username;
                                                                                   manager.currentUserPassword = password;
                                                                                   [manager encodeLoginAndRefreshTokenData:data];
                                                                               }
                                                                               block(data, nil);
                                                                           }
                                                                       }];
}

//获取工程名
+ (void)ims_getProjectsWithBlock:(void(^)(id JSON, NSError *error))block {

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

//create Incident
+ (void)ims_checkIncidentWithProjectId:(NSString *)projectId
                              deviceId:(NSString *)deviceId
                          serialNumber:(NSString *)serialNumber
                              latitude:(NSString *)latitude
                             longitude:(NSString *)longitude
                                 check:(NSString *)check
                                 Block:(void(^)(id JSON, NSError *error))block {
    
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

//getRoadMap
+ (void)ims_getRoadMapWithNum:(NSString *)num
                         size:(NSString *)size
                         zoom:(NSString *)zoom
                   marksArray:(NSArray <MarkersInfoModel *>*)marksArray
                        Block:(void(^)(id JSON, NSError *error))block {
    NetworkAPIManager *api = [NetworkAPIManager shareManager];
    api.responseSerializer = [AFImageResponseSerializer serializer];
    
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

//getLocationName
+ (void)ims_getLocationNameWithLatitude:(NSString *)latitude
                              longitude:(NSString *)longitude
                                  Block:(void(^)(id JSON, NSError *error))block {
    
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

//用户退出登录
+ (void)ims_userLogoutWithBlock:(void(^)(id JSON, NSError *error))block {
    
    [[NetworkAPIManager shareManager] requestJsonDataWithEffectiveTokenWithPath:@"auth/logout"
                                                                     withParams:nil
                                                                 withMethodType:Post
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

//用户更新用户密码或者用户邮箱
+ (void)ims_userUpdateAccountNewPassword:(NSString *)newPassword
                                newEmail:(NSString *)newEmail
                               WithBlock:(void(^)(id JSON, NSError *error))block {
    
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (!STR_IS_NIL(newPassword)) {
        [parameters setObject:newPassword forKey:@"newPwd"];
    }
    if (!STR_IS_NIL(newEmail)) {
        [parameters setObject:newEmail forKey:@"newEmail"];
    }
    
    [[NetworkAPIManager shareManager] requestJsonDataWithPath:@"IMS/service/updateAccount"
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

//用户忘记密码
+ (void)ims_userForgotPasswordWithEmail:(NSString *)email
                              WithBlock:(void(^)(id JSON, NSError *error))block {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                email,@"email",
                                nil];
    
    [[NetworkAPIManager shareManager] requestJsonDataWithEffectiveTokenWithPath:@"IMS/service/forgotPassword"
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

@end
