//
//  StateChangesclearInformationCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/5.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "StateChangesclearInformationCell.h"

@implementation StateChangesclearInformationCell

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
        
    }
    return self;
}

- (void)initView {
    
    _clearInformationStrLab = [[UILabel alloc] initWithFrame:CGRectMake(12*NewRatio, 0, APP_SCREEN_WIDTH/2, 52*NewRatio)];
    _clearInformationStrLab.text = @"清空信息";
    _clearInformationStrLab.textColor = YCTextColorBlack;
    _clearInformationStrLab.font = [UIFont systemFontOfSize:14*NewRatio];
    [self.contentView addSubview:_clearInformationStrLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 51*NewRatio, APP_SCREEN_WIDTH, 1)];
    lineView.backgroundColor = UICOLOR_RGB_Alpha(0xf4f4f4, 1.0);
    [self.contentView addSubview:lineView];
}

- (void)setDictModel:(NSDictionary *)dictModel {
    
}

@end
