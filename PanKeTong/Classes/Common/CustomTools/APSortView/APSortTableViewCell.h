//
//  APSortTableViewCell.h
//  APlus
//
//  Created by 张旺 on 2017/11/10.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APSortTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (APSortTableViewCell *)cellWithTableView:(UITableView *)tableView;

@end
