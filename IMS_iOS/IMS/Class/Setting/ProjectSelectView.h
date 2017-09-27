//
//  ProjectSelectView.h
//  Investigator
//
//  Created by Kim on 2017/9/27.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectSelectView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *uTableView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;


@end
