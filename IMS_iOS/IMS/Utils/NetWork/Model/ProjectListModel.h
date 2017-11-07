//
//  ProjectListModel.h
//  Investigator
//
//  Created by Kim on 2017/11/7.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectModel.h"

@interface ProjectListModel : NSObject


@property (nonatomic, strong) NSMutableArray <ProjectModel *>*projects;

@end
