//
//  Hud.h
//  IMS
//
//  Created by 赵鑫 on 15/1/25.
//  Copyright (c) 2015年 赵鑫. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 MessageView
 */
@interface MessageView : UIView

@property (nonatomic, assign, readonly) BOOL hasInit;
@property (nonatomic, assign, readonly) BOOL isAnimating;

- (instancetype)init;
- (void)showMessage:(NSString *)message;
@end


/**
 HudView
 */
@interface HudView : UIView

@property (nonatomic, assign, readonly) BOOL hasInit;
@property (nonatomic, assign, readonly) BOOL isAnimating;

- (instancetype)init;
- (void)wait:(CGFloat)time;
- (void)start;
- (void)stop;

@end


/**
 Hud
 */
@interface Hud : NSObject

//MessageView
@property (nonatomic, strong) MessageView *messageView;

//HudView
@property (nonatomic, strong) HudView *hudView;

+ (void)wait;
+ (void)wait:(CGFloat)time;
+ (void)start;
+ (void)stop; 
+ (void)showMessage:(NSString *)message;

@end
