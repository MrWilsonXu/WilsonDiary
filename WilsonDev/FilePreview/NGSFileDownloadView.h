//
//  NGSFileDownloadView.h
//  NewGSLib
//
//  Created by Wilson on 17/03/2018.
//  Copyright © 2018 NewGSLib. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NGSFileDownloadViewDelegate;

@interface NGSFileDownloadView : UIView

@property (nonatomic, weak) id<NGSFileDownloadViewDelegate> delegate;

/**
 *  0.0 - 1.0
 */
@property (nonatomic, assign) CGFloat progressValue;

@property (nonatomic, copy) NSString *fileSize;

@property (nonatomic, copy) NSString *currentDownloadSize;

@property (nonatomic, copy) NSString *fileTypeContent;

@property (nonatomic, copy) NSString *fileTitle;

@property (nonatomic, copy) NSString *errorDes;

@property (nonatomic, copy) NSString *reStart;

@end

@protocol NGSFileDownloadViewDelegate <NSObject>

- (void)fileDownloadViewClickStart;

@end
