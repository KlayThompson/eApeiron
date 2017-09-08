//
//  Hud.m
//  IMS
//
//  Created by 赵鑫 on 15/1/25.
//  Copyright (c) 2015年 赵鑫. All rights reserved.
//

#import "Hud.h"

/**
 MessageView
 */
@interface MessageView ()
{
    UIView *_viewBack;
    UILabel *_labelMessage;
}
@end
@implementation MessageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //
        [self setFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 2*64)];
        [self setBackgroundColor:[UIColor clearColor]];
        //
        _hasInit = YES;
        
        //
        _viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
        [_viewBack setBackgroundColor:[UIColor blackColor]];
        [_viewBack setAlpha:0.8];
        [_viewBack.layer setMasksToBounds:YES];
        [_viewBack.layer setCornerRadius:4];
        [self addSubview:_viewBack];
        
        //
        _labelMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 44)];
        [_labelMessage setBackgroundColor:[UIColor clearColor]];
        [_labelMessage setTextColor:[UIColor whiteColor]];
        [_labelMessage setFont:[UIFont systemFontOfSize:14]];
        [_labelMessage setNumberOfLines:0];
        [_viewBack addSubview:_labelMessage];
    }
    return self;
}

//
- (void)showMessage:(NSString *)message
{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    _isAnimating = YES;
    
    [_labelMessage setText:message];
    [_labelMessage sizeToFit];
    [_labelMessage setFrame:CGRectMake(10, 10, _labelMessage.frame.size.width, _labelMessage.frame.size.height)];
    
    [_viewBack setFrame:CGRectMake(0, 0, _labelMessage.frame.size.width + 2*10, _labelMessage.frame.size.height + 2*10)];
    [_viewBack setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
    
    [UIView animateWithDuration:0.6 animations:^{
        [_viewBack.layer setAffineTransform:CGAffineTransformMakeScale(1.3, 1.3)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            [_viewBack.layer setAffineTransform:CGAffineTransformIdentity];
        } completion:^(BOOL finished) {
            _isAnimating = NO;
            [self removeFromSuperview];
        }];
    }];
}

@end


/**
 HudView
 */
@interface HudView ()
{
    UIView *_viewBack;
    UIActivityIndicatorView *_activityIndicatorView;
}
@end
@implementation HudView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //
        [self setFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 2*64)];
        [self setBackgroundColor:[UIColor clearColor]];
        //
        _hasInit = YES;
        
        //
        _viewBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_viewBack setBackgroundColor:[UIColor blackColor]];
        [_viewBack setAlpha:0.8];
        [_viewBack.layer setMasksToBounds:YES];
        [_viewBack.layer setCornerRadius:4];
        [_viewBack setCenter:CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2)];
        [self addSubview:_viewBack];
        
        //
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityIndicatorView setCenter:CGPointMake(_viewBack.bounds.size.width/2, _viewBack.bounds.size.height/2)];
        [_viewBack addSubview:_activityIndicatorView];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStop)];
//        [self addGestureRecognizer:tap];
    }
    return self;
}

//wait
- (void)wait:(CGFloat)time
{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    _isAnimating = YES;
    
    //
    [_activityIndicatorView startAnimating];
    
    //
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stop];
    });
}

//start
- (void)start
{
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    _isAnimating = YES;
    
    //
    [_activityIndicatorView startAnimating];
}

//stop
- (void)tapStop
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stop];
    });
}
- (void)stop
{
    [UIView animateWithDuration:0.3 animations:^{
        [_viewBack.layer setAffineTransform:CGAffineTransformMakeScale(1.2, 1.2)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            [_viewBack.layer setAffineTransform:CGAffineTransformIdentity];
        } completion:^(BOOL finished) {
            if (_activityIndicatorView.isAnimating) {
                [_activityIndicatorView stopAnimating];
            }
            _isAnimating = NO;
            [self removeFromSuperview];
        }];
    }];
}
@end


/**
 Hud
 */
@interface Hud ()
@end
@implementation Hud

+ (Hud *)standardDefault
{
    static Hud *hud = nil;
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            hud = [[Hud alloc] init];
        });
    }
    return hud;
}

//wait
+ (void)wait
{
    Hud *hud = [Hud standardDefault];
    
    if (hud.hudView.isAnimating) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stop];
        });
        return;
    }
    if (!hud.hudView.hasInit) {
        hud.hudView = [[HudView alloc] init];
    }
    [hud.hudView wait:0];
}
+ (void)wait:(CGFloat)time
{
    Hud *hud = [Hud standardDefault];
    
    if (hud.hudView.isAnimating) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stop];
        });
        return;
    }
    if (!hud.hudView.hasInit) {
        hud.hudView = [[HudView alloc] init];
    }
    [hud.hudView wait:time];
}

//start
+ (void)start
{
    Hud *hud = [Hud standardDefault];
    
    if (hud.hudView.isAnimating) {
        return;
    }
    
    if (!hud.hudView.hasInit) {
        hud.hudView = [[HudView alloc] init];
    }
    [hud.hudView start];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(180 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (hud.hudView.isAnimating) {
            [self showMessage:@"网络超时!"];
        }
    });
}

//stop
+ (void)stop
{
    Hud *hud = [Hud standardDefault];
    
    if (hud.hudView.isAnimating) {
        [hud.hudView stop];
    }
}

//showMessage
+ (void)showMessage:(NSString *)message
{
    [self stop];
    
    if (message == nil || message.length == 0) {
        message = @"没有要显示的信息!";
    }
    
    Hud *hud = [Hud standardDefault];
    if (hud.hudView.isAnimating) {
        [hud.hudView stop];
    }
    
    if (!hud.messageView.hasInit) {
        hud.messageView = [[MessageView alloc] init];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud.messageView showMessage:message];
    });
}

@end
