//
//  PDPropFollowCell.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/23.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "PDPropFollowCell.h"

@implementation PDPropFollowCell
{

    __weak IBOutlet UILabel *_followContentLabel;
    
    __weak IBOutlet UILabel *_nameLabel;

    __weak IBOutlet UILabel *_typeLabel;
    
    __weak IBOutlet UILabel *_timeLabel;


    __weak IBOutlet NSLayoutConstraint *followContraints;
    


}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFollowDetailEntity:(PropFollowRecordDetailEntity *)followDetailEntity
{
    if (_followDetailEntity != followDetailEntity)
    {
        _followDetailEntity = followDetailEntity;

        [self setNeedsLayout];

    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _followContentLabel.text = _followDetailEntity.followContent?:@"";

    _nameLabel.text = _followDetailEntity.follower;

    followContraints.constant = _followDetailEntity.follower?8:16;
    
    
    CGSize sizeThatFits = [_nameLabel sizeThatFits:CGSizeZero];

    _nameLabel.width = sizeThatFits.width;
    
    _typeLabel.text = _followDetailEntity.followType;

    _timeLabel.left = _nameLabel.right + 12;
    _timeLabel.text = [self getTimeStr:_followDetailEntity.followTime];
    
    
    if ([_followDetailEntity.followContent contains:@"查看权限"]) {
        
        self.accessoryType = 0;
        self.selectionStyle = 0;
    }else{
        
        self.accessoryType = 1;
         self.selectionStyle = 2;
    }
    
    

}
- (NSString *)getTimeStr:(NSString *)timeStr{
    
   
    
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    if (timeStr.length > 16) {
        
        timeStr = [timeStr substringToIndex:16];
        
    }
    
    return timeStr;
    
}


@end
