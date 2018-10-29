//
//  DecorationTypeCell.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/3/13.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "DecorationTypeCell.h"

@implementation DecorationTypeCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubviews];
    }
    return self;
}


- (void)createSubviews
{
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    if (!_decorationTpyeLabel) {
        _decorationTpyeLabel = [[UILabel alloc] init];
        _decorationTpyeLabel.frame = self.contentView.bounds;
        _decorationTpyeLabel.textAlignment = NSTextAlignmentCenter;
        _decorationTpyeLabel.layer.masksToBounds = YES;
        //        _decorationTpyeLabel.layer.cornerRadius = 5;
        //        _decorationTpyeLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        //        _decorationTpyeLabel.layer.borderWidth = 1.0f;
        _decorationTpyeLabel.textColor = [UIColor lightGrayColor];
        _decorationTpyeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_decorationTpyeLabel];
    }
    
}

- (void)setLabelValue:(NSString *)decorationTpye
{
    _decorationTpyeLabel.text = decorationTpye;
}

// label变色
- (void)selectItme:(NSInteger)itemTag
{
    _decorationTpyeLabel.textColor = [UIColor redColor];
    //    _decorationTpyeLabel.backgroundColor = [UIColor redColor];
    //    _decorationTpyeLabel.textColor = [UIColor whiteColor];
    //    _decorationTpyeLabel.layer.borderColor = [[UIColor clearColor] CGColor];
}

// label颜色还原
- (void)recoverItem
{
    //    _decorationTpyeLabel.backgroundColor = [UIColor whiteColor];
    _decorationTpyeLabel.textColor = [UIColor lightGrayColor];
    //    _decorationTpyeLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
}

@end
