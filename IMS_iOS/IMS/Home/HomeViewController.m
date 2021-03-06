//
//  HomeViewController.m
//  IMS
//
//  Created by Kim on 15/3/9.
//  Copyright (c) 2015年 kodak. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
{
    UITabBar *_tabBar;
    UITabBarItem *itemBase;
    
    UIWebView *_webView;
    CLLocationManager *_locationManager;
    CLLocation *_loc;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    //
    _tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, ScreenHeight - 49, ScreenWidth, 49)];
    [_tabBar setBackgroundColor:[UIColor clearColor]];
    UITabBarItem *homeItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"ic_menu_home_selected"] selectedImage:[UIImage imageNamed:@"ic_menu_home"]];
    UITabBarItem *scanItem = [[UITabBarItem alloc] initWithTitle:@"Scan" image:[UIImage imageNamed:@"ic_scan"] selectedImage:[UIImage imageNamed:@"ic_scan_selected"]];
    UITabBarItem *setItem = [[UITabBarItem alloc] initWithTitle:@"Settings" image:[UIImage imageNamed:@"ic_settings"] selectedImage:[UIImage imageNamed:@"ic_settings_selected"]];
    NSArray *items = @[homeItem, scanItem, setItem];
    [_tabBar setItems:items animated:YES];
    [_tabBar setDelegate:self];
    [self.view addSubview:_tabBar];  
    
    //
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 20 - 49)];
    _webView.delegate = self;
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@#home",kHostURL_USA]]]];
    [self.view addSubview:_webView];
    DLog(@"kHostURL_USA == %@",[HostURL defaultManager].hostURL);
    
    //_locationManager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    if ([[UIDevice currentDevice].systemVersion floatValue] > 8) {
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
    }
    [_locationManager startUpdatingLocation]; 
}
- (void)updateLoad
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@#home",[HostURL defaultManager].hostURL]]]];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //
    [Hud stop];
}
 
#pragma mark -
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [Hud start];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [Hud stop];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [Hud showMessage:error.description];
}

#pragma mark - delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if ([item.title isEqualToString:@"Home"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_webView stringByEvaluatingJavaScriptFromString:@"appClientInterface('{\"page\": \"#home\"}');"];
        });
    }
    else if ([item.title isEqualToString:@"Scan"]) {
        if (!_webView.isLoading) {
//            ScanViewController *scan = [[ScanViewController alloc] init];
//            [scan setDelegate:self];
//            [self presentViewController:scan animated:NO completion:^{
//            }];
            AVMetadataController *scan = [[AVMetadataController alloc] init];
            [scan setDelegate:self];
            [self presentViewController:scan animated:NO completion:^{
            }];
        }
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_webView stringByEvaluatingJavaScriptFromString:@"appClientInterface('{\"page\": \"showSettingsPanel\"}');"];
        });
    }
    [_tabBar setSelectedItem:nil];
    
}

- (void)returnSerial:(NSString *)serial covertSerial:(NSString *)covertSerial
{
    if (serial == nil) {
        NSString *string = [NSString stringWithFormat:@"appClientInterface('{\"page\": \"#scan\"}');"];
        DLog(@"string = %@", string);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_webView stringByEvaluatingJavaScriptFromString:string];
        });
    }
    else {
        NSString *string = [NSString stringWithFormat:@"appClientInterface('{\"page\": \"#scan\", \"s\": \"%@\", \"c\":\"%@\", \"d\": \"%@\", \"lat\": \"%f\", \"lng\": \"%f\", \"language\": \"%@\"}');", serial, covertSerial, [OpenUDID value], _loc.coordinate.latitude, _loc.coordinate.longitude, [self getLanguage]];
        DLog(@"string = %@", string);
        dispatch_async(dispatch_get_main_queue(), ^{
            [_webView stringByEvaluatingJavaScriptFromString:string];
        });
    }
}

#pragma mark -
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
    _loc = [locations firstObject];
    DLog(@"纬度=%f，经度=%f",_loc.coordinate.latitude,_loc.coordinate.longitude);
    [manager stopUpdatingLocation];
}

#pragma mark - getLanguage
- (NSString *)getLanguage
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString* preferredLang = [languages objectAtIndex:0];
    
    DLog(@"Preferred Language:%@", preferredLang);
    return preferredLang;
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
