//
//  AppDelegate.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/14.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "JMAdLoadingViewController.h"
#import "CalendarStrokeVC.h"


#import "CheckAppVersonUtil.h"
#import "RCIMUserDataSource.h"
#import "NotificationNameDefine.h"
#import <AdSupport/AdSupport.h>
#import "LogOffUtil.h"
#import "ManageAccountLockStatusApi.h"
#import "StaffTurnOverEntity.h"
#import "StaffTurnEntity.h"
#import "StaffTurnOverApi.h"
#import "SimApiDomainUtil.h"
#import "HomeConfigUtils.h"
#import "FormalApiDomainUtil.h"
#import "CheckPermissionUtils.h"

#import "CheckFaceUtils.h"
#import "AppDelegate+APPConfig.h"

//陈行添加，处理sqlite3使用
#import "SQLiteManager.h"


#define FaceRecogAlertTag   100000

/**
 *  获取异常崩溃信息
 */
void UncaughtExceptionHandler(NSException *exception) {
    
    //    NSArray *callStack = [exception callStackSymbols];
    //    NSString *reason = [exception reason];
    //    NSString *name = [exception name];
    //    NSString *content = [NSString stringWithFormat:@"========异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[callStack componentsJoinedByString:@"\n"]];
    //    /**
    //     *  把异常崩溃信息发送至开发者邮件
    //     */
    //    NSMutableString *mailUrl = [NSMutableString string];
    //    [mailUrl appendString:@"mailto:"];
    //    [mailUrl appendString:@"?subject=程序异常崩溃，请配合发送异常报告，谢谢合作！"];
    //    [mailUrl appendFormat:@"&body=%@", content];    // 打开地址
    //    NSString *mailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailPath]];
}

@interface AppDelegate ()<AlertInputPwdViewDelegate,ResponseDelegate,UIAlertViewDelegate,BMKGeneralDelegate, BMKLocationAuthDelegate>
{
    UIWindow *_adLondingWindow;
    UIWindow *_mainWindow;
    UIViewController *jumpBaseVC;
    
    UIView *_shadowView;
    
    BOOL isResetGesture;
    BOOL _isPwdShow;                                    // 密码框是否显示
    
    //    AdLoadingViewController *_adLoadingViewController;  // 获取系统参数vc
    DataBaseOperation * _dataOperation;
    CLLockVC *_clLockVC;
    RequestManager *_manager;
    DataBaseOperation *_dataBaseOperation;              // 数据库操作类
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     _manager = [RequestManager initManagerWithDelegate:self];
    //检查数据库
    [SQLiteManager checkAndUpdateDatabaseVersion];
    
    // 创建数据库
    _dataOperation = [DataBaseOperation sharedataBaseOperation];
    [_dataOperation createDataBaseMethod];
    
    // 首次安装App
    [self firstInstallSetting];
    
    // 检查用户版本，存储首次安装的配置
    [CheckAppVersonUtil checkVersonMethod];
    
    // 检查是否需要登陆
    [self appLaunchRoot];
    
    // 添加启动页动画
    [self addAdLondingView];
    
    // 第三方配置相关
    [self thirdPartySetting:launchOptions];
    
    // 创建网络监听
    [self observeNetworkState];
    
    //基本View设置
    [self defaultSettingView];
    
    // 捕获崩溃日志
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    
    return YES;
}

#pragma mark - AppLaunchRoot

- (void)appLaunchRoot
{
#warning 测试：ApiDomainUtil
    [BaseApiDomainUtil shareApiDomain:[ApiDomainUtil class]];
    
#warning SIM：SimApiDomainUtil
    //        [BaseApiDomainUtil shareApiDomain:[SimApiDomainUtil class]];
    
#warning 正式: FormalApiDomainUtil
    //        [BaseApiDomainUtil shareApiDomain:[FormalApiDomainUtil class]];
    
    [self createLoginNav];
    
    _isForceUnLock = NO;
    
    BOOL isUserLogin = [[NSUserDefaults standardUserDefaults] boolForKey:UserLoginSuccess];
    
    if (isUserLogin)
    {
        _tabBarController = [[TCRaisedCenterTabBarController alloc] init];
        self.window.rootViewController = _tabBarController;
    }
    else
    {
        self.window.rootViewController = _loginNav;
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // 监听用户是否登录成功，用来处理登录成功后首页的数据加载
    [[NSUserDefaults standardUserDefaults] addObserver:_tabBarController
                                            forKeyPath:@"UserLoginSuccess"
                                               options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                               context:nil];
}

#pragma mark - AddViewOnWindow
- (void)addAdLondingView{
    
    
    
    _adLondingWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    __block typeof(self) weakSelf = self;
    
    JMAdLoadingViewController * con = [[JMAdLoadingViewController alloc] init];
    
    [con setCanCloseBlock:^{
        
        [weakSelf getSysParamSuccessed];
        
    }];
    
    _adLondingWindow.rootViewController = con;
    _adLondingWindow.windowLevel = UIWindowLevelStatusBar + 1;
    
    [_adLondingWindow makeKeyAndVisible];
    
    
}

- (void)hiddenLDWindow
{
    __weak UIWindow *weakAdWindow = _adLondingWindow;
    
    [UIView animateWithDuration:0.8 animations:^{
        weakAdWindow.alpha = 0;
    } completion:^(BOOL finished){
        [weakAdWindow removeFromSuperview];
    }];
}

#pragma mark - ApplicationLiftCycle

/// 处理微信的系统回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([Growing handleUrl:url]||[UMSocialSnsService handleOpenURL:url])
    {
        return YES;
    }
    
    return NO;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // 注册远程通知
    [application registerForRemoteNotifications];
}

// 获取苹果推送权限成功。
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
    BOOL showChatItem = [[NSUserDefaults standardUserDefaults] boolForKey:ShowChatIcon];
    
    if (showChatItem)
    {
        NSString *token = [[[[deviceToken description]
                             stringByReplacingOccurrencesOfString:@"<" withString:@""]
                            stringByReplacingOccurrencesOfString:@">" withString:@""]
                           stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        /**
         * 设置DeviceToken，请在连接之前调用，否则无法上传token
         * @param deviceToken 从苹果服务器获取的设备唯一标识
         */
        //        [[RCIMClient sharedRCIMClient] setDeviceToken:token];
        
        //        [self setUploadTokenSuccess:YES];
    }
    
    // 注册极光推送
    [JPUSHService registerDeviceToken:deviceToken];
    NSLog(@"设备Token : %@",deviceToken);
    
    // 注册极光推送别名
    BOOL isUserLogin = [[NSUserDefaults standardUserDefaults]boolForKey:UserLoginSuccess];
    
    if (isUserLogin)
    {
        NSString *userCityCode = [[NSUserDefaults standardUserDefaults]stringForKey:CityCode];
        NSString *staffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
        
        NSString *pushAlias = [[NSString stringWithFormat:@"%@_%@", userCityCode, staffNo] lowercaseString];
        NSString *pushTag = [NSString stringWithFormat:@"%@_ios",userCityCode];
        
        NSString *log = [NSString stringWithFormat:@"CityCode:%@====StaffNO:%@====PushAlias:%@====PushTag:%@",userCityCode,staffNo,pushAlias,pushTag];
        NSLog(@"%@",log);
        
        /**
         *  极光推送需要注册别名和标签两种推送：
         
         1、别名用来针对某一个人来推送
         2、标签是用来发布当前城市下所有的用户
         *
         */
        [JPUSHService setTags:[NSSet setWithObjects:pushTag, nil]
                        alias:pushAlias
             callbackSelector:nil
                       object:nil];
    }
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
    
    // 收到推送之后的处理
    [self handleRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    _pauseDate = [[NSDate alloc]init];
    //    NSLog(@"可能来电话了...");
    if (_notifyDelegate && [_notifyDelegate respondsToSelector:@selector(appDidEnterBackground:)])
    {
        [_notifyDelegate appDidEnterBackground:application];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"应用被打断...");
    if (_notifyDelegate && [_notifyDelegate respondsToSelector:@selector(appDidEnterBackground:)])
    {
        [_notifyDelegate appDidEnterBackground:application];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    if ([notifyType isEqualToString:@"999"])
    {
        return;
    }
    
    isResetGesture = NO;
    
    [self appWillEnterForeground:application];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if (_notifyDelegate && [_notifyDelegate respondsToSelector:@selector(appWillEnterForeground:)])
    {
        [_notifyDelegate appWillEnterForeground:application];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

#pragma mark - AboutGesture

- (void)validGestureView
{
    BOOL hasPwd = [CLLockVC hasPwd];
    isResetGesture = NO;
    
    if(!hasPwd)
    {
        NSLog(@"你还没有设置密码，请先设置密码");
    }
    else
    {
        if (_isPwdShow)
        {
            return;
        }
        
        BOOL isOn = [[CommonMethod getUserdefaultWithKey:FaceRecogSwitch] boolValue];
        
        // 手势密码
        [self showGestureView];
    }
}

- (void)showGestureView
{
    NSLog(@"%@",self.window.rootViewController);
    
    _clLockVC = [CLLockVC showVerifyLockVCInVC:self.window.rootViewController forgetPwdBlock:^(CLLockVC *lockVC) {
        isResetGesture = YES;
        [self showInputPwd:YES];
        
        
    } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
        
        [_shadowView removeFromSuperview];
        _shadowView = nil;
        NSLog(@"密码正确");
        [AlertInputPwdView resetErrorTimes];
        [lockVC dismiss:0.2f];
        _clLockVC = nil;
        
        // 判断人员异动
        CheckPermissionUtils *checkPermission = [CheckPermissionUtils sharedCheckPermissionUtils];
        [checkPermission checkUserPermission];
        
    } errorLimit:DefaultErrorTimes achieveErrorLimitBlock:^(CLLockVC *lockVC) {
        [_shadowView removeFromSuperview];
        _shadowView = nil;
        [self showInputPwd:NO];
        isResetGesture = YES;
    }];
    
    UIView * view = [self.window.subviews firstObject];
    
    [self.window bringSubviewToFront:view];
    
}

- (void)setGestureView
{
    BOOL hasPwd = [CLLockVC hasPwd];
    
    if (hasPwd)
    {
        return;
    }
    
    if (_clLockVC)
    {
        jumpBaseVC = _clLockVC;
    }
    else
    {
        jumpBaseVC = self.window.rootViewController;
    }
    
    [CLLockVC showSettingLockVCInVC:jumpBaseVC successBlock:^(CLLockVC *lockVC, NSString *pwd) {
        
        NSLog(@"密码设置成功");
        [lockVC dismissNow];
        
        // 设置手势密码倒计时时间间隔默认为一分钟
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        if(![userDefault objectForKey:AutoGestureLockTimeSpan])
        {
            [CommonMethod setUserdefaultWithValue:@"1" forKey:AutoGestureLockTimeSpan];
        }
        
        [AlertInputPwdView resetErrorTimes];
        // 验证手势密码
        if (_clLockVC)
        {
            [_clLockVC resetValidPwd];
        }
        // 请求系统参数
        [[NSNotificationCenter defaultCenter] postNotificationName:RequestSystemParamNotification object:nil];
    }
                     isShowNavClose:NO];
}

- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    
    if (topVC.presentedViewController)
    {
        topVC = topVC.presentedViewController;
    }
    
    return topVC;
}

- (void)showInputPwd:(BOOL)isShowColse
{
    _mainWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AlertInputPwdView" owner:nil options:nil];
    
    AlertInputPwdView *customView = [array firstObject];
    customView.delegate = self;
    [customView showClose:isShowColse];
    _isPwdShow = YES;
    customView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);
    [_mainWindow makeKeyAndVisible];
    [_mainWindow addSubview:customView];
}

- (void)validSuc
{
    if (isResetGesture)
    {
        if (_clLockVC)
        {
            // 清空手势密码
            [CLLockVC clearCoreLockPWDKey];
        }
        // 设置新的手势密码
        [self setGestureView];
    }
    else
    {
        [_clLockVC dismissNow];
    }
    
    if (_isPwdShow) {
        _isPwdShow = NO;
    }
    
    // 判断人员异动
    CheckPermissionUtils *checkPermission = [CheckPermissionUtils sharedCheckPermissionUtils];
    [checkPermission checkUserPermission];
}

- (void)locked
{
    if(_clLockVC)
    {
        [_clLockVC userInteractionDisEnabled];
    }
}



- (void)changeVerifyType:(NSNotification *)noti
{
    if ([noti.object isEqualToString:@"Face"])
    {
//        [self showFaceRecogVC];
    }
    else if([noti.object isEqualToString:@"Gesture"])
    {
        [self showGestureView];
    }
}

- (void)faceRecogSuccess
{
    [_shadowView removeFromSuperview];
    // 刷脸成功
    NSLog(@"密码正确");
    [AlertInputPwdView resetErrorTimes];
    _clLockVC = nil;
    
    // 判断人员异动
    CheckPermissionUtils *checkPermission = [CheckPermissionUtils sharedCheckPermissionUtils];
    [checkPermission checkUserPermission];
}

#pragma mark - PrivateMethod

///// 捕获崩溃日志
//void UncaughtExceptionHandler(NSException *exception)
//{
//
//    NSArray *arr = [exception callStackSymbols];    // 得到当前调用栈信息
//    NSString *reason = [exception reason];          // 非常重要，就是崩溃的原因
//    NSString *name = [exception name];              // 异常类型
//    NSLog(@"====================================================================== \n 异常类型 : %@ \n 崩溃原因 : %@ \n 堆栈信息 : %@\n====================================================================== \n"
//          ,name, reason, arr);
//}

/// 创建登录vc
- (void)createLoginNav
{
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    _loginNav = [[CustomPanNavgationController alloc] initWithRootViewController:loginVC];
    
    [_loginNav.navigationBar setTintColor:[UIColor whiteColor]];
}

/// 是否弹出登陆页面
- (void)changeDiscoverRootVCIsLogin:(BOOL)isLogin
{
    if (isLogin)
    {
        [self createLoginNav];
        self.window.rootViewController = _loginNav;
    }
    else
    {
//        if ([CityCodeVersion isTianJin]) {
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(changeVerifyType:)
//                                                         name:ChangeVerifyType
//                                                       object:nil];
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(faceRecogSuccess)
//                                                         name:FaceRecogSuccess
//                                                       object:nil];
//        }
    
        if(!_tabBarController)
        {
            _tabBarController = [[TCRaisedCenterTabBarController alloc] init];
        }
        
        self.window.rootViewController = _tabBarController;
        
        // 从新调用set方法，是为了触发首页的监听，好做登录完成后的处理
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:YES]
                                       forKey:UserLoginSuccess];
        
        [CommonMethod registPushWithState:YES];
        
        // 判断跟上次登录用户是否一样
        NSString *lastUserName = [CommonMethod getUserdefaultWithKey:LastStaffNo];
        NSString *userName = [CommonMethod getUserdefaultWithKey:UserStaffNumber];
        
        NSString *cityCode = [CommonMethod getUserdefaultWithKey:CityCode];
        NSString *lastCityCode = [CommonMethod getUserdefaultWithKey:LastStaffCityCode];
        
        if (![lastUserName isEqualToString:userName])
        {
            // 清空手势密码
            [CLLockVC clearCoreLockPWDKey];
            // 设置手势密码
            [self setGestureView];
        }
        
        if (![cityCode isEqualToString:lastCityCode])
        {
            // 切换城市城市
            // 清空搜索历史
            _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
            [_dataBaseOperation deleteSearchResultWithType:PropListSearchType];
            [_dataBaseOperation deleteSearchResultWithType:TrustAuditingSearchType];
            [_dataBaseOperation deleteAllFilterCondition];
            [CommonMethod setUserdefaultWithValue:nil forKey:NameString];
            [CommonMethod setUserdefaultWithValue:nil forKey:KeyWord];
        }
    }
}

/// 收到推送时输入手势密码框消失后
- (void)inputDismissNotification:(NSNotification *)notifi
{
    NSInteger intNum = [[CommonMethod getUserdefaultWithKey:AddTakingSeeRemind] integerValue];
    if (intNum == 1 && [notifyType isEqualToString:@"240"])
    {
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithInt:NO] forKey:AddTakingSeeRemind];
        CalendarStrokeVC *calendarVc = [[CalendarStrokeVC alloc] init];
        [_tabBarController.selectedViewController pushViewController:calendarVc animated:NO];
    }
}

- (void)defaultSettingView{
    
    [[UITextField appearance] setTintColor:rgba(0, 122, 255, 1)];
    [[UITextView appearance] setTintColor:rgba(0, 122, 255, 1)];
    [[UISearchBar appearance] setTintColor:rgba(0, 122, 255, 1)];
    [[UITableView appearance] setSeparatorColor:YCOtherColorDivider];
}

#pragma mark - <AdLoadingDelegate>

- (void)getSysParamSuccessed
{
    BOOL isLoginSuccess = [[NSUserDefaults standardUserDefaults]boolForKey:UserLoginSuccess];
    
    [self hiddenLDWindow];
    
    if (!isLoginSuccess)
    {
        [self createLoginNav];
        
        self.window.rootViewController = _loginNav;
        [self.window makeKeyAndVisible];
    }
    else
    {
        [self.window makeKeyAndVisible];
        [CommonMethod registPushWithState:YES];
        
        // 从新调用set方法，是为了触发首页的监听，好做登录完成后的处理
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:YES] forKey:UserLoginSuccess];
        
        // 验证手势密码是否存在
        BOOL hasPwd = [CLLockVC hasPwd];
        if (hasPwd)
        {
            // 验证手势密码
            [self validGestureView];
        }
        else
        {
            // 设置手势密码
            [self setGestureView];
        }
        
        // 检查是否倒计时锁定
        BOOL forceLock = [AlertInputPwdView isForceLock];
        if(_isForceUnLock)
        {
            // 不需要倒计时
            forceLock = NO;
            
            // 改变错误次数
            NSString *ErrorTimesString = [NSString stringWithFormat:@"%d",DefaultErrorTimes];
            [CommonMethod setUserdefaultWithValue:ErrorTimesString forKey:ErrorTimes];
            
            // 改变错误时间
            [CommonMethod setUserdefaultWithValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"APlusPwdErrorTime"];
            
            // 设置手势密码
            [self setGestureView];
            
            // 恢复服务器
            ManageAccountLockStatusApi *manageAccountLockStatusApi = [[ManageAccountLockStatusApi alloc] init];
            manageAccountLockStatusApi.ManageAccountLockStatusType = ResetAccountLockStatus;
            [_manager sendRequest:manageAccountLockStatusApi];
            return;
        }
        
        if(forceLock)
        {
            [self showInputPwd:NO];
        }
    }
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999)
    {
        [LogOffUtil clearUserInfoFromLocal];
        [self changeDiscoverRootVCIsLogin:YES];
        return;
    }
    
    if (alertView.tag == FaceRecogAlertTag)
    {
        if (buttonIndex == 0)
        {
            // 跳转到"我的"页面
            if (_tabBarController)
            {
                TCNavigationController *nav4 = [_tabBarController.viewControllers objectAtIndex:3];
                _tabBarController.selectedViewController = nav4;    // 跳转到我的
            }
        }
        return;
    }
    
    StaffTurnOverEntity *entity = [DataConvert convertDic:_jsonDic toEntity:[StaffTurnOverEntity class]];
    StaffTurnOverApi *staffTurnOverApi = [[StaffTurnOverApi alloc] init];
    staffTurnOverApi.keyId = entity.keyId;
    staffTurnOverApi.employeeKeyId = entity.employeeKeyId;
    staffTurnOverApi.employeeName = entity.employeeName;
    staffTurnOverApi.employeeDeptKeyId = entity.employeeDeptKeyId;
    staffTurnOverApi.employeeDeptName = entity.employeeDeptName;
    staffTurnOverApi.operationType = @"0";
    [_manager sendRequest:staffTurnOverApi];
}

#pragma mark - <ResponseDelegate>

/// 响应成功
- (void)respSuc:(id)data andRespClass:(id)cls
{
    if ([cls isEqual:[StaffTurnEntity class]])
    {
        [LogOffUtil clearUserInfoFromLocal];
        [self changeDiscoverRootVCIsLogin:YES];
        _haveAlert = NO;
    }
}

/// 响应失败
- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    
}

@end
