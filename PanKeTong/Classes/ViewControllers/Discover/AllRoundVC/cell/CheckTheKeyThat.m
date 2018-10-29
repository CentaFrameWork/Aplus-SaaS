//
//  CheckTheKeyThat.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/17.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "CheckTheKeyThat.h"

@implementation CheckTheKeyThat

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    _view = [[UIView alloc] initWithFrame:CGRectMake(12*NewRatio, 12*NewRatio, 3*NewRatio, 14*NewRatio)];
    _view.backgroundColor = YCThemeColorGreen;
    [self.contentView addSubview:_view];
    
    UILabel *labelshuo = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_view.frame)+12*NewRatio, CGRectGetMinY(_view.frame), 150*NewRatio, 14*NewRatio)];
    labelshuo.textColor = YCTextColorBlack;
    labelshuo.font = [UIFont systemFontOfSize:14*NewRatio];
    labelshuo.text = @"钥匙说明";
    [self.contentView addSubview:labelshuo];
    
    _viewbian = [[UIView alloc] initWithFrame:CGRectMake(12*NewRatio, CGRectGetMaxY(_view.frame)+14*NewRatio, APP_SCREEN_WIDTH-24*NewRatio, 202*NewRatio)];
    _viewbian.layer.cornerRadius = 5*NewRatio;
    _viewbian.layer.borderColor = YCOtherColorDivider.CGColor;
    _viewbian.layer.borderWidth = 1;
    _viewbian.clipsToBounds = YES;
    [self.contentView addSubview:_viewbian];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(12*NewRatio, 10*NewRatio, APP_SCREEN_WIDTH-50*NewRatio, 200*NewRatio)];
    _label.numberOfLines = 0;
    _label.textColor = YCTextColorBlack;
    _label.font = [UIFont systemFontOfSize:14*NewRatio];
    [_viewbian addSubview:_label];
    
}

- (void)setString:(NSString *)string {
    _string = string;
    CGSize size = CGSizeMake(APP_SCREEN_WIDTH-50*NewRatio, CGFLOAT_MAX);
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14*NewRatio]};
    CGSize titleh = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    CGFloat titleH = titleh.height;
    _label.frame = CGRectMake(12*NewRatio, 10*NewRatio, APP_SCREEN_WIDTH-50*NewRatio, titleH);
    _label.text = string;
    
    if (titleH > 200*NewRatio-24*NewRatio) {
        _viewbian.frame = CGRectMake(12*NewRatio, CGRectGetMaxY(_view.frame)+14*NewRatio, APP_SCREEN_WIDTH-24*NewRatio, titleH + 24*NewRatio);
        _max = titleH + 36*NewRatio;
    }else {
        _max = 250*NewRatio;
    }
    
}






@end
