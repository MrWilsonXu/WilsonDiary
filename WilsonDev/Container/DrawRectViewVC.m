//
//  DrawRectViewVC.m
//  WilsonDev
//
//  Created by Wilson on 2017/12/21.
//  Copyright © 2017年 Wilson. All rights reserved.
//

#import "DrawRectViewVC.h"

#import "WilsonDrawView.h"

@interface DrawRectViewVC ()

@property (strong, nonatomic) WilsonDrawView *upDrawView;
@property (strong, nonatomic) WilsonDrawView *downDrawView;

@end

@implementation DrawRectViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSubview];
}

- (void)customSubview {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnWidth = CGRectGetWidth([UIScreen mainScreen].bounds)/2;
    
    UIButton *arrowUp = [UIButton buttonWithType:UIButtonTypeSystem];
    arrowUp.frame = CGRectMake(0, 0, btnWidth, 50);
    [arrowUp setTitle:@"arrowUp" forState:UIControlStateNormal];
    arrowUp.selected = NO;
    [arrowUp addTarget:self action:@selector(clickArrowUp:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *arrowDown = [UIButton buttonWithType:UIButtonTypeSystem];
    arrowDown.frame = CGRectMake(btnWidth, 250, btnWidth, 50);
    [arrowDown setTitle:@"arrowDown" forState:UIControlStateNormal];
    arrowDown.selected = NO;
    [arrowDown addTarget:self action:@selector(clickArrowDown:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:arrowUp];
    [self.view addSubview:arrowDown];
}

#pragma mark - Action

- (void)clickArrowUp:(UIButton *)sender {

    if (sender.selected) {
        [self.upDrawView dismissDrawView];
    } else {
        [self.upDrawView showInView:self.view fromView:sender];
    }
    
    sender.selected = !sender.selected;
}

- (void)clickArrowDown:(UIButton *)sender {
    
    if (sender.selected) {
        [self.downDrawView dismissDrawView];
    } else {
        [self.downDrawView showInView:self.view fromView:sender];
    }
    
    sender.selected = !sender.selected;
}

#pragma mark - Getter

- (WilsonDrawView *)upDrawView {
    if (!_upDrawView) {
        self.upDrawView = [[WilsonDrawView alloc] initWithArrowDirection:WilsonArrowDirectionUp];
    }
    return _upDrawView;
}

- (WilsonDrawView *)downDrawView {
    if (!_downDrawView) {
        self.downDrawView = [[WilsonDrawView alloc] initWithArrowDirection:WilsonArrowDirectionDown];
    }
    return _downDrawView;
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
