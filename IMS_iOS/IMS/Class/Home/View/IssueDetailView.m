//
//  IssueDetailView.m
//  Investigator
//
//  Created by Kim on 2017/9/15.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "IssueDetailView.h"
#import "YYWebImage.h"

@implementation IssueDetailView

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.baseScrollView.layer.cornerRadius = 5;
    self.baseScrollView.layer.masksToBounds = YES;
    
}

- (void)configIssueDetailViewWith:(HistoryUnit *)unit {

    if (!unit) {
        return;
    }
    
    self.idLabel.text = unit.issueId;
    self.projectLabel.text = unit.projectName;
    self.titleLabel.text = unit.title;
    self.serialNumberLabel.text = unit.serial_number;
    
    self.issueTypeLabel.text = unit.issue_type;
    self.latitudeLabel.text = unit.latitude;
    self.longitudeLabel.text = unit.longitude;
    self.priceLabel.text = unit.price;
    //picture
    [self.productImageView yy_setImageWithURL:[NSURL URLWithString:unit.full_product_image_path] placeholder:[UIImage imageNamed:@"missing-thumbnail.jpg"]];
    
    self.descriptionLabel.text = unit.issueDescription;
    
    //time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:MM:SS"];
    NSString *time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[unit.created_at doubleValue]]];
    self.createdLabel.text = time;
}

- (IBAction)closeButtonTap:(id)sender {
    
    [self removeFromSuperview];
}

@end
