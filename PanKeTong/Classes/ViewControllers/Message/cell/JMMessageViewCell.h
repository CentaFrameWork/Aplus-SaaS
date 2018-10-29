//
//  JMMessageViewCell.h
//  PanKeTong
//
//  Created by 陈行 on 2018/4/24.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OfficialMessageResultEntity.h"

@interface JMMessageViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) OfficialMessageResultEntity * entity;


@end
