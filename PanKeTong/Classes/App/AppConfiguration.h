//
//  AppConfiguration.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#ifndef PanKeTong_AppConfiguration_h
#define PanKeTong_AppConfiguration_h

#warning A Online Warn 上线前注意事项
/**
 *  1、检查所有第三方SDK的 appkey/id 是否修改为正式：百度统计
 *  2、JPush的plist文件中的id修改为正式
 *  3、所有接口地址修改为正式的
 *  4、修改百度统计策略
 *  5、百度地图bundle id修改
 *  6、修改请求超时时间
 *  7、修改APP更新版本号
 *
 */


#pragma mark - <Device information>
#define MODEL_NAME                      [[UIDevice currentDevice] model]
#define MODEL_VERSION                   [[[UIDevice currentDevice] systemVersion] floatValue]

/* iOS设备 */
#define kDevice_Is_iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6PlusBigMode ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen]currentMode].size) : NO)

#pragma mark -  iphone X 适配相关
/// 是否是iPhone X
#define IS_iPhone_X             ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size)) : NO)
//像素点，显示1像素的大小
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
/// 电池条高度
#define STATUS_BAR_HEIGHT       (IS_iPhone_X ? 44 : 20)
/// 底部安全区域高度
#define BOTTOM_SAFE_HEIGHT      (IS_iPhone_X ? 34 : 0)
/// 导航栏高度
#define APP_NAV_HEIGHT          (IS_iPhone_X ? 88 : 64)
/// 标签栏高度
#define APP_TAR_HEIGHT          (IS_iPhone_X ? 83 : 49)
#define APP_SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
#define APP_SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)
#define APP_SCREENSafeAreaHeight        (APP_SCREEN_HEIGHT - BOTTOM_SAFE_HEIGHT)
#define APP_Height_Bottom               (APP_SCREEN_HEIGHT - BOTTOM_SAFE_HEIGHT-APP_NAV_HEIGHT)
#define MainScreenBounds                [UIScreen mainScreen].bounds

#define ratio2                   (APP_SCREEN_WIDTH/750.0)
#define NewRatio                   (APP_SCREEN_WIDTH/375.0)
#define WIDTH_SCALE2 ([UIScreen mainScreen].bounds.size.width/375)
#define HeightRatio                   (APP_SCREEN_HEIGHT/667.0)
#define WIDTH_UI_DESIGN_SCREEN 375.0
#define HEIGHT_UI_DESIGN_SCREEN 667.0


#define showMsg(msg) \
{UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];\
[alertView show];}

#define showJDStatusStyleErrorMsg(msg) \
{[JDStatusBarNotification showWithStatus:msg dismissAfter:2 styleName:FINAL_JD_STATUS_BAR_NOTIFICATION_ERROR];}

#define showJDStatusStyleSuccMsg(msg) \
{[JDStatusBarNotification showWithStatus:msg dismissAfter:2 styleName:FINAL_JD_STATUS_BAR_NOTIFICATION_SUCC];}

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define StrongSelf(strongSelf) __strong __typeof(&*self) strongSelf = weakSelf;
#define kWeakSelf __weak typeof(self) weakSelf = self;

#pragma mark - UIApplication
#define KeyWindow [UIApplication sharedApplication].keyWindow
#define JMWindow [[[UIApplication sharedApplication] delegate] window]
#pragma mark - <TextColor>


#define UIColorFromHex(hex,alp)  [UIColor colorWithRed:(((hex & 0xFF0000) >> 16))/255.0 green:(((hex &0xFF00) >>8))/255.0 blue:((hex &0xFF))/255.0 alpha:alp]

#define APP_BACKGROUND_COLOR                [UIColor colorWithRed:246.0 / 255.0 green:245.0 / 255.0 blue:241.0 / 255.0 alpha:1.0f]
#define LOGIN_NAV_BAR_COLOR                 [UIColor colorWithRed:220.0 / 255.0 green:93.0 / 255.0 blue:73.0 / 255.0 alpha:1.0f]
#define COMMIT_BTN_COLOR                    [UIColor colorWithRed:223.0 / 255.0 green:48.0 / 255.0 blue:49.0 / 255.0 alpha:1.0f]
#define COMFIRM_BTN_COLOR                   [UIColor colorWithRed:216.0 / 255.0 green:77.0 / 255.0 blue:55.0 / 255.0 alpha:1.0f]
#define YOUHUI_CONTACTESTATE_BTN_COLOR      [UIColor colorWithRed:100.0 / 255.0 green:183.0 / 255.0 blue:228.0 / 255.0 alpha:1.0f]
#define MY_SIGN_UP_BTN_COLOR                [UIColor colorWithRed:255.0 / 255.0 green:80.0 / 255.0 blue:39.0 / 255.0 alpha:1.0f]
#define ORANGE_COLOR                        [UIColor colorWithRed:255.0 / 255.0 green:159.0 / 255.0 blue:12.0 / 255.0 alpha:1.0f]
#define GREEN_COLOR                         [UIColor colorWithRed:70.0 / 255.0 green:180.0 / 255.0 blue:65.0 / 255.0 alpha:1.0f]
#define RED_COLOR                           [UIColor colorWithRed:254.0 / 255.0 green:61.0 / 255.0 blue:29.0 / 255.0 alpha:1.0f]

#define LITTLE_BLACK_COLOR                  [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0f]
#define LITTLE_GRAY_COLOR                   [UIColor colorWithRed:102.0 / 255.0 green:102.0 / 255.0 blue:102.0 / 255.0 alpha:1.0f]
#define LITTLE_LIGHTGRAY_COLOR              [UIColor colorWithRed:199.0 / 255.0 green:199.0 / 255.0 blue:205.0 / 255.0 alpha:1.0f]
#define LIST_HEADER_COLOR                   [UIColor colorWithRed:234.0/255 green:234.0/255 blue:234.0/255 alpha:1]
#define ERSHOUEST_ICON_SELECT_COLOR         [UIColor colorWithRed:85.0/255 green:190.0/255 blue:231.0/255 alpha:1]
#define REGETCODESIGN_GREEN_COLOR           [UIColor colorWithRed:97.0/255.0 green:173.0/255.0 blue:46.0/255.0 alpha:1.0]
#define LITTLE_BLUE_COLOR                   [UIColor colorWithRed:92.0/255.0 green:199.0/255.0 blue:226.0/255.0 alpha:1.0]
#define LABEL_LITTLEGRAY_COLOR                   [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]
#define CHOOSEBTN_BACKGROUND_COLOR          [UIColor colorWithRed:238.0 / 255.0 green:118.0 / 255.0 blue:86.0 / 255.0 alpha:1.0f]
#define ShadowBackgroundColor               [UIColor colorWithRed:0.0 / 255.0 green:0.0 / 255.0 blue:0.0 / 255.0 alpha:0.5f]

//#define MainRedColor                        [UIColor colorWithRed:255.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0f]
#define MainGrayFontColor                   [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0f]
#define SeparateLineColor                   [UIColor colorWithRed:238.0 / 255.0 green:238.0 / 255.0 blue:238.0 / 255.0 alpha:1.0f]

// RGB颜色
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define UICOLOR_RGB_Alpha(_color,_alpha) [UIColor colorWithRed:((_color>>16)&0xff)/255.0f green:((_color>>8)&0xff)/255.0f blue:(_color&0xff)/255.0f alpha:_alpha]

#define AMapAPI            @"cfcd1e37ab05b79e13b3f8666d01570d"


#warning 颜色 以原翠拼音首字母开头👇👇👇👇👇👇
// 见Color.rtfd文件
// 主题颜色
#define  YCThemeColorGreen          UICOLOR_RGB_Alpha(0xff0000,1.0)  //（37 , 167, 99 , 1.0）主色调绿色
#define  YCThemeColorGreenTrans     UICOLOR_RGB_Alpha(0x25A763, 0.65)  //（37 , 167, 99 , 0.65）主色调绿色半透明，手势选中用
#define  YCThemeColorOrange         UICOLOR_RGB_Alpha(0xE58909,1.0)  //（229, 137, 9  , 1.0）辅助橙色
#define  YCThemeColorRed            UICOLOR_RGB_Alpha(0xE65F5F,1.0)  //（230, 95 , 95 , 1.0）辅助红色
#define  YCThemeColorBackground     UICOLOR_RGB_Alpha(0xF4F4F4,1.0)  //（244, 244, 244, 1.0）背景色
#define  YCThemeColorAuxiliary      UICOLOR_RGB_Alpha(0x000000,0.6)  //（0  , 0  , 0  , 0.6）辅助背景

// 文字颜色
#define  YCTextColorBlack           UICOLOR_RGB_Alpha(0x333333,1.0)  //（51 , 51 , 51 , 1.0）主标题文字
#define  YCTextColorGray            UICOLOR_RGB_Alpha(0x666666,1.0)  //（102, 102, 102, 1.0）副标题/正文
#define  YCTextColorAuxiliary       UICOLOR_RGB_Alpha(0x999999,1.0)  //（153, 153, 153, 1.0）辅助文字
#define  YCTextColorRed             UICOLOR_RGB_Alpha(0xE65F5F,1.0)  //（230, 95 , 95 , 1.0）错误提示文字
#define  YCTextColorSaleRed         UICOLOR_RGB_Alpha(0xE65F5F,1.0)  //（230, 95 , 95 , 1.0）售-文字
#define  YCTextColorRentOrange      UICOLOR_RGB_Alpha(0xE58909,1.0)  //（229, 137, 9  , 1.0）租-文字
#define  YCTextColorSelect          UICOLOR_RGB_Alpha(0x25A763,1.0)  //（229, 137, 9  , 1.0）选中状态文字颜色单选
#define YCTextColorMoreSelect       UICOLOR_RGB_Alpha(0xE58909,1.0)  //（229, 137, 9  , 1.0）选中状态文字颜色多选
#define  YCTextColorRoomRBlue       UICOLOR_RGB_Alpha(0x4A90E2,1.0)  //（74 , 144, 226, 1.0）房型-文字


// 其他颜色
#define  YCOtherColorBackground     UICOLOR_RGB_Alpha(0xF3F4F9,1.0)  //（243, 244, 249, 1.0）输入框背景色
#define  YCOtherColorBorder         UICOLOR_RGB_Alpha(0xECECEC,1.0)  //（236, 236, 236, 1.0）边框颜色
#define  YCOtherColorSelectBorder   UICOLOR_RGB_Alpha(0xE58909,1.0)  //（229, 137, 9  , 1.0）选中边框颜色
#define  YCOtherColorDivider        UICOLOR_RGB_Alpha(0xECECEC,1.0)  //（236, 236, 236, 1.0）分割线颜色
#define YCTranslucentBGColor        UICOLOR_RGB_Alpha(0x000000,0.3)  //（0, 0, 0, 1.0）半透明背景颜色

// 按钮颜色
#define  YCButtonColorGreen         UICOLOR_RGB_Alpha(0x25A763,1.0)  //（37 , 167, 99 , 1.0）绿色按钮
#define  YCButtonColorOrange        UICOLOR_RGB_Alpha(0xE58909,1.0)  //（229, 137, 9  , 1.0）橙色按钮
#define  YCButtonColorRed           UICOLOR_RGB_Alpha(0xE65F5F,1.0)  //（230, 95 , 95 , 1.0）红色按钮

//背景色
#define  YCHeaderViewBGColor        UICOLOR_RGB_Alpha(0xDCDCDC,1.0)  //（220, 220 , 220 , 1.0）已完成行程左侧背景色
#define  YCTextBGColor              UICOLOR_RGB_Alpha(0xF3F4F9,1.0)  //（243, 244 , 249 , 1.0）文字背景颜色
#define YCEntrustAttachmentBGColor  RGBColor(249, 250, 255) //备案上传附件背景颜色


#warning 颜色 以原翠拼音首字母开头👆👆👆👆👆👆

#define  YCAppMargin        12*NewRatio                              // 页边距
#define  YCLayerCornerRadius    5*NewRatio                           //切角大小





#define     SettingMicrophone   @"请在手机的“设置-隐私-麦克风”中，允许“移动A+”访问你的麦克风"
#define     SettingProjectName  @"移动A+"

#pragma mark - <SDK_AppKey/ID>
// 百度统计Appkey(正式)
#define BaiduMobStatAppKey              @"1074e750fd"
// 百度统计id(正式)
#define BaiduMobStatChannelId           @"enterprise"
// 百度统计id(测试)
#define BaiduMobStatChannelIdDev        @"dev"
// 百度地图appkey(正式)
#define BaiduMapAppKey                  @"M3MCopveqK0tejiIO78A9NwptcL2xYVp"

// 科大讯飞AppId
#define IFlySpeechAppId                 @"5b39e6e6"

// 友盟分享appkey
#define UMAppKey                        @"5b3c6bfca40fa31a5400003e"
// 微信分享appkey
#define WeixinAppKey                    @"wx850a9752f68624f2"
// 微信分享appSecret
#define WeixinAppSecret                 @"ede92b593f4cf3848e1df03d13958600"

// GrowingIO项目ID
#define GrowingIOKey                    @"9a29759503aafcbb"

// Bugly APPID
#define BuglyAppId                      @"6b84d686d1"
// Bugly APPKEY
#define BuglyAppKey                     @"0def0602-9787-4ef8-aacf-8ffd4de221b9"

#define RongCloudAppKey                 @"n19jmcy59f619"                            // 融云appkey(正式)
#define RongCloudAppSecret              @"178n2EQNgoipC"                            // 融云secret

#pragma mark - <FontName>
#define BoldFontName                    @"Helvetica-Bold"
#define FontName                        @"Helvetica"

#define BeijingInfoKey                  @"HiddenModule"                             // 北京资讯分享链接key


#pragma mark - <UserDefault_Key>
#define PersonalPushVC                  @"PersonalPushViewController"               // 个人中心跳转页面通知name
#define CustomHelpUrl                   @"CustomHelpUrl"                            // 客服帮助url
#define APlusDomainToken                @"AgencyDomainToken"                        // agency系统中的
#define HouseKeeperSession              @"HouseKeeperSession"                       // 移动A+API
#define UserLoginSuccess                @"UserLoginSuccess"                         // 用户是否登录成功
#define LastStaffNo                     @"LastUserStaffNumber"                      // 最后一次登录用户名
#define LastStaffCityCode               @"LasrUserCityCode"                         // 最后一次用户登录城市

#define ChangeVerifyType                @"ChangeVerifyType"                         // 切换解锁方式通知
#define FaceRecogSuccess                @"FaceRecogSuccess"                         // 人脸识别成功通知

// 搜索房源历史纪录
#define PropListSearchType              @"PropListSearchType"                       // 二手房搜索类型
#define TrustAuditingSearchType         @"TrustAuditingSearchType"                  // 委托审核搜索类型
#define PropCalendarSearchList          @"PropCalendarSearchList"                   // 日历行程搜索类型

#define PersonRemindType                @"PersonRemindType"                         // 提醒人类型：员工
#define DeparmentRemindType             @"DeparmentRemindType"                      // 提醒人类型：部门
#define RealSurveyPersonType            @"RealSurveyPersonType"                     // 实勘筛选：员工
#define RealSurveyDeparmentType         @"RealSurveyDeparmentType"                  // 实勘筛选：部门
#define CallRecordPersonType            @"CallRecordPersonType"                     // 通话记录筛选：员工
#define CallRecordDeparmentType         @"CallRecordDeparmentType"                  // 通话记录筛选：部门
#define CalendarPersonType              @"CalendarPersonType"                       // 日历筛选：员工
#define CalendarDeparmentType           @"CalendarDeparmentType"                    // 日历筛选：部门
#define TrustAuditingPersonType         @"TrustAuditingPersonType"                  // 委托审核筛选：员工
#define TrustAuditingDeparmentType      @"TrustAuditingDeparmentType"               // 委托审核筛选：部门
#define ClientFilterPersonType          @"ClientFilterPersonType"                   // 我的客户筛选：员工
#define ClientFilterDepartmentType      @"ClientFilterDepartmentType"               // 我的客户筛选：部门
#define RealSurveyAuditor               @"RealSurveyExaminePerson"                  // 实勘筛选 : 审核人
#define CheckRoomNumberLimitTimes       @"CheckRoomNumberLimitTimes"                // 查看房号的限制次数
#define CurrentAppVerson                @"CurAppVerson"                             // 当前APP版本
#define SaveDateTime                    @"SaveDateTime"                             // APP当前使用的时间（用来限制单日功能）
#define RongCloudUserToken              @"UserToken"                                // 融云token
#define ShowWelcomePage                 @"ShowWelcomePage"                          // 欢迎页
#define ShowChatIcon                    @"ShowChatIcon"                             // 开启首页聊天入口
#define ShowImageOnlyWIFI               @"ShowImageOnlyWIFI"                        // 是否仅wifi网络显示图片
#define GetAgencyPhoneSuccess           @"GetAgencyPhoneSuccess"                    // 获取手机号成功
#define UpdateVersionUrl                @"UpdateVersionUrl"                         // 更新版本地址
#define UpdateContent                   @"UpdateContent"                            // 更新内容
#define EnableNotify                    @"EnableNotify"                             // 消息提醒开关
#define AllMessageRemind                @"AllMessageRemind"                         // 所有消息红点提示
#define OfficalMessageRemind            @"OfficalMessageRemind"                     // 官方消息红点提示
#define PropMessageRemind               @"PropMessageRemind"                        // 房源消息
#define CustomerMessageRemind           @"CustomerMessageRemind"                    // 客源消息
#define DealMessageRemind               @"DealMessageRemind"                        // 成交消息
#define PrivateMessageRemind            @"PrivateMessageRemind"                     // 我的私信
#define AddTakingSeeRemind              @"AddTakingSeeRemind"                       // 新增约看推送
#define UnreadNotification              @"UnreadNotification"                       // 消息未读通知name
#define RealSurveyAuditingSearch        @"RealSurveyAuditingSearch"                 // 实勘审核搜索列表
#define RealSurveyBdNameSearch          @"RealSurveyBdNameSearch"                   // 实勘列表楼盘搜索列表
#define ChangeTradingState              @"ChangeTradingState"                       // 房源状态更改
#define KeyListVCCallTime               @"CallKeyTelTime"                           // 拨打钥匙电话记录时间
#define CustomerInfoTelTime             @"CustomerInfoTelTime"                      // 拨打客户信息电话记录时间


#define AutoGestureLockTimeSpan         @"AutoGestureLockTimeSpan"                  // 手势自动锁定时间间隔
#define AutoPwdLockTimeSpan             1800                                        // 30分钟后密码锁定（30分＊60秒）
#define DefaultErrorTimes               5                                           // 默认A+密码验证错误次数限制
#define ErrorTimes                      @"ErrorTimes"                               // 错误次数
#define Account                         @"AccountName"                              // 登录帐号
#define PwdInputLength                  20                                          // 密码输入框长度
#define AccountLockStatus @"AccountLockStatus"//账号锁定状态,0未锁定，1锁定


#define PhotoWidth          @"?width=3000"

#define AllRoundListPhotoWidth          @"?width=200"                               // 通盘房源列表 首页实勘图宽度为200
#define PhotoDownWidth                  @"?width=800"                               // 浏览实勘大图 实勘图宽度为800
#define EntrustPhotoDownWidth           @"?width=1000"                              // 浏览实勘大图 实勘图宽度为1000
#define RealPhotoDownWidth              @"?width=1500"                              // 下载实勘宽度
//#define WaterMark                       @"&watermark=smallgroup_center"             // 加中原地产水印
#define TrustWaterMark                  @"&watermark=copyright"                     // 加委托审核水印

/**
 *  登录用户在集团人事系统中的信息
 */
#pragma mark - <UserInfo>
#define UserName                        @"UserName"                                 // 用户名
#define APlusUserName                   @"APlusUserName"                            // 员工姓名
#define APlusUserMobile                 @"APlusUserMobile"                          // 用户手机号
#define APlusUserExtendMobile           @"APlusUserExtendMobile"                    // 用户其他手机号
#define APlusUserDepartName             @"APlusUserDepartName"                      // 用户部门名称
#define APlusUserRoleName               @"APlusUserRoleName"                        // 用户角色名称
#define APlusUserPhotoPath              @"APlusUserPhotoPath"                       // 用户角色头像
#define UserStaffNumber                 @"UserStaffNumber"                          // 用户编号
#define CityCode                        @"CityCode"                                 // 城市编号
#define UserStaffMobile                 @"UserStaffMobile"                          // 用户电话
#define UserDeptName                    @"UserDeptName"                             // 用户部门
#define UserTitle                       @"UserTitle"                                // 用户职称
#define AgentUrl                        @"AgentUrl"                                 // 用户头像地址
#define UserCompanyName                 @"UserCompanyName"                          // 用户公司名称
#define IsLoginSuccess                  @"IsLoginSuccess"                           // 是否登陆成功
#define Msisdn                          @"msisdn"                                   // 得实达康报备号
//城市keyID
#define CorporationKeyId        @"CorporationKeyId"
//城市名称
#define CorporationName         @"CorporationName"



// 天津2.X相关
#define Home_Default                    @"Home_Default"          // 首页默认显示
#define Home_More                       @"Home_More"            // 首页所有应用
#define Home_Event                      @"Home_Event"           // 首页新增事件
#define Have_Alert_Msg                  @"HaveAlertMsg"                             // 是否已经过不是三级市场的提示
#define QRcodeUrl                       @"/Home/MobileAplus"                        // 转交钥匙二维码拼接地址

#define KeyWord                         @"KeyWord"                                  // 通盘房源默认搜索条件
#define NameString                      @"NameString"                               // 通盘房源默认保存名字

// 人脸识别相关
#define FaceCollectUrl                  @"FaceCollectUrl"                           // 人脸采集地址（未采集是"0"）
#define FaceRecogSwitch                 @"FaceRecogSwitch"                          // 我的-人脸识别开关
#define FaceRecogTime                   @"FaceRecogTime"                            // 人脸识别时间记录

/**
 *  登录用户业务设置参数
 */
#define DeptVirtualSwitch               @"DeptVirtualSwitch"                        // 部门虚拟号开关(北京)
#define VirtualCallSwitch               @"VirtualCallSwitch"                        // APPSetting虚拟号开关
#define DeptCentaBoxSwitch              @"DeptCentaBoxSwitch"                       // 部门智能钥匙箱开关(天津)
#define BoxRange                        @"BoxRange"                                 // 钥匙箱还钥半径


/**
 *  更多筛选项中对应的文字显示
 */
#define FilterRoomKey             @"房型"
#define FilterAreaKey             @"建筑面积（平)"
#define FilterEstateStateKey      @"房源状态"
#define FilterEstateStatusQuoKey  @"房屋现状"
#define FilterEstateGrade         @"房屋等级"
#define FilterDirectionKey        @"朝向"
#define FilterEstateTag           @"房源标签"
#define FilterBuildingTypeKey     @"建筑类型"
#define FilterTrustsTagItemValue  @"isTrustsApproved"

//获取本地缓存的城市CorporationKeyId
#define FINAL_CORPORATION_KEY_ID [CommonMethod getUserdefaultWithKey:CorporationKeyId]

/*
 * 几种进入房源列表的方式
 */
/// <summary>
/// 战区房源（通盘房源）
/// </summary>
#define WARZONE                         @"1"

/// <summary>
/// 推荐房源
/// </summary>
#define RECOMMEND                       @"2"

/// <summary>
/// 我的房源贡献
/// </summary>
#define CONTRIBUTION                    @"3"


/// <summary>
/// 我的楼主盘
/// </summary>
#define RESPONSIBLE                     @"4"


/// <summary>
/// 我的收藏
/// </summary>
#define FAVORITE                        @"5"


/// <summary>
/// 我的推荐
/// </summary>
#define MYRECOMMEND                     @"6"


/// <summary>
/// 公盘池
/// </summary>
#define PUBLIC_PROPERTY                 @"7"


/// <summary>
/// 我的全部客户
/// </summary>
#define MYINQUIRY                       @"8"

/// <summary>
/// 公盘池
/// </summary>
#define PUBLIC_INQUIRY                  @"9"



/// <summary>
/// 转介盘
/// </summary>
#define MYREFERRAL                      @"10"



/**
 *  房源类型
 */
#define TRADINGSTATE                    @"tradingState"


//权限提示信息
#define FINAL_PERMISSIONS_PROMPT @"您没有相关权限！"
//无交易类型点击之后提示语
#define FINAL_ESTATE_HAS_NO_TRUST_TYPE @"该房源没有交易类型，请联系数据组补充"


#define FINAL_KEY_DES       @"asds234g"//des加密使用的key

#define FINAL_KEY_SIGN      @"@gency12#"//签名算法中用到的秘钥

#define FINAL_JD_STATUS_BAR_NOTIFICATION_ERROR @"FINAL_JD_STATUS_BAR_NOTIFICATION_ERROR"//弹框样式名称
#define FINAL_JD_STATUS_BAR_NOTIFICATION_SUCC @"FINAL_JD_STATUS_BAR_NOTIFICATION_SUCC"//弹框样式名称


#endif
