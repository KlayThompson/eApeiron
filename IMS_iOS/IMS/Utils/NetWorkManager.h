//
//  NetWorkManager.h
//  Investigator
//
//  Created by Kim on 2017/9/8.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkManager : NSObject

@property (nonatomic, assign) BOOL userLoginState;

+ (NetWorkManager *)shareInstance;
@end
