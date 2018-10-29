//
//  JMEntrustFilingHeaderView.m
//  PanKeTong
//
//  Created by 陈行 on 2018/4/26.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMEntrustFilingHeaderView.h"

#import "UIView+Extension.h"

@implementation JMEntrustFilingHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.themeView setLayerCornerRadius:1];
    
    self.themeView.backgroundColor = YCThemeColorGreen;
    
}

@end
