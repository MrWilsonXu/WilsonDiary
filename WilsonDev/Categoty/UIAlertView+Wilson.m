//
//  UIAlertView+Wilson.m
//  Wilson
//
//  Created by Wilson on 3/28/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "UIAlertView+Wilson.h"
#import <objc/runtime.h>

@implementation UIAlertView (Wilson)

const char *DismissStr;
const char *CancelStr;
#pragma mark Getter Setter

- (void)setDismissBlock:(CommonBlock)dismissBlock {
    objc_setAssociatedObject(self, &DismissStr, dismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CommonBlock)dismissBlock {
    return objc_getAssociatedObject(self, &DismissStr);
}

- (void)setCancelBlock:(CommonBlock)cancelBlock {
    objc_setAssociatedObject(self, &CancelStr, cancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CommonBlock)cancelBlock {
    return objc_getAssociatedObject(self, &CancelStr);
}

#pragma mark - Public

+ (UIAlertView *)wilsonAlertContent:(NSString *)content
                    cancel:(NSString *)cancel
                   confirm:(NSString *)confirm
              dismissBlock:(CommonBlock)dismissBlock
               cancelBlock:(CommonBlock)cancelBlock {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Prompt" message:content delegate:[self class] cancelButtonTitle:cancel otherButtonTitles:confirm, nil];
    [alertView show];
    [alertView setDismissBlock:dismissBlock];
    [alertView setCancelBlock:cancelBlock];
    
    return alertView;
}

+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        alertView.cancelBlock(buttonIndex);
    } else {
        alertView.dismissBlock(buttonIndex);
    }
}

@end
