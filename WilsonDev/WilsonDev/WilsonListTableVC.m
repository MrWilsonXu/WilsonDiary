//
//  WilsonListTableVC.m
//  WilsonDev
//
//  Created by Wilson on 2017/12/5.
//  Copyright © 2017年 Wilson. All rights reserved.
//

#import "WilsonListTableVC.h"
#import "GestureVC.h"
#import "DrawRectViewVC.h"

@interface WilsonModel : NSObject

@property (strong, nonatomic) void(^DidSelect)(void);

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *vc;

@end
@implementation WilsonModel
@end

@interface WilsonListTableVC ()

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

NSString * const TableViewCellReuseIdentify = @"TableViewCellReuseIdentify";

@implementation WilsonListTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customViews];
    [self customDataSource];
}

- (void)customViews {
    self.title = @"iOS-Diary";
    self.clearsSelectionOnViewWillAppear = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellReuseIdentify];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)customDataSource {
    NSString *vc1 = NSStringFromClass([GestureVC class]);
    NSString *vc2 = NSStringFromClass([DrawRectViewVC class]);
   
    WilsonModel *gesture = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:@"手势操作" vc:vc1];
    WilsonModel *drawView = [self wilsonModelWithSEL:@selector(pushToVCWithSting:) title:@"画图" vc:vc2];
    
    [self.dataSource addObject:gesture];
    [self.dataSource addObject:drawView];
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellReuseIdentify forIndexPath:indexPath];
    WilsonModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WilsonModel *model = self.dataSource[indexPath.row];
    model.DidSelect();
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
