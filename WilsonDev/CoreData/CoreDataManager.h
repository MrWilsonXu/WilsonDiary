//
//  CoreDataManager.h
//  WilsonDev
//
//  Created by Wilson on 2020/3/28.
//  Copyright © 2020 Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^Success) (void);
typedef void (^Failure) (NSError *error);

@interface CoreDataManager : NSObject

+ (instancetype)shared;

- (BOOL)save:(Student *)student;

- (BOOL)remove:(int)score;

- (BOOL)clear;

- (BOOL)alterContent:(int)score;

- (NSArray *)fetchData:(int)score;

- (NSArray *)fetchData;

@end

NS_ASSUME_NONNULL_END
