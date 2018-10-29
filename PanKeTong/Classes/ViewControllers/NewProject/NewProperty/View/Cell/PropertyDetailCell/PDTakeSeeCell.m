//
//  PDTakeSeeCell.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/22.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "PDTakeSeeCell.h"

@implementation PDTakeSeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    NSLog(@"%f",self.oneWeekLabel.width);
    
     NSLog(@"%@",NSStringFromCGRect(self.oneWeekLabel.frame));
    self.oneWeekLabel.layer.cornerRadius = self.oneWeekLabel.width/2;
    self.oneWeekLabel.layer.masksToBounds = YES;
    self.oneWeekLabel.layer.borderWidth = 1;
    self.oneWeekLabel.layer.borderColor = RGBColor(188, 188, 188).CGColor;
    
    self.sumLabel.layer.cornerRadius = self.oneWeekLabel.width/2;
    self.sumLabel.layer.masksToBounds = YES;
    self.sumLabel.layer.borderWidth = 1;
    self.sumLabel.layer.borderColor = RGBColor(188, 188, 188).CGColor;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
