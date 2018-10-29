//
//  PropSituationKeyCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/15.
//  Copyright © 2018年 中原集团. All rights reserved.
//
// 钥匙情况
#import "PropSituationKeyCell.h"

@implementation PropSituationKeyCell

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    _labelName = [[UILabel alloc] initWithFrame:CGRectMake(10*NewRatio, 18*NewRatio, 100*NewRatio, 14*NewRatio)];
    _labelName.font = [UIFont systemFontOfSize:14*NewRatio];
    _labelName.textColor = YCTextColorBlack;
    _labelName.text = @"钥匙情况";
    [self.contentView addSubview:_labelName];
    
    _labelResults = [[UILabel alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH-233*NewRatio, 18*NewRatio, 200*NewRatio, 14*NewRatio)];
    _labelResults.font = [UIFont systemFontOfSize:14*NewRatio];
    _labelResults.textColor = YCTextColorBlack;
    _labelResults.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_labelResults];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH-20*NewRatio, 18*NewRatio, 8*NewRatio, 14*NewRatio)];
    imageview.image = [UIImage imageNamed:@"icon_jm_right_arrow"];
    [self.contentView addSubview:imageview];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49*NewRatio, APP_SCREEN_WIDTH, 1)];
    lineView.backgroundColor = YCOtherColorDivider;
    [self.contentView addSubview:lineView];
}

- (void)setModel:(PropKeyModel *)model {
    if (_indexPath.row == 0) {
        _labelName.text = @"钥匙情况";
        if (model.propertyKeyStatus == 1) {
            _labelResults.text = @"无";
        }
        else if (model.propertyKeyStatus == 2) {
            _labelResults.text = @"在店";
        }
        else if (model.propertyKeyStatus == 3) {
            _labelResults.text = @"同行";
        }
    }
    else if (_indexPath.row == 1) {
        _labelName.text = @"收钥匙人";
        if (model.receiver) {
            _labelResults.text = model.receiver;
        }else {
            _labelResults.text = @"请选择或输入";
        }
    }
}

@end
