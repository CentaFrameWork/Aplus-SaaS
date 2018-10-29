//
//  NewTakeLookFirstCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTakeLookFirstCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UIButton *deleteCustomer;
@property (weak, nonatomic) IBOutlet UIButton *takeSeeCustomerBtn;


+ (NewTakeLookFirstCell *)cellWithTableView:(UITableView *)tableView;

@end