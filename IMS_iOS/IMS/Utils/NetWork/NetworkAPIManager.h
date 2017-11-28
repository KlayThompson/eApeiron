//
//  NetworkAPIManager.h
//  Investigator
//
//  Created by Kim on 2017/9/11.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, NetworkMethod) {
    Get = 0,
    Post,
    Put,
    Delete
};

@interface NetworkAPIManager : AFHTTPSessionManager

+ (id)shareManager;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(int)NetworkMethod
                       andBlock:(void (^)(id data, NSError *error))block;

- (void)downloadDataWithFullPath:(NSString *)aPath
                        andBlock:(void (^)(id data, NSError *error))block;

/**
 供不需要Token或者确定Token有效的进行请求，否则使用requestJsonDataWithPath
 */
- (void)requestJsonDataWithEffectiveTokenWithPath:(NSString *)aPath
                                       withParams:(NSDictionary*)params
                                   withMethodType:(int)NetworkMethod
                                         andBlock:(void (^)(id data, NSError *error))block;
@end
