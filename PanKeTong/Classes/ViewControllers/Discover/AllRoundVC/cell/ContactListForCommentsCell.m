//
//  ContactListForCommentsCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/11.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "ContactListForCommentsCell.h"

@implementation ContactListForCommentsCell

// cell 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initView];
        
    }
    return self;
}

- (void)initView {
    
    
    
    /*
     @property (nonatomic, strong)UIImageView *jiantouImage;     // 箭头图片
     @property (nonatomic, strong)UILabel *chakanLabel;          // 箭头文案
     */
    // 分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12*NewRatio, 0, APP_SCREEN_WIDTH-48*NewRatio, 1*NewRatio)];
    lineView.backgroundColor = UIColorFromHex(0xf6f6f6, 1.0);
    [self.contentView addSubview:lineView];
    
    // 箭头图片
    _jiantouImage = [[UIImageView alloc] initWithFrame:CGRectMake(136*NewRatio, 12*NewRatio, 14*NewRatio, 14*NewRatio)];
    [self.contentView addSubview:_jiantouImage];
    
    // 箭头文案
    _chakanLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_jiantouImage.frame)+12*NewRatio, 12*NewRatio, 100*NewRatio, 14*NewRatio)];
    _chakanLabel.textColor = YCTextColorAuxiliary;
    _chakanLabel.font = [UIFont systemFontOfSize:14*NewRatio weight:UIFontWeightLight];
    [self.contentView addSubview:_chakanLabel];
}

- (void)setModel:(WJContactListModel *)model {
    
    if (model.isEnable) {
        _jiantouImage.image = [UIImage imageNamed:@"收起备注-箭头"];
        _chakanLabel.text = @"收起";
    }else {
        _jiantouImage.image = [UIImage imageNamed:@"查看备注-箭头"];
        _chakanLabel.text = @"查看备注";
    }
    
}

// 设置cell子视图位置
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    //设置切哪个直角
    //    UIRectCornerTopLeft     = 1 << 0,  左上角
    //    UIRectCornerTopRight    = 1 << 1,  右上角
    //    UIRectCornerBottomLeft  = 1 << 2,  左下角
    //    UIRectCornerBottomRight = 1 << 3,  右下角
    //    UIRectCornerAllCorners  = ~0UL     全部角
    //得到view的遮罩路径
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5*NewRatio,5*NewRatio)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


@end
