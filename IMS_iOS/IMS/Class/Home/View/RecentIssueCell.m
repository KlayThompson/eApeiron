//
//  RecentIssueCell.m
//  Investigator
//
//  Created by Kim on 2017/9/14.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "RecentIssueCell.h"

@implementation RecentIssueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configCellDataWith:(HistoryUnit *)unit {

    if (!unit) {
        return;
    }
    //describtion
    self.describtionLabel.text = unit.issueDescription;
    
    //时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[unit.updated_at doubleValue]]];
    self.timeLabel.text = time;
}

@end
