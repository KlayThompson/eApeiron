//
//  HistoryUnit.m
//  Investigator
//
//  Created by Kim on 2017/9/13.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "HistoryUnit.h"

@implementation HistoryUnit

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"issueId" : @"id",
             @"issueDescription" : @"description"};
}

@end
