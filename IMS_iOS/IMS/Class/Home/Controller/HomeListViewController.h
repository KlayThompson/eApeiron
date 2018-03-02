//
//  HomeListViewController.h
//  Investigator
//
//  Created by Kim on 2018/3/2.
//  Copyright © 2018年 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HistoryType) {
    
    HistoryTypeAssigned = 0, //Default style
    
    HistoryTypeNearBy = 1,
    
    HistoryTypeRecent = 2,
};

@interface HomeListViewController : UIViewController

@property (nonatomic, assign) HistoryType historyType;

@end
