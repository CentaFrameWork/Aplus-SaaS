//
//  GoOutScreeningCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/28.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoOutScreeningCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;

+ (GoOutScreeningCell *)cellWithTableView:(UITableView *)tableView;

@end
