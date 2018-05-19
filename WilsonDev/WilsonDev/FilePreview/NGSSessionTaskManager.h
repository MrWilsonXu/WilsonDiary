//
//  NGSSessionTaskManager.h
//  NewGSLib
//
//  Created by Wilson on 17/03/2018.
//  Copyright © 2018 NewGSLib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NGSSessionTaskManagerDelegate;

@interface NGSSessionTaskManager : NSObject

- (instancetype)initSessionTaskManagerWithUrl:(NSURL *)url moveToPath:(NSURL *)moveToPath;

- (void)resumeTask;

- (void)suspendTask;

- (void)cancelTask;

- (void)finishTasksAndInvalidateSession;

@property (nonatomic, weak) id<NGSSessionTaskManagerDelegate> delegate;

@end

@protocol NGSSessionTaskManagerDelegate <NSObject>

- (void)sessionTaskDownloadProgress:(CGFloat)progress currentDownSize:(NSString *)currentDownSize totalSize:(NSString *)totalSize;

- (void)sessionTaskCompleteWithPath:(NSString *)path;

- (void)sessionTaskDownloadWithError:(NSError *)error;

@end
