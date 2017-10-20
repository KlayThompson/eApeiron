//
//  ShowMapViewController.m
//  Investigator
//
//  Created by Kim on 2017/10/19.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "ShowMapViewController.h"
#import "YYWebImage.h"

@interface ShowMapViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;

@end

@implementation ShowMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *mapSize = [NSString stringWithFormat:@"%.0fx%.0f",ScreenWidth,ScreenHeight - 64];
    self.mapUrl = [NSString stringWithFormat:@"%@%@",self.mapUrl,mapSize];
    self.mapUrl = [self.mapUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.mapImageView yy_setImageWithURL:[NSURL URLWithString:self.mapUrl] placeholder:[UIImage imageNamed:@""]];

}
- (IBAction)backButtonTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
