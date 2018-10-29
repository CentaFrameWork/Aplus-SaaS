//
//  CheckTheKeysCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/17.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "CheckTheKeysCell.h"

@implementation CheckTheKeysCell

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    // 钥匙图片
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake((APP_SCREEN_WIDTH-100*NewRatio)/2, 34*NewRatio, 100*NewRatio, 100*NewRatio)];
    _imageview.image = [UIImage imageNamed:@"查看钥匙icon"];
    [self.contentView addSubview:_imageview];
    
    // 钥匙情况字样
    _labelName = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageview.frame)+16*NewRatio, APP_SCREEN_WIDTH, 17*NewRatio)];
    _labelName.text = @"钥匙情况";
    _labelName.textColor = YCTextColorBlack;
    _labelName.font = [UIFont systemFontOfSize:17*NewRatio];
    _labelName.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_labelName];
    
    // 钥匙情况
    _label = [[UILabel alloc] initWithFrame:CGRectMake((APP_SCREEN_WIDTH-160*NewRatio)/2, CGRectGetMaxY(_labelName.frame)+16*NewRatio, 160*NewRatio, 36*NewRatio)];
    _label.font = [UIFont systemFontOfSize:17*NewRatio];
    _label.backgroundColor = YCButtonColorOrange;
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.layer.cornerRadius = 18*NewRatio;
    _label.clipsToBounds = YES;
    [self.contentView addSubview:_label];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 256*NewRatio, APP_SCREEN_WIDTH, 1)];
    _lineView.backgroundColor = YCOtherColorBackground;
    [self.contentView addSubview:_lineView];
}

@end
