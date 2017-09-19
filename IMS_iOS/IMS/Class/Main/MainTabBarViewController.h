//
//  MainTabBarViewController.h
//  Investigator
//
//  Created by Kim on 2017/9/8.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarViewController : UITabBarController

@property (nonatomic, copy) NSString *serial;
@property (nonatomic, copy) NSString *covertSerial;

//登录成功后重新设置rootViewController
- (void)setRootViewController;
@end
