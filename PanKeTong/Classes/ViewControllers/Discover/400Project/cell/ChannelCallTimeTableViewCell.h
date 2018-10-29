//
//  ChannelCallTimeTableViewCell.h
//  PanKeTong
//
//  Created by 燕文强 on 16/1/19.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickDelegate <NSObject>

- (void)dateStartPick;
- (void)dateEndPick;

@end

@interface ChannelCallTimeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *dateTimeStartBtn;
@property (weak, nonatomic) IBOutlet UIButton *dateTimeEndBtn;

@property (nonatomic,assign)id <DatePickDelegate>delegate;

@end
