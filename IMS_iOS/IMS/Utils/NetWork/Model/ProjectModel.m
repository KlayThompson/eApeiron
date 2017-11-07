//
//  ProjectModel.m
//  Investigator
//
//  Created by Kim on 2017/9/25.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "ProjectModel.h"
#import "UserInfoManager.h"
#import "YYModel.h"

@implementation ProjectModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"projectId" : @"project_id",
             @"projectName" : @"name",
             @"projectDetailModel" : @"assets",
             };
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.projectId forKey:@"projectId"];
    [aCoder encodeObject:self.projectName forKey:@"projectName"];
    [aCoder encodeObject:self.projectDetailModel forKey:@"projectDetailModel"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.projectId = [aDecoder decodeObjectForKey:@"projectId"];
        self.projectName = [aDecoder decodeObjectForKey:@"projectName"];
        self.projectDetailModel = [aDecoder decodeObjectForKey:@"projectDetailModel"];
    }
    return self;
}

@end
