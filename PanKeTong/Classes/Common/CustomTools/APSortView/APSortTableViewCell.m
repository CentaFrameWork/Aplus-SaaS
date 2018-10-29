//
//  APSortTableViewCell.m
//  APlus
//
//  Created by 张旺 on 2017/11/10.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "APSortTableViewCell.h"

static NSString * const cellIdentifier = @"APSortTableViewCell";

@implementation APSortTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (APSortTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    
    APSortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"APSortTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    return cell;
}

@end
