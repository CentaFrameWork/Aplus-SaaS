//
//  SellAndRentTableViewCell.h
//  PanKeTong
//
//  Created by wanghx17 on 15/9/25.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellAndRentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *estateNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *estateAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *estateInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *residualTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reloadTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseButton;

@end
