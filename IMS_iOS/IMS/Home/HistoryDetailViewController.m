//
//  HistoryDetailViewController.m
//  Investigator
//
//  Created by Kim on 2017/9/12.
//  Copyright © 2017年 kodak. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import "IMSAPIManager.h"
#import "HistoryModel.h"
#import "YYModel.h"

static NSString *cellId = @"cellId";

@interface HistoryDetailViewController ()<UITableViewDelegate,UITableViewDataSource> {

    NSInteger sectionState[19];

}

@property (weak, nonatomic) IBOutlet UITableView *uTableView;

@end

@implementation HistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadHistoryFromServer];
    
    [self.uTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

#pragma mark - 网络
- (void)loadHistoryFromServer {

    [IMSAPIManager ims_getHistoryWithLatitude:@"0"
                                    longitude:@"0"
                                        limit:@"10"
                                     deviceId:[OpenUDID value]
                                        Block:^(id JSON, NSError *error) {
                                            
                                            HistoryModel *model = [HistoryModel yy_modelWithDictionary:JSON];
                                            
        
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (sectionState[section]) {
        return 10;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    cell.textLabel.text = @"123423123";
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    //返回一个button吧
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, ScreenWidth, 30);
    button.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [button addTarget:self action:@selector(sectionTap:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.tag = 101 + section;
    if (section == 0) {
        if (sectionState[section] != 0) {
            [button setTitle:@"Recent Issues On" forState:UIControlStateNormal];
        } else {
            [button setTitle:@"Recent Issues Off" forState:UIControlStateNormal];
        }
    } else if (section == 1) {
        if (sectionState[section] != 0) {
            [button setTitle:@"Nearby Issues On" forState:UIControlStateNormal];
        } else {
            [button setTitle:@"Nearby Issues Off" forState:UIControlStateNormal];
        }
    } else {
        return [UIView new];
    }
    
    
    return button;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

#pragma mark - Acrions
- (void)sectionTap:(UIButton *)button {

    NSInteger section = button.tag - 101;
    
    sectionState[section] = !sectionState[section];
    
    [self.uTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

@end
