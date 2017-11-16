//
//  CheckIncidentModel.m
//  Investigator
//
//  Created by Kim on 2017/9/19.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "CheckIncidentModel.h"

@implementation CheckIncidentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"incidentDescription" : @"description"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"markersInfo" : [MarkersInfoModel class],
             };
}

@end

