//
//  AppDelegate+APPConfig.m
//  PanKeTong
//
//  Created by 李慧娟 on 2018/1/31.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "AppDelegate+APPConfig.h"
#import "UserGuideViewController.h"
#import "CalendarStrokeVC.h"
#import "CheckVersonUtils.h"
#import "HomeConfigUtils.h"
#import "CheckFaceUtils.h"
#import "JDStatusBarNotification.h"


@interface LoginType : NSObject

@property (nonatomic,assign) PopupType type;
@property (nonatomic,assign) float time;

@end

@implementation LoginType

@end

@implementation AppDelegate (APPConfig)

#pragma mark - 首次安装配置

- (void)firstInstallSetting
{
    
    NSString *curAppVerson = [[NSUserDefaults standardUserDefaults] stringForKey:CurrentAppVerson];

    // 首次安装APP
    if (!curAppVerson || [curAppVerson isEqualToString:@""])
    {
        // 默认打开聊天入口
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:YES] forKey:ShowChatIcon];

        // 默认开启消息提醒
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:YES] forKey:EnableNotify];

        // 是否仅wifi网络显示图片，默认NO
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:NO] forKey:ShowImageOnlyWIFI];

//        if ([CityCodeVersion isTianJin])
//        {
//            // 默认人脸未采集
//            [CommonMethod setUserdefaultWithValue:@"0" forKey:FaceCollectUrl];
//
//            // 默认人脸识别关闭
//            [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:NO] forKey:FaceRecogSwitch];
//        }
    }
    
    SettingSystem * set = [SettingSystem settingSystemForDatabase];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString * appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    //当前版本号是否还需要展示
    if ([appVersion isEqualToString:set.launchVersion]) {
        
        return;
        
    }else{
        
        [self addAdUserGuideView];
        
    }
    
}

- (void)addAdUserGuideView
{
    // 新手教程
    _LDWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _LDWindow.windowLevel = UIWindowLevelStatusBar + 1;

    NSMutableArray *imageArray;
    if (IS_iPhone_X) {
        
         imageArray = [NSMutableArray arrayWithObjects:@"iPhoneLX1",@"iPhoneLX2",@"iPhoneLX3", nil];
        
    }else{
        
       imageArray = [NSMutableArray arrayWithObjects:@"iPhoneL1",@"iPhoneL2",@"iPhoneL3", nil];
    }
    
    
    UserGuideViewController *controlGuide = [[UserGuideViewController alloc] initWithArrayGuideImage:imageArray];
    _LDWindow.rootViewController = controlGuide;
    [_LDWindow makeKeyAndVisible];
}


#pragma mark - 第三方配置

- (void)thirdPartySetting:(NSDictionary *)launchOptions
{
    // 集成科大讯飞SDK相关
    [self addIFlySetting];

    

    // 集成友盟分享
    [UMSocialData setAppKey:UMAppKey];
    [UMSocialData openLog:NO];

    // 集成Bugly
    [self addBuglySetting];

    // 集成微信
    [UMSocialWechatHandler setWXAppId:WeixinAppKey appSecret:WeixinAppSecret url:nil];

    // 集成百度相关
    [self addBaiduSetting];

    // 集成极光推送
    [self addJPush:launchOptions];

    // 集成GrowingIO
    [self addGrowIO];
    
    //设置网络请求错误弹框提示样式
    [self addJDStatusStyle];
    
    [self setKeyBoard];
}
- (void)setKeyBoard {
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setPreviousNextDisplayMode:IQPreviousNextDisplayModeAlwaysHide];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 80;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
/// 科大讯飞
- (void)addIFlySetting
{
    // 设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_NONE];

    // 打开输出在console的log开关
    [IFlySetting showLogcat:NO];

    NSString *IFlySpeechInitStr = [NSString stringWithFormat:@"appid=%@",IFlySpeechAppId];
    [IFlySpeechUtility createUtility:IFlySpeechInitStr];
}



/// Bugly
- (void)addBuglySetting
{
    BuglyConfig *bugConfig = [[BuglyConfig alloc] init];
    bugConfig.reportLogLevel = BuglyLogLevelWarn;
    NSString *userID = [NSString stringWithFormat:@"%@_%@",[CityCodeVersion getCurrentCityCode], [AgencyUserPermisstionUtil getIdentify].userNo];
    [Bugly setUserIdentifier:userID];
    [Bugly startWithAppId:BuglyAppId config:bugConfig];
}

/// 百度相关
- (void)addBaiduSetting
{
    // 授权地图
    _mapManager = [[BMKMapManager alloc]init];
    [_mapManager start:BaiduMapAppKey generalDelegate:nil];
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BaiduMapAppKey authDelegate:self];
    BOOL ret = [[[BMKMapManager alloc] init] start:BaiduMapAppKey generalDelegate:self];
    if (!ret)
    {
        NSLog(@"manager start failed!");
    }

    // 百度统计
    NSBundle * _Nonnull mainBundle = [NSBundle mainBundle];
    NSString * appVersion = [[mainBundle infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    BaiduMobStat *statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES;                       // 启用crash收集
    statTracker.logSendWifiOnly = NO;                           // 是否只在wifi发送日志
    statTracker.logStrategy = BaiduMobStatLogStrategyCustom;    // 日志发送策略
    statTracker.shortAppVersion = appVersion;                   // 设置APP版本号
    statTracker.channelId = BaiduMobStatChannelIdDev;           // 统计id
    statTracker.enableDebugOn = NO;                             // 是否打印日志
    statTracker.logSendInterval = 1;                            // 发送日志间隔
    [statTracker startWithAppId:BaiduMobStatAppKey];

}

/// 极光推送
- (void)addJPush:(NSDictionary *)launchOptions
{
    //如不需要使用IDFA，advertisingIdentifier 可为nil
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PushConfig" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *APP_KEY = dic[@"APP_KEY"];
    BOOL Production = TRUE;
    if ([dic[@"APS_FOR_PRODUCTION"] isEqualToString:@"0"])
    {
        Production = FALSE;
    }
    NSLog(@"APP_KEY = %@,apsForProduction = %d",APP_KEY,Production);
    
    [JPUSHService setLogOFF]; //关闭极光打印
    
    [JPUSHService setupWithOption:launchOptions appKey:APP_KEY
                          channel:dic[@"CHANNEL"]
                 apsForProduction:Production
            advertisingIdentifier:nil];
    
    
}

- (void)addGrowIO
{
#ifdef DEBUG
    //do sth.
#else
    // 启动GrowingIO
    [Growing startWithAccountId:GrowingIOKey];
    
    // 开启Growing调试日志 可以开启日志
//     [Growing setEnableLog:YES];
#endif
}

- (void)addJDStatusStyle{
    
    [JDStatusBarNotification addStyleNamed:FINAL_JD_STATUS_BAR_NOTIFICATION_ERROR prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
        
        style.barColor = UICOLOR_RGB_Alpha(0xE65F5F, 0.90)  ;
        
        style.textColor = [UIColor whiteColor];
        
        style.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        
        return style;
        
    }];
    
    [JDStatusBarNotification addStyleNamed:FINAL_JD_STATUS_BAR_NOTIFICATION_SUCC prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
        
        style.barColor = UICOLOR_RGB_Alpha(0x25A763, 0.90)  ;
        
        style.textColor = [UIColor whiteColor];
        
        style.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
        
        return style;
        
    }];
    
}

#pragma mark - <BMKLocationAuthDelegate>

/**集成百度地图
 *@brief 返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKLocationAuthErrorCode
 */
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError
{
    if (iError == BMKLocationAuthErrorSuccess)
    {
        
        NSString *str = [NSString stringWithFormat:@"授权成功-<%@>",BaiduMapAppKey];
        NSLog(@"%@",str);
    }
    else
    {
        NSLog(@"授权失败");
        NSString *errorStr = [NSString stringWithFormat:@"授权失败-%ld-<%@>",iError,BaiduMapAppKey];
        NSLog(@"%@",errorStr);
    }
}

#pragma mark - 监听网络状态

- (void)observeNetworkState
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    __weak typeof (self) weakSelf = self;
    Reachability * reach = [Reachability reachabilityWithHostname:SERVER_IP];
    reach.reachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{

            [weakSelf handleNetworkStatusChanged:[reachability isReachable]];
        });
    };

    reach.unreachableBlock = ^(Reachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{

            [weakSelf handleNetworkStatusChanged:[reachability isReachable]];
        });
    };

    [reach startNotifier];
}

- (void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    self.currentNetworkStatus = [reach currentReachabilityStatus];
    [self handleNetworkStatusChanged:[reach isReachable]];
}

- (void)handleNetworkStatusChanged:(BOOL)isReachable
{
    self.reachableNetwork = isReachable;

    if (self.messageDelegate &&  [self.messageDelegate respondsToSelector:@selector(networkStatusChanged:)])
    {
        [self.messageDelegate networkStatusChanged:isReachable];
    }
}

#pragma mark - 处理推送

/// 收到推送之后
- (void)handleRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];

    if ([[userInfo objectForKey:@"type"] isKindOfClass:[NSString class]])
    {
        notifyType = [userInfo objectForKey:@"type"];
    }
    else
    {
        notifyType = [[userInfo objectForKey:@"type"] stringValue];
    }

    NSInteger notifyTypeNum = [notifyType integerValue];
    if (notifyTypeNum == OfficeMsgNotify)
    {
        // 官方消息
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:YES] forKey:OfficalMessageRemind];
    }
    else if (notifyTypeNum == CustomerMsgNotify)
    {
        // 客源消息
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:YES] forKey:CustomerMessageRemind];
    }
    else if (notifyTypeNum == PropertyMsgNotify)
    {
        // 房源消息
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:YES] forKey:PropMessageRemind];
    }
    else if (notifyTypeNum == DealMsgNotify)
    {
        // 成交消息
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:YES] forKey:DealMessageRemind];
    }
    else if (notifyTypeNum == PrivateMsgNotify)
    {
        // 私信消息
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:YES] forKey:PrivateMessageRemind];
    }
    else if (notifyTypeNum == NewTakingSeeMsgNotify)
    {
        // 新增约看推送
        NSInteger appState = [UIApplication sharedApplication].applicationState;
        if (appState == UIApplicationStateActive)
        {
            // 程序在前台时不跳转
            return;
        }

        // 判断是否为登录状态
        BOOL isLoginSuccess = [[NSUserDefaults standardUserDefaults]boolForKey:UserLoginSuccess];
        NSTimeInterval  timeInterval = [_pauseDate timeIntervalSinceNow];

        if (isLoginSuccess)
        {
            // 登录
            TCNavigationController *nav1 = _tabBarController.selectedViewController;    // 当前选中的子视图
            NSArray *vcArr = nav1.viewControllers;
            if (vcArr.count > 0) {
                for (UIViewController *vc in vcArr)
                {
                    if ([vc isMemberOfClass:[CalendarStrokeVC class]])
                    {
                        [nav1 popToViewController:vc animated:YES];
                        return;
                    }
                }
            }

            [CommonMethod setUserdefaultWithValue:[NSNumber numberWithInt:YES] forKey:AddTakingSeeRemind];
            if (vcArr.count > 1)
            {
                [nav1 popToRootViewControllerAnimated:NO];
            }

            TCNavigationController *nav2 = [_tabBarController.viewControllers objectAtIndex:0];
            _tabBarController.selectedViewController = nav2;    // 跳转到首页

            [self deblockingSetting:timeInterval];

            [CommonMethod setUserdefaultWithValue:[NSNumber numberWithInt:NO] forKey:AddTakingSeeRemind];
            CalendarStrokeVC *calendarVc = [[CalendarStrokeVC alloc] init];
            [nav2 pushViewController:calendarVc animated:NO];
        }
        else
        {
            // 未登陆
            [CommonMethod setUserdefaultWithValue:[NSNumber numberWithInt:NO] forKey:AddTakingSeeRemind];
            self.window.rootViewController = _loginNav;
        }

        return;
    }
    else if (notifyTypeNum == CommonNotify)
    {
        NSNumber *loginNum = [CommonMethod getUserdefaultWithKey:UserLoginSuccess];
        if ([loginNum integerValue] == 0)
        {
            // 用户未登录
            return;
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"您的登录账号已被解绑，请重新登录！"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        alert.tag = CommonNotify;
        [alert show];
    }
    else if (notifyTypeNum == TransferKeyNotify)
    {
        // 转交钥匙成功（发送通知）
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Transfersucceed" object:nil];

    }
    else
    {
        NSString *pinStr = [NSString stringWithFormat:@"请更新最新版本!-%@",notifyType];
        showMsg(pinStr);
    }

    // 刷新页面，显示未读消息
    [[NSNotificationCenter defaultCenter] postNotificationName:UnreadNotification object:nil];
}

#pragma mark - 处理即将进入程序

- (void)appWillEnterForeground:(UIApplication *)application
{
    NSLog(@"应用重新进入...");
    if (self.notifyDelegate && [self.notifyDelegate respondsToSelector:@selector(appWillEnterForeground:)])
    {
        [self.notifyDelegate appWillEnterForeground:application];
    }

    NSTimeInterval  timeInterval = [_pauseDate timeIntervalSinceNow];

    // 判断是否为登录状态
    BOOL isLoginSuccess = [[NSUserDefaults standardUserDefaults]boolForKey:UserLoginSuccess];

    // 已登录
    if (isLoginSuccess){
        // 检查版本更新
//        CheckVersonUtils *checkVerson = [CheckVersonUtils shareCheckVersonUtils];
//        [checkVerson checkAppVerson];

        // 请求城市配置
//        HomeConfigUtils *homeConfig = [HomeConfigUtils shareHomeConfigUtils];
//        [homeConfig getHomeConfig];

        // 请求人脸采集
//        CheckFaceUtils *checkFace = [CheckFaceUtils sharedFaceUtils];
//        [checkFace checkFaceExists];

        [self deblockingSetting:timeInterval];
    }
}

// 解锁方式
- (void)deblockingSetting:(CGFloat)timeInterval
{
    PopupType popupType = [self selectUnlockType:timeInterval];
    switch (popupType)
    {
        case G:
        {
            // 手势验证
            self.showFaceRecog = NO;
            [self validGestureView];
            return;
        }
            break;
        case P:
        {
            // 密码验证
            [self showInputPwd:NO];
            return;
        }
            break;
        case F:
        {
            // 人脸识别
            self.showFaceRecog = YES;
            [self validGestureView];
            return;
        }
            break;

        default:
            self.showFaceRecog = NO;
            break;
    }

}

- (PopupType)selectUnlockType:(float)timeInterval
{
    PopupType unlockType;
    if ([CityCodeVersion isTianJin])
    {
        unlockType = [self intervalFace:timeInterval];
    }
    else
    {
        unlockType = [self intervalPwd:timeInterval];
    }

    return unlockType;
}

- (PopupType)intervalFace:(float)timeInterval
{
    // 手势密码验证
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *timeSpan = [userDefault objectForKey:AutoGestureLockTimeSpan];
    float g = [timeSpan intValue] * 60;
    LoginType *gCls = [LoginType new];
    gCls.type = G;
    gCls.time = g;

    float f = [[CommonMethod getUserdefaultWithKey:@"FaceOption"] floatValue] * 60;
    LoginType *fCls = [LoginType new];
    fCls.type = F;
    fCls.time = f;

    if (fCls.time > 0)
    {
        if (fCls.time < gCls.time)
        {
            if (-timeInterval > gCls.time)
            {
                // 弹手势
                return G;
            }

            if (-timeInterval>fCls.time)
            {
                // 弹人脸
                return F;
            }
        }
        else
        {
            if (-timeInterval > fCls.time)
            {
                // 弹手势
                return F;
            }

            if (-timeInterval>gCls.time)
            {
                // 弹手势
                return G;
            }
        }
    }
    else
    {
        if (-timeInterval > gCls.time)
        {
            // 手势
            return G;
        }
    }
    return N;
}

- (PopupType)intervalPwd:(float)timeInterval
{
    // 手势密码验证
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *timeSpan = [userDefault objectForKey:AutoGestureLockTimeSpan];
    float g = [timeSpan intValue] * 60;
    LoginType *gCls = [LoginType new];
    gCls.type = G;
    gCls.time = g;

    float p = 30 * 60;
    LoginType *pCls = [LoginType new];
    pCls.type = P;
    pCls.time = p;

    if (- timeInterval < pCls.time && -timeInterval > gCls.time)
    {
        // 手势
        return G;
    }

    if (- timeInterval > pCls.time)
    {
        return P;
    }

    return N;
}

@end
