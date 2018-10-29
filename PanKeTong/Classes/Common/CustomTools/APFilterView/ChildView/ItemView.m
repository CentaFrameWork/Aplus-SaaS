//
//  ItemView.m
//  APlusFilterView
//
//  Created by 张旺 on 2017/10/23.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "ItemView.h"
#import "Masonry.h"

@implementation ItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void)setItemTitleArray:(NSArray *)itemTitleArray
{
    // 筛选按钮的宽度
    CGFloat itemWidth;
    if (itemTitleArray.count > 0)
    {
        itemWidth = APP_SCREEN_WIDTH/itemTitleArray.count;
     
        UIView * itemView;
     
        for (int i = 0; i < itemTitleArray.count; i ++)
        {
            itemView = [[UIView alloc] initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, FilterViewHeight)];
            itemView.backgroundColor = [UIColor whiteColor];
     
            NSString *itemTitleStr = itemTitleArray[i];
            
            // titleLabel
            UILabel *itemTitleLabel = [[UILabel alloc]init];
            itemTitleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
            
            itemTitleLabel.tag = ItemTitleBaseTag + i;
            itemTitleLabel.numberOfLines = 1;
            itemTitleLabel.textAlignment = NSTextAlignmentCenter;
//            itemTitleLabel.backgroundColor = UICOLOR_RGB_Alpha(0xf9f9f9, 1.0);
            itemTitleLabel.text = itemTitleStr;
            //itemTitleLabel.minimumScaleFactor = 0.0;
            //itemTitleLabel.adjustsFontSizeToFitWidth = YES;
            [itemTitleLabel setUserInteractionEnabled:NO];

            // 箭头image
            UIImageView *arrowImgView = [[UIImageView alloc]init];
            [arrowImgView setTag:ArrowImageBaseTag + i];
            [arrowImgView setUserInteractionEnabled:NO];
            
            // 默认选中的颜色
            // 房源
            if (i == 0 && [itemTitleStr isEqualToString:@"全部"])
            {
                itemTitleLabel.textColor = YCTextColorBlack;
                [arrowImgView setImage:[UIImage imageNamed:ArrowDownGrayImgName]];
            }else if (i == 1 && [itemTitleStr isEqualToString:@"价格"])
            {
                itemTitleLabel.textColor = YCTextColorBlack;
                [arrowImgView setImage:[UIImage imageNamed:ArrowDownGrayImgName]];
            }else if (i == 2 && [itemTitleStr isEqualToString:@"标签"])
            {
                itemTitleLabel.textColor = YCTextColorBlack;
                [arrowImgView setImage:[UIImage imageNamed:ArrowDownGrayImgName]];
            }
            else if (i == 3 && [itemTitleStr isEqualToString:@"更多"])
            {
                itemTitleLabel.textColor = YCTextColorBlack;
                [arrowImgView setImage:[UIImage imageNamed:ArrowDownGrayImgName]];
            }else
            {
                itemTitleLabel.textColor = YCTextColorSelect;
                [arrowImgView setImage:[UIImage imageNamed:ArrowDownRedImgName]];
            }
            
            // 按钮
            UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [itemBtn setBackgroundColor:[UIColor clearColor]];
            [itemBtn setTag:ItemButtonBaseTag + i];
            [itemBtn addTarget:self
                        action:@selector(itemBtnClickWithBtn:)
              forControlEvents:UIControlEventTouchUpInside];
            
            [itemView addSubview:itemTitleLabel];
            [itemView addSubview:arrowImgView];
            [itemView addSubview:itemBtn];
            
            // 文字label居中显示
            [itemTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.center.mas_equalTo(itemView);
                make.width.mas_lessThanOrEqualTo(itemWidth - 25);
            }];
            
            // 箭头imgView设置在文字label右边
            // 相差ledding
            int leading = 5;
            [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.mas_equalTo(0);
                make.left.equalTo(itemTitleLabel.mas_right).with.offset(leading);
                
            }];
            
            // 按钮和view等宽等高
            [itemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.edges.equalTo(itemView).with.insets(UIEdgeInsetsMake(0,
                                                                          0,
                                                                          0,
                                                                          0));
            }];
            
            [self addSubview:itemView];
        }

        // 分割线
        UIImageView *seperatorImgView = [[UIImageView alloc]init];
        [seperatorImgView setImage:[UIImage imageNamed:@"horizontalLongSeperator_line"]];
        [seperatorImgView setFrame:CGRectMake(0,
                                              FilterViewHeight - 1,
                                              APP_SCREEN_WIDTH,
                                              1)];
        
        
        [self addSubview:seperatorImgView];
    }
}

- (void)itemBtnClickWithBtn:(UIButton *)clickBtn
{
    if (self.btnClickBlock)
    {
        self.btnClickBlock(clickBtn);
    }
}

@end
