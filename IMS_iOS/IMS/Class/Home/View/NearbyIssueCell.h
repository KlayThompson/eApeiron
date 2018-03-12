//
//  NearbyIssueCell.h
//  Investigator
//
//  Created by Kim on 2017/9/14.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NearbyIssueCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *isusseIdLabel;

- (void)configCellDataWith:(NSDictionary *)dict;
@end
