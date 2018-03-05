//
//  AppStroeMainVC.m
//  WilsonDev
//
//  Created by Wilson on 02/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "AppStroeMainVC.h"
#import "WilsonTransitonMar.h"
#import <SDAutoLayout.h>

@interface AppStroeMainVC ()<UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UITableViewHeaderFooterView *headerView;

@end

@implementation AppStroeMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    
    [self customHeaderView];
    [self customViews];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)customViews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"ico_close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    CGFloat topSpace = 15;
    if (([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)) {
        topSpace += 24;
    }
    
    button.sd_layout
    .topSpaceToView(self.view, topSpace)
    .rightSpaceToView(self.view, 15)
    .widthIs(40)
    .heightIs(40);

}

- (void)customHeaderView {
    CGFloat proportion = 108.0 / 192;
    CGFloat viewWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat viewHeight = viewWidth * proportion;
    
    self.headerView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    self.imgView.frame = self.headerView.frame;
    self.imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imgStr]];
 
    [self.headerView addSubview:self.imgView];
}

#pragma mark - Public

- (void)setImgStr:(NSString *)imgStr {
    _imgStr = imgStr;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [WilsonTransitonMar transitionWithTransitionType:WilsonTransitonMarTypePresent];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [WilsonTransitonMar transitionWithTransitionType:WilsonTransitonMarTypeDismiss];
}

#pragma mark - getter

- (void)backVC:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewHeaderFooterView *)headerView {
    if (!_headerView) {
        _headerView = [[UITableViewHeaderFooterView alloc] init];
    }
    return _headerView;
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
