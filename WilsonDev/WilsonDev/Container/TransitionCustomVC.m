
//
//  TransitionCustomVC.m
//  WilsonDev
//
//  Created by Wilson on 02/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "TransitionCustomVC.h"
#import <SDAutoLayout.h>
#import "AppStroeMainVC.h"

#import "TransitionCustonCell.h"

@interface TransitionCustomVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (strong, nonatomic) UIButton *backBtn;

@end

#define CellIdentify  @"TransitionCustonCell"
@implementation TransitionCustomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.backBtn];
    
    self.backBtn.sd_layout
    .topSpaceToView(self.view, 40)
    .leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .heightIs(40);
    
    self.tableView.sd_layout
    .topSpaceToView(self.backBtn, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 20);
    
    [self.tableView reloadData];
    
}

- (void)backToPresentVC:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransitionCustonCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentify];
    NSString *imgStr = self.dataSource[indexPath.row];
    cell.imgName = imgStr;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:CGRectGetWidth(self.view.frame) tableView:tableView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppStroeMainVC *vc = [[AppStroeMainVC alloc] init];
    NSString *imgStr = self.dataSource[indexPath.row];
    vc.imgStr = imgStr;
    self.currentIndexPath = indexPath;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        for (int i = 1; i < 5; i++) {
            NSString *imgStr = [NSString stringWithFormat:@"banner%d",i];
            [_dataSource addObject:imgStr];
        }
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[TransitionCustonCell class] forCellReuseIdentifier:CellIdentify];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:1];
        [_backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_backBtn setTitle:@"AppStore Transition" forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backToPresentVC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
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
