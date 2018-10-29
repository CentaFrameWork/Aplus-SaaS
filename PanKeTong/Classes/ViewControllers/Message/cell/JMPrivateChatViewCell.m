//
//  JMPrivateChatViewCell.m
//  PanKeTong
//
//  Created by 陈行 on 2018/5/16.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "JMPrivateChatViewCell.h"

#import "UIImage+Cap.h"

@interface JMPrivateChatViewCell()
/**
 *  头像居左边界距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageViewLeftCon;
/**
 *  消息居左边界距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageConViewLeftCon;
/**
 *  消息view的高度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageConViewHeightCon;
/**
 *  消息view的宽度
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageConViewWidthCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelLeftConViewCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelRightConViewCon;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerImageViewTopCon;


@end

@implementation JMPrivateChatViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.headerImageView setLayerCornerRadius:self.headerImageView.width / 2.0f];
    self.backgroundColor = YCThemeColorBackground;
    self.contentView.backgroundColor = YCThemeColorBackground;
}

- (void)setMessage:(JMMessageText *)message{
    _message = message;

    self.timeLabel.text = message.time;
    self.messageLabel.text = message.text;

    self.messageConViewHeightCon.constant = message.textHeight;
    self.messageConViewWidthCon.constant = message.textWidth;
    self.headerImageViewTopCon.constant = message.isHiddenTime ? 12 : 41;
    self.timeLabel.hidden = message.isHiddenTime;
    
    //给数据赋值
    if(message.isMe){
        
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:message.accountImageUrl] placeholderImage:[UIImage imageNamed:@"icon_jm_chat_me_placeholder"]];
        
        self.messageImageView.image=[UIImage resizableImageWithImageName:@"icon_jm_chat_bg_me"];
        
        self.messageLabel.textColor = [UIColor whiteColor];

        self.headerImageViewLeftCon.constant = APP_SCREEN_WIDTH - 12 - 50;
        
        self.messageConViewLeftCon.constant = APP_SCREEN_WIDTH - message.textWidth - 74;
        
        self.textLabelLeftConViewCon.constant = 12;
        
        self.textLabelRightConViewCon.constant = 24;
        
    }else{
        
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:message.accountImageUrl] placeholderImage:[UIImage imageNamed:@"icon_jm_chat_other_placeholder"]];
        
        self.messageImageView.image=[UIImage resizableImageWithImageName:@"icon_jm_chat_bg_other"];
        
        self.messageLabel.textColor = YCTextColorBlack;

        self.headerImageViewLeftCon.constant = 12;

        self.messageConViewLeftCon.constant = 74;
        
        self.textLabelLeftConViewCon.constant = 24;
        
        self.textLabelRightConViewCon.constant = 12;

    }

}

@end
