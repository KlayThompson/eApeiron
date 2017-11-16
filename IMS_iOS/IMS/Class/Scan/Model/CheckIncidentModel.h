//
//  CheckIncidentModel.h
//  Investigator
//
//  Created by Kim on 2017/9/19.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CheckIncidentAuthority.h"
#import "MarkersInfoModel.h"

@interface CheckIncidentModel : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *incidentDescription;
@property (nonatomic, copy) NSString *deviceid;
@property (nonatomic, copy) NSString *incident_type;//扫码check的时候不为0方可create，即createRecord按钮可点击
@property (nonatomic, copy) NSString *issue_id;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *project_id;
@property (nonatomic, copy) NSString *region_threshold;
@property (nonatomic, copy) NSString *scanHistoryId;
@property (nonatomic, copy) NSString *scan_threshold;
@property (nonatomic, copy) NSString *serial_number;
@property (nonatomic, copy) NSString *time_threshold;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *usertype;
@property (nonatomic, copy) NSString *mapUrlBase;//地图图片url

@property (nonatomic, strong) NSMutableArray <MarkersInfoModel *>*markersInfo;


@property (nonatomic, strong) CheckIncidentAuthority *authority;

@end


