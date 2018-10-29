//
//  MyMessageListTableViewCell.h
//  PanKeTong
//
//  Created by wanghx17 on 15/12/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMessageListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *unReadCountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unReadCountLabelWidthCon;


@end
