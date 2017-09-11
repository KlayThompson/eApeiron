//
//  IMSAPIManager.h
//  Investigator
//
//  Created by Kim on 2017/9/11.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMSAPIManager : NSObject

+ (instancetype)sharedManager;

#pragma mark - 获取CSrfToken
+ (void)ims_getCSRFTokenWithBlock:(void(^)(id JSON, NSError *error))block;

#pragma mark -

/**
 登录认证，获取AuthToken

 @param username 用户名
 @param password 密码
 @param block 回调
 */
+ (void)ims_getAuthTokenWithUsername:(NSString *)username
                            password:(NSString *)password
                               Block:(void(^)(id JSON, NSError *error))block;

/**
 获取项目信息

 @param block 回调项目信息
 */
+ (void)ims_getProjectsWithBlock:(void(^)(id JSON, NSError *error))block;
@end
