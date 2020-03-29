//
//  CoreDataCell.m
//  WilsonDev
//
//  Created by Wilson on 2020/3/29.
//  Copyright © 2020 Wilson. All rights reserved.
//

#import "CoreDataCell.h"

@interface CoreDataCell()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *height;

@end

@implementation CoreDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)config:(Student *)student {
    self.name.text = student.name;
    self.score.text = [NSString stringWithFormat:@"%d分", student.score];
    self.height.text = [NSString stringWithFormat:@"%.fcm", student.height];
}

@end
