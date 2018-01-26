//
//  IssueDetailView.m
//  Investigator
//
//  Created by Kim on 2017/9/15.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "IssueDetailView.h"
#import "YYWebImage.h"
#import "UserInfoManager.h"
#import "UIColor+Addtions.h"
#import "UIView+Size.h"

@implementation IssueDetailView

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.baseScrollView.layer.cornerRadius = 5;
    self.baseScrollView.layer.masksToBounds = YES;
    
    self.mapButton.layer.cornerRadius = 5;
    self.mapButton.layer.masksToBounds = true;
    self.mapButton.layer.borderWidth = 0.5;
    self.mapButton.layer.borderColor = [UIColor ims_colorWithHex:0x888888].CGColor;
}

- (void)configIssueDetailViewWith:(HistoryUnit *)unit allProjectsArray:(NSMutableArray <ProjectModel *>*)projects {

    if (!unit) {
        return;
    }
    
    self.idLabel.text = unit.issueId;
//    self.projectLabel.text = unit.projectName;
    self.titleLabel.text = unit.title;
    self.serialNumberLabel.text = unit.serial_number;
    
    self.issueTypeLabel.text = unit.issue_type;
    self.latitudeLabel.text = unit.latitude;
    self.longitudeLabel.text = unit.longitude;
    self.priceLabel.text = unit.price;
    //picture
    [self.productImageView yy_setImageWithURL:[NSURL URLWithString:unit.full_product_image_path] placeholder:[UIImage imageNamed:IMS_DEFAULT_IMAGE]];
    
    self.descriptionLabel.text = unit.issueDescription;
    
    //time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:MM:SS"];
    NSString *time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[unit.created_at doubleValue]]];
    self.createdLabel.text = time;

    for (ProjectModel *model in projects) {
        if ([model.projectId isEqualToString:unit.project_id]) {
            self.projectLabel.text = model.projectName;
            break;
        }
    }

}

- (void)configIssueDetailViewWith:(CheckIncidentModel *)incidentModel {
    if (!incidentModel) {
        return;
    }
    
    self.idLabel.text = incidentModel.issue_id;
    //    self.projectLabel.text = unit.projectName;
    self.titleLabel.text = incidentModel.title;
    self.serialNumberLabel.text = incidentModel.serial_number;
    
    self.issueTypeLabel.text = @"";
    self.latitudeLabel.text = incidentModel.lat;
    self.longitudeLabel.text = incidentModel.lng;
    self.priceLabel.text = incidentModel.authority.product_price;
    //picture
    [self.productImageView yy_setImageWithURL:[NSURL URLWithString:incidentModel.authority.product_image] placeholder:[UIImage imageNamed:IMS_DEFAULT_IMAGE]];
    
    self.descriptionLabel.text = incidentModel.incidentDescription;
    
    //time*
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd  HH:MM:SS"];
//    NSString *time = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[incidentModel.created_at doubleValue]]];
    self.createdLabel.text = @"";
    UserInfoManager *manager = [UserInfoManager shareInstance];
    for (ProjectModel *model in manager.projectsListModel.projects) {
        if ([model.projectId isEqualToString:incidentModel.project_id]) {
            self.projectLabel.text = model.projectName;
            break;
        }
    }
    
    //设置schema
    [self showProductSchemaWith:incidentModel.authority.product_schema];
}

- (void)showProductSchemaWith:(NSDictionary *)dict {
    
    if (DICT_IS_NIL(dict)) {
        return;
    }
    
    int labelHeight = 20, topMargin = 5, leftMargin = 15, keyLabelWidth = 100;
    
    for (int index = 0; index < dict.allKeys.count; index++) {
        NSString *key = [dict.allKeys objectAtIndex:index];
        NSString *value = [dict objectForKey:key];
        
        //创建key value label
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (topMargin + labelHeight)*index + 23, keyLabelWidth, labelHeight)];
        keyLabel.font = [UIFont systemFontOfSize:15];
        keyLabel.textColor = [UIColor blackColor];
        keyLabel.text = key;
        [self.schemeBgView addSubview:keyLabel];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(keyLabel.right + leftMargin, keyLabel.top, self.schemeBgView.width - keyLabelWidth - leftMargin, labelHeight)];
        valueLabel.font = [UIFont systemFontOfSize:15];
        valueLabel.textColor = [UIColor blackColor];
        valueLabel.text = value;
        [self.schemeBgView addSubview:valueLabel];
        
    }
    
    //设置背景视图的高度约束
    self.schemeBgViewHeightCons.constant = 40 + dict.allKeys.count * (labelHeight + topMargin);
}

- (IBAction)closeButtonTap:(id)sender {
    
    self.bgView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:.3 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
