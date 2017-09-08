//
//  AVMetadataController.h
//  Investigator
//
//  Created by Kim on 15/7/7.
//  Copyright (c) 2015年 kodak. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AVMetadataDelegate <NSObject>

- (void)returnSerial:(NSString *)serial covertSerial:(NSString *)covertSerial;

@end

@interface AVMetadataController : UIViewController

@property (nonatomic, assign) id <AVMetadataDelegate> delegate;

@end
