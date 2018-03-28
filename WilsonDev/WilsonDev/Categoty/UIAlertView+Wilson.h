//
//  UIAlertView+Wilson.h
//  Wilson
//
//  Created by Wilson on 3/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CommonBlock) (NSInteger index);

@interface UIAlertView (Wilson)<UIAlertViewDelegate>

+ (UIAlertView *)wilsonAlertContent:(NSString *)content
                    cancel:(NSString *)cancel
                   confirm:(NSString *)confirm
              dismissBlock:(CommonBlock)dismissBlock
               cancelBlock:(CommonBlock)cancelBlock;

@property (nonatomic, copy) CommonBlock dismissBlock;
@property (nonatomic, copy) CommonBlock cancelBlock;

@end
