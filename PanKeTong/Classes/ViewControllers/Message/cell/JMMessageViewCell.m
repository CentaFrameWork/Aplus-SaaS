//
//  JMMessageViewCell.m
//  PanKeTong
//
//  Created by 陈行 on 2018/4/24.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMMessageViewCell.h"

@implementation JMMessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setEntity:(OfficialMessageResultEntity *)entity{
    
    _entity = entity;
    
    self.messageLabel.text = entity.title;
    
    self.timeLabel.text = [NSString formattingYMdHmHTimeStr:entity.createTime];
    
    self.messageLabel.textColor = entity.isRead ? YCTextColorAuxiliary : YCTextColorBlack;
    
}


@end
