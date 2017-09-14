//
//  HistoryModel.m
//  Investigator
//
//  Created by Kim on 2017/9/13.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "HistoryModel.h"

@implementation HistoryModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"issuesByTime" : [HistoryUnit class],
             @"issuesByProx" : [HistoryUnit class]
             };
}


@end

