//
//  WilsonTransitonMar.h
//  WilsonDev
//
//  Created by Wilson on 01/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WilsonTransitonMarType) {
    WilsonTransitonMarTypePresent,
    WilsonTransitonMarTypeDismiss
};

@interface WilsonTransitonMar : NSObject<UIViewControllerAnimatedTransitioning>

/**
 *  初始化方法
 */
+ (instancetype)transitionWithTransitionType:(WilsonTransitonMarType)transitionType;
- (instancetype)initWithTransitionType:(WilsonTransitonMarType)transitionType;

@end
