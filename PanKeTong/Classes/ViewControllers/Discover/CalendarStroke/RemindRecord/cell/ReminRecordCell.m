//
//  ReminRecordCell.m
//  PanKeTong
//
//  Created by 张旺 on 16/11/30.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "ReminRecordCell.h"
#import "SubAlertEventEntity.h"

@implementation ReminRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (ReminRecordCell *)cellWithTableView:(UITableView *)tableView{
    
    ReminRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass(self) bundle:nil] forCellReuseIdentifier:NSStringFromClass(self)];
        
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
        
    }
    return cell;
    
}

-(void)setReminRecordDetailWithListEntity:(NSArray *)reminRecordListEntity
                             andIndexPath:(NSIndexPath *)indexPath
{
    SubAlertEventEntity * subAlertEntity = [reminRecordListEntity objectAtIndex:indexPath.row];
    
    self.reminTime.text = [CommonMethod getFormatWeekDateStrFromTime:subAlertEntity.alertEventTimes DateFormat:OnlyDateFormat];
    
    NSString * alertListDetail = [NSString stringWithFormat:@"提醒人：%@  \n提醒时间：%@ \n提醒内容：%@",
                                  subAlertEntity.employeeName,
                                  [CommonMethod getFormatDateStrFromTime:subAlertEntity.alertEventTimes DateFormat:YearToMinFormat],
                                  subAlertEntity.remark];
    
    self.reminDetail.text = alertListDetail;
}

@end
