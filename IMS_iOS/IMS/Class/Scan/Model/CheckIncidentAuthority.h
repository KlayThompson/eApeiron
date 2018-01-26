//
//  CheckIncidentAuthority.h
//  Investigator
//
//  Created by Kim on 2017/9/19.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckIncidentAuthority : NSObject


@property (nonatomic, copy) NSString *_logistics_table;
@property (nonatomic, copy) NSString *_region_table;
@property (nonatomic, copy) NSString *authServer;
@property (nonatomic, copy) NSString *distance_threshold;
@property (nonatomic, copy) NSString *exists;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *product_details;
@property (nonatomic, copy) NSString *product_image;
@property (nonatomic, copy) NSString *product_name;
@property (nonatomic, copy) NSString *product_price;
@property (nonatomic, copy) NSString *project_id;
@property (nonatomic, copy) NSString *recall_date;
@property (nonatomic, copy) NSString *recalled;
@property (nonatomic, copy) NSString *scan_threshold;
@property (nonatomic, copy) NSString *serial_number;
@property (nonatomic, copy) NSString *stolen;
@property (nonatomic, copy) NSString *stolen_date;
@property (nonatomic, copy) NSString *time_threshold;

@property (nonatomic, strong) NSDictionary *product_schema;


@end
