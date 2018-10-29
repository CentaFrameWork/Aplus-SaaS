//
//  PublishPropertyVC.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/26.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "WebViewModuleVC.h"
#import "NSString+JSON.h"
#import "UploadRealSurveyViewController.h"
#import "CheckRealProtectedDurationApi.h"
#import "CheckRealProtectedEntity.h"
#import "PropertyStatusCategoryEnum.h"
#import "NSString+UrlEncodeUTF8.h"




#define selectPhotoAlert    1000
#define exitPageAlert       2000

@interface WebViewModuleVC ()<UIWebViewDelegate,UIAlertViewDelegate>
{
    UIWebView *_webView;
    IFlyRecognizerView  *_iflyRecognizerView;   // 语音输入
    NSInteger _selectedPhotosNum;               // 选择的图片数量
    BOOL _shouldShowExitAlert;
    
}

@end

@implementation WebViewModuleVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [self initNav];
    [self initWebView];
}

#pragma mark - init

- (void)initNav
{
    [self setNavTitle:@""
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(webviewGoBack)]
      rightButtonItem:nil
     ];

}




- (void)webviewGoBack
{
    if (_selectedPhotosNum > 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否放弃本次上传?"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        alertView.tag = selectPhotoAlert;
        [alertView show];
        return;
    }

    if (_webView.canGoBack)
    {
        [_webView goBack];
        return;
    }
    

   
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - <webView>

- (void)initWebView{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64)];
    _webView.delegate = self;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_webView];

    NSURL *requestUrl = [NSURL URLWithString:_requestUrl];
    NSURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl];
    [_webView loadRequest:request];
}

#pragma mark - <UIWebViewDelegate>
/// 开始加载
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestUrl = request.URL.absoluteString;
    if ([requestUrl startWith:@"centaline"])
    {
        NSLog(@"requestUrl = %@",requestUrl);

        NSString *shareUrl =[[NSString stringWithFormat:@"%@", requestUrl] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // JSON字符串转字典
        NSDictionary *jsonDic = [[shareUrl substringFromIndex:10] jsonDictionaryFromJsonString];
        NSLog(@"jsonDic = %@",jsonDic);
        [self actionMethodWithDic:jsonDic];
        return NO;
    }

    return YES;
}

/// 网页成功加载完成之后
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 获取当前页面的title
    NSString *title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
}

/// 网页加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    showMsg(@"加载失败！");
}

#pragma mark - <Method>

- (void)actionMethodWithDic:(NSDictionary *)dic
{
    NSString *actionStr = [dic objectForKey:@"action"];

    if ([actionStr isEqualToString:@"open_voiceRecognition"])
    {
        // 打开语音识别
        [self openvoiceRecognition];
    }

    if ([actionStr isEqualToString:@"uploadPhoto"])
    {
        // 上传实勘
        [self uploadPhoto];
    }
    if ([actionStr isEqualToString:@"getToken"])
    {
        // 获取token
        NSString *agencyToken = [AgencyUserPermisstionUtil getToken];
        NSString *userNo = [AgencyUserPermisstionUtil getIdentify].userNo;
        NSString *adkeyid = (_adKeyId.length > 0)?_adKeyId:@"";
        NSDictionary *dic = @{
                              @"platform":@"ios",
                              @"userNo":userNo,
                              @"token":agencyToken,
                              @"tradeType":_tradeType,              // 交易类型
                              @"keyId":_propModelEntity.keyId,      // 房源KeyId
                              @"advertKeyId":adkeyid                // 房源广告KeyId
                              };

        NSString *paramJson = [dic JSONString];
        NSString *javascript = [NSString stringWithFormat:@"windowReady(%@);",paramJson];
        [_webView stringByEvaluatingJavaScriptFromString:javascript];
    }
    if ([actionStr isEqualToString:@"setTitle"])
    {
        // 设置标题
        NSString *title = [dic objectForKey:@"data"];
        self.title = title;
    }
    if ([actionStr isEqualToString:@"closePage"])
    {
        // 关闭本界面
        [self back];
    }
    if ([actionStr isEqualToString:@"selectedPhotos"])
    {
        // 传递的照片数量大于0时，弹框是否放弃本次上传实勘
        NSNumber *selectedPhotos = [dic objectForKey:@"data"];
        _selectedPhotosNum = [selectedPhotos integerValue];
    }
    if ([actionStr isEqualToString:@"publish_scceed"])
    {
        // 发布房源成功/发布到外网成功
        _shouldShowExitAlert = NO;
    }
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == selectPhotoAlert)
    {
        if (buttonIndex == 1)
        {
            //确定放弃本次上传实勘
            _selectedPhotosNum = 0;
            [_webView goBack];
            return;
        }
    }
    
    if ((alertView.tag == exitPageAlert))
    {
        if (buttonIndex == 1)
        {
            [self back];
        }
    }
}

#pragma mark-<语音识别>

- (void)openvoiceRecognition
{
    __weak typeof (self) weakSelf = self;

    // 检测麦克风功能是否打开
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {

        if (granted)
        {
            // 初始化语音识别控件
            if (!_iflyRecognizerView)
            {
                _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];

                [_iflyRecognizerView setParameter:@"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];

                // asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
                [_iflyRecognizerView setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];

                // 设置有标点符号
                [_iflyRecognizerView setParameter:@"YES" forKey:[IFlySpeechConstant ASR_PTT]];
                [_iflyRecognizerView setParameter:@"YES" forKey:[IFlySpeechConstant ASR_PTT_HAVEDOT]];
            }

            _iflyRecognizerView.delegate = weakSelf;

            [_iflyRecognizerView start];
            
        }
        else
        {
            
            showMsg(SettingMicrophone);
        }
    }];
}

#pragma mark - <IFlyRecognizerViewDelegate>
/** 识别结果返回代理
 *  @param resultArray 识别结果
 *  @param isLast 表示是否最后一次结果
 */
- (void)onResult: (NSArray *)resultArray isLast:(BOOL) isLast
{
    NSDictionary *vcnJson = [[NSDictionary alloc]initWithDictionary:[resultArray objectAtIndex:0]];

    if (resultArray.count == 0)
    {
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
        vcnMutlResultValue.length > 0)
    {
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"speechComplete('%@');",vcnMutlResultValue]];
    }

    [_iflyRecognizerView cancel];
}


/** 识别会话错误返回代理
 *  @param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
    if (error.errorCode != 0) {
    }

    [_iflyRecognizerView cancel];
}

#pragma mark - <上传实勘>

- (void)uploadPhoto
{
    BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_ADD_ALL];
    BOOL hasPermisstion = YES;

    if (![NSString isNilOrEmpty:_propModelEntity.departmentPermissions])
    {
        hasPermisstion =  [_propModelEntity.departmentPermissions contains:DEPARTMENT_PROPERTY_REALSURVEY_ADD_ALL];
    }

    if(isAble && hasPermisstion)
    {
            // 验证实勘保护期
            CheckRealProtectedDurationApi *checkRealProtectedApi = [[CheckRealProtectedDurationApi alloc] init];
            checkRealProtectedApi.keyId = _propModelEntity.keyId;
            [_manager sendRequest:checkRealProtectedApi];

//            UploadRealSurveyViewController *uploadRealSurveyVC = [[UploadRealSurveyViewController alloc]initWithNibName:@"UploadRealSurveyViewController" bundle:nil];
//            uploadRealSurveyVC.propKeyId = _propModelEntity.keyId;
//
//            [self.navigationController pushViewController:uploadRealSurveyVC animated:YES];
//        }
    }
    else
    {
        showMsg(@(NotHavePermissionTip));
    }
}

#pragma mark - <ResponseDelegate>


- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[CheckRealProtectedEntity class]])
    {
        // 点击上传实勘
        CheckRealProtectedEntity *checkRealProtectedEntity = [DataConvert convertDic:data toEntity:modelClass];

        BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_ADD_ALL];

        if(isAble)
        {
            UploadRealSurveyViewController *uploadRealSurveyVC = [[UploadRealSurveyViewController alloc]initWithNibName:@"UploadRealSurveyViewController"
                                                                                                                 bundle:nil];
            uploadRealSurveyVC.propKeyId = _propModelEntity.keyId;

            if (![NSString isNilOrEmpty:checkRealProtectedEntity.width])
            {
                uploadRealSurveyVC.widthScale = [checkRealProtectedEntity.width integerValue];
            }
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.high])
            {
                uploadRealSurveyVC.hightScale = [checkRealProtectedEntity.high integerValue];
            }

            NSString *isLockRoom = [NSString stringWithFormat:@"%d",checkRealProtectedEntity.isLockRoom];
            if (![NSString isNilOrEmpty:isLockRoom])
            {
                uploadRealSurveyVC.isLockRoom = checkRealProtectedEntity.isLockRoom;
            }

            uploadRealSurveyVC.imgUploadCount = [checkRealProtectedEntity.imgUploadCount integerValue];
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.imgRoomMaxCount])
            {
                uploadRealSurveyVC.imgRoomMaxCount = [checkRealProtectedEntity.imgRoomMaxCount integerValue];
            }
            
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.imgAreaMaxCount])
            {
                uploadRealSurveyVC.imgAreaMaxCount = [checkRealProtectedEntity.imgAreaMaxCount integerValue];
            }
            [self.navigationController pushViewController:uploadRealSurveyVC
                                                 animated:YES];
        }
        else
        {
            showMsg(@(NotHavePermissionTip));
        }
    }
}

@end
