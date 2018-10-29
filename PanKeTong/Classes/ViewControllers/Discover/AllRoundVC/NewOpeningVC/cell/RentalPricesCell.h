//
//  RentalPricesCell.h
//  PanKeTong
//
//  Created by zhwang on 16/4/21.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentalPricesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet UITextField *rightPricesTextField;

@end
