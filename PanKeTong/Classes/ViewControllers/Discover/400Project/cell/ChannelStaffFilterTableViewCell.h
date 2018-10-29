//
//  ChannelStaffFilterTableViewCell.h
//  PanKeTong
//
//  Created by 燕文强 on 16/1/19.
//  Copyright (c) 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextFeildPressedDelegate <NSObject>

- (void)textFeildPressedWithSender:(NSObject *)sender;

@end

@interface ChannelStaffFilterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelForKey;
@property (weak, nonatomic) IBOutlet UIButton *textFeildForValue;

@property (nonatomic,assign)id <TextFeildPressedDelegate>delegate;

@end
