//
//  DetailIssueView.m
//  Investigator
//
//  Created by Kim on 2018/3/5.
//  Copyright © 2018年 kodak. All rights reserved.
//

#import "DetailIssueView.h"
#import "DetailIssueCell.h"

static NSString *cellId = @"DetailIssueCell";

@interface DetailIssueView ()<UITableViewDataSource,UITableViewDelegate>

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
    
    [cell configDetailIssueCellWithKey:key value:value];
    
    return cell;
}

#pragma mark - Action
- (IBAction)closeButonTap:(id)sender {
    self.bgView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:.3 animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
