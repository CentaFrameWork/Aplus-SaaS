//
//  RecordDetailCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/23.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *checkInTime;
@property (weak, nonatomic) IBOutlet UILabel *checkInAddress;


+ (RecordDetailCell *)cellWithTableView:(UITableView *)tableView;

-(void)goOutRecordCheckListDetailWithEntity:(NSArray *)goOutRecordCheckEntity andIndexPath:(NSIndexPath *)indexPath;

@end
