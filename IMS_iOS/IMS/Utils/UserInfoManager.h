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
 保存用户信息到本地
 */
- (void)saveUserInfoToLocal;

/**
 应用刚启动获取AuthToken，为空则需要登录

 @return AuthToken
 */
- (NSString *)getUserAuthToken;

/**
 用户退出登录，清除用户信息
 */
- (void)clearUserInfo;
@end
