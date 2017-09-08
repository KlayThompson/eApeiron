//
//  HostURL.m
//  Investigator
//
//  Created by Kim on 2017/2/17.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "HostURL.h"

@implementation HostURL

static HostURL *defaultHost = nil;
+ (HostURL *)defaultManager
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(defaultHost == nil) {
            defaultHost = [[self alloc] init];
            [defaultHost baseHostURL];
        }
    });
    return defaultHost;
}

- (void)baseHostURL
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"hostURL"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hostURL"] length] == 0) {
#ifdef TARGER_INVESTIGATOR
        _hostURL = @"http://47.89.177.210/IMS/app/";
#elif TARGER_CONSUMER
        _hostURL = @"http://47.89.177.210/IMS/app/consumer/";
#elif TARGER_PACKAGE
        _hostURL = @"http://47.89.177.210/IMS/app/package/";
#endif
        [[NSUserDefaults standardUserDefaults] setObject:_hostURL forKey:@"hostURL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        _hostURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"hostURL"];
    }
}

- (void)changeHostURL:(NSString *)url
{
    [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"hostURL"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _hostURL = url;
}


@end
