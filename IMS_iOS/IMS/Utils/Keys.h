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





#endif
