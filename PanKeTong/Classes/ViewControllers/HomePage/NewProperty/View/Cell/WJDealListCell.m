//
//  WJDealListCell.m
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/19.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "WJDealListCell.h"

@implementation WJDealListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    _customerLabel = [[UILabel alloc] init];
    _customerLabel.font = [UIFont systemFontOfSize:15.0];
    _customerLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_customerLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:_timeLabel];
//    _customerLabel.numberOfLines = 0;
//    _timeLabel.numberOfLines = 0;
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.font = [UIFont systemFontOfSize:15.0];
    _typeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_typeLabel];
    
    _nodeLabel = [[UILabel alloc] init];
    _nodeLabel.font = [UIFont systemFontOfSize:15.0];
    _nodeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_nodeLabel];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _customerLabel.frame = CGRectMake(12, 0, 90*WIDTH_SCALE2, self.height);
    _timeLabel.frame = CGRectMake(_customerLabel.right, 0, 150*WIDTH_SCALE2, self.height);
    _typeLabel.frame = CGRectMake(_timeLabel.right, 0, 50*WIDTH_SCALE2, self.height);
    _nodeLabel.frame = CGRectMake(_typeLabel.right, 0, APP_SCREEN_WIDTH - _typeLabel.right, self.height);
}


















































@end
