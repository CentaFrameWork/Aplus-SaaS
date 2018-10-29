//
//  RecordDetailCell.m
//  PanKeTong
//
//  Created by 张旺 on 16/11/23.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "RecordDetailCell.h"
#import "SigendRecordListEntity.h"

@implementation RecordDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (RecordDetailCell *)cellWithTableView:(UITableView *)tableView{
    
    RecordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:NSStringFromClass(self)];
        
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
        
    }
    return cell;
    
}

-(void)goOutRecordCheckListDetailWithEntity:(NSArray *)goOutRecordCheckEntity andIndexPath:(NSIndexPath *)indexPath
{
    
    SigendRecordListEntity *goOutRecordCheck = [goOutRecordCheckEntity objectAtIndex:indexPath.row];
    self.checkInTime.text = [NSString stringWithFormat:@"签到时间：%@",[CommonMethod getFormatDateStrFromTime:goOutRecordCheck.checkInTime DateFormat:YearToMinFormat]];
    self.checkInAddress.text = [NSString stringWithFormat:@"签到位置：%@",goOutRecordCheck.checkInAddress];
}

@end
