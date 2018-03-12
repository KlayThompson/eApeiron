//
//  ProjectSelectView.h
//  Investigator
//
//  Created by Kim on 2017/9/27.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectSelectView : UIView
@property (weak, nonatomic) IBOutlet UITableView *uTableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

/**
 如果是主页选择的时候，不能点击背景关闭弹出框
 */
@property (nonatomic, assign) BOOL isHomePage;
@end
