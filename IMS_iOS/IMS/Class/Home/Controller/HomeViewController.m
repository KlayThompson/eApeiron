//
//  HomeViewController.m
//  IMS
//
//  Created by Kim on 15/3/9.
//  Copyright (c) 2015年 kodak. All rights reserved.
//

#import "HomeViewController.h"
#import "HistoryDetailViewController.h"
#import "UserInfoManager.h"
#import "IMSAPIManager.h"
#import "YYWebImage.h"
#import "ProjectModel.h"
#import "UIColor+Addtions.h"

@interface HomeViewController ()
{
    UITabBar *_tabBar;
    UITabBarItem *itemBase;
    
    UIWebView *_webView;
    CLLocationManager *_locationManager;
    CLLocation *_loc;
}

/**
 查看历史button
 */
@property (nonatomic, strong) UIButton *historyButton;

@property (nonatomic, strong) UIImageView *topImageView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
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
//    [self.view addSubview:_tabBar];  
    
    //
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 20 - 49)];
    _webView.delegate = self;
//    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@#home",kHostURL_USA]]]];
//    [self.view addSubview:_webView];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //每次在Home界面出现时候更新位置
    [_locationManager startUpdatingLocation];
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
   
    UserInfoManager *userInfo = [UserInfoManager shareInstance];
    userInfo.longitude = [NSString stringWithFormat:@"%f",_loc.coordinate.longitude];
    userInfo.latitude = [NSString stringWithFormat:@"%f",_loc.coordinate.latitude];
    
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

#pragma mark - 此处为最新修改部分
- (void)setupUI {
    
    UserInfoManager *manager = [UserInfoManager shareInstance];
    self.navigationItem.title = manager.appName;
    
    [self.view addSubview:self.historyButton];
    [self.view addSubview:self.topImageView];
    [self updateTopImage];
    //增加GetProject成功通知，主要用于更新图标
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTopImage)
                                                 name:IMS_NOTIFICATION_GETPROJECSSUCCESS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTopImage)
                                                 name:IMS_NOTIFICATION_CHANGEPROJECT
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateLocation)
                                                 name:IMS_NOTIFICATION_UPDATELOCATION
                                               object:nil];
}

- (void)updateTopImage {
    
//    BOOL ss = YYImageWebPAvailable();
    UserInfoManager *manager = [UserInfoManager shareInstance];
    //获取当前Project
    for (ProjectModel *model in manager.projectAllInfoArray) {
        if ([manager.currentProjectId isEqualToString:model.projectId]) {
            [self.topImageView yy_setImageWithURL:[NSURL URLWithString:model.projectDetailModel.mobileLogo] placeholder:[UIImage imageNamed:IMS_DEFAULT_IMAGE]];
        }
    }
}

- (void)updateLocation {
    
    [_locationManager startUpdatingLocation];
}

- (UIButton *)historyButton {

    if (_historyButton == nil) {
        _historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_historyButton setTitle:@"History" forState:UIControlStateNormal];
        [_historyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_historyButton setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
        _historyButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _historyButton.frame = CGRectMake(15, 200, ScreenWidth - 20*2, 44);
        _historyButton.layer.cornerRadius = 5;
        _historyButton.layer.masksToBounds = YES;
        _historyButton.layer.borderWidth = 1;
        _historyButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_historyButton addTarget:self action:@selector(gotoHistoryDetailView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _historyButton;
}

- (UIImageView *)topImageView {

    if (_topImageView == nil) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 90, 133, 100)];
        _topImageView.image = [UIImage imageNamed:IMS_DEFAULT_IMAGE];
        _topImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _topImageView;
}

- (void)gotoHistoryDetailView {
    
    HistoryDetailViewController *detail = [[HistoryDetailViewController alloc] initWithNibName:@"HistoryDetailViewController" bundle:nil];
    detail.hidesBottomBarWhenPushed = YES;
    detail.title = self.title;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMS_NOTIFICATION_GETPROJECSSUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMS_NOTIFICATION_CHANGEPROJECT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMS_NOTIFICATION_UPDATELOCATION object:nil];
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
