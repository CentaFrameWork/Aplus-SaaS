//
//  PropFollowRecordCell.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropFollowRecordCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *propFollowDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *propFollowOtherMsgLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgConfirm;

@property (weak, nonatomic) IBOutlet UILabel *followType;
@property (weak, nonatomic) IBOutlet UILabel *followTime;

@end
