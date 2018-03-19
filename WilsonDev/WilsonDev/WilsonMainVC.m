//
//  WilsonMainVC.m
//  WilsonDev
//
//  Created by Wilson on 2018/1/9.
//  Copyright © 2018年 Wilson. All rights reserved.
//

#import "WilsonMainVC.h"
#import "GestureVC.h"
#import "DrawRectViewVC.h"
#import "TransitionMainVC.h"
#import "WeakStrongVC.h"
#import "LocalizableVC.h"

#import "SDAutolayout.h"

@interface WilsonModel : NSObject

@property (strong, nonatomic) void(^DidSelect)(void);

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *vc;

@end
@implementation WilsonModel
@end

@interface WilsonMainVC ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation WilsonMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customViews];
    [self customDataSource];
}

- (void)customViews {
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
    self.navigationItem.title = @"iOS-Diary";
    [self.view addSubview:self.tableView];
}

- (void)customDataSource {
    NSString *vc1 = NSStringFromClass([GestureVC class]);
    NSString *vc2 = NSStringFromClass([DrawRectViewVC class]);
    NSString *vc3 = NSStringFromClass([TransitionMainVC class]);
    NSString *vc4 = NSStringFromClass([WeakStrongVC class]);
    NSString *vc5 = NSStringFromClass([LocalizableVC class]);
    
    WilsonModel *gesture = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:NSLocalizedString(@"GestureHandle", nil) vc:vc1];
    WilsonModel *drawView = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:@"画图" vc:vc2];
    WilsonModel *custom = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:@"转场动画" vc:vc3];
    WilsonModel *weakStrong = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:NSLocalizedStringFromTable(@"WeakStrong", @"Wilson", nil) vc:vc4];
    WilsonModel *localize = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:@"国际化" vc:vc5];
    
    [self.dataSource addObject:gesture];
    [self.dataSource addObject:drawView];
    [self.dataSource addObject:custom];
    [self.dataSource addObject:weakStrong];
    [self.dataSource addObject:localize];
    
    [self.tableView reloadData];
}

- (WilsonModel *)wilsonModelWithSEL:(SEL)sel title:(NSString *)title vc:(NSString *)vc {
    WilsonModel *model = [[WilsonModel alloc] init];
    model.title = title;
    model.vc = vc;
    model.DidSelect = ^{
        [self performSelector:sel withObject:vc];
    };
    return model;
}

#pragma mark - Action

- (void)pushToVCWithSting:(NSString *)string {
    UIViewController *vc = [NSClassFromString(string) new];
    vc.title = string;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    WilsonModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.title;
    cell.contentView.backgroundColor = [UIColor yellowColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WilsonModel *model = self.dataSource[indexPath.row];
    model.DidSelect();
}

#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
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
