//
//  ApplyReasonInputCell.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/28.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ApplyReasonInputCellContentType) {
	ApplyReasonInputCellContentTypeVoice,
	ApplyReasonInputCellContentTypeTextView
};

typedef void(^VoiceInputBlock)(NSString *contentStr,ApplyReasonInputCellContentType type);

@interface ApplyReasonInputCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *rightInputTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceInputBtn;
@property (weak, nonatomic) IBOutlet UIImageView *voiceIcon;


/**
 *  初始化 “跟进内容” cell
 */
- (void)setupFollowCententCellWithViewController:(UIViewController *)viewController title:(NSString *)title;

/**
 *  点击 “语音输入”
 *
 *  @param block block
 */
- (void)onClickVoiceInputButtonWithContentBlock:(VoiceInputBlock) block;



@end
