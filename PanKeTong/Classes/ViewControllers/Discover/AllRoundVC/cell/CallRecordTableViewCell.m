//
//  CallRecordTableViewCell.m
//  PanKeTong
//
//  Created by 王雅琦 on 17/4/14.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "CallRecordTableViewCell.h"
#import "UILabel+Extension.h"

#define  RecordingExists       @"existence" // 录音存在
#define  NoRecord              @"none"      // 录音不存在
#define  PlayRecording         @"playRecording" // 播放录音
#define  PlayPause             @"playPause" // 暂停录音

@implementation CallRecordTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _openButton.hidden = YES;
    [_openButton addTarget:self action:@selector(openAllTextAction) forControlEvents:UIControlEventTouchUpInside];
    
//    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chickImage)];
//    [_listenImage addGestureRecognizer:tap];
}


- (IBAction)checkImage:(id)sender {
 
    if ([_delegate respondsToSelector:@selector(clickPlayButtonIndexPath:andStuts:)]) {
        [_delegate clickPlayButtonIndexPath:_indexRow andStuts:_callRecordStuts];
    }
}

- (void)openAllTextAction
{
    _followUpHeight.constant = _relatedFollowUp.textHeight + 10;
    
    if ([_delegate respondsToSelector:@selector(changeCellHeight:andHasFollowUp:)]) {
        
        if ([_openButton.titleLabel.text isEqualToString:@"点击展开"]) {
            [_openButton setTitle:@"点击收起" forState:UIControlStateNormal];
            [_delegate changeCellHeight:_indexRow andHasFollowUp:YES];
        }
        else
        {
            [_openButton setTitle:@"点击展开" forState:UIControlStateNormal];
            [_delegate changeCellHeight:_indexRow andHasFollowUp:NO];
        }
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
