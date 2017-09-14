//
//  HistoryModel.h
//  Investigator
//
//  Created by Kim on 2017/9/13.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryUnit.h"

@interface HistoryModel : NSObject

@property (nonatomic, strong) NSMutableArray <HistoryUnit *>*issuesByTime;

@property (nonatomic, strong) NSMutableArray <HistoryUnit *>*issuesByProx;

@end

