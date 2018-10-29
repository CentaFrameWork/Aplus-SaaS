//
//  CheckTheKeyPersonCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/17.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "CheckTheKeyPersonCell.h"

@implementation CheckTheKeyPersonCell

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    // 收钥匙人
    UILabel *labelyaoshiren = [[UILabel alloc] initWithFrame:CGRectMake(12*NewRatio, 18*NewRatio, 150*NewRatio, 14*NewRatio)];
    labelyaoshiren.font = [UIFont systemFontOfSize:14*NewRatio];
    labelyaoshiren.textColor = YCTextColorBlack;
    labelyaoshiren.text = @"收钥匙人";
    [self.contentView addSubview:labelyaoshiren];
    
    // 钥匙人
    _label = [[UILabel alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH-312*NewRatio, 18*NewRatio, 300*NewRatio, 14*NewRatio)];
    _label.font = [UIFont systemFontOfSize:14*NewRatio];
    _label.textColor = YCTextColorBlack;
    _label.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49*NewRatio, APP_SCREEN_WIDTH, 1)];
    lineView.backgroundColor = YCOtherColorBackground;
    [self.contentView addSubview:lineView];
    
}

@end
