//
//  WJTaskSeePropertyListCell.m
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/9.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "WJTaskSeePropertyListCell.h"

@implementation WJTaskSeePropertyListCell
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
   
    _titleLabel.font = [UIFont systemFontOfSize:13.0];
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
  
    
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(14, 0, (APP_SCREEN_WIDTH -28), self.height);
    
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
