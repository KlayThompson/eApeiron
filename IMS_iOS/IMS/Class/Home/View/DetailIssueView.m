//
//  DetailIssueView.m
//  Investigator
//
//  Created by Kim on 2018/3/5.
//  Copyright © 2018年 kodak. All rights reserved.
//

#import "DetailIssueView.h"
#import "DetailIssueCell.h"
#import "UIView+Size.h"
#import "UIColor+Addtions.h"

static NSString *cellId = @"DetailIssueCell";

@interface DetailIssueView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, copy) NSDictionary *detailDic;

@end

@implementation DetailIssueView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.uTableView.tableFooterView = [UIView new];
    self.uTableView.dataSource = self;
    self.uTableView.delegate = self;
    self.uTableView.estimatedRowHeight = 60;
    self.uTableView.rowHeight = UITableViewAutomaticDimension;
    [self.uTableView registerNib:[UINib nibWithNibName:@"DetailIssueCell" bundle:nil] forCellReuseIdentifier:cellId];
    [self.footerView addSubview:self.mapButton];
    self.uTableView.tableFooterView = self.footerView;
}

- (void)configDetailIssueViewWith:(NSDictionary *)dict {
    
    NSDictionary *dic = dict[@"Details"];
    if (DICT_IS_NIL(dic)) {
        return;
    }
    
    self.detailDic = dic;
    
    [self.uTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.detailDic.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];

    NSString *key = [self.detailDic.allKeys objectAtIndex:indexPath.row];
    
    id value = self.detailDic[key];
    
    if ([key isEqualToString:@"Latitude"]) {
        self.lat = self.detailDic[@"Latitude"];
    } else if ([key isEqualToString:@"Longitude"]) {
        self.lng = self.detailDic[@"Longitude"];
    }
    
    [cell configDetailIssueCellWithKey:key value:value];
    
    return cell;
}

#pragma mark - Action
- (IBAction)closeButonTap:(id)sender {
    self.coverView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:.3 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 初始化
- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, 100)];
        _footerView.backgroundColor = [UIColor whiteColor];
    }
    return _footerView;
}

- (UIButton *)mapButton {
    if (_mapButton == nil) {
        _mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mapButton.frame = CGRectMake(15, 30, self.bgView.width - 30, 40);
        _mapButton.backgroundColor = [UIColor ims_colorWithHex:0xf0f0f0];
        _mapButton.layer.cornerRadius = 5;
        _mapButton.layer.masksToBounds = YES;
        _mapButton.layer.borderWidth = 0.5;
        _mapButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [_mapButton setTitle:@"Map" forState:UIControlStateNormal];
        [_mapButton setTitleColor:[UIColor ims_colorWithHex:0x888888] forState:UIControlStateNormal];
    }
    return _mapButton;
}
@end
