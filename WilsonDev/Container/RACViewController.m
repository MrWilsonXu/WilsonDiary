//
//  RACViewController.m
//  WilsonDev
//
//  Created by Klion on 2020/7/27.
//  Copyright © 2020 Wilson. All rights reserved.
//

#import "RACViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACViewController ()

@property (nonatomic, strong) UIButton *contentBtn;
@property (nonatomic, strong) UIButton *changeBtn;

@end

@implementation RACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
    [self testSignal];
}

- (void)setupUI {
    [self.view addSubview:self.contentBtn];
    [self.view addSubview:self.changeBtn];
}

- (void)testSignal {
    [[self.contentBtn rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        
    }];
}

- (void)changeValue:(UIButton *)sender {
    NSString *value = [NSString stringWithFormat:@"%d", arc4random() % 100000];
    [self.contentBtn setTitle:value forState:UIControlStateNormal];
}

#pragma mark - 懒加载
- (UIButton *)contentBtn {
    if (!_contentBtn) {
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _contentBtn.frame = CGRectMake(16, 300, 100, 44);
        _contentBtn.backgroundColor = UIColor.blackColor;
    }
    return _contentBtn;
}

- (UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _changeBtn.frame = CGRectMake(16, 100, 100, 44);
        _changeBtn.backgroundColor = UIColor.orangeColor;
        [_changeBtn setTitle:@"改变值" forState:UIControlStateNormal];
        [_changeBtn addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}

@end
