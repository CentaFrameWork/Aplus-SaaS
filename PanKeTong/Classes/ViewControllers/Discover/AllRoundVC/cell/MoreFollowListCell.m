//
//  MoreFollowListCell.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MoreFollowListCell.h"
#import "PropFollowRecordDetailEntity.h"
#import "CustomerFollowItemEntity.h"

@implementation MoreFollowListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _followContentLabel.font = [UIFont setFontSizeWithFontName:FontName  andSize:13.0];
    _followPersonLabel.font = [UIFont setFontSizeWithFontName:FontName  andSize:13.0];
    
}

/// 房源跟进
- (void)setPropFollowRecordDetailEntity:(PropFollowRecordDetailEntity *)propFollowRecordDetailEntity {
    _propFollowRecordDetailEntity = propFollowRecordDetailEntity;
    
    NSString *detaileFormatDate = [CommonMethod getDetailedFormatDateStrFromTime:propFollowRecordDetailEntity.followTime];
    NSString *followContentStr = [NSString stringWithFormat:@"%@",
                                  propFollowRecordDetailEntity.followContent];
    self.followContentLabel.text = followContentStr;
    self.followPersonLabel.text = propFollowRecordDetailEntity.follower ? propFollowRecordDetailEntity.follower:@"";
    self.followPersonLabel.textColor = RGBColor(71, 151, 202);
    self.followType.text = propFollowRecordDetailEntity.followType;
    self.followTime.text = detaileFormatDate;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    if (propFollowRecordDetailEntity.topFlag)
    {
        self.contentView.backgroundColor = RGBColor(244, 244, 244);
    }
}

/// 客源跟进
- (void)setCustomerFollowItemEntity:(CustomerFollowItemEntity *)customerFollowItemEntity {
    _customerFollowItemEntity = customerFollowItemEntity;
    
    NSString *formatDateStr = [self formatDate:customerFollowItemEntity.followDate];
    
    NSString *followContentStr = [NSString stringWithFormat:@"%@", customerFollowItemEntity.followContent];
    self.followPersonLabel.textColor = [UIColor colorWithRed:(71 / 255.0f)
                                                       green:(151 / 255.0f)
                                                        blue:(202 / 255.0f)
                                                       alpha:1.0f];
    self.followContentLabel.text = followContentStr;
    self.followPersonLabel.text = customerFollowItemEntity.followPerson?customerFollowItemEntity.followPerson:@"";
    self.followType.text = customerFollowItemEntity.followType;
    self.followTime.text = formatDateStr;
}

- (NSString *)formatDate:(NSString *)dateString
{
    if(dateString)
    {
        //    2015-11-16T14:37:34.102+08:00
        if(dateString.length > 19)
        {
            NSString *date = [dateString substringWithRange:NSMakeRange(0, 19)];
            return [CommonMethod getDetailedFormatDateStrFromTime:date];
        }
        
        return [CommonMethod getDetailedFormatDateStrFromTime:dateString];
    }
    else
    {
        return dateString;
    }
}



@end
