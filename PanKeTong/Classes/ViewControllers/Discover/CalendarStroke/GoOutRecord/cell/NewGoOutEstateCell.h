//
//  NewGoOutEstateCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/12/14.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewGoOutEstateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *customerImg;
@property (weak, nonatomic) IBOutlet UIImageView *houseImg;
@property (weak, nonatomic) IBOutlet UIButton *customerBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteCustomer;

@property (weak, nonatomic) IBOutlet UIButton *houseBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteHouse;

@property (weak, nonatomic) IBOutlet UILabel *customerLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseLabel;


+ (NewGoOutEstateCell *)cellWithTableView:(UITableView *)tableView;

@end
