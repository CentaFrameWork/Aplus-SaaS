//
//  NewPropertyCell.m
//  APlus
//
//  Created by 李慧娟 on 2017/10/15.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "NewPropertyCell.h"

@implementation NewPropertyCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.bgConView setLayerCornerRadius:self.bgConView.height/2];
}

- (void)setDataArr:(NSArray *)dataArr
{
    if (_dataArr != dataArr)
    {
        _dataArr = dataArr;

        [self setNeedsLayout];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];

    _marqueeView.titleArr = self.dataArr;
}


@end
