//
//  TransitionCustonCell.m
//  WilsonDev
//
//  Created by Wilson on 02/03/2018.
//  Copyright © 2018 Wilson. All rights reserved.
//

#import "TransitionCustonCell.h"
#import "UIView+SDAutolayout.h"

@interface TransitionCustonCell()

@end

@implementation TransitionCustonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self customViews];
    }
    return self;
}

- (void)customViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.imgView];
    
    CGFloat proportion = 108.0 / 192;
    CGFloat margin = 20;
    CGFloat imgWidth = CGRectGetWidth([UIScreen mainScreen].bounds)-2*20;
    CGFloat imgHeight = imgWidth * proportion;
    
    self.imgView.sd_layout
    .topSpaceToView(self.contentView, margin)
    .leftSpaceToView(self.contentView, 20)
    .widthIs(imgWidth)
    .heightIs(imgHeight);
    
    [self setupAutoHeightWithBottomView:self.imgView bottomMargin:0];
}

- (void)setImgName:(NSString *)imgName {
    _imgName = imgName;
    if (_imgName.length > 0) {
        self.imgView.image = [UIImage imageNamed:_imgName];
    }
}

- (UIImageView *)imgView {
    if (!_imgView) {
        self.imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.layer.cornerRadius = 10.f;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

@end
