//
//  WjTakeLookRecordCell.m
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/7.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "WjTakeLookRecordCell.h"

@implementation WjTakeLookRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:12.0];
    _titleLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_detailLabel];
    _titleLabel.numberOfLines = 0;
    _detailLabel.numberOfLines = 0;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(12, 0, _titleLabel.textWidth, self.height);
    _detailLabel.frame = CGRectMake(_titleLabel.right, 0, APP_SCREEN_WIDTH - 24, self.height);
}


@end
