//
//  ScanViewController.m
//  IMS
//
//  Created by Kim on 14/12/22.
//  Copyright (c) 2014年 kodak. All rights reserved.
//

#import "ScanViewController.h"

@interface UIImageView_Scan : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@end

@implementation UIImageView_Scan

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGRect scanRect = CGRectMake(0.2*rect.size.width, 0.2*rect.size.height, 0.6*rect.size.width, 0.6*rect.size.height);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.6);
    CGContextFillRect(ctx, self.bounds);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//    CGContextStrokeRectWithWidth(ctx, scanRect, 1);//框
    CGContextClearRect(ctx, scanRect);
}

@end


@interface ScanViewController ()
{
    UIImageView *_imageLine;
    NSTimer *_timer;
}
@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, strong) UIImageView *scanView;

@end

@implementation ScanViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    _scanView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 0)];
    [_scanView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scanView];
    
    //
    _capture = [[ZXCapture alloc] init];
    _capture.layer.frame = _scanView.bounds;
    [_capture setCamera:1];
    [_capture setDelegate:self];
    {
        ZXDecodeHints *hint = [ZXDecodeHints hints];
        [hint addPossibleFormat:kBarcodeFormatDataMatrix];
        [hint addPossibleFormat:kBarcodeFormatQRCode];
        _capture.hints = hint;
    }
    [_capture start];
    [_scanView.layer addSublayer:_capture.layer];
    
    //
    UIImageView_Scan *imageBackGround = [[UIImageView_Scan alloc] initWithFrame:_scanView.bounds];
    [_scanView addSubview:imageBackGround];
    
    CGRect rect = CGRectMake(0.2*_scanView.bounds.size.width, 0.2*_scanView.bounds.size.height + 0.3*_scanView.bounds.size.height, 0.6*_scanView.bounds.size.width, 1.5);
    _imageLine = [[UIImageView alloc] initWithFrame:rect];
    _imageLine.backgroundColor = [UIColor redColor];
    [_scanView addSubview:_imageLine];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, 44)];
    [label setText:@"Hover over code with camera.\n Avoid glare an shadows."];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setNumberOfLines:0];
    [self.view addSubview:label];
    [label sizeToFit];
    [label setCenter:CGPointMake(ScreenWidth/2, 20 + label.frame.size.height/2)];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(10, ScreenHeight - 10 - 44, ScreenWidth - 2*10, 44)];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(continueFocus) userInfo:nil repeats:YES];
}

- (void)continueFocus
{
    [_capture setFocusMode:AVCaptureFocusModeAutoFocus];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [_timer invalidate];
    [_capture stop]; 
}

#pragma mark - lightClick
- (void)lightClick
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setTorchMode:(device.torchMode == AVCaptureTorchModeOff) ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}

#pragma mark - cancelClick
- (void)cancelClick
{
    [_capture stop];
    [self dismissViewControllerAnimated:NO completion:^{
//        if (self.scanBlock) {
//            self.scanBlock(nil, nil);
//        }
        if ([_delegate respondsToSelector:@selector(returnSerial:covertSerial:)]) {
            [_delegate returnSerial:nil covertSerial:nil];
        }
    }];
}



#pragma mark - ZXCaptureDelegate Methods
//test
- (void)captureResult:(ZXCapture*)capture result:(ZXResult*)result
{
    int8_t *rawData = result.rawBytes;
    NSString *signature = @"";
    if (rawData != nil && (result.barcodeFormat == kBarcodeFormatQRCode || result.barcodeFormat == kBarcodeFormatDataMatrix)) {
        // byte to hex
        NSMutableString *sb = [NSMutableString stringWithString:@""];
        for (NSInteger i = 0; i < result.length ; i ++) {
            int8_t *xx = (rawData + sizeof(int8_t) * i );
            DLog(@"%s",xx);
            DLog(@"ddaf   %x", *(rawData + sizeof(int8_t) * i) & 0xff);
            [sb appendFormat:@"%02x", *(rawData + sizeof(int8_t) * i) & 0xff];
        }
        // get signature
        long int position = 0;
        long int msglen = 0;
        NSString *strval;
        NSString *divider = @"";
        while (position < sb.length) {
            strval = [sb substringWithRange:NSMakeRange(position, 1)];
            if ([strval isEqualToString:@"4"]) {
                NSString *str = [sb substringWithRange:NSMakeRange(position + 1, 2)];
                msglen = strtoul([str UTF8String],0,16);
                signature = [NSString stringWithFormat:@"%@%li%@",signature, msglen, divider];
                position = position + 2 + msglen * 2 + 1;
            } else {
                break;
            }
            divider = @",";
        }
        DLog(@"signature %@", signature);
    }
    
    DLog(@"barcodeFormat == %@",signature);
    DLog(@"result.text == %@",result.text);
    
    if (!result) {
        return;
    }
    [_capture stop]; 
    
    [self dismissViewControllerAnimated:NO completion:^{
        if ([_delegate respondsToSelector:@selector(returnSerial:covertSerial:)]) {
            [_delegate returnSerial:result.text covertSerial:signature];
        }
//        if (self.scanBlock) {
//            self.scanBlock(result.text, signature);
//        }
    }];
}
- (void)captureSize:(ZXCapture*)capture width:(NSNumber*)width height:(NSNumber*)height
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
