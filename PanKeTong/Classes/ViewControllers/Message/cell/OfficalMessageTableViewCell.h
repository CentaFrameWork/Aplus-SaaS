//
//  OfficalMessageTableViewCell.h
//  PanKeTong
//
//  Created by wanghx17 on 15/9/23.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfficalMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infomationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelWidthConstraint;

@end
