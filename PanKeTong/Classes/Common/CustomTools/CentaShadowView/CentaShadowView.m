//
//  CentaShadowView.m
//  PanKeTong
//
//  Created by 李慧娟 on 2018/2/2.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "CentaShadowView.h"

@implementation CentaShadowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.3;
        self.hidden = YES;

        UITapGestureRecognizer *shadowViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(shadowViewTapAction:)];
        [self addGestureRecognizer:shadowViewTap];

    }
    return self;
}

- (void)shadowViewTapAction:(UITapGestureRecognizer *)tapAction
{
    self.hidden = YES;

    if (self.delegate && [self.delegate respondsToSelector:@selector(tapAction)])
    {
        [self.delegate tapAction];
    }

}

@end
