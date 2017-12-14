//
//  AboutViewController.m
//  Investigator
//
//  Created by Kim on 2017/12/6.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "AboutViewController.h"
#import "ShowEapeironWebViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (ScreenWidth == 320) {
        self.linkButton.titleLabel.font = [UIFont systemFontOfSize:11];
        self.label.font = [UIFont systemFontOfSize:12];
    } else {
        self.linkButton.titleLabel.font = [UIFont systemFontOfSize:13];
        self.label.font = [UIFont systemFontOfSize:15];
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"http://www.eapeiron.com/"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [self.linkButton setAttributedTitle:str forState:UIControlStateNormal];
    
    NSString *currentVersion = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *buildStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.versionLabel.text = [NSString stringWithFormat:@"Version:  %@-%@",currentVersion,buildStr];
}

- (IBAction)linkButtonClick:(id)sender {
    
    ShowEapeironWebViewController *show = [[ShowEapeironWebViewController alloc] init];
    [self.navigationController pushViewController:show animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)title {
    return @"About";
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
