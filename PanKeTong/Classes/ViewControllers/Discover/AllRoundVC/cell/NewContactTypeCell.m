//
//  NewContactTypeCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/8.
//  Copyright © 2018年 中原集团. All rights reserved.
//

// 联系人类型
#import "NewContactTypeCell.h"

@implementation NewContactTypeCell

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    // 类型label
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12*NewRatio, 0, 40*NewRatio, 48*NewRatio)];
    _typeLabel.textColor = YCTextColorGray;
    _typeLabel.font = [UIFont systemFontOfSize:14*NewRatio];
    [self.contentView addSubview:_typeLabel];
    
    // 背景View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_typeLabel.frame), 6*NewRatio, 310*NewRatio, 36*NewRatio)];
    view.backgroundColor = UICOLOR_RGB_Alpha(0xf9faff, 1.0);
    view.layer.cornerRadius = 5*NewRatio;
    view.clipsToBounds = YES;
    [self.contentView addSubview:view];
    
    // 类型结果
    _typeLabelResults = [[UILabel alloc] initWithFrame:CGRectMake(12*NewRatio, 0, 290*NewRatio, 36*NewRatio)];
    _typeLabelResults.backgroundColor = [UIColor clearColor];
    _typeLabelResults.textColor = UICOLOR_RGB_Alpha(0xc7c7cd, 1.0);
    _typeLabelResults.font = [UIFont systemFontOfSize:14*NewRatio];
    _typeLabelResults.text = @"请选择";
    [view addSubview:_typeLabelResults];
    
}

- (void)setModel:(NewContactModel *)model {
    _typeLabelResults.text = @"请选择";
    if (_indexPath.row == 0) {
        _typeLabel.text = @"类型";
        if (model.typeSelector != nil) {
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_typeArray[[model.typeSelector intValue]];
            self.typeLabelResults.text = itemDto.itemText;
        }
    }
    else if (_indexPath.row == 2) {
        _typeLabel.text = @"称谓";
        if (model.appellationSelector != nil) {
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_appellationArray[[model.appellationSelector intValue]];
            self.typeLabelResults.text = itemDto.itemText;
        }
        
    }
    else if (_indexPath.row == 3) {
        _typeLabel.text = @"婚姻";
        if (model.marriageSelector != nil) {
            SelectItemDtoEntity *itemDto = (SelectItemDtoEntity *)_marriageArray[[model.marriageSelector intValue]];
            self.typeLabelResults.text = itemDto.itemText;
        }
    }
    
    if ([_typeLabelResults.text isEqualToString:@"请选择"]) {
        _typeLabelResults.textColor = UICOLOR_RGB_Alpha(0xc7c7cd, 1.0);
    }else {
        _typeLabelResults.textColor = YCTextColorBlack;
    }
    
}

@end
