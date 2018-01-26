//
//  IssueDetailView.h
//  Investigator
//
//  Created by Kim on 2017/9/15.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryUnit.h"
#import "ProjectModel.h"
#import "CheckIncidentModel.h"

@interface IssueDetailView : UIView
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdLabel;
@property (weak, nonatomic) IBOutlet UILabel *issueTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *schemeBgView;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *schemeBgViewHeightCons;



/**
 在主界面History中调用
 */
- (void)configIssueDetailViewWith:(HistoryUnit *)unit allProjectsArray:(NSMutableArray <ProjectModel *>*)projects;
/**
 在checkIncident点击detail时候调用
 */
- (void)configIssueDetailViewWith:(CheckIncidentModel *)incidentModel;
@end
