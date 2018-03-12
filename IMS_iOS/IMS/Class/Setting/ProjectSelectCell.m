//
//  ProjectSelectCell.m
//  Investigator
//
//  Created by Kim on 2017/9/27.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "ProjectSelectCell.h"
#import "YYWebImage.h"
#import "UserInfoManager.h"

@interface ProjectSelectCell() {
    
    ProjectModel *currentModel;
}

@end

@implementation ProjectSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //setup color infomation? is API call w/ JSON reponese sufficient, or is some type of "configurations file" better?
    
    self.selectButton.imageEdgeInsets = UIEdgeInsetsMake(0, 230, 0, 0);
    
}

- (IBAction)selectButtonTap:(id)sender {
    
    if (self.SelectButtonTap) {
        self.SelectButtonTap();
    }
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    self.selectButton.selected = !self.selectButton.selected;
    
    for (ProjectModel *model in manager.projectsListModel.projects) {
        if (self.selectButton.isSelected) {
            if ([model.projectId isEqualToString:currentModel.projectId]) {
                model.didSelected = YES;
            } else {
                model.didSelected = NO;
            }
        } else {
            if ([model.projectId isEqualToString:currentModel.projectId]) {
                model.didSelected = NO;
            } else {
                
            }
        }
    }

}

- (void)configCellDataWithProjectModel:(ProjectModel *)model {
    
    currentModel = model;
    
    self.projectNameLabel.text = model.projectName;
    
    [self.projectImageView yy_setImageWithURL:[NSURL URLWithString:model.projectDetailModel.mobileLogo] placeholder:[UIImage imageNamed:IMS_DEFAULT_IMAGE]];
    
    self.selectButton.selected = model.didSelected;
}

@end
