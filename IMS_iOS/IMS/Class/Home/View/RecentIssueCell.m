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
    
    self.describtionLabel.text = unit.issueDescription;
    self.timeLabel.text = unit.title;
}

@end
