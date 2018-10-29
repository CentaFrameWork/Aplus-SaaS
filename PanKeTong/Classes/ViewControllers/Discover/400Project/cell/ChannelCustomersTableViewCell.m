//
//  ChannelCustomersTableViewCell.m
//  PanKeTong
//
//  Created by 燕文强 on 16/2/3.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "ChannelCustomersTableViewCell.h"
#import "ChannelCallModelEntity.h"
#import "PhoneAddressInfo.h"

@implementation ChannelCustomersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPhoneAddressInfo:(PhoneAddressInfo *)phoneAddressInfo
{
    _phoneAddressInfo = phoneAddressInfo;
}

- (void)setChannelCallModelEntity:(ChannelCallModelEntity *)channelCallModelEntity
{
    _channelCallModelEntity = channelCallModelEntity;
    
    NSString *channelSource = @" ";
    NSString *address = @"";
    double timeDouble = [CommonMethod tryTimeNumberWith:_channelCallModelEntity.mcreateTime];
    NSString *time = [CommonMethod dateConcretelyTime:timeDouble andYearNum:[[_channelCallModelEntity.mcreateTime substringToIndex:4] integerValue]];
    
    if (_channelCallModelEntity.mchannelInquirySources && ![_channelCallModelEntity.mchannelInquirySources isEqualToString:@""])
    {
        channelSource = _channelCallModelEntity.mchannelInquirySources;
    }
    
    if (_phoneAddressInfo)
    {
        address = _phoneAddressInfo.city;
    }
    
    self.channelPhone.text = _channelCallModelEntity.mphone;
    self.channelSource.text = channelSource;
    self.agentInfo.text = [NSString stringWithFormat:@"%@  %@",_channelCallModelEntity.mchannelInquiryChief,_channelCallModelEntity.mchannelInquiryChiefDept];
    self.departmentOfAgent.text = _channelCallModelEntity.mpublicAccount;
    self.createTime.text = time;
    self.phoneAddress.text = address;
}
@end
