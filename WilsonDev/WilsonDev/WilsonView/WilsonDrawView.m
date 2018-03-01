//
//  WilsonDrawView.m
//  WilsonDev
//
//  Created by Wilson on 2017/12/21.
//  Copyright © 2017年 Wilson. All rights reserved.
//

#import "WilsonDrawView.h"

@interface WilsonDrawView()

@property (assign, nonatomic) CGPoint arrowPoint;

/**
 *  default is WilsonArrowDirectionNone
 */
@property (assign, nonatomic) WilsonArrowDirection arrowDirection;

@end

const CGFloat SelfWidth = 100;
const CGFloat SelfHeight = 200;
const CGFloat arrowWidthHeight = 10;

@implementation WilsonDrawView

- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 3.0f;
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.arrowDirection = WilsonArrowDirectionNone;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self drawBackground:self.bounds inContext:UIGraphicsGetCurrentContext()];
}

- (void)drawBackground:(CGRect)frame inContext:(CGContextRef) context {
    CGFloat originXMin = frame.origin.x;
    CGFloat originXMax = frame.origin.x + frame.size.width;
    CGFloat originYMin = frame.origin.y;
    CGFloat originYMax = frame.origin.y + frame.size.height;
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    const CGFloat coincide = 1.f;
    
    if (self.arrowDirection == WilsonArrowDirectionUp || self.arrowDirection == WilsonArrowDirectionNone) {
        
        const CGFloat arrowXMedium = self.arrowPoint.x;
        const CGFloat arrowXmin = arrowXMedium - arrowWidthHeight/2 - 2;
        const CGFloat arrowXMax = arrowXMedium + arrowWidthHeight/2 + 2;
        const CGFloat arrowYMin = originYMin;
        const CGFloat arrowYMax = originYMin + arrowWidthHeight + coincide;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXMedium, arrowYMin}];
        [arrowPath addLineToPoint: (CGPoint){arrowXMax, arrowYMax}];
        [arrowPath addLineToPoint: (CGPoint){arrowXmin, arrowYMax}];
        [arrowPath addLineToPoint: (CGPoint){arrowXMedium, arrowYMin}];
        
        // Set the color: Sets the fill and stroke colors in the current drawing context.
        [[UIColor lightGrayColor] set];
        
        originYMin += arrowWidthHeight;
        
    } else if (self.arrowDirection == WilsonArrowDirectionDown) {
        
        const CGFloat arrowXMedium = self.arrowPoint.x;
        const CGFloat arrowXmin = arrowXMedium - arrowWidthHeight/2 - 2;
        const CGFloat arrowXMax = arrowXMedium + arrowWidthHeight/ + 2;
        const CGFloat arrowYMin = originYMax - arrowWidthHeight - coincide;
        const CGFloat arrowYMax = originYMax;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXMedium, arrowYMax}];
        [arrowPath addLineToPoint: (CGPoint){arrowXMax, arrowYMin}];
        [arrowPath addLineToPoint: (CGPoint){arrowXmin, arrowYMin}];
        [arrowPath addLineToPoint: (CGPoint){arrowXMedium, arrowYMax}];
        
        // Set the color: Sets the fill and stroke colors in the current drawing context.
        [[UIColor lightGrayColor] set];
        
        originYMax -= arrowWidthHeight;
    }
    
    [arrowPath fill];
    
    const CGRect bodyFrame = {originXMin, originYMin, originXMax - originXMin, originYMax - originYMin};

    CGContextSetLineWidth(context, 0.5);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:bodyFrame cornerRadius:arrowWidthHeight/5];
    CGContextAddPath(context, bezierPath.CGPath);
    
    CGContextEOFillPath(context);
}

#pragma mark - public

- (instancetype)initWithArrowDirection:(WilsonArrowDirection)arrowDirection {
    if (self = [super init]) {
        self = [self init];
        self.arrowDirection = arrowDirection;
    }
    return self;
}

- (void)showInView:(UIView *)inView fromView:(UIView *)fromView {
    [inView addSubview:self];

    CGFloat frameY = 0;
    CGFloat originFrameY = 0;
    
    if (self.arrowDirection == WilsonArrowDirectionUp || self.arrowDirection == WilsonArrowDirectionNone) {
        frameY = fromView.center.y + CGRectGetHeight(fromView.frame)/2;
        originFrameY = fromView.center.y + CGRectGetHeight(fromView.frame)/2;
    } else if (self.arrowDirection == WilsonArrowDirectionDown) {
        frameY = fromView.center.y - CGRectGetHeight(fromView.frame)/2 - SelfHeight;
        originFrameY = fromView.center.y - CGRectGetHeight(fromView.frame)/2;
    }
    
    CGRect finalFrame = CGRectMake(fromView.center.x-SelfWidth/2, frameY, SelfWidth, SelfHeight);
    self.arrowPoint = CGPointMake(CGRectGetWidth(finalFrame)/2, finalFrame.origin.y);
    CGRect originFrame = CGRectMake(finalFrame.origin.x+CGRectGetWidth(finalFrame)/2, originFrameY, 1, 1);
    
    self.frame = originFrame;
    typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.frame = finalFrame;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismissDrawView {
    CGFloat originFrameY = 0;
    
    if (self.arrowDirection == WilsonArrowDirectionUp || self.arrowDirection == WilsonArrowDirectionNone) {
        originFrameY = self.frame.origin.y;
    } else if (self.arrowDirection == WilsonArrowDirectionDown) {
        originFrameY = self.frame.origin.y + CGRectGetHeight(self.frame);
    }
    
    CGRect originFrame = CGRectMake(self.frame.origin.x+CGRectGetWidth(self.frame)/2, originFrameY, 1, 1);
    
    typeof(self) __weak weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.frame = originFrame;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end
