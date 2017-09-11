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
+ (void)ims_getCSRFTokenWithBlock:(void(^)(id JSON, NSError *error))block {

    [[NetworkAPIManager shareManager] requestJsonDataWithPath:IMS_GET_CSRF_URL
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

#pragma mark - 获取AuthToken
+ (void)ims_getAuthTokenWithUsername:(NSString *)username
                            password:(NSString *)password
                               Block:(void(^)(id JSON, NSError *error))block {
    
    //需要先请求CSRFToken
    [self ims_getCSRFTokenWithBlock:^(id JSON, NSError *error) {
        if (!DICT_IS_NIL(JSON)) {
            NSString *csrfToken = JSON[@"csrfToken"];
            
            NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                        username,@"userId",
                                        password,@"password",
                                        csrfToken,@"fuel_csrf_token",
                                        nil];
            
            [[NetworkAPIManager shareManager] requestJsonDataWithPath:IMS_AUTH_URL
                                                           withParams:parameters
                                                       withMethodType:Post
                                                             andBlock:^(id data, NSError *error) {
                                                                 if (error) {
                                                                     block(nil, error);
                                                                 } else {
                                                                     if (!DICT_IS_NIL(data)) {
                                                                         NSString *authToken = data[@"authToken"];
                                                                         NSString *emailAddress = data[@"emailAddress"];

                                                                         UserInfoManager *manager = UserInfoManager.shareInstance;
                                                                         manager.userLogin = YES;
                                                                         manager.authToken = authToken;
                                                                         manager.emailAddress = emailAddress;
                                                                         //存储用户信息
                                                                         [manager saveUserInfoToLocal];
                                                                     }
                                                                     block(data, nil);
                                                                 }
                                                             }];
        } else {
            [Hud showMessage:IMS_ERROR_MESSAGE];
        }
    }];
    
}

+ (void)ims_getProjectsWithBlock:(void(^)(id JSON, NSError *error))block {

    UserInfoManager *manager = [UserInfoManager shareInstance];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                manager.authToken,@"authToken",
                                nil];
    
    [[NetworkAPIManager shareManager] requestJsonDataWithPath:IMS_GET_PROJECTS
                                                   withParams:parameters
                                               withMethodType:Get
                                                     andBlock:^(id data, NSError *error) {
                                                         if (error) {
                                                             block(nil, error);
                                                         } else {
                                                             if (!DICT_IS_NIL(data)) {
                                                                 UserInfoManager *manager = UserInfoManager.shareInstance;

                                                                 NSDictionary *messageDic = data[@"Message"];
                                                                 manager.projectDic = messageDic;
                                                             }
                                                             block(data, nil);
                                                         }
                                                     }];
}


@end
