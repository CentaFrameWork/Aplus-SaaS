//
//  ChnnelCallTableViewCell.m
//  PanKeTong
//
//  Created by 燕文强 on 16/1/5.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import "ChnnelCallTableViewCell.h"
#import "ChannelCallModelEntity.h"
#import "PhoneAddressInfo.h"

@implementation ChnnelCallTableViewCell

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
    
    NSString *propInfo = @" ";
    NSString *channelSource = @" ";
    
    if(_channelCallModelEntity.motherNetComments && ![_channelCallModelEntity.motherNetComments isEqualToString:@""])
    {
        propInfo = _channelCallModelEntity.motherNetComments;
    }
    
    if(_channelCallModelEntity.mchannelInquirySources && ![_channelCallModelEntity.mchannelInquirySources isEqualToString:@""])
    {
        channelSource = _channelCallModelEntity.mchannelInquirySources;
    }
    
    double timeDouble = [CommonMethod tryTimeNumberWith:_channelCallModelEntity.mcreateTime];
    NSString *time = [CommonMethod dateConcretelyTime:timeDouble andYearNum:[[_channelCallModelEntity.mcreateTime substringToIndex:4] integerValue]];\
    
    NSString *address = @"";
    if(_phoneAddressInfo)
    {
        address = _phoneAddressInfo.city;
    }
    
    self.channelPhone.text = _channelCallModelEntity.mphone;
    self.phoneAddress.text = address;
    self.agentName.text = _channelCallModelEntity.mchannelInquiryChief;
    self.propInfo.text = propInfo;
    self.channelSource.text = channelSource;
    self.createTime.text = time;
}
@end
