//
//  SearchViewCell.h
//  PanKeTong
//
//  Created by 张旺 on 2017/8/3.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightLabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *bracketsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLabelWidthConstant;


+(SearchViewCell *)cellWithTableView:(UITableView *)tableView;

@end
