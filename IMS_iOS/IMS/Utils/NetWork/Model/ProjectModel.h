//
//  ProjectModel.h
//  Investigator
//
//  Created by Kim on 2017/9/25.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectDetailModel.h"

@interface ProjectModel : NSObject

@property (nonatomic, copy) NSString *projectId;

@property (nonatomic, copy) NSString *projectName;

@property (nonatomic, strong) ProjectDetailModel *projectDetailModel;

@property (nonatomic, assign) BOOL didSelected;
@end
