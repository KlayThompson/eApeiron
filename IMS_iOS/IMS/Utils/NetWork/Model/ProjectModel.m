//
//  ProjectModel.m
//  Investigator
//
//  Created by Kim on 2017/9/25.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "ProjectModel.h"
#import "UserInfoManager.h"
#import "YYModel.h"

@implementation ProjectModel

- (void)encodeDataWithJson:(id)json {
    
    NSMutableArray <ProjectModel *>*projectArray = [NSMutableArray new];
    UserInfoManager *manager = UserInfoManager.shareInstance;
    
    NSDictionary *messageDic = json[@"Message"];
    NSMutableDictionary *projectDic = [NSMutableDictionary new];
    for (int index  = 0; index < messageDic.allKeys.count; index++) {
        NSString *key = [messageDic.allKeys objectAtIndex:index];
        NSDictionary *valueDic = [messageDic.allValues objectAtIndex:index];
        //取出projectName
        NSString *projectName = [valueDic objectForKey:@"name"];
        NSDictionary *assetsDic = [valueDic objectForKey:@"assets"];
        ProjectDetailModel *model = [ProjectDetailModel yy_modelWithDictionary:assetsDic];
        ProjectModel *project = [ProjectModel new];
        project.projectId = key;
        project.projectName = projectName;
        project.projectDetailModel = model;
        [projectArray addObject:project];
        [projectDic setObject:projectName forKey:key];
    }
    manager.projectDic = projectDic;
    manager.projectAllInfoArray = projectArray;
    
}
@end
