//
//  ProjectListModel.m
//  Investigator
//
//  Created by Kim on 2017/11/7.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "ProjectListModel.h"

@implementation ProjectListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"projects" : [ProjectModel class],
             };
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.projects forKey:@"projects"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.projects = [aDecoder decodeObjectForKey:@"projects"];
    }
    return self;
}

@end
