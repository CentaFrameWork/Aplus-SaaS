//
//  AppDelegate.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/14.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//  com.centanet.newprop.panketong   com.centanet.facecollect  com.centaline.yuancui

#import <UIKit/UIKit.h>
#import "TCRaisedCenterTabBarController.h"
#import "TCNavigationController.h"
#import "CustomPanNavgationController.h"
#import "Reachability.h"
#import "CLLockVC.h"
#import "AllRoundFilterCustomView.h"
#import "CoreLockConst.h"
#import "AlertInputPwdView.h"


#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BMKLocationkit/BMKLocationAuth.h>
enum RemoteNotifyEnum {
    OfficeMsgNotify = 100,      // 官方消息
    CustomerMsgNotify = 200,    // 客源消息
    PropertyMsgNotify = 210,    // 房源消息
    DealMsgNotify = 220,        // 成交消息
    PrivateMsgNotify = 230,     // 私信
    NewTakingSeeMsgNotify = 240,// 新增约看
    TransferKeyNotify = 260,    // 转交钥匙
    CommonNotify = 999,         // 人员异动
};

typedef enum : NSUInteger {
    N = 0,  // 不弹
    G = 1,  // 手势
    P = 2,  // 密码
    F = 3,  // 人脸
} PopupType;

@protocol MessageChangeDelegate <NSObject>

@optional
- (void)networkStatusChanged:(BOOL)isReachable;
- (void)loadAnimationSuccess;
@end

@protocol AppLifeCycleDelegate <NSObject>
- (void)appDidEnterBackground:(UIApplication *)application;
- (void)appWillEnterForeground:(UIApplication *)application;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *_LDWindow;
    TCRaisedCenterTabBarController *_tabBarController;
    BMKMapManager *_mapManager; // 设置地图引擎
    NSString *notifyType;       // 推送消息类型
    NSDate *_pauseDate;         // 暂停时间
    CustomPanNavgationController *_loginNav;
    NSDictionary *_jsonDic;
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) id <MessageChangeDelegate> messageDelegate;
@property (nonatomic, assign) id <AppLifeCycleDelegate> notifyDelegate;
@property (nonatomic, assign) BOOL isForceUnLock;

/// 网络连接成功
@property (nonatomic, assign) BOOL reachableNetwork;
/// 上传token到融云服务器是否成功
@property (nonatomic, assign) BOOL uploadTokenSuccess;
/// 当前网络连接状态
@property (nonatomic,assign) NetworkStatus currentNetworkStatus;
/// 隐藏链接
@property (nonatomic, copy) NSString *infoUrl;
@property (nonatomic, copy) NSString *hideDescription;
@property (nonatomic, copy) NSString *hideTitle;
/// 是否已经弹出人员异动提醒
@property (nonatomic,assign)BOOL haveAlert;
@property (nonatomic, assign) BOOL showFaceRecog;
/// 上次请求新上房源时间
@property (nonatomic, strong) NSDate *lastRequestNewPropTime;

/// 登录完成后切换rootvc
- (void)changeDiscoverRootVCIsLogin:(BOOL)isLogin;

/// 手势密码相关
- (void)validGestureView;
- (void)showInputPwd:(BOOL)isShowColse;

/**
 
 
 
 [请求地址：http://10.1.30.119:29263//api/permission/user-info?staffNo=Ceshi1&cityCode=M02123434]
 
 [请求地址：http://10.1.30.119:29263//api/permission/update-parameter]
 
 
 
 [请求地址：http://10.1.30.119:29263//api/property/war-zone]
 
 
 [请求地址：https://jmssoapi.yuan-cui.com/api/AppConfigRelation?location=Home_Event]
 [请求地址：https://jmssoapi.yuan-cui.com/api/AppConfigRelation?location=Home_More]
 [请求地址：https://jmssoapi.yuan-cui.com/api/AppVersion?]
 
 
 [请求地址：https://jmssoapi.yuan-cui.com/api/AccountLock?Mobile=13121799148]
 
 
 */
@end

