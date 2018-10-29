//
//  MyClientTableViewCell.h
//  PanKeTong
//
//  Created by wanghx17 on 15/9/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomerEntity;

@interface MyClientTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *estateAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *estatePriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *hireLabel;

@property (nonatomic, strong) CustomerEntity *customerEntity;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
