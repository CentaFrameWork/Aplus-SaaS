//
//  ChannelCustomersTableViewCell.h
//  PanKeTong
//
//  Created by 燕文强 on 16/2/3.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChannelCallModelEntity;
@class PhoneAddressInfo;

@interface ChannelCustomersTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *channelPhone;
@property (weak, nonatomic) IBOutlet UILabel *phoneAddress;
@property (weak, nonatomic) IBOutlet UILabel *channelSource;
@property (weak, nonatomic) IBOutlet UILabel *agentInfo;
@property (weak, nonatomic) IBOutlet UILabel *departmentOfAgent;
@property (weak, nonatomic) IBOutlet UILabel *createTime;

@property (nonatomic, strong) ChannelCallModelEntity *channelCallModelEntity;
@property (nonatomic, strong) PhoneAddressInfo *phoneAddressInfo;


@end
