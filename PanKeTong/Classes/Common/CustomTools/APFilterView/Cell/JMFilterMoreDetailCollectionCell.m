//
//  JMFilterMoreDetailCollectionCell.m
//  PanKeTong
//
//  Created by 陈行 on 2018/5/10.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMFilterMoreDetailCollectionCell.h"

@implementation JMFilterMoreDetailCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.titleBtn setTitleColor:YCTextColorBlack forState:UIControlStateNormal];
    
    self.titleBtn.layer.borderColor = YCTextColorBlack.CGColor;
    self.titleBtn.layer.borderWidth = 1;
    [self.titleBtn setLayerCornerRadius:YCLayerCornerRadius];
    self.titleBtn.userInteractionEnabled = NO;
    
}

- (void)setIsSelect:(BOOL)isSelect{
    
    if (isSelect) {
        
        self.titleBtn.backgroundColor = [UIColor whiteColor];
        
        self.titleBtn.layer.borderColor = YCTextColorMoreSelect.CGColor;
        
        [self.titleBtn setTitleColor:YCTextColorMoreSelect forState:UIControlStateNormal];
        
        self.selectImageView.hidden = NO;
        
    }else{
        
        self.titleBtn.backgroundColor = YCOtherColorBackground;
        
        self.titleBtn.layer.borderColor = [UIColor clearColor].CGColor;
        
        [self.titleBtn setTitleColor:YCTextColorBlack forState:UIControlStateNormal];
        
        self.selectImageView.hidden = YES;
        
    }
    
}

@end
