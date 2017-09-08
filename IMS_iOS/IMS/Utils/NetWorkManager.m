//
//  NetWorkManager.m
//  Investigator
//
//  Created by Kim on 2017/9/8.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "NetWorkManager.h"


static NetWorkManager *instance = nil;

typedef enum : NSUInteger  {
    POST,
    GET
} RequestMethod;


@implementation NetWorkManager

+ (NetWorkManager *)shareInstance
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        if(instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}




@end
