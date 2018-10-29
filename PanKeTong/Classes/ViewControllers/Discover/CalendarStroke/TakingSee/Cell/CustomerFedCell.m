//
//  CustomerFedCell.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/2.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "CustomerFedCell.h"
#import "AddTakingSeeVC.h"
#import "NewTakeLookRecordViewController.h"


@implementation CustomerFedCell{
    IFlyRecognizerView  *_iflyRecognizerView; // 语音输入
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // 限制条件
    _textView.limitLength = 200;
}

#pragma mark - 麦克风输入

- (IBAction)voiceInputAction:(id)sender {
    if ([self.viewController isMemberOfClass:[AddTakingSeeVC class]])
    {
        // 埋点
        [CommonMethod addLogEventWithEventId:@"New a_voice enter_Click" andEventDesc:@"新增约看-语音输入点击量"];
    }

    if (_textView.text.length >= 200)
    {
        return;
    }

    [self endEditing:YES];

    __weak typeof (self) weakSelf = self;

    // 检测麦克风功能是否打开
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted)
    {

        if (granted) {

            // 初始化语音识别控件
            if (!_iflyRecognizerView) {

                _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.viewController.view.center];

                [_iflyRecognizerView setParameter:@"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];

                // asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
                [_iflyRecognizerView setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];

                // 设置有标点符号
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

    for (int i = 0; i<vcnWSArray.count; i++) {

        NSMutableDictionary *vcnWSDic = [vcnWSArray objectAtIndex:i];
        NSArray *vcnCWArray = [vcnWSDic objectForKey:@"cw"];
        NSDictionary *vcnCWDic = [vcnCWArray objectAtIndex:0];

        [vcnMutlResultValue appendFormat:@"%@",[vcnCWDic objectForKey:@"w"]];
    }

    if (![vcnMutlResultValue isEqualToString:@""] &&
        vcnMutlResultValue) {
        //获取当前光标的位置
        NSRange cursorPosition = [_textView selectedRange];
        NSInteger index = cursorPosition.location;
        NSMutableString *content = [[NSMutableString alloc] initWithString:_textView.text];

        //插入文字
        [content insertString:vcnMutlResultValue atIndex:index];
        _textView.text = content;

        id vc = self.viewController;
        if ([vc isMemberOfClass:[AddTakingSeeVC class]]){
            //新增约看
            AddTakingSeeVC *addVc = (AddTakingSeeVC *)vc;
            addVc.customerFed = _textView.text;
        }else if ([vc isMemberOfClass:[NewTakeLookRecordViewController class]]){
            //新增带看
//            NewTakeLookRecordViewController *newTakeVc = (NewTakeLookRecordViewController *)vc;
//            NSInteger tag = _textView.tag;
//            if (tag == 100) {
//                newTakeVc.customerFeedbackContent = _textView.text;
//            }else{
//                newTakeVc.nextStepContent = _textView.text;
//            }
//
            if (self.delegate &&[self.delegate respondsToSelector:@selector(IFlyRecognizerViewDidEndEditing:)]) {
                [self.delegate IFlyRecognizerViewDidEndEditing:_textView];
            }
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
