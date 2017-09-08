//
//  SettingsViewController.m
//  IMS
//
//  Created by Kim on 14/12/22.
//  Copyright (c) 2014年 kodak. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
{
    UITabBar *_tabBar;
    UIWebView *_webView;
}
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    [self setTitle:@"Setting"];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    //
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@#showSettingsPanel",[HostURL defaultManager].hostURL]]]];
    [self.view addSubview:_webView];
}

#pragma mark -
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    [Hud start];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    [Hud stop];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [Hud showMessage:error.description];
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
