//
//  ShowEapeironWebViewController.m
//  Investigator
//
//  Created by Kim on 2017/12/6.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "ShowEapeironWebViewController.h"

@interface ShowEapeironWebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ShowEapeironWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.eapeiron.com/"];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (NSString *)title {
    return @"eapeiron";
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
