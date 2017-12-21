//
//  WilsonDrawView.h
//  WilsonDev
//
//  Created by Wilson on 2017/12/21.
//  Copyright © 2017年 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WilsonArrowDirection){
    WilsonArrowDirectionNone,
    WilsonArrowDirectionUp,
    WilsonArrowDirectionDown
};

@interface WilsonDrawView : UIView

- (instancetype)initWithArrowDirection:(WilsonArrowDirection)arrowDirection;

- (void)showInView:(UIView *)inView fromView:(UIView *)fromView;

- (void)dismissDrawView;

@end
