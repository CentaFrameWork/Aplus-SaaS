//
//  NewGoOutEstateCell.m
//  PanKeTong
//
//  Created by 张旺 on 16/12/14.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "NewGoOutEstateCell.h"

@implementation NewGoOutEstateCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NewGoOutEstateCell *)cellWithTableView:(UITableView *)tableView{
    
    NewGoOutEstateCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:NSStringFromClass(self)];
        
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
        
    }
    return cell;
    
}

@end
