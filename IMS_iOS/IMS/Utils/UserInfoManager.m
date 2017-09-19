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
    
    //ProjectID
    [[NSUserDefaults standardUserDefaults] setObject:self.currentProjectId forKey:@"ims_projectid"];
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
    self.currentProjectId = [[NSUserDefaults standardUserDefaults] objectForKey:@"ims_projectid"];
    DLog(@"");
}

//用户退出登录，清除用户信息
- (void)clearUserInfo {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ims_authToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ims_projectname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ims_projectid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ims_username"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ims_logintime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.currentProjectName = nil;
    self.authToken = nil;
    self.userLogin = nil;
    self.emailAddress = nil;
    self.projectDic = [NSDictionary new];
    self.currentProjectId = nil;
    self.currentUsername = nil;
    self.longitude = nil;
    self.latitude = nil;
}

/**
 用户登录成功，保存当前时间
 */
- (void)saveCurrentTime {
    NSString *currentTime = [self getCurrentTime];
    [[NSUserDefaults standardUserDefaults] setObject:currentTime forKey:@"ims_logintime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取当前时间
- (NSString*)getCurrentTime {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *datenow = [NSDate date];
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}

// 判断当前时间和用户上次登录时间是否超过半小时，超过则需要重新登录
- (BOOL)checkUserShouldLoginAgain {
    // 1.确定时间
    NSString *time1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"ims_logintime"];
    NSString *time2 = [self getCurrentTime];
    // 2.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    // 3.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitMinute;
    // 4.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 5.输出结果
    if (cmps.minute < 30) {
        return NO;
    }
    //清除用户信息
    [self clearUserInfo];
    return YES;
}
@end
