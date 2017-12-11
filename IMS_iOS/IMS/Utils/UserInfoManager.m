//
//  UserInfoManager.m
//  Investigator
//
//  Created by Kim on 2017/9/11.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "UserInfoManager.h"
#import "NetworkAPIManager.h"

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
    [[NSUserDefaults standardUserDefaults] setObject:self.authToken forKey:IMS_USERDEFAULTS_AUTHTOKEN];
    
    //EXPIRES_IN过期时间
    [[NSUserDefaults standardUserDefaults] setObject:self.expires_in forKey:IMS_USERDEFAULTS_EXPIRES_IN];

    //ProjectName
    [[NSUserDefaults standardUserDefaults] setObject:self.currentProjectName forKey:IMS_USERDEFAULTS_PROJECTNAME];
    
    
    //ProjectID
    [[NSUserDefaults standardUserDefaults] setObject:self.currentProjectId forKey:IMS_USERDEFAULTS_PROJECTID];
    

    //UserName
    [[NSUserDefaults standardUserDefaults] setObject:self.currentUsername forKey:IMS_USERDEFAULTS_USERNAME];
    
    //projectJson
    [[NSUserDefaults standardUserDefaults] setObject:self.projectResultJson forKey:IMS_USERDEFAULTS_PROJECTRESULTJSON];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.refresh_token forKey:IMS_USERDEFAULTS_REFRESH_TOKEN];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.refresh_token_expires_in forKey:IMS_USERDEFAULTS_REFRESH_TOKEN_EXPIRES_IN];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.currentUserPassword forKey:@"ims_userpassword"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//设置用户保存在本地的信息
- (void)getUserInfo {
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:IMS_USERDEFAULTS_AUTHTOKEN];
    self.currentProjectName = [[NSUserDefaults standardUserDefaults] objectForKey:IMS_USERDEFAULTS_PROJECTNAME];
    self.currentUsername = [[NSUserDefaults standardUserDefaults] objectForKey:IMS_USERDEFAULTS_USERNAME];
    self.currentProjectId = [[NSUserDefaults standardUserDefaults] objectForKey:IMS_USERDEFAULTS_PROJECTID];
    self.projectResultJson = [[NSUserDefaults standardUserDefaults] objectForKey:IMS_USERDEFAULTS_PROJECTRESULTJSON];
    self.expires_in = [[NSUserDefaults standardUserDefaults] objectForKey:IMS_USERDEFAULTS_EXPIRES_IN];
    self.refresh_token = [[NSUserDefaults standardUserDefaults] objectForKey:IMS_USERDEFAULTS_REFRESH_TOKEN];
    self.refresh_token_expires_in = [[NSUserDefaults standardUserDefaults] objectForKey:IMS_USERDEFAULTS_REFRESH_TOKEN_EXPIRES_IN];
    self.currentUserPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"ims_userpassword"];

    DLog(@"");
}

//用户退出登录，清除用户信息
- (void)clearUserInfo {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:IMS_USERDEFAULTS_AUTHTOKEN];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:IMS_USERDEFAULTS_EXPIRES_IN];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:IMS_USERDEFAULTS_PROJECTNAME];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:IMS_USERDEFAULTS_PROJECTID];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:IMS_USERDEFAULTS_USERNAME];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:IMS_USERDEFAULTS_LOGINTIME];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:IMS_USERDEFAULTS_PROJECTRESULTJSON];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:IMS_USERDEFAULTS_REFRESH_TOKEN];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:IMS_USERDEFAULTS_REFRESH_TOKEN_EXPIRES_IN];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ims_userpassword"];

    
    self.currentProjectName = nil;
    self.authToken = nil;
    self.userLogin = nil;
    self.emailAddress = nil;
    self.currentProjectId = nil;
    self.currentUsername = nil;
    self.longitude = nil;
    self.latitude = nil;
    self.projectResultJson = nil;
    self.expires_in = nil;
    self.refresh_token_expires_in = nil;
    self.refresh_token = nil;
    self.currentUserPassword = nil;
}

/**
 用户登录成功，保存当前时间
 */
- (void)saveCurrentTime {
    NSString *currentTime = [self getCurrentTime];
    [[NSUserDefaults standardUserDefaults] setObject:currentTime forKey:IMS_USERDEFAULTS_LOGINTIME];
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


/**
 当登录时间超过refresh_token_expires_in则提示用户重新登录（仅仅在应用启动时候判断）

 @return YES,则需要重新登录 NO则不需要，但是要进一步验证是否需要请求refresh_token
 */
- (BOOL)checkUserShouldLoginAgain {
    // 1.确定时间
    NSString *time1 = [[NSUserDefaults standardUserDefaults] objectForKey:IMS_USERDEFAULTS_LOGINTIME];
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
    if (cmps.minute < self.refresh_token_expires_in.integerValue) {
        return NO;
    }
    //清除用户信息
    [self clearUserInfo];
    return YES;
}

/**
 根据用户登录时间，和AccessToken有效时间进行对比，如果超过有效时间，则利用refresh_token重新获取access_token和expires_in，来保持用户长时间在线状态，
 */
- (BOOL)checkUserShouldRequestRefresh_token {
    
    // 1.确定时间
    NSString *time1 = [[NSUserDefaults standardUserDefaults] objectForKey:IMS_USERDEFAULTS_LOGINTIME];
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
    if (cmps.minute < self.expires_in.integerValue) {
        return NO;
    }
    return YES;
}

- (void)getServerPathUrl {
    
    self.serverPathUrl = [[NSUserDefaults standardUserDefaults] objectForKey:IMS_USERDEFAULTS_SERVERPATHURL];
    if (STR_IS_NIL(self.serverPathUrl)) {
        self.serverPathUrl = SERVER_PATH_URL;
    }
}

- (void)saveServerPathUrlwith:(NSString *)urlString {
    
    //直接保存在本地
    [[NSUserDefaults standardUserDefaults] setObject:urlString forKey:IMS_USERDEFAULTS_SERVERPATHURL];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.serverPathUrl = urlString;
    
}

/**
 解析用户登录或者RefreshToken的结果并进行处理
 
 @param json 服务端返回结果
 */
- (void)encodeLoginAndRefreshTokenData:(NSDictionary *)json {
    if (DICT_IS_NIL(json)) {
        return;
    }
    NSDictionary *response = json[@"response"];
    NSString *access_token = response[@"access_token"];
    NSString *refresh_token = response[@"refresh_token"];
    NSNumber *expires_in = response[@"expires_in"];
    NSNumber *refresh_token_expires_in = response[@"refresh_token_expires_in"];
    self.userLogin = YES;
    self.authToken = access_token;
    self.refresh_token = refresh_token;
    self.refresh_token_expires_in = refresh_token_expires_in;
    self.expires_in = expires_in;
    self.need_update_pwd = response[@"need_update_pwd"];
    //存储用户信息
    [self saveUserInfoToLocal];
    [self saveCurrentTime];
}
@end
