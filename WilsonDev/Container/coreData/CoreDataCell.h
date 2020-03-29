//
//  CoreDataCell.h
//  WilsonDev
//
//  Created by Wilson on 2020/3/29.
//  Copyright © 2020 Wilson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataCell : UITableViewCell

- (void)config:(Student *)student;

@end

NS_ASSUME_NONNULL_END
