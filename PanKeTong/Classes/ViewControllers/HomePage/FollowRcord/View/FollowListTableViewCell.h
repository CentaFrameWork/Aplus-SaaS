//
//  FollowListTableViewCell.h
//  PanKeTong
//
//  Created by 燕文强 on 16/4/19.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PropLeftFollowItemEntity;

@interface FollowListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *followContent;

@property (weak, nonatomic) IBOutlet UILabel *followTime;
@property (weak, nonatomic) IBOutlet UILabel *follower;


@property (nonatomic, strong) PropLeftFollowItemEntity *propLeftFollowItemEntity;
@property (copy, nonatomic)  NSString *timeType;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *lineImage;

@end
