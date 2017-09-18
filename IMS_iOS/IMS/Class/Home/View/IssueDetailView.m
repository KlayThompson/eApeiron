//
//  IssueDetailView.m
//  Investigator
//
//  Created by Kim on 2017/9/15.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "IssueDetailView.h"

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
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:unit.full_product_image_path]];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.productImageView.image = [UIImage imageWithData:data];
        });
    });
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
