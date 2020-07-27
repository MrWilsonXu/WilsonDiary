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
#import "NGSQLPreviewVC.h"
#import "MarkdownVC.h"
#import "CoreDataViewController.h"
#import "RACViewController.h"

#import "SDAutolayout.h"

@interface WilsonModel : NSObject

@property (strong, nonatomic) void(^DidSelect)(void);

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *vc;

@end
@implementation WilsonModel
@end

@interface WilsonMainVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *storage;

@property (nonatomic, strong) UILabel *memory;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation WilsonMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customViews];
    [self customDataSource];
    [self testCirculeReference];
}

- (void)customViews {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (@available(iOS 11.0, *)) {
//        self.navigationController.navigationBar.prefersLargeTitles = YES;
//        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
    self.navigationItem.title = @"iOS-Diary";
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 40)];
    view.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:self.storage];
    [view addSubview:self.memory];
    self.tableView.tableHeaderView = view;
    [self.view addSubview:self.tableView];
    
}

- (void)testCirculeReference {
    NSMutableArray *a = [NSMutableArray array];
    NSMutableArray *b = [NSMutableArray array];
    [a addObject:b];
    [b addObject:a];
}

- (void)customDataSource {
    NSString *vc1 = NSStringFromClass([GestureVC class]);
    NSString *vc2 = NSStringFromClass([DrawRectViewVC class]);
    NSString *vc3 = NSStringFromClass([TransitionMainVC class]);
    NSString *vc4 = NSStringFromClass([WeakStrongVC class]);
    NSString *vc5 = NSStringFromClass([LocalizableVC class]);
    NSString *vc6 = NSStringFromClass([NGSQLPreviewVC class]);
    NSString *vc7 = NSStringFromClass([MarkdownVC class]);
    NSString *vc8 = NSStringFromClass([CoreDataViewController class]);
    NSString *vc9 = NSStringFromClass([RACViewController class]);
    
    WilsonModel *gesture = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:NSLocalizedString(@"GestureHandle", nil) vc:vc1];
    WilsonModel *drawView = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:@"画图" vc:vc2];
    WilsonModel *custom = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:@"转场动画" vc:vc3];
    WilsonModel *weakStrong = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:NSLocalizedStringFromTable(@"WeakStrong", @"Wilson", nil) vc:vc4];
    WilsonModel *localize = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:@"国际化" vc:vc5];
    WilsonModel *preview = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:@"文件预览" vc:vc6];
    WilsonModel *markdown = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:@"Markdown" vc:vc7];
    WilsonModel *coreData = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:@"coreData" vc:vc8];
    WilsonModel *RAC = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:@"RAC" vc:vc9];
    
    [self.dataSource addObject:gesture];
    [self.dataSource addObject:drawView];
    [self.dataSource addObject:custom];
    [self.dataSource addObject:weakStrong];
    [self.dataSource addObject:localize];
    [self.dataSource addObject:preview];
    [self.dataSource addObject:markdown];
    [self.dataSource addObject:coreData];
    [self.dataSource addObject:RAC];
    
    [self.tableView reloadData];
    
    double space = (double)[CommonTool getFreeDiskspace];
    double availableMemory = [CommonTool availableMemory];
    double usedMemory = [CommonTool usedMemory];
    NSString *size = [CommonTool sizeFormatted:[NSNumber numberWithDouble:space]];
    self.storage.text = [NSString stringWithFormat:@"Device available storage: %@",size];
    self.memory.text = [NSString stringWithFormat:@"Device usedMemory: %.f\nDevice availableMemory: %.f",usedMemory,availableMemory];
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

#pragma mark - Lazy loading

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UILabel *)storage {
    if (!_storage) {
        self.storage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 20)];
        _storage.textColor = [UIColor blackColor];
        _storage.font = [UIFont systemFontOfSize:12];
    }
    return _storage;
}

- (UILabel *)memory {
    if (!_memory) {
        self.memory = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.frame), 20)];
        _memory.textColor = [UIColor blackColor];
        _memory.font = [UIFont systemFontOfSize:12];
    }
    return _memory;
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
