//
//  GoOutScreeningCell.m
//  PanKeTong
//
//  Created by 张旺 on 16/11/28.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "GoOutScreeningCell.h"

@implementation GoOutScreeningCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (GoOutScreeningCell *)cellWithTableView:(UITableView *)tableView{
    
    GoOutScreeningCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:NSStringFromClass(self)];
        
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
        
    }
    return cell;
    
}

@end
