//
//  ChatListCell.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/16.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userChatContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *userChatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *badgeNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badgeLabelLeftFrame;


@end
