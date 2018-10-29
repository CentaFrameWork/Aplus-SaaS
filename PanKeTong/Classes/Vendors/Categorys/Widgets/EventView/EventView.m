//
//  AddEventView.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "EventView.h"
#import "BaseViewController.h"

#define TitleBtnBaseTag 2000


@implementation EventView
{
    BOOL _isHaveImage;
    UIView *_contentView;
}

- (instancetype)initWithFrame:(CGRect)frame
               andIsHaveImage:(BOOL)isHaveImage
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _isHaveImage = isHaveImage;
        self.backgroundColor = [UIColor clearColor];

        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, ArrowHeight, RowWidth, 0)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.borderColor = RGBColor(231, 231, 231).CGColor;
        _contentView.layer.borderWidth = 1;
        [_contentView setLayerCornerRadius:3];
        [self addSubview:_contentView];

        UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(RowWidth - ArrowHeight - 10,1 ,14 , 14)];
        arrowImgView.image = [UIImage imageNamed:@"Slice"];
        [self addSubview:arrowImgView];
    }

    return self;
}

- (void)setTitleArr:(NSArray *)titleArr
{
    if (_titleArr != titleArr)
    {
        _titleArr = titleArr;
        [self setNeedsLayout];
    }
}

- (void)btnClick:(UIButton *)btn
{
    NSInteger selectIndex = btn.tag - TitleBtnBaseTag;
    NSString *titleStr = [_titleArr objectAtIndex:selectIndex];
    BaseViewController *vc = (BaseViewController *)self.viewController;
    // 首页、消息、工作
    if ([titleStr contains:@"首页"])
    {
        vc.tabBarController.selectedViewController = vc.tabBarController.viewControllers[0];
        [vc.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([titleStr contains:@"消息"])
    {
        vc.tabBarController.selectedViewController = vc.tabBarController.viewControllers[1];

        [vc.navigationController popToRootViewControllerAnimated:YES];
    }
    else if ([titleStr contains:@"工作"])
    {
        vc.tabBarController.selectedViewController = vc.tabBarController.viewControllers[2];
        [vc.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.eventDelegate eventClickWithBtnTitle:titleStr];
    }

}

- (void)layoutSubviews
{
    [super layoutSubviews];

    NSInteger count = _titleArr.count;

    _contentView.height = count * RowHeight;
    for (int i = 0; i < count; i ++)
    {
        NSString *str = _titleArr[i];
        UIButton *btn = [self viewWithTag:TitleBtnBaseTag + i];
        if (btn == nil)
        {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = TitleBtnBaseTag + i;
            btn.backgroundColor = [UIColor clearColor];
            btn.frame = CGRectMake(15, RowHeight * i, RowWidth - 15, RowHeight);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_contentView addSubview:btn];
        }

        if (i < count - 1)
        {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, RowHeight * (i + 1), RowWidth - 45, 1)];
            lineView.backgroundColor = RGBColor(231, 231, 231);
            [_contentView addSubview:lineView];
        }

        if (_isHaveImage == YES)
        {
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"top_right_0%d",i+3]] forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"   %@",str] forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitle:[NSString stringWithFormat:@"%@",str] forState:UIControlStateNormal];
        }
    }
}


@end
