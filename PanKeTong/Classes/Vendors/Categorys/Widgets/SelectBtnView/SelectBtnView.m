//
//  SelectBtnView.m
//  APlus
//
//  Created by 李慧娟 on 2017/10/19.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "SelectBtnView.h"

#define BaseBtnTag  1000

@implementation SelectBtnView {
    UIView *_lineView;
    NSInteger _lastSelectTag;

}

- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)titleArr {
    self = [super initWithFrame:frame];
    if (self)
    {
        _titleArr = titleArr;
        _lastSelectTag = BaseBtnTag;
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _lastSelectTag = BaseBtnTag;
    }
    return self;
}

- (void)setTitleArr:(NSArray *)titleArr {
    if (_titleArr != titleArr)
    {
        _titleArr = titleArr;
        [self initView];
    }
}

- (void)initView {

    NSInteger count = _titleArr.count;
    CGFloat width = (APP_SCREEN_WIDTH - (count + 1)* 15) /  count;
    CGFloat height = 20;

    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0,height + 5 , 80*NewRatio, 3)];
    _lineView.backgroundColor = YCThemeColorGreen;
    [self addSubview:_lineView];

    for (int i = 0;  i < count; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15 + (width + 15) * i, 15, width, height);
        btn.titleLabel.font = [UIFont systemFontOfSize:14*NewRatio];
        btn.tag = BaseBtnTag + i;
        [btn setTitle:_titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:YCTextColorBlack forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];

        if (i == 0)
        {
            _lineView.center = CGPointMake(btn.center.x, btn.bottom + 10);
            [btn setTitleColor:YCThemeColorGreen forState:UIControlStateNormal];
            btn.selected = YES;
        }
    }

}



- (void)selectClick:(UIButton *)btn {
    if (_titleArr.count > 1)
    {
        if (_lastSelectTag != btn.tag)
        {
            btn.selected = !btn.selected;
            UIButton *lastBtn = [self viewWithTag:_lastSelectTag];
            lastBtn.selected = NO;
            _lineView.center = CGPointMake(btn.center.x, btn.bottom + 10);

            [btn setTitleColor:YCThemeColorGreen forState:UIControlStateNormal];
            [lastBtn setTitleColor:YCTextColorBlack forState:UIControlStateNormal];

            _lastSelectTag = btn.tag;

            [self.selectBtnDelegate didSelectWithBtnIndex:btn.tag - BaseBtnTag];
        }
    }
}

- (void)setSelectBtnDelegate:(id<SelectBtnDelegate>)selectBtnDelegate {
    if (_selectBtnDelegate != selectBtnDelegate) {
        _selectBtnDelegate = selectBtnDelegate;
    }
}





@end
