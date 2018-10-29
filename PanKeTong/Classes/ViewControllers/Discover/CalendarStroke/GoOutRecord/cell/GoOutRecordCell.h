//
//  GoOutRecordCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/23.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoOutRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *goOutDetail;      //外出详情
@property (weak, nonatomic) IBOutlet UIButton *goOutdetailBtn;  //外出详情按钮


+ (GoOutRecordCell *)cellWithTableView:(UITableView *)tableView;

-(void)setGoOutRecordListDetailWithEntity:(NSArray *)goOutRecordEntity
                             andIndexPath:(NSIndexPath *)indexPath;
@end
