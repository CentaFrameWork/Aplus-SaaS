//
//  MoreFollowListCell.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PropFollowRecordDetailEntity;
@class CustomerFollowItemEntity;

@interface MoreFollowListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *followContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *followPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *followType;
@property (weak, nonatomic) IBOutlet UILabel *followTime;

@property (nonatomic, strong) PropFollowRecordDetailEntity *propFollowRecordDetailEntity;
@property (nonatomic, strong) CustomerFollowItemEntity *customerFollowItemEntity;

@property (nonatomic, strong)UIButton *buttonPlacedTop;     // 置顶button

@end
