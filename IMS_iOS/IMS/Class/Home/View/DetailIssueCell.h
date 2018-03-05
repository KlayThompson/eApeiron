//
//  DetailIssueCell.h
//  Investigator
//
//  Created by Kim on 2018/3/5.
//  Copyright © 2018年 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailIssueCell : UITableViewCell


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueBgViewHeightCons;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIView *valueBgView;
@property (weak, nonatomic) IBOutlet UIView *schmaBgView;


- (void)configDetailIssueCellWithKey:(NSString *)key value:(id)value;

@end
