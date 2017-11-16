//
//  MarkersInfoModel.h
//  Investigator
//
//  Created by Kim on 2017/11/16.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkersInfoModel : NSObject

@property (nonatomic, strong) NSNumber *zoom;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;

@end
