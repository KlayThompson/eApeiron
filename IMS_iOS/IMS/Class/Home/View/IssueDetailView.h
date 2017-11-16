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

- (void)configIssueDetailViewWith:(HistoryUnit *)unit allProjectsArray:(NSMutableArray <ProjectModel *>*)projects;
@end
