//
//  Person.h
//  WilsonDev
//
//  Created by Wilson on 2020/3/28.
//  Copyright © 2020 Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject

@property (nonatomic, assign) int score;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSString *name;

@end

NS_ASSUME_NONNULL_END
