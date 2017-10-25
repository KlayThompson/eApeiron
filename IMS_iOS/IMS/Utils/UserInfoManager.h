//
//  UserInfoManager.h
//  Investigator
//
//  Created by Kim on 2017/9/11.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>

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
 Project字典
 */
@property (nonatomic, strong) NSDictionary *projectDic;

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
 Project全部信息对象数组
 */
@property (nonatomic, strong) NSMutableArray *projectAllInfoArray;

/**
 服务器URL
 */
@property (nonatomic, copy) NSString *serverPathUrl;

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
 判断当前时间和用户上次登录时间是否超过半小时，超过则需要重新登录

 @return 是否需要重新登陆 YES 需要 NO 不需要
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
@end
