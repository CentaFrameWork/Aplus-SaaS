//
//  MyHeadImageCell.m
//  PanKeTong
//
//  Created by zhwang on 16/3/30.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "MyHeadImageCell.h"

@implementation MyHeadImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headImageView setLayerCornerRadius:self.headImageView.width/2];
    self.headImageView.layer.borderColor = RGBColor(188, 188, 188).CGColor;
    self.headImageView.layer.borderWidth = 1;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
