//
//  UserInfoManager.m
//  Investigator
//
//  Created by Kim on 2017/9/11.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "UserInfoManager.h"

static UserInfoManager *instance = nil;

@implementation UserInfoManager

+ (UserInfoManager *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

/**
 保存用户登录信息
 */
- (void)saveUserInfoToLocal {
    
    [[NSUserDefaults standardUserDefaults] setObject:self.authToken forKey:@"ims_authToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

//获取AuthToken
- (NSString *)getUserAuthToken {
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"ims_authToken"];
    return self.authToken;
}

//用户退出登录，清除用户信息
- (void)clearUserInfo {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ims_authToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
