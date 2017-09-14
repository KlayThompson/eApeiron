//
//  ScanViewController.h
//  IMS
//
//  Created by Kim on 14/12/22.
//  Copyright (c) 2014年 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZXingObjC/ZXingObjC.h"

@protocol ScanDelegate <NSObject>

- (void)returnSerial:(NSString *)serial covertSerial:(NSString *)covertSerial;

@end

@interface ScanViewController : UIViewController <ZXCaptureDelegate>
 
typedef void (^ScanBlock) (NSString *serial, NSString *covertSerial);
@property (nonatomic, copy) ScanBlock scanBlock;


@property (nonatomic, assign) id <ScanDelegate> delegate;

@end
