//
//  WJMyDealScreenCell.m
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/22.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "WJMyDealScreenCell.h"

@implementation WJMyDealScreenCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    _leftLabel = [[UILabel alloc] init];
    _leftLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_leftLabel];
    
    _rightLabel = [[UILabel alloc] init];
    _rightLabel.font = [UIFont systemFontOfSize:15.0];
    _rightLabel.textColor = [UIColor lightGrayColor];
    _rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_rightLabel];
   
    _rightImg = [[UIImageView alloc] init];
    [self.contentView addSubview:_rightImg];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    //左右间距
    CGFloat margin = 15;
    _leftLabel.frame = CGRectMake(margin, 0, 100*WIDTH_SCALE2, self.height);
    _rightLabel.frame = CGRectMake(margin + 100*WIDTH_SCALE2, 0, APP_SCREEN_WIDTH - 100*WIDTH_SCALE2-2*margin-15*WIDTH_SCALE2, self.height);
    _rightImg.frame = CGRectMake(APP_SCREEN_WIDTH - margin -8*WIDTH_SCALE2, (self.height - 13*WIDTH_SCALE2)/2.0, 8*WIDTH_SCALE2, 13*WIDTH_SCALE2);
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
























































@end
