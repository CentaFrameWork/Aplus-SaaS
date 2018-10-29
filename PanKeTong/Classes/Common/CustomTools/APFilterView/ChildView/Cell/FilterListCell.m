//
//  FilterListCell.m
//  APlusFilterView
//
//  Created by 张旺 on 2017/10/25.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "FilterListCell.h"

static NSString * const cellIdentifier = @"FilterListCell";

@implementation FilterListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (FilterListCell *)cellWithTableView:(UITableView *)tableView
{
    
    FilterListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"FilterListCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    return cell;
}

@end
