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

//返回当前工程名
- (NSString *)appName {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info.plist" ofType:nil];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    return dic[@"IMSIdentifier"];
}

/**
 保存用户登录信息
 */
- (void)saveUserInfoToLocal {
    
    //AuthToken
    [[NSUserDefaults standardUserDefaults] setObject:self.authToken forKey:@"ims_authToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //ProjectName
    [[NSUserDefaults standardUserDefaults] setObject:self.currentProjectName forKey:@"ims_projectname"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //UserName
    [[NSUserDefaults standardUserDefaults] setObject:self.currentUsername forKey:@"ims_username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//设置用户保存在本地的信息
- (void)getUserInfo {
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"ims_authToken"];
    self.currentProjectName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ims_projectname"];
    self.currentUsername = [[NSUserDefaults standardUserDefaults] objectForKey:@"ims_username"];
    DLog(@"");
}

//用户退出登录，清除用户信息
- (void)clearUserInfo {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ims_authToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ims_projectname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ims_username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
