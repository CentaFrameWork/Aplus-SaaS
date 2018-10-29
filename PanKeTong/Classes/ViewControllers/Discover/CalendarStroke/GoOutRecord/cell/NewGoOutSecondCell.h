//
//  NewGoOutSecondCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/24.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewGoOutSecondCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *addEstateBtn;

+ (NewGoOutSecondCell *)cellWithTableView:(UITableView *)tableView;

@end
