//
//  IMSAPIManager.h
//  Investigator
//
//  Created by Kim on 2017/9/11.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMSAPIManager : NSObject

+ (instancetype)sharedManager;

#pragma mark - news
/**
 [商业头条]->[新闻]
 新闻详情
 新闻详情
 */
+ (void)news_loadNewsContentWithNewsId:(NSNumber *)newsId
                            industryID:(NSNumber *)inid
                              websitId:(NSNumber *)websitId
                                 Block:(void(^)(id JSON, NSError *error))block;
+ (void)ims_getCSRFTokenWithBlock:(void(^)(id JSON, NSError *error))block;
@end
