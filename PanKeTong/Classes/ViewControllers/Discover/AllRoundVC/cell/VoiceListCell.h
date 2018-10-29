//
//  VoiceListCell.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VoiceListCellDelegate <NSObject>
@optional
- (void)clickPlayRecordImageView:(UIImageView *)imageV;

@end

@interface VoiceListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *voiceRecordPlayItem;

@property (weak, nonatomic) IBOutlet UILabel *recordTimeLabel;


@property (weak, nonatomic) IBOutlet UIView *voiceLegth;
@property (weak, nonatomic) IBOutlet UILabel *vocie_Time;

@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,weak)id<VoiceListCellDelegate>delegate;

@end
