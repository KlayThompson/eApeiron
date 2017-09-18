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

/**
 获取History

 @param latitude latitude
 @param longitude longitude
 @param limit 固定值，传10
 @param deviceId 设备标识符
 @param block 回调
 */
+ (void)ims_getHistoryWithLatitude:(NSString *)latitude
                         longitude:(NSString *)longitude
                             limit:(NSString *)limit
                          deviceId:(NSString *)deviceId
                             Block:(void(^)(id JSON, NSError *error))block;


/**
 check Incident

 @param projectId ProjectId
 @param deviceId deviceId
 @param serialNumber serialNumber
 @param latitude latitude
 @param longitude longitude
 @param check 1 or 0
 @param block 返回json
 */
+ (void)ims_checkIncidentWithProjectId:(NSString *)projectId
                              deviceId:(NSString *)deviceId
                          serialNumber:(NSString *)serialNumber
                              latitude:(NSString *)latitude
                             longitude:(NSString *)longitude
                                 check:(NSString *)check
                                 Block:(void(^)(id JSON, NSError *error))block;
@end
