//
//  AVMetadataController.m
//  Investigator
//
//  Created by Kim on 15/7/7.
//  Copyright (c) 2015年 kodak. All rights reserved.
//

#import "AVMetadataController.h"

#import <AVFoundation/AVFoundation.h>

@interface AVMetadataController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIImageView *_imageLine;
    NSTimer *_timer;
}
@end

@implementation AVMetadataController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    }
    else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = CGRectMake(60, 80, ScreenWidth - 2*60, ScreenHeight - 2*80);//self.view.bounds
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    [_session startRunning];
    
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
    
    CGRect rect = _prevLayer.frame;
    _imageLine = [[UIImageView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y + rect.size.height/2, rect.size.width, 1)];
    _imageLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:_imageLine];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(flash) userInfo:nil repeats:YES];
}

- (void)flash
{
    if (_imageLine.alpha == 1) {
        _imageLine.alpha = 0;
    }
    else {
        _imageLine.alpha = 1;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_timer invalidate];
    if (_session.running) {
        [_prevLayer removeFromSuperlayer];
        [_session stopRunning];
    } 
}

#pragma mark - cancelClick
- (void)cancelClick
{
    [self dismissViewControllerAnimated:NO completion:^{ 
        if ([_delegate respondsToSelector:@selector(returnSerial:covertSerial:)]) {
            [_delegate returnSerial:nil covertSerial:nil];
        }
    }];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeDataMatrixCode];
//    NSArray *barCodeTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeDataMatrixCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type]) {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
    }
    NSLog(@"detectionString == %@",detectionString);
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([_delegate respondsToSelector:@selector(returnSerial:covertSerial:)]) {
        [_delegate returnSerial:detectionString covertSerial:@""];
    }
    }];
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
