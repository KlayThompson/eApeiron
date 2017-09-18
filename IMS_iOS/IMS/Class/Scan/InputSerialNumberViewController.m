//
//  InputSerialNumberViewController.m
//  Investigator
//
//  Created by Kim on 2017/9/18.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "InputSerialNumberViewController.h"

@interface InputSerialNumberViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

@property (weak, nonatomic) IBOutlet UITextField *serialNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *creatRecordButton;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;


@end

@implementation InputSerialNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - Network
- (void)loadServer {

}

#pragma mark - Actions
- (IBAction)creatRecordButtonTap:(id)sender {
}

- (IBAction)mapButtonTap:(id)sender {
}

#pragma mark - UI
- (void)setupUI {

    self.creatRecordButton.layer.cornerRadius = 5;
    self.creatRecordButton.layer.masksToBounds = true;
    self.creatRecordButton.layer.borderWidth = 1;
    self.creatRecordButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.mapButton.layer.cornerRadius = 5;
    self.mapButton.layer.masksToBounds = true;
    self.mapButton.layer.borderWidth = 1;
    self.mapButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
}


@end
