//
//  CommonTool.h
//  WilsonDev
//
//  Created by Wilson on 4/8/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTool : NSObject

// Caculate file size
+ (NSString *)sizeFormatted:(NSNumber *)size;
// Get device storage
+ (uint64_t)getFreeDiskspace;
+ (double)availableMemory;
+ (double)usedMemory;
@end
