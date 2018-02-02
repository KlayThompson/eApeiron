//
//  ShowMapViewController.h
//  Investigator
//
//  Created by Kim on 2017/10/19.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkersInfoModel.h"

@interface ShowMapViewController : UIViewController

@property (nonatomic, strong) NSMutableArray <MarkersInfoModel *> *markersInfo;
@end
