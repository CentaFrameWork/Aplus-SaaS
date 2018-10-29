//
//  JMCustomInfoCell.m
//  PanKeTong
//
//  Created by Admin on 2018/4/21.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMCustomInfoCell.h"

@implementation JMCustomInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = YCThemeColorBackground;
    self.selectedBackgroundView = view;
}



@end
