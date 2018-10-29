//
//  UploadSeeEstateListCell.m
//  PanKeTong
//
//  Created by 张旺 on 16/12/9.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "UploadSeeEstateListCell.h"

@implementation UploadSeeEstateListCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

+ (UploadSeeEstateListCell *)cellWithTableView:(UITableView *)tableView{
    
    UploadSeeEstateListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:NSStringFromClass(self)];
        
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
        
    }
    return cell;
    
}

@end
