//
//  NGSQLPreviewVC.m
//  NewGSLib
//
//  Created by Wilson on 22/03/2018.
//  Copyright © 2018 NewGSLib. All rights reserved.
//

#import "NGSQLPreviewVC.h"
#import <QuickLook/QuickLook.h>
#import <AFNetworking.h>
#import "UIView+SDAutolayout.h"
#import "NGSFileDownloadView.h"
#import "NGSSessionTaskManager.h"


@interface NGSQLPreviewVC ()<QLPreviewControllerDelegate, QLPreviewControllerDataSource, NGSFileDownloadViewDelegate, NGSSessionTaskManagerDelegate>

@property (nonatomic, copy) NSURL *fileURL; //文件路径

@property (nonatomic, strong) NGSFileDownloadView *downloadView;

@property (nonatomic, strong) NGSSessionTaskManager *sessionManager;

@end

@implementation NGSQLPreviewVC

- (void)dealloc {
    NSLog(@"%@ -> dealloc",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.URLPath = @"http://resources.newgs.net/shenlun_mianshi/0424chengdu06.pdf?OSSAccessKeyId=0qzfiBreffBeNSjN&Expires=1842079789&Signature=y4LG4v1w5bXeLsl40jLayivud%2Fo%3D";
    self.delegate = self;
    self.dataSource = self;
    [self setNavigationTitle];
    [self customViews];
    [self createDefaultFolder];
    [self requestDataSource];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.sessionManager finishTasksAndInvalidateSession];
}

- (void)customViews {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.downloadView];
    self.downloadView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

- (void)loadPreviewVC {
    [self.view sendSubviewToBack:self.downloadView];
    self.downloadView.hidden = YES;
    /*title为文件后缀名
    NSString *last = self.fileURL.lastPathComponent;
    self.navigationItem.title = last.stringByDeletingPathExtension;*/
    [self reloadPage];
}

- (void)setNavigationTitle {
    self.navigationItem.title = @"文件预览";
}

- (void)reloadPage {
    //刷新界面,如果不刷新的话，不重新走一遍代理方法，返回的url还是上一次的url
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshCurrentPreviewItem];
        [self reloadData];
        [self setNavigationTitle];
    });
}

#pragma amrk - Data

- (void)requestDataSource {
    //获取文件名称，过滤 ？后面参数
    NSURL *url = [NSURL URLWithString:self.URLPath];
    NSString *urlPath = url.path;
    NSString *fileName = [urlPath lastPathComponent];
    
    //判断是否存在
    if ([self isFileExist:fileName]) {
        NSURL *url = [self saveURLFileName:fileName];
        self.fileURL = url;
        [self loadPreviewVC];
        /*调试下载
         if ([[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
         [[NSFileManager defaultManager] removeItemAtPath:url.path error:nil];
         }*/
    } else {
        self.downloadView.hidden = NO;
        self.downloadView.fileTypeContent = [fileName.pathExtension uppercaseString];
        self.downloadView.fileTitle = fileName.stringByDeletingPathExtension;
        
        // iOS 9的设备需要延时加载
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view bringSubviewToFront:self.downloadView];
        });
        
        self.sessionManager = [[NGSSessionTaskManager alloc] initSessionTaskManagerWithUrl:[NSURL URLWithString:self.URLPath] moveToPath:[self saveURLFileName:fileName]];
        self.sessionManager.delegate = self;
    }
}

#pragma mark - NGSFileDownloadViewDelegate

- (void)fileDownloadViewClickStart {
    [self.sessionManager resumeTask];
    self.downloadView.currentDownloadSize = @"正在下载...";
}

#pragma mark - NGSSessionTaskManagerDelegate

- (void)sessionTaskCompleteWithPath:(NSString *)path {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fileURL = [NSURL fileURLWithPath:path];
        self.downloadView.currentDownloadSize = @"下载成功";
        self.downloadView.hidden = YES;
        [self loadPreviewVC];
    });
}

- (void)sessionTaskDownloadProgress:(CGFloat)progress currentDownSize:(NSString *)currentDownSize totalSize:(NSString *)totalSize {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.downloadView.progressValue = progress;
        self.downloadView.fileSize = totalSize;
        self.downloadView.currentDownloadSize = [NSString stringWithFormat:@"正在下载...(%@/%@)",currentDownSize,totalSize];;
    });
}

- (void)sessionTaskDownloadWithError:(NSError *)error {
    NSString *errDes = error.localizedDescription;
    self.downloadView.currentDownloadSize = [NSString stringWithFormat:@"无法下载：%@",errDes];
    self.downloadView.reStart = @"重新下载";
}

#pragma mark - QLPreviewControllerDataSource

-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return self.fileURL;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController{
    return 1;
}

#pragma mark - FilePath

// 用户的文件夹
- (NSString *)userAcUuidPath {
    return [NSString stringWithFormat:@"NGSPDFFolder/kkk"];
}

// 在指定目录下创建 "head" 文件夹
- (NSString *)fileRootPath {
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataFilePath = [docsdir stringByAppendingPathComponent:[self userAcUuidPath]];
    return dataFilePath;
}

// 创建文件夹
- (void)createDefaultFolder {
    
    NSString *dataFilePath = [self fileRootPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
    if (!(isDir == YES && existed == YES) ) {
        [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSLog(@"----pdf保存的路径 %@",dataFilePath);
}

- (NSURL *)saveURLFileName:(NSString *)fileName {
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                          inDomain:NSUserDomainMask
                                                                 appropriateForURL:nil
                                                                            create:NO
                                                                             error:nil];
    
    NSURL *url = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",[self userAcUuidPath],fileName]];
    
    return url;
}

//判断文件是否已经在沙盒中存在
- (BOOL)isFileExist:(NSString *)fileName {
    NSString *urlStr = [self fullPathFileName:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:urlStr ];
    return result;
}

- (NSString *)fullPathFileName:(NSString*) fileName {
    NSString *urlStr = [[self fileRootPath] stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    return urlStr;
}

#pragma mark - Getter

- (NGSFileDownloadView *)downloadView {
    if (!_downloadView) {
        self.downloadView = [[NGSFileDownloadView alloc] init];
        _downloadView.delegate = self;
        _downloadView.hidden = YES;
        _downloadView.backgroundColor = [UIColor whiteColor];
    }
    return _downloadView;
}

@end
