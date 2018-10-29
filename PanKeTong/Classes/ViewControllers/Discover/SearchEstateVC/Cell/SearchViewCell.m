//
//  SearchViewCell.m
//  PanKeTong
//
//  Created by 张旺 on 2017/8/3.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "SearchViewCell.h"

static NSString * const cellIdentifier = @"SearchViewCell";

@implementation SearchViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    if([CommonMethod is4_7InchScreen])
    {
        self.leftLabelWidthConstant.constant = [CommonMethod calculateLengthFromMultipleScreenSizeWithLength:250];
    }else if ([CommonMethod is5InchScreen])
    {
        self.leftLabelWidthConstant.constant = [CommonMethod calculateLengthFromMultipleScreenSizeWithLength:265];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (SearchViewCell *)cellWithTableView:(UITableView *)tableView
{
    
    SearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"SearchViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
    }
    return cell;
}

@end
