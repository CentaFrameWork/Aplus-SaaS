//
//  JMCalendarStrokeTakingSeeCell.h
//  PanKeTong
//
//  Created by 陈行 on 2018/5/16.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SubTakingSeeEntity.h"

@interface JMCalendarStrokeTakingSeeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *customerNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *customerPhoneNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *callPhoneNumBtn;

@property (nonatomic, strong) SubTakingSeeEntity * entity;

@end
