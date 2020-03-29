//
//  CoreDataViewController.m
//  WilsonDev
//
//  Created by Wilson on 2020/3/28.
//  Copyright © 2020 Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreDataViewController.h"
#import "CoreDataManager.h"
#import "Student.h"
#import "CoreDataCell.h"

@interface CoreDataViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) NSMutableArray *dataSource;
@property(nonatomic, retain) UILabel *toast;

@end

@implementation CoreDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

- (void)setupView {
    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, width, 160)];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.backgroundColor = UIColor.yellowColor;
    [self.view addSubview:stackView];
    UIButton *insert = [self create:@"插入随机数" sel:@selector(insert)];
    UIButton *delet = [self create:@"删除成绩小于60分" sel:@selector(delet)];
    UIButton *clear = [self create:@"删除所有数据" sel:@selector(clearData)];
    UIButton *fetch = [self create:@"查找成绩高于90分" sel:@selector(fetch)];
    [stackView addArrangedSubview:insert];
    [stackView addArrangedSubview:delet];
    [stackView addArrangedSubview:clear];
    [stackView addArrangedSubview:fetch];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 160, width, self.view.bounds.size.height-160-88) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"CoreDataCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.toast];
}

- (UIButton *)create:(NSString *)title sel:(SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)showToast:(NSString *)contet {
    self.toast.text = contet;
    self.toast.hidden = false;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.toast.hidden = YES;
    });
}

//为了观察数据库操作，直接取数据库
- (void)insert {
    Student *std = [[Student alloc] init];
    std.score = arc4random() % 100;
    std.name = [NSString stringWithFormat:@"JACK-%d", arc4random() % 50];
    std.height = arc4random() % 180;
    [[CoreDataManager shared] save:std];
    [self fetchAllData];
}

- (void)clearData {
    BOOL isSuccess = [[CoreDataManager shared] clear];
    if (isSuccess) {
        [self showToast:@"删除数据成功"];
        return;
    }
    [self fetchAllData];
}

- (void)delet {
    BOOL isSuccess = [[CoreDataManager shared] remove:60];
    if (!isSuccess) {
        [self showToast:@"删除数据失败！"];
        return;
    }
    [self fetchAllData];
}

- (void)fetch {
    NSArray *data = [[CoreDataManager shared] fetchData:90];
    if (data.count == 0) {
        [self showToast:@"未查询到数据！"];
        return;
    }
    self.dataSource = [NSMutableArray arrayWithArray:data];
    [self.tableView reloadData];
}

- (void)fetchAllData {
    NSArray *allData = [[CoreDataManager shared] fetchData];
    self.dataSource = [NSMutableArray arrayWithArray:allData];
    [self.tableView reloadData];
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (UILabel *)toast {
    if (_toast == nil) {
        _toast = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _toast.adjustsFontSizeToFitWidth = YES;
    }
    return _toast;
}

#pragma mark UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CoreDataCell *cell = (CoreDataCell *)[tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    Student *std = self.dataSource[indexPath.row];
    [cell config:std];
    return cell;
}

@end
