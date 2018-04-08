//
//  CommonTool.m
//  WilsonDev
//
//  Created by Wilson on 4/8/18.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "CommonTool.h"

@implementation CommonTool

+ (NSString *)sizeFormatted:(NSNumber *)size {
    
    double convertedValue = [size doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = @[@"B", @"KB", @"MB", @"GB", @"TB"];
    
    while(convertedValue > 1024){
        convertedValue /= 1024;
        
        multiplyFactor++;
    }
    
    NSString *sizeFormat = ((multiplyFactor > 1) ? @"%.2f %@" : @"%.f %@");
    return [NSString stringWithFormat:sizeFormat, convertedValue, tokens[multiplyFactor]];
}

+ (uint64_t)getFreeDiskspace {
    uint64_t totalSpace = 0.0f;
    uint64_t totalFreeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes floatValue];
        totalFreeSpace = [freeFileSystemSizeInBytes floatValue];
        NSLog(@"Memory Capacity of %llu GB with %llu GB Free memory available.", ((totalSpace/1024ll)/1024ll/1024ll), ((totalFreeSpace/1024ll)/1024ll/1024ll));
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return totalFreeSpace;
}

@end
