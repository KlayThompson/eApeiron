//
//  MainNavigationController.m
//  Investigator
//
//  Created by Kim on 2017/9/8.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "MainNavigationController.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if (self.childViewControllers.count > 0) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 160, 30);
        [button setTitle:@"Back" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -100, 0, 0)];
        
        
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
    }
    [super pushViewController:viewController animated:animated];
}

- (void)goBack {
    [self popViewControllerAnimated:YES];
}

@end
