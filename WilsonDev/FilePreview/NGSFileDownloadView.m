//
//  NGSFileDownloadView.m
//  NewGSLib
//
//  Created by Wilson on 17/03/2018.
//  Copyright © 2018 NewGSLib. All rights reserved.
//

#import "NGSFileDownloadView.h"
#import "M13ProgressViewBorderedBar.h"
#import "UIView+SDAutolayout.h"

@interface NGSFileDownloadView()

@property (nonatomic, strong) UILabel *fileTypeLab;

@property (nonatomic, strong) UILabel *fileDesLab;  // 隐藏文件名

@property (nonatomic, strong) UILabel *downloadDesLab;

@property (nonatomic, strong) M13ProgressViewBorderedBar *progressView;

@property (nonatomic, strong) UIButton *handleBtn;

@end

@implementation NGSFileDownloadView

- (instancetype)init {
    if (self = [super init]) {
        [self customViews];
    }
    return self;
}

- (void)customViews {
    [self sd_addSubviews:@[self.fileTypeLab, self.fileDesLab, self.downloadDesLab, self.progressView, self.handleBtn]];
    
    self.fileTypeLab.sd_layout
    .topSpaceToView(self, 44)
    .minWidthIs(50)
    .maxWidthIs(200)
    .heightEqualToWidth()
    .centerXEqualToView(self);
    
    self.fileDesLab.sd_layout
    .topSpaceToView(self.fileTypeLab, 30)
    .leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .heightIs(0);
    
    self.downloadDesLab.sd_layout
    .topSpaceToView(self.fileDesLab, 15)
    .leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .heightIs(20);
    
    self.progressView.sd_layout
    .topSpaceToView(self.downloadDesLab, 15)
    .leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .heightIs(10);
    
    self.handleBtn.sd_layout
    .topSpaceToView(self.downloadDesLab, 15)
    .leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .heightIs(50);
}

#pragma mark - Action

- (void)startDownload:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(fileDownloadViewClickStart)]) {
        [self.delegate fileDownloadViewClickStart];
        self.handleBtn.hidden = YES;
        self.progressView.hidden = NO;
    }
}

#pragma mark - Public

- (void)setProgressValue:(CGFloat)progressValue {
    _progressValue = progressValue;
    [self.progressView setProgress:_progressValue animated:NO];
}

- (void)setFileSize:(NSString *)fileSize {
    _fileSize = fileSize;
    self.downloadDesLab.text = _fileSize;
}

- (void)setCurrentDownloadSize:(NSString *)currentDownloadSize {
    _currentDownloadSize = currentDownloadSize;
    self.downloadDesLab.text = _currentDownloadSize;
}

- (void)setFileTitle:(NSString *)fileTitle {
    _fileTitle = fileTitle;
    self.fileDesLab.text = _fileTitle;
}

- (void)setFileTypeContent:(NSString *)fileTypeContent {
    _fileTypeContent = fileTypeContent;
    self.fileTypeLab.text = _fileTypeContent;
    [self.fileTypeLab sizeToFit];
    self.fileTypeLab.sd_layout.widthIs(CGRectGetWidth(self.fileTypeLab.frame)+10).heightEqualToWidth();
}

- (void)setErrorDes:(NSString *)errorDes {
    _errorDes = errorDes;
    self.downloadDesLab.text = _errorDes;
}

- (void)setReStart:(NSString *)reStart {
    _reStart = reStart;
    [self.handleBtn setTitle:_reStart forState:UIControlStateNormal];
    self.handleBtn.hidden = NO;
    self.progressView.hidden = YES;
}

#pragma mark - Getter

- (UILabel *)fileTypeLab {
    if (!_fileTypeLab) {
        _fileTypeLab = [self labelWithFont:[UIFont systemFontOfSize:30] textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        _fileTypeLab.backgroundColor = [UIColor redColor];
        _fileTypeLab.sd_cornerRadius = @(3.f);
        [_fileTypeLab clipsToBounds];
    }
    return _fileTypeLab;
}

- (UILabel *)fileDesLab {
    if (!_fileDesLab) {
        _fileDesLab = [self labelWithFont:[UIFont systemFontOfSize:16] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
        _fileDesLab.hidden = YES;
    }
    return _fileDesLab;
}

- (UILabel *)downloadDesLab {
    if (!_downloadDesLab) {
        self.downloadDesLab = [self labelWithFont:[UIFont systemFontOfSize:12] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    }
    return _downloadDesLab;
}

- (UIButton *)handleBtn {
    if (!_handleBtn) {
        self.handleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_handleBtn setBackgroundColor:[UIColor yellowColor]];
        [_handleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _handleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [_handleBtn setTitle:@"开始下载" forState:UIControlStateNormal];
        _handleBtn.layer.cornerRadius = 5.f;
        [_handleBtn addTarget:self action:@selector(startDownload:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _handleBtn;
}

- (M13ProgressViewBorderedBar *)progressView {
    if (!_progressView) {
        self.progressView = [M13ProgressViewBorderedBar new];
        _progressView.failureColor = [UIColor redColor];
        [_progressView performAction:M13ProgressViewActionFailure animated:YES];
        _progressView.cornerType = M13ProgressViewBorderedBarCornerTypeCircle;
    }
    return _progressView;
}

- (UILabel *)labelWithFont:(UIFont *)font
                 textColor:(UIColor *)textColor
             textAlignment:(NSTextAlignment)textAlignment {
    UILabel *lab = [UILabel new];
    lab.font = font;
    lab.textColor = textColor;
    lab.textAlignment = textAlignment;
    return lab;
}

@end
