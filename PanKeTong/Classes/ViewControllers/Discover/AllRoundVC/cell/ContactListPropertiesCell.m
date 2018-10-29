//
//  ContactListPropertiesCell.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/5/11.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "ContactListPropertiesCell.h"

@implementation ContactListPropertiesCell

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
     @property (nonatomic, strong)UIImageView *yuanImage;    // 圆点图片
     @property (nonatomic, strong)UILabel *nameLabel;        // 名字label
     @property (nonatomic, strong)UIButton *deleteButton;    // 删除button
     @property (nonatomic, strong)UIButton *editorButton;    // 编辑button
     @property (nonatomic, strong)UILabel *attributeLabel;   // 属性label
     */
    
    // 圆点图片
    _yuanImage = [[UIImageView alloc] initWithFrame:CGRectMake(12*NewRatio, 17*NewRatio, 8*NewRatio, 8*NewRatio)];
    _yuanImage.image = [UIImage imageNamed:@"Oval 6"];
    [self.contentView addSubview:_yuanImage];
    
    // 名字label
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(24*NewRatio, 12*NewRatio, 250*NewRatio, 17*NewRatio)];
    _nameLabel.font = [UIFont systemFontOfSize:18*NewRatio];
    _nameLabel.textColor = YCTextColorBlack;
    [self.contentView addSubview:_nameLabel];
    
    
    // 删除button
    _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH-24*NewRatio-55*NewRatio, 14*NewRatio, 14*NewRatio, 14*NewRatio)];
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"删除3"] forState:UIControlStateNormal];
    [[_deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.deleteClickEvent(_indexPath);
    }];
    [self.contentView addSubview:_deleteButton];
    
    // 编辑button
    _editorButton = [[UIButton alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH-24*NewRatio-25*NewRatio, 14*NewRatio, 14*NewRatio, 14*NewRatio)];
    [_editorButton setBackgroundImage:[UIImage imageNamed:@"编辑-1"] forState:UIControlStateNormal];
    [[_editorButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.editClickEvent(_indexPath);
    }];
    [self.contentView addSubview:_editorButton];
    
    // 属性label
    _attributeLabel = [[UILabel alloc] initWithFrame:CGRectMake(24*NewRatio, CGRectGetMaxY(_nameLabel.frame)+8*NewRatio, 250*NewRatio, 14*NewRatio)];
    _attributeLabel.textColor = YCTextColorGray;
    _attributeLabel.font = [UIFont systemFontOfSize:14*NewRatio];
    [self.contentView addSubview:_attributeLabel];
    
}

- (void)setModel:(WJContactListModel *)model {
    
    _nameLabel.text = model.TrustorName;
    _attributeLabel.text = [NSString stringWithFormat:@"%@ / %@ / %@",model.TrustorTypeKeyId,model.TrustorGenderKeyId,model.MaritalStatusKeyId];
    
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
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5*NewRatio,5*NewRatio)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end














