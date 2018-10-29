//
//  ReminRecordCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/30.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *reminDetail;
@property (weak, nonatomic) IBOutlet UILabel *reminTime;

-(void)setReminRecordDetailWithListEntity:(NSArray *)reminRecordListEntity
                             andIndexPath:(NSIndexPath *)indexPath;

+ (ReminRecordCell *)cellWithTableView:(UITableView *)tableView;

@end
