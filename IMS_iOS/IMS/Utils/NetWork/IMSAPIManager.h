//
//  IMSAPIManager.h
//  Investigator
//
//  Created by Kim on 2017/9/11.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MarkersInfoModel.h"

@interface IMSAPIManager : NSObject

+ (instancetype)sharedManager;

#pragma mark - 获取requestAccessTokenWithRefresh_token
+ (void)ims_requestAccessTokenWithRefresh_tokenBlock:(void(^)(id JSON, NSError *error))block;

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


/**
 getRoadMap

 @param num marks的个数
 @param size 地图显示尺寸 300x400
 @param latitude latitude
 @param longitude longitude
 @param color like red or blue ..
 @param zoom 放大尺寸
 @param block 图片
 */
+ (void)ims_getRoadMapWithNum:(NSString *)num
                         size:(NSString *)size
                         zoom:(NSString *)zoom
                   marksArray:(NSArray <MarkersInfoModel *>*)marksArray
                        Block:(void(^)(id JSON, NSError *error))block;

//getLocationName
+ (void)ims_getLocationNameWithLatitude:(NSString *)latitude
                              longitude:(NSString *)longitude
                                  Block:(void(^)(id JSON, NSError *error))block;

/**
 用户退出登录

 @param block 
 */
+ (void)ims_userLogoutWithBlock:(void(^)(id JSON, NSError *error))block;


/**
 用户更新用户密码或者用户邮箱
 邮箱或者密码必须有一个不能为空

 @param newPassword 新密码 密码长度需要大于五 必须包含一个大写字母和数字
 @param newEmail 新邮箱  不能是已经存在的
 @param block 返回data
 */
+ (void)ims_userUpdateAccountNewPassword:(NSString *)newPassword
                                newEmail:(NSString *)newEmail
                               WithBlock:(void(^)(id JSON, NSError *error))block;


/**
 用户忘记密码

 @param email 接受重置密码邮箱
 @param block data
 */
+ (void)ims_userForgotPasswordWithEmail:(NSString *)email
                              WithBlock:(void(^)(id JSON, NSError *error))block;
@end
