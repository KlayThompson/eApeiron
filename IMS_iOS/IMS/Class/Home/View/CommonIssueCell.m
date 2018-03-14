//
//  CommonIssueCell.m
//  Investigator
//
//  Created by Kim on 2018/3/12.
//  Copyright © 2018年 kodak. All rights reserved.
//  Assined & recent Cell

#import "CommonIssueCell.h"

@implementation CommonIssueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCellDataWith:(NSDictionary *)dict {
    
    if (DICT_IS_NIL(dict)) {
        return;
    }
    
    //get Details
    NSString *createDate = dict[@"Created At"];
    NSString *idStr = dict[@"ID"];
    NSString *serialNumber = dict[@"Serial Number"];
    if (STR_IS_NIL(createDate)) {
        createDate = @"";
    }
    if (STR_IS_NIL(idStr)) {
        idStr = @"";
    }
    if (STR_IS_NIL(serialNumber)) {
        serialNumber = @"";
    }
    
    //时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[createDate doubleValue]]];
    self.timeLabel.text = time;
    
    //id
    self.incidentIdLabel.text = idStr;
    
    //serial number
    self.serialNumberLabel.text = serialNumber;
    
}

@end
