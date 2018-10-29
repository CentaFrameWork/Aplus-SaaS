//
//  ModuleCell.m
//  APlus
//
//  Created by 李慧娟 on 2017/10/13.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "JMModuleCell.h"

@implementation JMModuleCell {

    __weak IBOutlet UIImageView *_iconImgView;
    __weak IBOutlet UILabel *_moduleNameLabel;

    __weak IBOutlet UIImageView *_newImgView;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    _itemWidth.constant = 60*NewRatio;
    _iconImgView.userInteractionEnabled = YES;
}

- (void)setEntity:(APPLocationEntity *)entity
{
    if (_entity != entity)
    {
        _entity = entity;
        [self setNeedsLayout];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];

    [_iconImgView setLayerCornerRadius:_itemWidth.constant / 2];

    if ([_entity.title isEqualToString:@"更多"])
    {
        NSString *imgStr = [NSString stringWithFormat:@"M%@",_entity.title];
        _iconImgView.image = [UIImage imageNamed:imgStr];
    }
    else
    {
        [_iconImgView sd_setImageWithURL:[NSURL URLWithString:_entity.iconUrl] placeholderImage:[UIImage imageNamed:@"mrt"]];
    }

    _moduleNameLabel.text = _entity.title;

    if (_entity.iconFrame.length > 0)
    {
        _newImgView.hidden = NO;
    }
    else
    {
        _newImgView.hidden = YES;
    }
}

@end
