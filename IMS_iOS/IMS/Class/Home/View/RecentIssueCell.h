//
//  RecentIssueCell.h
//  Investigator
//
//  Created by Kim on 2017/9/14.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryUnit.h"

@interface RecentIssueCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *describtionLabel;

- (void)configCellDataWith:(HistoryUnit *)unit;
@end
