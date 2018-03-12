//
//  CommonIssueCell.h
//  Investigator
//
//  Created by Kim on 2018/3/12.
//  Copyright © 2018年 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonIssueCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *incidentIdLabel;


- (void)configCellDataWith:(NSDictionary *)dict;
@end
