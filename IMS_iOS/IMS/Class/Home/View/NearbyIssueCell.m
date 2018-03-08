//
//  NearbyIssueCell.m
//  Investigator
//
//  Created by Kim on 2017/9/14.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "NearbyIssueCell.h"
#import <CoreLocation/CoreLocation.h>
#import "UserInfoManager.h"

@implementation NearbyIssueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configCellDataWith:(NSDictionary *)dict {
    
    if (DICT_IS_NIL(dict)) {
        return;
    }
    NSDictionary *detailDic = dict[@"Details"];

    //get Details
    NSString *createDate = dict[@"Created At"];
    NSString *lat = detailDic[@"Latitude"];
    NSString *lng = detailDic[@"Longitude"];
    NSString *desc = detailDic[@"Description"];
    if (STR_IS_NIL(createDate)) {
        createDate = @"";
    }
    if (STR_IS_NIL(lat)) {
        lat = @"";
    }
    if (STR_IS_NIL(lng)) {
        lng = @"";
    }
    if (STR_IS_NIL(desc)) {
        desc = @"";
    }
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    //distance
    double distance = [self distanceBetweenOrderByLat1:manager.latitude.doubleValue lat2:lat.doubleValue lng1:manager.longitude.doubleValue lng2:lng.doubleValue];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f feet",distance];
    
    //时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[createDate doubleValue]]];
    self.timeLabel.text = time;
    
    //id
    self.isusseIdLabel.text = [NSString stringWithFormat:@"%@",desc];
    
}

//feet单位
-(double)distanceBetweenOrderByLat1:(double)lat1 lat2:(double)lat2 lng1:(double)lng1 lng2:(double)lng2 {
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    
    
    double change = 0.3048;
    
    double value = distance/change;
    
    return  value;
    
}

@end
