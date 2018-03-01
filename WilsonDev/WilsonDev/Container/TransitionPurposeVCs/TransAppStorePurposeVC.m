//
//  TransAppStorePurposeVC.m
//  WilsonDev
//
//  Created by Wilson on 01/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "TransAppStorePurposeVC.h"
#import "WilsonTransitonMar.h"

@interface TransAppStorePurposeVC ()<UIViewControllerTransitioningDelegate>

@end

@implementation TransAppStorePurposeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customViews];
}

- (void)customViews {
    self.view.backgroundColor = [UIColor yellowColor];
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [WilsonTransitonMar transitionWithTransitionType:WilsonTransitonMarTypeDismiss];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [WilsonTransitonMar transitionWithTransitionType:WilsonTransitonMarTypePresent];
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
