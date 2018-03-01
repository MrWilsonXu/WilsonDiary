//
//  TransAppStorePurposeVC.h
//  WilsonDev
//
//  Created by Wilson on 01/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransAppStorePurposeVCDelegate;

@interface TransAppStorePurposeVC : UIViewController

@property (weak, nonatomic) id<TransAppStorePurposeVCDelegate> delegate;

@end

@protocol TransAppStorePurposeVCDelegate <NSObject>

- 

@end


