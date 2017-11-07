//
//  ProjectDetailModel.m
//  Investigator
//
//  Created by Kim on 2017/9/25.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "ProjectDetailModel.h"

@implementation ProjectDetailModel
/**
 @property (nonatomic, copy) NSString *backgroundApp;
 @property (nonatomic, copy) NSString *backgroundWeb;
 @property (nonatomic, copy) NSString *backgroundWebTabArea;
 @property (nonatomic, copy) NSString *emailLogo;
 @property (nonatomic, copy) NSString *mobileLogo;
 @property (nonatomic, copy) NSString *tabActiveColor;
 @property (nonatomic, copy) NSString *tabColor;
 @property (nonatomic, copy) NSString *theme;
 @property (nonatomic, copy) NSString *webPageLogo;
 */
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.backgroundApp forKey:@"backgroundApp"];
    [aCoder encodeObject:self.backgroundWeb forKey:@"backgroundWeb"];
    [aCoder encodeObject:self.backgroundWebTabArea forKey:@"backgroundWebTabArea"];
    [aCoder encodeObject:self.emailLogo forKey:@"emailLogo"];
    [aCoder encodeObject:self.mobileLogo forKey:@"mobileLogo"];
    [aCoder encodeObject:self.tabActiveColor forKey:@"tabActiveColor"];
    [aCoder encodeObject:self.tabColor forKey:@"tabColor"];
    [aCoder encodeObject:self.theme forKey:@"theme"];
    [aCoder encodeObject:self.webPageLogo forKey:@"webPageLogo"];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.backgroundApp = [aDecoder decodeObjectForKey:@"backgroundApp"];
        self.backgroundWeb = [aDecoder decodeObjectForKey:@"backgroundWeb"];
        self.backgroundWebTabArea = [aDecoder decodeObjectForKey:@"backgroundWebTabArea"];
        self.emailLogo = [aDecoder decodeObjectForKey:@"emailLogo"];
        self.mobileLogo = [aDecoder decodeObjectForKey:@"mobileLogo"];
        self.mobileLogo = [aDecoder decodeObjectForKey:@"mobileLogo"];
        self.tabActiveColor = [aDecoder decodeObjectForKey:@"tabActiveColor"];
        self.tabColor = [aDecoder decodeObjectForKey:@"tabColor"];
        self.theme = [aDecoder decodeObjectForKey:@"theme"];
        self.webPageLogo = [aDecoder decodeObjectForKey:@"webPageLogo"];
    }
    return self;
}
@end
