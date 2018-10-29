//
//  GoOutRecordCell.m
//  PanKeTong
//
//  Created by 张旺 on 16/11/23.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "GoOutRecordCell.h"
#import "SubGoOutListEntity.h"

@implementation GoOutRecordCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (GoOutRecordCell *)cellWithTableView:(UITableView *)tableView{
    
    GoOutRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:NSStringFromClass(self)];
        
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
        
    }
    return cell;
    
}

-(void)setGoOutRecordListDetailWithEntity:(NSArray *)goOutRecordEntity andIndexPath:(NSIndexPath *)indexPath
{
    SubGoOutListEntity *goOutListEntity = [goOutRecordEntity objectAtIndex:indexPath.row];
    
    self.goOutDetail.text = [NSString stringWithFormat:@"外出人：%@ %@  \n外出时间：%@ \n上报位置：%@ \n完成时间：%@ \n完成位置：%@ \n备注：%@",
                             goOutListEntity.employeeName?goOutListEntity.employeeName:@"",
                             goOutListEntity.employeeDeptName?goOutListEntity.employeeDeptName:@"",
                             [CommonMethod getFormatDateStrFromTime:goOutListEntity.goOutTime DateFormat:YearToMinFormat],
                             goOutListEntity.goOutAddress?goOutListEntity.goOutAddress:@"",
                             [CommonMethod getFormatDateStrFromTime:goOutListEntity.finishTime DateFormat:YearToMinFormat],
                             goOutListEntity.finishAddress?goOutListEntity.finishAddress:@"",
                             goOutListEntity.remark?goOutListEntity.remark:@""];
    
}

@end
