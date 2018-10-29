//
//  FilterListCell.h
//  APlusFilterView
//
//  Created by 张旺 on 2017/10/25.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

+ (FilterListCell *)cellWithTableView:(UITableView *)tableView;

@end
