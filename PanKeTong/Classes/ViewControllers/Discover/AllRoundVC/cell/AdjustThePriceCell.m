//
//  AdjustThePriceCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/16.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "AdjustThePriceCell.h"

@implementation AdjustThePriceCell

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    // 总价：  租价：
    _labelName = [[UILabel alloc] initWithFrame:CGRectMake(20*ratio2, 0, 150*ratio2, 80*ratio2)];
    [self.contentView addSubview:_labelName];
    
    // 输入框
    _textFieldPrice = [[UITextField alloc] initWithFrame:CGRectMake(150*ratio2, 10*ratio2, APP_SCREEN_WIDTH-340*ratio2, 60*ratio2)];
    _textFieldPrice.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldPrice.keyboardType = UIKeyboardTypePhonePad;
    [self.contentView addSubview:_textFieldPrice];
    
    // 单位
    _labelUnit = [[UILabel alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH-170*ratio2, 0, 150*ratio2, 80*ratio2)];
    [self.contentView addSubview:_labelUnit];
    
}

-(void)setType:(int)type {
    _type = type;
    if (_indexPath.row == 0) {
        if (_type == 1 || _type == 3) {
            _labelName.text = @"总价：";
            _labelUnit.text = @"万元";
        }
        else if (_type == 2) {
            _labelName.text = @"租价：";
            _labelUnit.text = @"元/月";
        }
    }
    else if (_indexPath.row == 1) {
        _labelName.text = @"租价：";
        _labelUnit.text = @"元/月";
    }
}


@end


















