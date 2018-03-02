//
//  HomeViewController.h
//  IMS
//
//  Created by Kim on 15/3/9.
//  Copyright (c) 2015年 kodak. All rights reserved.
//
/**
 ----------------------------------
 已经废弃
 使用HomeRootViewController
 ----------------------------------
 */

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AVMetadataController.h"

@interface HomeViewController : UIViewController <UITabBarDelegate, UIWebViewDelegate, CLLocationManagerDelegate, AVMetadataDelegate>
- (void)updateLoad;


@end
