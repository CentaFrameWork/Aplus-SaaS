//
//  DropDownMeunCollectionCell.m
//  下拉菜单
//
//  Created by 王雅琦 on 16/7/15.
//  Copyright © 2016年 王雅琦. All rights reserved.
//

#import "DropDownMeunCollectionCell.h"

@implementation DropDownMeunCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createSubviews];
    }
    
    return self;
}


- (void)createSubviews
{
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.masksToBounds = YES;
    _whiteView.layer.cornerRadius = 3.0;
    [self.contentView addSubview:_whiteView];
    
    _cellText = [[UILabel alloc] initWithFrame:_whiteView.frame];
    _cellText.font = [UIFont systemFontOfSize:13];
    _cellText.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_cellText];
       
    
}


- (void)setCellframe:(CGRect)cellframe
{
    _cellframe = cellframe;
    
    _whiteView.frame = _cellframe;
    _cellText.frame = _cellframe;
}



@end
