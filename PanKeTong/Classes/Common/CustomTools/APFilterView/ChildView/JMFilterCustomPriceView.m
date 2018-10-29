//
//  JMFilterCustomPriceView.m
//  PanKeTong
//
//  Created by 陈行 on 2018/5/10.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMFilterCustomPriceView.h"

@implementation JMFilterCustomPriceView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.ensureBtn.backgroundColor = YCThemeColorGreen;
    
    [self.minPriceTextField setLayerCornerRadius:YCLayerCornerRadius];
    [self.maxPriceTextField setLayerCornerRadius:YCLayerCornerRadius];
    [self.ensureBtn setLayerCornerRadius:YCLayerCornerRadius];
}

@end
