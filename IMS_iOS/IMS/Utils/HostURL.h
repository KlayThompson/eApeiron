//
//  HostURL.h
//  Investigator
//
//  Created by Kim on 2017/2/17.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HostURL : NSObject
@property (nonatomic, strong) NSString *changeHost;
@property (nonatomic, strong) NSString *hostURL; 

+ (HostURL *)defaultManager;
//- (void)baseHostURL;
- (void)changeHostURL:(NSString *)url;
@end
