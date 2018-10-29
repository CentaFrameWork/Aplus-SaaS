//
//  FollowListTableViewCell.m
//  PanKeTong
//
//  Created by 燕文强 on 16/4/19.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "FollowListTableViewCell.h"
#import "PropLeftFollowItemEntity.h"





@implementation FollowListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setPropLeftFollowItemEntity:(PropLeftFollowItemEntity *)propLeftFollowItemEntity {
    
    _propLeftFollowItemEntity = propLeftFollowItemEntity;
    
    double timeDouble = [CommonMethod tryTimeNumberWith:propLeftFollowItemEntity.followTime];
    NSString *time = [CommonMethod dateConcretelyTime:timeDouble
                                           andYearNum:[[propLeftFollowItemEntity.followTime substringToIndex:4] integerValue]];
    
    self.followContent.text = propLeftFollowItemEntity.followContent;
    self.followTime.text = time?:@"";
    self.follower.text = propLeftFollowItemEntity.follower?:@"";

    
}

- (void)setTimeType:(NSString *)timeType {
    
    if ([timeType isEqualToString:@"今天"]) {
    
        
        _lineView.backgroundColor = YCThemeColorGreen;
        
        _lineImage.image = [UIImage imageNamed:@"circle_icon"];
        
    }else{
        
        _lineView.backgroundColor = YCHeaderViewBGColor;
        
        _lineImage.image = [UIImage imageNamed:@"circle_icon_gray"];
        
    }
}



@end
