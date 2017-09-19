//
//  Constants.h
//  IMS
//
//  Created by Kim on 14/12/22.
//  Copyright (c) 2014年 kodak. All rights reserved.
//

#if defined (DEBUG)
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define     DLog( s, ... )
#endif

#ifndef IMS_Constants_h
#define IMS_Constants_h


//#ifdef TARGER_INVESTIGATOR
//#define kHostURL_USA                                            @"http://47.89.177.210/IMS/app/"
//#elif TARGER_CONSUMER
//#define kHostURL_USA                                            @"http://47.89.177.210/IMS/app/consumer/"
//#elif TARGER_PACKAGE
//#define kHostURL_USA                                            @"http://47.89.177.210/IMS/app/package/"
//#endif

//#ifdef TARGER_INVESTIGATOR
//    #define kHostURL_USA                                            @"https://brandprotection.kodak.com/IMS/app/"
//#elif TARGER_CONSUMER
//    #define kHostURL_USA                                            @"https://brandprotection.kodak.com/IMS/app/consumer/"
//#elif TARGER_PACKAGE
//    #define kHostURL_USA                                            @"https://brandprotection.kodak.com/IMS/app/package/"
//#endif



#define ScreenHeight                                            [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth                                             [[UIScreen mainScreen] bounds].size.width


#define IMS_GET_CSRF_URL                                        @"getCSRFToken"
#define IMS_AUTH_URL                                            @"getAuthToken"
#define IMS_CREATE_INCIDENT                                     @"incident"
#define IMS_GET_HISTORY                                         @"history"
#define IMS_GET_PROJECTS                                        @"projects"


// 字符串
#define STR_IS_NIL(objStr) (![objStr isKindOfClass:[NSString class]] || objStr == nil || [objStr length] <= 0 || [[objStr stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])
// 字典
#define DICT_IS_NIL(objDict) (![objDict isKindOfClass:[NSDictionary class]] || objDict == nil || [objDict count] <= 0 )
// 数组
#define ARRAY_IS_NIL(objArray) (![objArray isKindOfClass:[NSArray class]] || objArray == nil || [objArray count] <= 0 )
// Number
#define NUMBER_IS_NIL(objNum) (![objNum isKindOfClass:[NSNumber class]] || objNum == nil )


#define IMS_ERROR_MESSAGE                                       @"Network error"

//NSUserDefaults
#define IMS_USERDEFAULTS_AUTHTOKEN                              @"ims_authToken"
#define IMS_USERDEFAULTS_PROJECTNAME                            @"ims_projectname"
#define IMS_USERDEFAULTS_PROJECTID                              @"ims_projectid"
#define IMS_USERDEFAULTS_USERNAME                               @"ims_username"
#define IMS_USERDEFAULTS_LOGINTIME                              @"ims_logintime"


//Notification
#define IMS_NOTIFICATION_SCANQRCODESUCCESS                            @"ims_scanqrcodesuccess"

#endif
