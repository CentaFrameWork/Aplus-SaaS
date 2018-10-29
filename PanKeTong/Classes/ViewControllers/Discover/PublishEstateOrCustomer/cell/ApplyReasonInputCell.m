//
//  ApplyReasonInputCell.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/28.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "ApplyReasonInputCell.h"
#import <iflyMSC/iflyMSC.h>
#import <AVFoundation/AVFoundation.h>

#import "AddContactsViewController.h"
@interface ApplyReasonInputCell ()<IFlyRecognizerViewDelegate,UITextViewDelegate>

@property (strong,nonatomic)IFlyRecognizerView *iflyRecognizerView;           //语音输入;

@property (strong,nonatomic)UIViewController *viewController;

@property (copy,nonatomic)VoiceInputBlock block;


@end

@implementation ApplyReasonInputCell

#pragma mark Life Cycle
- (void)awakeFromNib{
    [super awakeFromNib];
	
	self.rightInputTextView.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textViewChangeInput:)
                                                name:UITextViewTextDidChangeNotification
                                              object:nil];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)textViewChangeInput:(NSNotification *)notification
{

    UITextView *inputTextView = (UITextView *)notification.object;
    if (inputTextView.text.length > 200) {
        NSString *subStr=[inputTextView.text substringToIndex:200];
        inputTextView.text = subStr;
    }

}



#pragma mark - <setup>
- (void)setupFollowCententCellWithViewController:(UIViewController *)viewController title:(NSString *)title{
	
	NSMutableAttributedString *leftTitleStr = [[NSMutableAttributedString alloc] initWithString:title];
	[leftTitleStr addAttribute:NSForegroundColorAttributeName
						 value:[UIColor redColor]
						 range:NSMakeRange(0, 1)];
	self.leftTitleLabel.attributedText = leftTitleStr;
	[self.leftTitleLabel sizeToFit];
	self.placeholderLabel.hidden = YES;
	
	self.voiceIcon.image = [UIImage imageNamed:@"icon_voice"];
	
	self.viewController = viewController;
	
	[self.voiceInputBtn addTarget:self action:@selector(voiceInputMethod) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - <Public Method>
- (void)onClickVoiceInputButtonWithContentBlock:(VoiceInputBlock)block{
	_block = block;
}

#pragma mark - <UITextViewDelegate>
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.viewController isKindOfClass:[AddContactsViewController class]]) {
        AddContactsViewController *vc = (AddContactsViewController *)self.viewController;
        vc.indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
	
	if (_block) {
		_block(textView.text,ApplyReasonInputCellContentTypeTextView);
	}
	
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
	
	if (text.length > 0) {
		self.placeholderLabel.hidden = YES;
	}
	
	if (range.location >= 200  && range.length == 0) {
		NSString *inputString = [NSString stringWithFormat:@"%@%@",
								 textView.text,
								 text];
		NSString *subStr = [inputString substringToIndex:200];
		textView.text = subStr;
	}
	return YES;
	
}


#pragma mark - <IFlyRecognizerViewDelegate>
- (void)voiceInputMethod{
	[self endEditing:YES];
	
	__weak typeof (self) weakSelf = self;
	
	//检测麦克风功能是否打开
	[[AVAudioSession sharedInstance]requestRecordPermission:^(BOOL granted) {
		
		if (granted) {
			
			//初始化语音识别控件
			if (!_iflyRecognizerView) {
				
				_iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.viewController.view.center];
				
				[_iflyRecognizerView setParameter:@"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
				
				//asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
				
				[_iflyRecognizerView setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
				
				//设置有标点符号
				[_iflyRecognizerView setParameter:@"YES" forKey:[IFlySpeechConstant ASR_PTT]];
				[_iflyRecognizerView setParameter:@"YES" forKey:[IFlySpeechConstant ASR_PTT_HAVEDOT]];
			}
			
			_iflyRecognizerView.delegate = weakSelf;
			
			[_iflyRecognizerView start];
			
		}else{
			
			showMsg(SettingMicrophone);
		}
	}];

}

#pragma mark - <IFlyRecognizerViewDelegate>
/*识别结果返回代理
 @param resultArray 识别结果
 @ param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast
{
	
	NSDictionary *vcnJson = [[NSDictionary alloc]initWithDictionary:[resultArray objectAtIndex:0]];
	
	if (resultArray.count == 0) {
		
		return;
	}
	
	/**
	 *  语音输入后返回的内容格式...
	 *
	 *  {
	 bg = 0;
	 ed = 0;
	 ls = 0;
	 sn = 1;
	 ws =     (
	 {
	 bg = 0;
	 cw =
	 (
	 {
	 sc = "-101.93";
	 w = "\U5582";
	 }
	 );
	 },
	 );
	 }
	 */
	
	
	NSString *vcnValue = [[vcnJson allKeys] objectAtIndex:0];
	NSData *vcnData = [vcnValue dataUsingEncoding:NSUTF8StringEncoding];
	
	NSError *error = nil;
	NSDictionary *vcnDic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:vcnData
																		   options:NSJSONReadingAllowFragments
																			 error:&error];
	
	NSMutableString *vcnMutlResultValue = [[NSMutableString alloc]init];
	
	/**
	 语音结果最外层的数组
	 */
	NSArray *vcnWSArray = [[NSArray alloc]initWithArray:[vcnDic objectForKey:@"ws"]];
	
	for (int i = 0; i < vcnWSArray.count; i ++) {
		
		NSMutableDictionary *vcnWSDic = [vcnWSArray objectAtIndex:i];
		NSArray *vcnCWArray = [vcnWSDic objectForKey:@"cw"];
		NSDictionary *vcnCWDic = [vcnCWArray objectAtIndex:0];
		
		[vcnMutlResultValue appendFormat:@"%@",[vcnCWDic objectForKey:@"w"]];
	}
	
	
	if (![vcnMutlResultValue isEqualToString:@""] &&
		vcnMutlResultValue) {
		
		NSString *voiceInputStr = [[NSString alloc] init];
		
		voiceInputStr = [NSString stringWithFormat:@"%@%@",
						voiceInputStr?voiceInputStr:@"",
						vcnMutlResultValue];
		
		if (voiceInputStr.length > 200) {
			
			voiceInputStr = [voiceInputStr substringToIndex:200];
		}
		
		if (_block) {
			_block(voiceInputStr,ApplyReasonInputCellContentTypeVoice);
		}
		
	}
	
}

/*识别会话错误返回代理
 @ param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
	if (error.errorCode != 0) {
		
	}
}




@end
