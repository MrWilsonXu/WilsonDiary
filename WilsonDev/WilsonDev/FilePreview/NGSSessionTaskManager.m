//
//  NGSSessionTaskManager.m
//  NewGSLib
//
//  Created by Wilson on 17/03/2018.
//  Copyright © 2018 NewGSLib. All rights reserved.
//

#import "NGSSessionTaskManager.h"
#import "CommonTool.h"

@interface NGSSessionTaskManager()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSData *resumeData;
@property (nonatomic, copy) NSURL *moveToPath;

@end

@implementation NGSSessionTaskManager

- (void)dealloc {
    NSLog(@"NGSSessionTaskManager -> dealloc");
}

- (instancetype)initSessionTaskManagerWithUrl:(NSURL *)url moveToPath:(NSURL *)moveToPath {
    if (self = [super init]) {
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                     delegate:self
                                                delegateQueue:[[NSOperationQueue alloc] init]];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        self.downloadTask = [self.session downloadTaskWithRequest:request];
        self.moveToPath = moveToPath;
    }
    return self;
}

#pragma mark - Public

- (void)resumeTask {
    if (self.resumeData) {
        self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
        self.resumeData = nil;
    }
    [self.downloadTask resume];
}

- (void)suspendTask {
    [self.downloadTask suspend];
}

- (void)cancelTask {
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
    }];
}

- (void)finishTasksAndInvalidateSession {
    [self cancelTask];
    [self.session finishTasksAndInvalidate];
}

#pragma mark - NSURLSessionDownloadDelegate

// 每次写入
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    CGFloat progress = 1.0 * totalBytesWritten / totalBytesExpectedToWrite;
    NSString *currentSize = [CommonTool sizeFormatted:@(totalBytesWritten)];
    NSString *totalSize = [CommonTool sizeFormatted:@(totalBytesExpectedToWrite)];
    NSLog(@"下载进度：%f\n下载文件大小%@\n文件大小%@\n",progress,currentSize,totalSize);
    
    if ([self.delegate respondsToSelector:@selector(sessionTaskDownloadProgress:currentDownSize:totalSize:)]) {
        [self.delegate sessionTaskDownloadProgress:progress currentDownSize:currentSize totalSize:totalSize];
    }
}

// 任务完成、暂停、下载出错调用
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSData *resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
    self.resumeData = resumeData;
    [self.downloadTask suspend];
    
    if (error) {
        if ([self.delegate respondsToSelector:@selector(sessionTaskDownloadWithError:)]) {
            [self.delegate sessionTaskDownloadWithError:error];
        }
    }
}

// 下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.moveToPath.path]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.moveToPath.path error:nil];
    }
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:self.moveToPath error:&error];
    if (!error) {
        [self.session finishTasksAndInvalidate];
        
        if ([self.delegate respondsToSelector:@selector(sessionTaskCompleteWithPath:)]) {
            [self.delegate sessionTaskCompleteWithPath:self.moveToPath.path];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(sessionTaskDownloadWithError:)]) {
            [self.delegate sessionTaskDownloadWithError:error];
        }
    }
}

@end
