//
//  IMSAPIManager.m
//  Investigator
//
//  Created by Kim on 2017/9/11.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "IMSAPIManager.h"
#import "NetworkAPIManager.h"

@implementation IMSAPIManager

+ (instancetype)sharedManager {
    static IMSAPIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - 获取CSrfToken
+ (void)ims_getCSRFTokenWithBlock:(void(^)(id JSON, NSError *error))block {

    [[NetworkAPIManager shareManager] requestJsonDataWithPath:@"getCSRFToken"
                                                   withParams:nil
                                               withMethodType:Get
                                                     andBlock:^(id data, NSError *error) {
                                                         if (error) {
                                                             block(nil, error);
                                                         } else {
                                                             
                                                             
                                                             block(data, nil);
                                                         }
                                                     }];
}


#pragma mark - news
/**
 [商业头条]->[新闻]
 新闻详情
 新闻详情
 */
+ (void)news_loadNewsContentWithNewsId:(NSNumber *)newsId
                            industryID:(NSNumber *)inid
                              websitId:(NSNumber *)websitId
                                 Block:(void(^)(id JSON, NSError *error))block {
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                newsId,@"newsid",
                                inid,@"inid",
                                websitId,@"websitId",
                                nil];
    
    [[NetworkAPIManager shareManager] requestJsonDataWithPath:@"news/loadNewsContent"
                                                   withParams:parameters
                                               withMethodType:Post
                                                     andBlock:^(id data, NSError *error) {
                                                         if (error) {
                                                             block(nil, error);
                                                         } else {
                                                             
                                                             
                                                             block(data, nil);
                                                         }
                                                     }];
}

@end
