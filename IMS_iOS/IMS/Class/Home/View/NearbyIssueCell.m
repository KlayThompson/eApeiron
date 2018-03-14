//
//  NearbyIssueCell.m
//  Investigator
//
//  Created by Kim on 2017/9/14.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "NearbyIssueCell.h"
#import <CoreLocation/CoreLocation.h>

@implementation NearbyIssueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configCellDataWith:(NSDictionary *)dict {
    
    if (DICT_IS_NIL(dict)) {
        return;
    }

    //get Details
    NSString *createDate = dict[@"Created At"];
    NSString *distance = dict[@"Dist"];
    NSString *issueId = dict[@"ID"];
    NSString *serialNumber = dict[@"Serial Number"];
    if (STR_IS_NIL(createDate)) {
        createDate = @"";
    }
    if (STR_IS_NIL(distance)) {
        distance = @"";
    }
    if (STR_IS_NIL(issueId)) {
        issueId = @"";
    }
    if (STR_IS_NIL(serialNumber)) {
        serialNumber = @"";
    }
    
    [self setUpDistanceLabelWith:distance];
    
    //时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[createDate doubleValue]]];
    self.timeLabel.text = time;
    
    //id
    self.isusseIdLabel.text = issueId;
    
    //serial Number
    self.serialNumberLabel.text = serialNumber;
}

- (void)setUpDistanceLabelWith:(NSString *)distance {
    
    double meters = distance.doubleValue;
    double miles = meters / 1609;
    double feet = meters / 0.3048;
    if (miles < 1) {
        //use feet
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2f feet",feet];
    } else {
        //use miles
        self.distanceLabel.text = [NSString stringWithFormat:@"%.2f miles",miles];
    }
}

@end
