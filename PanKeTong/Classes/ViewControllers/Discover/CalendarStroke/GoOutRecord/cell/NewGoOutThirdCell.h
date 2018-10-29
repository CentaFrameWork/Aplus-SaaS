//
//  NewGoOutThirdCell.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/24.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewGoOutThirdCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *customerImg;
@property (weak, nonatomic) IBOutlet UIImageView *houseImg;
@property (weak, nonatomic) IBOutlet UIButton *deleteThirdCell;
@property (weak, nonatomic) IBOutlet UIView *deleteView;
@property (weak, nonatomic) IBOutlet UILabel *customerLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteCustomer;

@property (weak, nonatomic) IBOutlet UILabel *houseLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteHouse;

@property (weak, nonatomic) IBOutlet UIButton *customerBtn;
@property (weak, nonatomic) IBOutlet UIButton *houseBtn;



+ (NewGoOutThirdCell *)cellWithTableView:(UITableView *)tableView;

@end
