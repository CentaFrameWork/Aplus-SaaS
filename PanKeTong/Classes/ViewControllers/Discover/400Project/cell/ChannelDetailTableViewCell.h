//
//  ChannelDetailTableViewCell.h
//  PanKeTong
//
//  Created by 燕文强 on 16/1/16.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *voiceImg;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *channelSource;
@property (weak, nonatomic) IBOutlet UILabel *propInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeSpanLabel;

@end
