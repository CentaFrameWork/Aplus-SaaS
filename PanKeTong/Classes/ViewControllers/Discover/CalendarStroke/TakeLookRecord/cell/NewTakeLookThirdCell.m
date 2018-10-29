//
//  NewTakeLookThirdCell.m
//  PanKeTong
//
//  Created by 张旺 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "NewTakeLookThirdCell.h"

@implementation NewTakeLookThirdCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.promptLabel.text = @"最多输入200字";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NewTakeLookThirdCell *)cellWithTableView:(UITableView *)tableView{
    
    NewTakeLookThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:NSStringFromClass(self)];
        
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
        
    }
    return cell;
    
}

@end
