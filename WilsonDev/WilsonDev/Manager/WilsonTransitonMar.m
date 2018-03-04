//
//  WilsonTransitonMar.m
//  WilsonDev
//
//  Created by Wilson on 01/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "WilsonTransitonMar.h"
#import "TransitionCustomVC.h"
#import "AppStroeMainVC.h"

#import "TransitionCustonCell.h"

@interface WilsonTransitonMar()

@property (assign, nonatomic) WilsonTransitonMarType type;

@end

@implementation WilsonTransitonMar

#pragma mark - Public

+ (instancetype)transitionWithTransitionType:(WilsonTransitonMarType)transitionType {
    return [[self alloc] initWithTransitionType:transitionType];
}

- (instancetype)initWithTransitionType:(WilsonTransitonMarType)transitionType {
    if (self = [super init]) {
        _type = transitionType;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.type) {
            case WilsonTransitonMarTypePresent:{
                [self presentAnimation:transitionContext];
            }
            break;
            
            case WilsonTransitonMarTypeDismiss:{
                [self dismissAnimation:transitionContext];
            }
            break;
            
        case WilsonTransitonMarTypePush:{
            [self doPushAnimation:transitionContext];
        }
            break;
            
        case WilsonTransitonMarTypePop:{
            [self doPopAnimation:transitionContext];
        }
            break;
        default:
            break;
    }
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

#pragma mark - Helper

/**
 *  Present
 */
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    TransitionCustomVC *fromVC = (TransitionCustomVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    AppStroeMainVC *toVC = (AppStroeMainVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    //拿到当前点击的cell的imageView
    TransitionCustonCell *cell = (TransitionCustonCell *)[fromVC.tableView cellForRowAtIndexPath:fromVC.currentIndexPath];
    UIView *containerView = [transitionContext containerView];
    //snapshotViewAfterScreenUpdates 对cell的imageView截图保存成另一个视图用于过渡，并将视图转换到当前控制器的坐标
    UIView *tempView = [cell.imageView snapshotViewAfterScreenUpdates:NO];
    tempView.frame = [cell.imageView convertRect:cell.imageView.bounds toView: containerView];
    //设置动画前的各个控件的状态
    cell.imageView.hidden = YES;
    toVC.view.alpha = 0;
    toVC.imgView.hidden = YES;
    //tempView 添加到containerView中，要保证在最前方，所以后添加
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];
    //开始做动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        tempView.frame = [toVC.imgView convertRect:toVC.imgView.bounds toView:containerView];
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        tempView.hidden = YES;
        toVC.imgView.hidden = NO;
        //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中动画完成的部署，会出现无法交互之类的bug
        [transitionContext completeTransition:YES];
    }];
}

/**
 *  Dismiss
 */
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    AppStroeMainVC *fromVC = (AppStroeMainVC *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    TransitionCustomVC *toVC = (TransitionCustomVC *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    TransitionCustonCell *cell = (TransitionCustonCell *)[toVC.tableView cellForRowAtIndexPath:toVC.currentIndexPath];
    UIView *containerView = [transitionContext containerView];
    //这里的lastView就是push时候初始化的那个tempView
    UIView *tempView = containerView.subviews.lastObject;
    //设置初始状态
    cell.imageView.hidden = YES;
    fromVC.imgView.hidden = YES;
    tempView.hidden = NO;
    [containerView insertSubview:toVC.view atIndex:0];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 usingSpringWithDamping:0.55 initialSpringVelocity:1 / 0.55 options:0 animations:^{
        tempView.frame = [cell.imageView convertRect:cell.imageView.bounds toView:containerView];
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        //由于加入了手势必须判断
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {//手势取消了，原来隐藏的imageView要显示出来
            //失败了隐藏tempView，显示fromVC.imageView
            tempView.hidden = YES;
            fromVC.imgView.hidden = NO;
        }else{//手势成功，cell的imageView也要显示出来
            //成功了移除tempView，下一次pop的时候又要创建，然后显示cell的imageView
            cell.imageView.hidden = NO;
            [tempView removeFromSuperview];
        }
    }];
}

/**
 *  执行push过渡动画
 */
- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
   
}
/**
 *  执行pop过渡动画
 */
- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
  
}

@end
