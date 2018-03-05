//
//  WeakStrongVC.m
//  WilsonDev
//
//  Created by Wilson on 04/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "WeakStrongVC.h"

@interface WilsonTestClass : NSObject

@property (copy, nonatomic) void (^TestHandler)(NSUInteger result);

@end
@implementation WilsonTestClass
@end

@interface WeakStrongVC ()

@property (strong, nonatomic) WilsonTestClass *wilsonTestClass;

@property (strong, nonatomic) NSString *titleStr;

@end

@implementation WeakStrongVC

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.titleStr addObserver:self forKeyPath:@"keyPath" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self weakStrongHandle];
}

- (void)weakStrongHandle {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.wilsonTestClass.TestHandler(200);
        });
    });

    /**
     *  Strong-Weak Dance
     *  需要注意：当self释放时，block还会执行，使用weakSelf避免循环引用，但此时weakSelf = nil。
     *  对于某些情况下，会导致crash（例如block中执行KVO）
     */
    typeof(self) __weak weakSelf = self;
    
    self.wilsonTestClass.TestHandler = ^(NSUInteger result) {
        weakSelf.titleStr = @"WeakStrong";
        weakSelf.title = weakSelf.titleStr;
        [weakSelf removeObserver:weakSelf forKeyPath:@"keyPath"];
    };
    
}

- (WilsonTestClass *)wilsonTestClass {
    if (!_wilsonTestClass) {
        _wilsonTestClass = [[WilsonTestClass alloc] init];
    }
    return _wilsonTestClass;
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
