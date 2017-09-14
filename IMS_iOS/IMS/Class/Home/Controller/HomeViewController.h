//
//  HomeViewController.h
//  IMS
//
//  Created by Kim on 15/3/9.
//  Copyright (c) 2015年 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "ScanViewController.h"
#import "AVMetadataController.h"

@interface HomeViewController : UIViewController <UITabBarDelegate, UIWebViewDelegate, CLLocationManagerDelegate, ScanDelegate, AVMetadataDelegate>
- (void)updateLoad;


@end
