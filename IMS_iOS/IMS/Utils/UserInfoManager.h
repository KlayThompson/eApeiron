//
//  UserInfoManager.h
//  Investigator
//
//  Created by Kim on 2017/9/11.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectListModel.h"

@interface UserInfoManager : NSObject

+ (UserInfoManager *)shareInstance;

/**
 authToken
 */
@property (nonatomic, copy) NSString *authToken;

/**
 用户是否登录
 */
@property (nonatomic, assign) BOOL userLogin;

/**
 用户邮箱
 */
@property (nonatomic, copy) NSString *emailAddress;

/**
 当前已经选择的Project名称
 */
@property (nonatomic, copy) NSString *currentProjectName;

/**
 当前已经选择的ProjectID
 */
@property (nonatomic, copy) NSString *currentProjectId;

/**
 当前登录用户名
 */
@property (nonatomic, copy) NSString *currentUsername;

/**
 当前工程名
 */
@property (nonatomic, copy) NSString *appName;

/**
 经度
 */
@property (nonatomic, copy) NSString *longitude;

/**
 纬度
 */
@property (nonatomic, copy) NSString *latitude;

/**
 getProject返回的Json
 */
@property (nonatomic, strong) NSDictionary *projectResultJson;

/**
 服务器URL
 */
@property (nonatomic, copy) NSString *serverPathUrl;

/**
 expires_in
 */
@property (nonatomic, copy) NSNumber *expires_in;

/**
 refresh_token_expires_in
 */
@property (nonatomic, copy) NSNumber *refresh_token_expires_in;

/**
 refresh_token
 */
@property (nonatomic, copy) NSString *refresh_token;

@property (nonatomic, strong) ProjectListModel *projectsListModel;

/**
 保存用户信息到本地
 */
- (void)saveUserInfoToLocal;

/**
 应用刚启动，从本地获取用户信息，赋值
 */
- (void)getUserInfo;

/**
 用户退出登录，清除用户信息
 */
- (void)clearUserInfo;

/**
 用户登录成功，保存登录时间
 */
- (void)saveCurrentTime;

/**
 获取当前时间
 */
- (NSString*)getCurrentTime;

/**
 当登录时间超过refresh_token_expires_in则提示用户重新登录（仅仅在应用启动时候判断）
 
 @return YES,则需要重新登录 NO则不需要，但是要进一步验证是否需要请求refresh_token
 */
- (BOOL)checkUserShouldLoginAgain;

/**
 程序每次启动后获取服务器url
 */
- (void)getServerPathUrl;

/**
 切换服务器url

 @param urlString 要切换的url
 */
- (void)saveServerPathUrlwith:(NSString *)urlString;

/**
 根据用户登录时间，和AccessToken有效时间进行对比，如果超过有效时间，则利用refresh_token重新获取access_token和expires_in，来保持用户长时间在线状态，
 */
- (BOOL)checkUserShouldRequestRefresh_token;

/**
 解析用户登录或者RefreshToken的结果并进行处理

 @param json 服务端返回结果
 */
- (void)encodeLoginAndRefreshTokenData:(NSDictionary *)json;
@end
