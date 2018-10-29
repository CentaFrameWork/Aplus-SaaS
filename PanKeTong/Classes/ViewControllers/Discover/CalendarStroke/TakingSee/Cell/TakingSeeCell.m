//
//  TakingSeeCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/7.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "TakingSeeCell.h"

@implementation TakingSeeCell

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
        
    }
    return self;
}

- (void)initView {
    
    // 约看客户
    _customerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*NewRatio, 15*NewRatio, APP_SCREEN_WIDTH-24*NewRatio, 14*NewRatio)];
    _customerLabel.font = [UIFont systemFontOfSize:14*NewRatio];
    _customerLabel.textColor = YCTextColorBlack;
    [self.contentView addSubview:_customerLabel];
    
    // 约看时间
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*NewRatio, CGRectGetMaxY(_customerLabel.frame)+6*NewRatio, APP_SCREEN_WIDTH-24*NewRatio, 14*NewRatio)];
    _timeLabel.font = [UIFont systemFontOfSize:14*NewRatio];
    _timeLabel.textColor = YCTextColorBlack;
    [self.contentView addSubview:_timeLabel];
    
}

- (void)setSubTakingSeeEntity:(SubTakingSeeEntity *)subTakingSeeEntity {
    
    _subTakingSeeEntity = subTakingSeeEntity;
    
    // 约看客户
    _customerLabel.text = [[NSString alloc] initWithFormat:@"约看客户  %@",subTakingSeeEntity.customerName];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:_customerLabel.text];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"约看客户"].location, 4);
    [noteStr addAttribute:NSForegroundColorAttributeName value:YCTextColorGray range:redRange];
    [_customerLabel setAttributedText:noteStr];
    
    // 约看时间
    NSString *timeStr = [_subTakingSeeEntity.reserveTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    timeStr = [timeStr substringToIndex:timeStr.length - 3];
    _timeLabel.text = [NSString stringWithFormat:@"约看时间  %@",timeStr];
    NSMutableAttributedString *noteStr2 = [[NSMutableAttributedString alloc] initWithString:_timeLabel.text];
    NSRange redRange2 = NSMakeRange([[noteStr2 string] rangeOfString:@"约看时间"].location, 4);
    [noteStr2 addAttribute:NSForegroundColorAttributeName value:YCTextColorGray range:redRange2];
    [_timeLabel setAttributedText:noteStr2];
}


@end
