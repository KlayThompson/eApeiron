//
//  CommonModel.h
//  Investigator
//
//  Created by Kim on 2017/11/27.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonModel : NSObject

//--------------忘记密码 更新账户信息
@property (nonatomic, copy) NSString *Result;
@property (nonatomic, copy) NSString *ErrCode;
@property (nonatomic, copy) NSString *Message;

//-------------退出登录
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *response;
@property (nonatomic, copy) NSString *status;
@end
