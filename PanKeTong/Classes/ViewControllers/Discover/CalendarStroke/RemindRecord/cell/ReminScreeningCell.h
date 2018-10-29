//
//  ReminScreeningCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/30.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminScreeningCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *reminContentField;

+ (ReminScreeningCell *)cellWithTableView:(UITableView *)tableView;
@end
