//
//  DetailIssueView.h
//  Investigator
//
//  Created by Kim on 2018/3/5.
//  Copyright © 2018年 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailIssueView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UITableView *uTableView;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

- (void)configDetailIssueViewWith:(NSDictionary *)dict;

@end
