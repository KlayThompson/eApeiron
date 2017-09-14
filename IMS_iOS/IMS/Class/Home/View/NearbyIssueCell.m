//
//  NearbyIssueCell.m
//  Investigator
//
//  Created by Kim on 2017/9/14.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "NearbyIssueCell.h"

@implementation NearbyIssueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)configCellDataWith:(HistoryUnit *)unit {
    
    if (!unit) {
        return;
    }
    
    self.descriptionLabel.text = unit.issueDescription;
    self.distanceLabel.text = unit.title;
}

@end
