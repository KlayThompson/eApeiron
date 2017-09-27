//
//  ProjectSelectCell.h
//  Investigator
//
//  Created by Kim on 2017/9/27.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectModel.h"

@interface ProjectSelectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UIImageView *projectImageView;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;

@property (copy,nonatomic) void(^SelectButtonTap)();

- (void)configCellDataWithProjectModel:(ProjectModel *)model;

@end
