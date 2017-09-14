//
//  HistoryUnit.h
//  Investigator
//
//  Created by Kim on 2017/9/13.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryUnit : NSObject

@property (nonatomic, copy) NSString *issueId;
@property (nonatomic, copy) NSString *project_id;
@property (nonatomic, copy) NSString *issue_type_id;
@property (nonatomic, copy) NSString *tracker_id;
@property (nonatomic, copy) NSString *related_id;
@property (nonatomic, copy) NSString *relation_type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *issueDescription;
@property (nonatomic, copy) NSString *start;
@property (nonatomic, copy) NSString *end;
@property (nonatomic, copy) NSString *progress;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *updated_at;
@property (nonatomic, copy) NSString *created_by;
@property (nonatomic, copy) NSString *closed;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *product_name;
@property (nonatomic, copy) NSString *product_image_path;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *serial_number;
@property (nonatomic, copy) NSString *full_product_image_path;

@end
