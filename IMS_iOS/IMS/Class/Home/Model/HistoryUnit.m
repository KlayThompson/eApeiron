//
//  HistoryUnit.m
//  Investigator
//
//  Created by Kim on 2017/9/13.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "HistoryUnit.h"
#import "UserInfoManager.h"

@implementation HistoryUnit

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"issueId" : @"id",
             @"issueDescription" : @"description",
             @"details" : @"Details"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"details" : [HistoryUnitDetails class],
             };
}

- (NSString *)issue_type {
    /**
     issueTypes =     {
     1 = diversion;
     2 = counterfeit;
     3 = stolen;
     4 = recall;
     };
     */
    if ([self.issue_type_id isEqualToString:@"1"]) {
        return @"Diversion";
    } else if ([self.issue_type_id isEqualToString:@"2"]) {
        return @"Counterfeit";
    } else if ([self.issue_type_id isEqualToString:@"3"]) {
        return @"Stolen";
    } else if ([self.issue_type_id isEqualToString:@"4"]) {
        return @"Recall";
    }
    
    return @"";
}

//- (NSString *)projectName {
//
//    UserInfoManager *manager = [UserInfoManager shareInstance];
//    
//    for (ProjectModel *model in manager.projectsListModel.projects) {
//        if ([model.projectId isEqualToString:self.project_id]) {
//            return model.projectName;
//        }
//    }
//    
//    return @"";
//}

@end
