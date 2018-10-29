//
//  JMPrivateChatViewCell.h
//  PanKeTong
//
//  Created by 陈行 on 2018/5/16.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JMMessage.h"

@interface JMPrivateChatViewCell : UITableViewCell
/**
 *  时间Label
 */
@property (weak, nonatomic) IBOutlet UILabel * timeLabel;
/**
 *  头像图
 */
@property (weak, nonatomic) IBOutlet UIImageView * headerImageView;
/**
 *  消息整体View
 */
@property (weak, nonatomic) IBOutlet UIView *messageConView;
/**
 *  消息背景图片
 */
@property (weak, nonatomic) IBOutlet UIImageView * messageImageView;
/**
 *  消息Label
 */
@property (weak, nonatomic) IBOutlet UILabel * messageLabel;

@property (nonatomic, strong) JMMessageText * message;

@end
