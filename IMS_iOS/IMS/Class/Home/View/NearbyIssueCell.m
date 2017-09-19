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

- (void)configCellDataWith:(HistoryUnit *)unit {
    
    if (!unit) {
        return;
    }
    UserInfoManager *manager = [UserInfoManager shareInstance];
    //distance
    double distance = [self distanceBetweenOrderByLat1:manager.latitude.doubleValue lat2:unit.latitude.doubleValue lng1:manager.longitude.doubleValue lng2:unit.longitude.doubleValue];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.1f feet",distance];
    
    //时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[unit.created_at doubleValue]]];
    self.timeLabel.text = time;
    
    //id
    self.isusseIdLabel.text = [NSString stringWithFormat:@"(%@)",unit.issueId];
    
}

-(double)distanceBetweenOrderByLat1:(double)lat1 lat2:(double)lat2 lng1:(double)lng1 lng2:(double)lng2 {
    
    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    
    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    double  distance  = [curLocation distanceFromLocation:otherLocation];
    
    
    double change = 0.3048;
    
    double value = distance/change;
    
    return  value;
    
}

@end
