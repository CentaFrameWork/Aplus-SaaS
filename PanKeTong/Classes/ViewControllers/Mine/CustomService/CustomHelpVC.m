//
//  CustomHelpViewController.m
//  PanKeTong
//
//  Created by TailC on 16/4/6.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "CustomHelpVC.h"
#import "CommonMethod.h"
#import "NSString+JSON.h"
#import <AVFoundation/AVFoundation.h>
#import <iflyMSC/iflyMSC.h>

#define YCSaveQRCode 1001

@interface CustomHelpVC ()<UIWebViewDelegate, UIAlertViewDelegate, IFlyRecognizerViewDelegate>
{
    NSInteger _selectedPhotosNum;               // 选择的图片数量
    IFlyRecognizerView  *_iflyRecognizerView;   // 语音输入
}

@property (strong,nonatomic) UIWebView *uiWebView;
@property (strong,nonatomic) NSMutableArray *URLArray;

@end

@implementation CustomHelpVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _URLArray = [NSMutableArray array];
    
	[self setupNavigation];
	
	[self setupUIWebView];
    
    NSLog(@"_helpURL=%@=",_helpURL);
}

#pragma mark - Private Method
- (void)setupNavigation
{
    BOOL share = [_helpURL contains:@"share=true"];

    [self setNavTitle:@""
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(webviewGoBack)]
      rightButtonItem:share ? [self customBarItemButton:@"分享"
                                        backgroundImage:nil
                                             foreground:nil
                                                    sel:@selector(shareMy2017)] : nil
     ];
}

- (void)setupUIWebView
{

	// 状态栏(statusbar)
	CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
	// 导航栏（navigationbar）
	CGRect rectNav = self.navigationController.navigationBar.frame;
	
	self.uiWebView= [[UIWebView alloc] initWithFrame:
					 CGRectMake(0,
								0,
								APP_SCREEN_WIDTH,
								APP_SCREEN_HEIGHT-rectStatus.size.height-rectNav.size.height)];
    self.uiWebView.mediaPlaybackRequiresUserAction = NO;
	
	[self.view addSubview:self.uiWebView];
    // 清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    self.uiWebView.opaque = NO;
    self.uiWebView.backgroundColor = [UIColor whiteColor];
    self.uiWebView.delegate = self;
    [self.uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_helpURL]]];
}

- (void)shareMy2017
{
    NSString *getAplusShare = [_uiWebView stringByEvaluatingJavaScriptFromString:@"getAplusShare()"];
    NSDictionary *dict = [getAplusShare jsonDictionaryFromJsonString];
    NSLog(@"%@", dict);
    if (!dict)
    {
        return;
    }
    [self sendMy2017:dict[@"link"] InforTitle:dict[@"title"] InforImage:dict[@"img"] Content:dict[@"description"]];
}

/// 截图
- (UIImage *) imageWithView:(UIScrollView *)selectView
{
    CGRect oldFrame = self.uiWebView.frame;
    CGRect newFrame = oldFrame;
    newFrame.size.height = selectView.contentSize.height;
    self.uiWebView.frame = newFrame;
    
    CGSize newSize = CGSizeMake(APP_SCREEN_WIDTH, selectView.contentSize.height);
    UIGraphicsBeginImageContextWithOptions(newSize, selectView.opaque, 0.0);
    
    [selectView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    CGImageRef imageRef = image.CGImage;
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRef];
    
    self.uiWebView.frame = oldFrame;
    
    return sendImage;
}

/// 保存截图至相册
- (void)saveImage
{
    
    UIImageWriteToSavedPhotosAlbum([self imageWithView:_uiWebView.scrollView], self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    
    if(error != NULL){
        showJDStatusStyleErrorMsg(@"保存图片失败");
    }else{
        showJDStatusStyleSuccMsg(@"保存图片成功");
    }
    
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == alertView.cancelButtonIndex) {
        
        return;
        
    }
    
    if (alertView.tag == YCSaveQRCode) {
        
        [self saveImage];
        
    }else{
        
        // 确定放弃本次上传实勘
        _selectedPhotosNum = 0;
        [_uiWebView goBack];
        
    }
    
}

#pragma mark - <UIWebViewDelegate>

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 获取当前页面的title
    NSString *title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestUrl = request.URL.absoluteString;
    NSString *url = [requestUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"requestUrl======%@===",url);
    
    if ([CommonMethod content:url containsWith:@"tel:"])
    {
        return YES;
    }

    if ([requestUrl startWith:@"centaline"])
    {

        NSString *shareUrl =[[NSString stringWithFormat:@"%@", requestUrl] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // JSON字符串转字典
        NSDictionary *jsonDic = [[shareUrl substringFromIndex:10] jsonDictionaryFromJsonString];
        NSLog(@"%@",jsonDic);
        NSString *actionStr = [jsonDic objectForKey:@"action"];
        
        if ([actionStr isEqualToString:@"open_voiceRecognition"])
        {
            // 打开语音识别
            [self openvoiceRecognition];
        }
        if ([actionStr isEqualToString:@"uploadPhoto"])
        {
            // 上传实勘
//            [self uploadPhoto];
        }

        if ([actionStr isEqualToString:@"getToken"])
        {
            // Token
            NSString *agencyToken = [AgencyUserPermisstionUtil getToken];
            NSString *userNo = [AgencyUserPermisstionUtil getIdentify].userNo;
            NSDictionary *dic = @{
                                  @"platform":@"ios",
                                  @"userNo":userNo,
                                  @"token":agencyToken,
                                  };

            NSString *paramJson = [dic JSONString];
            NSString *javascript = [NSString stringWithFormat:@"windowReady(%@);",paramJson];
            [webView stringByEvaluatingJavaScriptFromString:javascript];
        }
        
        if ([actionStr isEqualToString:@"setTitle"])
        {
            // 设置title
            NSString *title = [jsonDic objectForKey:@"data"];
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
            NSNumber *selectedPhotos = [jsonDic objectForKey:@"data"];
            _selectedPhotosNum = [selectedPhotos integerValue];
        }
        
        if ([actionStr isEqualToString:@"snapshoot"])
        {
            
            
            UIAlertView * av = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存二维码", nil];
            
            av.tag = YCSaveQRCode;
            
            [av show];
            
//            // 二维码截图
//            BYActionSheetView *byActionSheetView = [[BYActionSheetView alloc]initWithTitle:nil
//                                                                                  delegate:self
//                                                                         cancelButtonTitle:@"取消"
//                                                                         otherButtonTitles:@"保存二维码", nil];
//            [byActionSheetView show];
        }

        return NO;
    }

    return YES;
}

#pragma mark-<上传实勘>

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

    // 语音结果最外层的数组
    NSArray *vcnWSArray = [[NSArray alloc]initWithArray:[vcnDic objectForKey:@"ws"]];

    for (int i = 0; i<vcnWSArray.count; i++) {

        NSMutableDictionary *vcnWSDic = [vcnWSArray objectAtIndex:i];
        NSArray *vcnCWArray = [vcnWSDic objectForKey:@"cw"];
        NSDictionary *vcnCWDic = [vcnCWArray objectAtIndex:0];

        [vcnMutlResultValue appendFormat:@"%@",[vcnCWDic objectForKey:@"w"]];
    }

    if (![vcnMutlResultValue isEqualToString:@""]
        && vcnMutlResultValue.length > 0)
    {
        [_uiWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"speechComplete('%@');",vcnMutlResultValue]];

    }

    [_iflyRecognizerView cancel];
}


/** 识别会话错误返回代理
 *  @param  error 错误码
 */
- (void)onError: (IFlySpeechError *) error
{
    if (error.errorCode != 0)
    {
    }
    
    [_iflyRecognizerView cancel];
    
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
        [alertView show];
        return;
    }

    if (_uiWebView.canGoBack)
    {
        [_uiWebView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
