//
//  JMDealCell.m
//  PanKeTong
//
//  Created by Admin on 2018/4/19.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMDealCell.h"

@implementation JMDealCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
         [self addSubviews];
        
        if ([reuseIdentifier isEqualToString:@"PresentV"]) {
            self.separatorInset = UIEdgeInsetsMake(0, 2, 0, 6);
            [self initSubView];
        }else{
        
             self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
     
    }
    
    return self;
}

- (void)initSubView {
    
    _customerLabel.textColor = YCTextColorBlack;
    _typeLabel.textColor = YCTextColorBlack;
    
    _timeLabel.hidden = YES;
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_phone"]];
    _customerLabel.frame = CGRectMake(8, 0, 100*WIDTH_SCALE2, self.height);
    _typeLabel.frame = CGRectMake(_customerLabel.right+60, 0, 150*WIDTH_SCALE2-60, self.height);
}

- (void)addSubviews {
    _customerLabel = [[UILabel alloc] init];
    _customerLabel.font = [UIFont systemFontOfSize:14.0];
    _customerLabel.textColor = YCTextColorBlack;
    [self.contentView addSubview:_customerLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = [UIFont systemFontOfSize:14.0];
    _timeLabel.textAlignment = 2;
     _timeLabel.textColor = YCTextColorBlack;
    [self.contentView addSubview:_timeLabel];
    
    
    _typeLabel = [[UILabel alloc] init];
    _typeLabel.font = [UIFont systemFontOfSize:14.0];
    _typeLabel.textColor = YCTextColorBlack;
    [self.contentView addSubview:_typeLabel];
    
    _customerLabel.frame = CGRectMake(12, 0, 90*WIDTH_SCALE2, self.height);
    _typeLabel.frame = CGRectMake(_customerLabel.right, 0, 50*WIDTH_SCALE2, self.height);
    _timeLabel.frame = CGRectMake(APP_SCREEN_WIDTH-50-150*WIDTH_SCALE2, 0, 150*WIDTH_SCALE2, self.height);
    
}

@end
