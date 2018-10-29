//
//  EstateMessageTableViewCell.h
//  PanKeTong
//
//  Created by wanghx17 on 15/9/23.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EstateMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
