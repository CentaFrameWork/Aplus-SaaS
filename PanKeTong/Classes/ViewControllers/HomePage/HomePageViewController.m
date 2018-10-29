//
//  HomePageViewController.m
//  PanKeTong
//
//  Created by TailC on 16/3/29.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "AllRoundViewController.h"
#import "ChannelCallViewController.h"
#import "ChannelCustomerViewController.h"
#import "CustomHelpViewController.h"
#import "HomePageJSExprt.h"
#import "HomePageViewController.h"
#import "MJRefresh.h"
#import "MyCollectViewController.h"
#import "NSDate+Format.h"
#import "NSString+JSON.h"
#import "PublishEstateOrCustomerViewController.h"
#import "SearchViewController.h"
#import "UIColor+Custom.h"
#import "SignedViewController.h"
#import "FollowListViewController.h"
#import "MessageViewController.h"
#import "ChatListViewController.h"
#import "NotificationNameDefine.h"
#import "EstateReleaseManageViewController.h"
#import "MyClientViewController.h"
#import "MyLiangHuaViewController.h"
#import "ChatListViewController.h"
//#import "UserTokenService.h"
#import "CheckAppVersonApi.h"
#import "CheckVersonEntity.h"
#import "RealSurveyAuditingVC.h"
#import "CheckRealSurveyViewController.h"
#import "CalendarStrokeVC.h"
#import "StaffTurnOverApi.h"//检查人员异动
#import "StaffTurnEntity.h"
#import "IdentifyEntity.h"
#import "LogOffUtil.h"
#import "GetEstAgentQuotaApi.h"
#import "AgentQuotaEntity.h"

#import "HomePageBJPresenter.h"
#import "HomePageNJPresenter.h"
#import "HomePageTJPresenter.h"
#import "HomePageSZPresenter.h"
#import "HomePageAMPresenter.h"
#import "HomePageGZPresenter.h"
#import "HomePageCQPresenter.h"
#import "HomePageCSPresenter.h"
#import "HomePageHZPresenter.h"

#import "GetSystemParamApi.h"
#import "WebViewFilterUtil.h"
#import "CalendarStrokeVC.h"
#import "TrustAuditingVC.h"


#import <RongIMKit/RongIMKit.h>
#import <CoreLocation/CoreLocation.h>


typedef NS_ENUM(NSInteger, HomePageHTMLToNativeJumpType) {
	
    HomePageHTMLToNativeJumpTypeCall = 281,                 //渠道来电
    HomePageHTMLToNativeJumpTypePublicEstate = 280,         //渠道公盘池
    HomePageHTMLToNativeJumpTypeMyFavorite = 400,           //我的收藏
    HomePageHTMLToNativeJumpTypePublishCustomer = 220,      //抢公客
    HomePageHTMLToNativeJumpTypePublishEstate = 210,        //抢公盘
    HomePageHTMLToNativeJumpTypeAllRoundEstate = 200,       //通盘房源
    HomePageHTMLToNativeJumpTypeNewEstateNews = 100,        //新盘资讯
    HomePageHTMLToNativeJumpTypeNewEstate = 110,            //新盘
    HomePageHTMLToNativeJumpTypeCustomHelp = 999,           //帮助快捷入口
    HomePageHTMLToNativeJumpTypeMessage = 800,              //消息快捷入口
    HomePageHTMLToNativeJumpTypeSigned = 282,               //签到入口
    HomePageHTMLToNativeJumpTypeLeftFollow = 283,           //左导跟进记录
    HomePageHTMLToNativeJumpTypeMyContribution = 240,       //房源贡献
    HomePageHTMLToNativeJumpTypeADM = 300,                  //放盘管理
    HomePageHTMLToNativeJumpTypeMyClient = 250,             //我的客户
    HomePageHTMLToNativeJumpTypeMyQuantification = 270,     //我的量化
    HomePageHTMLToNativeJumpTypeRealSurveyAuditing = 261,   //实勘审核
    HomePageHTMLToNativeJumpTypeCalendarStroke = 290,       //日历行程
    HomePageHTMLToNativeJumpTypeTrustAuditing = 310         //委托审核
	
};


#define ForceUpdateAlertTag         1000    //强制版本更新提示框
#define NormalUpdateAlertTag        2000    //正常版本更新提示框


@interface HomePageViewController () <UIWebViewDelegate,HomePageViewProtocol>
{
    GetSystemParamApi *_systemParamApi;
    
    ///获取聊天用户token的service
//    UserTokenService *_userTokenService;
    
    ///获取融云用户签名的service
    CheckAppVersonApi *_checkAppVersonApi;


    NSString *_HTTPURL;//H5Url
    
    HomePageBasePresenter *_homePagePresenter;

}

@property(strong, nonatomic)UIWebView *uiWebView;
@property(strong, nonatomic)NSString *URL;
@property(strong, nonatomic)UIButton *navLeftButton;
@property(assign, nonatomic)BOOL yesOrNo;

@end

@implementation HomePageViewController

#pragma mark life cycle
- (void)viewDidLoad {
    
  [super viewDidLoad];

    [self initPresenter];
    [self initData];
    
    _yesOrNo = NO;
	_URL = [self setupURL];
	[self setupNavigationBar];
	[self setGestureView];
	[self setupWebView];
    [self receiveNotificationCenter];
}

- (void)initPresenter
{
    if ([CityCodeVersion isTianJin]) {
        _homePagePresenter = [[HomePageTJPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isBeiJing]){
        _homePagePresenter = [[HomePageBJPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isNanJing]){
        _homePagePresenter = [[HomePageNJPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isChongQing]){
        _homePagePresenter = [[HomePageCQPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isShenZhen]){
        _homePagePresenter = [[HomePageSZPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isAoMenHengQin]){
        _homePagePresenter = [[HomePageAMPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isGuangZhou]){
        _homePagePresenter = [[HomePageGZPresenter alloc] initWithDelegate:self];
    }
    else if ([CityCodeVersion isChangSha]){
        _homePagePresenter = [[HomePageCSPresenter alloc] initWithDelegate:self];
    }else if ([CityCodeVersion isHangZhou]){
        _homePagePresenter = [[HomePageHZPresenter alloc] initWithDelegate:self];
    }
    else{
        _homePagePresenter = [[HomePageBasePresenter alloc] initWithDelegate:self];
    }
}

- (void)initData
{
    // 检查人员异动
    [_homePagePresenter checkPersonnelAbnormalMove];
}

#pragma  mark - HomePageViewProtocol
/// 通知检查人员异动
- (void)noticeCheckPersonnelAbnormalMove
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificaticon:) name:@"Dismiss" object:nil];
}

- (void)notificaticon:(NSNotification *)notiftcation{
    //检查是否有人员异动
    IdentifyEntity *identifyEntity = [AgencyUserPermisstionUtil getIdentify];
    StaffTurnOverApi *staffTurnOverApi = [[StaffTurnOverApi alloc] init];
    staffTurnOverApi.keyId = @"";
    staffTurnOverApi.employeeKeyId = identifyEntity.uId;
    staffTurnOverApi.employeeName = identifyEntity.uName;
    staffTurnOverApi.employeeDeptKeyId = identifyEntity.departId;
    staffTurnOverApi.employeeDeptName = identifyEntity.departName;
    staffTurnOverApi.operationType = @"2";
    [_manager sendRequest:staffTurnOverApi];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];

	_uiWebView.frame = self.view.bounds;
	
	// 添加kvo观察是否上传token成功，如果已经上传成功则不监听
	[[self sharedAppDelegate] addObserver:self
                               forKeyPath:@"uploadTokenSuccess"
                                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                  context:nil];
	
	// 检查通讯录授权
    if ([_homePagePresenter isUseDascom])
    {
        [CommonMethod CheckAddressBookAuthorization:^(bool isAuthorized){
            
            if(isAuthorized)
            {
                NSString *photoName = [NSString stringWithFormat:@"%@虚拟号",SettingProjectName];
                NSString *photoNumber = [[BaseApiDomainUtil getApiDomain] getDascomNumber];
                
                // 通讯录无此联系人 且 虚拟号接入码为空时不做添加号码操作
                if(![self filterContentForSearchText:photoName andNumber:photoNumber] && ![NSString isNilOrEmpty:photoNumber]){
                    [self addPeople];
                }
            }
            else
            {
                showMsg(@"请到设置>隐私>通讯录打开本应用的权限设置");
            }
        }];

    }

	
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark Private Method
/** 通知回调，登陆后重置URL  */
- (void)loginStatusChanged:(NSNotification *)notification{
    
    [self initPresenter];
	
	_URL = [self setupURL];
	//[_uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URL]]];
    [_uiWebView.scrollView headerBeginRefreshing];
    
    if ([notification.name isEqualToString:RequestSystemParamNotification]) {
        // 重新获取系统参数
        NSString *sysParamNewUpdTime = [AgencySysParamUtil getSysParamNewUpdTime];
        // sysParamNewUpdTime = @"2015-02-03";

        _systemParamApi = [GetSystemParamApi new];
        _systemParamApi.updateTime = sysParamNewUpdTime;
        [_manager sendRequest:_systemParamApi];

    }
    

}

- (void)setGestureView {
	BOOL hasPwd = [CLLockVC hasPwd];
	if (hasPwd) {
		return;
	}
	
	[CLLockVC showSettingLockVCInVC:self
					   successBlock:^(CLLockVC *lockVC, NSString *pwd) {
						   NSLog(@"密码设置成功");
						   [lockVC dismissNow];
						   [AlertInputPwdView resetErrorTimes];
					   }
					 isShowNavClose:NO];
}

/** 初始化WebView  */
- (void)setupWebView {
	
	// 判断登陆情况
	BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:IsLoginSuccess];
	if (isLogin) {

		_uiWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
		
		_uiWebView.backgroundColor = [UIColor whiteColor];
		_uiWebView.delegate = self;
		[_uiWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_URL]]];
        
		
		[self.view addSubview:_uiWebView];
		
        __weak typeof(_uiWebView) weakUIWebView = _uiWebView;
        __weak HomePageViewController *safeSelf = self;
        __block NSString *WebURL = _URL;
        
        [_uiWebView.scrollView addHeaderWithCallback:^{
            // 更新URL
            WebURL = [safeSelf setupURL];
            [weakUIWebView
             loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WebURL]]];
            
            //[weakUIWebView reload];
        }];
        

		
	}
}

/** 初始化URL，拼接Seesion  */
- (NSString *)setupURL {
    /*
     http://10.4.18.33:8010/hkindex/022/?HKSession=100000&DomainName=heam1&timestamp=9988788
     HKSession：服务器返回的session
     DomainName：域名
     timestamp：时间戳
     */
    
    NSString *domianName =
    [[NSUserDefaults standardUserDefaults] stringForKey:AgencyDomainToken];
    NSString *session =
    [[NSUserDefaults standardUserDefaults] stringForKey:HouseKeeperSession];
    double timestamp =
    [CommonMethod getTimeNumberWith:[NSDate stringWithDate:[NSDate date]]];
    
    /** http://10.4.18.33:8010/hkindex/022/  */
    NSString *headURL = [[BaseApiDomainUtil getApiDomain] getHKH5HomeDomain];
    NSString *cityCode = [CityCodeVersion getCurrentCityCode];
    
    NSString *URL =
    [NSString stringWithFormat:@"%@?HKSession=%@&DomainName=%@&timestamp=%f&citycode=%@",
     headURL, session, domianName, timestamp,cityCode];

    NSLog(@"*******************首页H5地址：%@",URL);

    return URL;
}


/** 初始化NavigaitonBar  */
- (void)setupNavigationBar {

	UIColor *navItemViewBackgroundColor = [UIColor colorFromHexString:@"#952403"];

	// 左边导航栏
	NSString *userCompanyName = [[NSUserDefaults standardUserDefaults] stringForKey:UserCompanyName];
	
	NSString *cityName = [userCompanyName stringByReplacingOccurrencesOfString:@"中原" withString:@""];
	CGFloat labelHeight = [cityName widthWithLabelFont:[UIFont fontWithName:FontName size:14.0f]];

	_navLeftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, labelHeight+40, 27)];
	_navLeftButton.backgroundColor = [UIColor clearColor];
	_navLeftButton.titleLabel.font = [UIFont fontWithName:FontName size:14.0f];
	_navLeftButton.titleLabel.tintColor = [UIColor whiteColor];
	_navLeftButton.userInteractionEnabled = NO;
	[_navLeftButton setImage:[UIImage imageNamed:@"ic_city_ico"] forState:UIControlStateNormal];
	[_navLeftButton setTitle:[NSString stringWithFormat:@"  %@",cityName] forState:UIControlStateNormal];
	UIBarButtonItem *leftNagativeSpacer = [[UIBarButtonItem alloc]
										   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
										   target:nil
										   action:nil];
	leftNagativeSpacer.width = -15 + 15; // 默认为-15
	UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navLeftButton];
	self.navigationItem.leftBarButtonItems = @[ leftNagativeSpacer, leftBarButtonItem ];
	
	// 右边
	UIView *rightBarItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 27)];
	rightBarItemView.backgroundColor = navItemViewBackgroundColor;
	rightBarItemView.layer.cornerRadius = 13.5f;

	UIButton *rightBarItemViewLeftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 27)];
	rightBarItemViewLeftButton.center = rightBarItemView.center;
	[rightBarItemViewLeftButton setImage:[UIImage imageNamed:@"home_img_search"]
								forState:UIControlStateNormal];
	[rightBarItemViewLeftButton addTarget:self
								   action:@selector(onClickNavLeftButton:)
						 forControlEvents:UIControlEventTouchUpInside];

	[rightBarItemView addSubview:rightBarItemViewLeftButton];

	//	UIButton *rightBarItemViewRightButton = [[UIButton alloc]
	// initWithFrame:CGRectMake(40, 0, 27, 27)];
	//	[rightBarItemViewRightButton setImage:[UIImage
	// imageNamed:@"home_img_scanning"] forState:UIControlStateNormal];
	UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarItemView];
	//	[rightBarItemView addSubview:rightBarItemViewRightButton];
	//	[rightBarItemViewRightButton addTarget:self
	// action:@selector(onClickNavRightButton:)
	// forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *rightNavigationSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
																						   target:nil
																						   action:nil];
	rightNavigationSpacer.width = -10;

	self.navigationItem.rightBarButtonItems = @[ rightNavigationSpacer, rightBarButtonItem ];
	
}

/*
 *  接收通知
 */
- (void)receiveNotificationCenter
{
    // 刷新页面
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStatusChanged:)
                                                 name:LoginSuccessNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStatusChanged:)
                                                 name:RequestSystemParamNotification
                                               object:nil];
    
    // 添加kvo观察是否上传融云token成功，如果已经上传成功则不监听
    if (![self sharedAppDelegate].uploadTokenSuccess)
    {
        [[self sharedAppDelegate] addObserver:self
                                   forKeyPath:@"uploadTokenSuccess"
                                      options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                                      context:nil];
    }

}

// 新增联系人
- (void)addPeople {
    
    NSString *phoneName = [NSString stringWithFormat:@"%@虚拟号",SettingProjectName];
    NSString *photoNumber = [[BaseApiDomainUtil getApiDomain] getDascomNumber];
    
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
    
    ABRecordRef newPerson = ABPersonCreate();
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(phoneName), nil);
    
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(photoNumber), kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, nil);
    
    CFRelease(multiPhone);
    
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, nil);
    ABAddressBookSave(iPhoneAddressBook, nil);
    CFRelease(newPerson);
    CFRelease(iPhoneAddressBook);
    
}


/**
 *  删除联系人
 */
- (void)deletePeople
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    // 获取通讯录中所有的联系人
    NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    // 遍历所有的联系人并删除(这里只删除姓名为张三的)
    for (id obj in array) {
        ABRecordRef people = (__bridge ABRecordRef)obj;
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
        
        if ([lastName isEqualToString:@"移动A+虚拟号"]) {
            ABAddressBookRemoveRecord(addressBook, people, NULL);
        }
    }
    // 保存修改的通讯录对象
    ABAddressBookSave(addressBook, NULL);
    // 释放通讯录对象的内存
    if (addressBook) {
        CFRelease(addressBook);
    }
    
}

- (BOOL)filterContentForSearchText:(NSString *)searchText andNumber:(NSString *)number
{
    NSInteger count = 0;
    BOOL phoneNumberBool = NO;
    
    // 判断授权状态
    if (ABAddressBookGetAuthorizationStatus()!=kABAuthorizationStatusAuthorized) {
        return YES;
    }
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (searchText.length == 0) {
        count = 0;
    }
    else
    {
        // 根据字符串查找前缀关键字
        CFStringRef cfSearchText = (CFStringRef)CFBridgingRetain(searchText);
        NSArray *listContacts = CFBridgingRelease(ABAddressBookCopyPeopleWithName(addressBook, cfSearchText));
        
        
        count = listContacts.count;
        
        for (int i = 0; i < count; i++) {
            // 从搜索出的联系人数组中获取一条数据 转换为ABRecordRef格式
            ABRecordRef thisPerson = CFBridgingRetain([listContacts objectAtIndex:i]);
            ABMultiValueRef valuesRef = ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);
            // 电话号码
            NSString *phoneNumber = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(valuesRef, 0));
            
            if([phoneNumber isEqualToString:number]){
                // 存在
                phoneNumberBool = YES;
            }
        }
        CFRelease(cfSearchText);
    }
    CFRelease(addressBook);
    
    if(count > 0 && phoneNumberBool){
        return YES;
    }else{
        return NO;
    }
}


/** 导航栏左边button （搜索）*/
- (void)onClickNavLeftButton:(UIButton *)button
{


    [self checkShowViewPermission:MENU_PROPERTY_WAR_ZONE andHavePermissionBlock:^(NSString *permission) {
        SearchViewController *searchVC = [[SearchViewController alloc] initWithNibName:@"SearchViewController"
                                                                                bundle:nil];
        searchVC.searchType = TopTextSearchType;

        searchVC.isFromMainPage = YES;
        [self.navigationController pushViewController:searchVC animated:YES];
    }];
}

/** 导航栏右边button （扫描二维码）  */
- (void)onClickNavRightButton:(UIButton *)button {
}


#pragma mark - ObserveValueForKeyPath
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"uploadTokenSuccess"]) {
        
        if ([[change objectForKey:@"new"] intValue] == 1) {
            
            // 上传token成功，连接融云服务器
//            [self getCodeSignMethod];
        }
    }else if ([keyPath isEqualToString:@"UserLoginSuccess"]){
        
        if ([[change objectForKey:@"new"] intValue] == 1) {
            
            // 登录成功，检查服务端版本号，看是否需要更新版本
//            _checkAppVersonApi = [[CheckAppVersonApi alloc] init];
//            [_manager sendRequest:_checkAppVersonApi];
        }
    }
    
}

#pragma mark - RongCloud
/*
 *  一、获取融云签名参数
 *
 *  1、首次登录的时候token已上传成功，但是用户还未登录，因此需要判断用户信息非空
 *  2、首次登录的时候如果还未登录，则清空header中的数据，否则登录失败
 *
 */
//- (void)getCodeSignMethod
//{
//    // 本地缓存没有token，或没有登录。请求token
//    
//    NSString *userCityCode = [[NSUserDefaults standardUserDefaults]stringForKey:CityCode];
//    NSString *userStaffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
//    NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:UserName];
//    NSString *staffHeadImage = [NSString stringWithFormat:@"%@%@.jpg",
//                                AgentUrl,
//                                userStaffNo];
//    
//    NSString *userTargetId = [[NSString stringWithFormat:@"s_%@_%@",
//                               userCityCode,
//                               userStaffNo] lowercaseString];
//    
//    _userTokenService = [UserTokenService shareService];
//    _userTokenService.delegate = self;
//    [_userTokenService getUserTokenWithUserId:userTargetId
//                                      andName:userName
//                               andPortraitUri:staffHeadImage];
//    
//}

#pragma mark - +++++连接融云服务器+++++
- (void)initChatData
{
    
    
    NSString *userToken = [[NSUserDefaults standardUserDefaults]stringForKey:RongCloudUserToken];
    
    NSString *userCityCode = [[NSUserDefaults standardUserDefaults]stringForKey:CityCode];
    NSString *userStaffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
    NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:UserName];
    NSString *staffHeadImage = [NSString stringWithFormat:@"%@%@.jpg",
                                AgentUrl,
                                userStaffNo];
    
    // 快速集成第二步，连接融云服务
    [[RCIM sharedRCIM] connectWithToken:userToken
                                success:^(NSString *userId) {
                                    
                                    // Connect 成功
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        NSString *currentUserId = [[NSString stringWithFormat:@"s_%@_%@",
                                                                    userCityCode,
                                                                    userStaffNo] lowercaseString];
                                        NSString *currentUserName = userName;
                                        NSString *currentUserPortrait = staffHeadImage;
                                        
                                        // 设置当前的用户信息
                                        RCUserInfo *currentUserInfo = [[RCUserInfo alloc]initWithUserId:currentUserId
                                                                                                   name:currentUserName
                                                                                               portrait:currentUserPortrait];
                                        [RCIMClient sharedRCIMClient].currentUserInfo = currentUserInfo;
                                        
                                        
                                    });
                                }
                                  error:^(RCConnectErrorCode status) {
                                      
                                      // Connect失败
                                      
                                  }
                         tokenIncorrect:^{
                             
                         }];
    
}

#pragma mark - BaseServiceDelegate
- (void)didReceiveResponse:(id)data
{
    
    if([data isKindOfClass:[NSDictionary class]]){
        //融云，获取token成功
        NSDictionary *userTokenDic = (NSDictionary *)data;
        NSString *codeValue = [[userTokenDic objectForKey:@"code"] stringValue];
        NSString *tokenValue = [userTokenDic objectForKey:@"token"];
        
        if ([codeValue isEqualToString:@"200"]) {
            
            //获取token成功
            [CommonMethod setUserdefaultWithValue:tokenValue
                                           forKey:RongCloudUserToken];
            
            [self initChatData];
            
        }else{
            
            [CommonMethod setUserdefaultWithValue:nil
                                           forKey:RongCloudUserToken];
        }
        
     
    }
    

    
}




#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999) {
        //退出登录
        IdentifyEntity *identifyEntity = [AgencyUserPermisstionUtil getIdentify];
        StaffTurnOverApi *staffTurnOverApi = [[StaffTurnOverApi alloc] init];
        staffTurnOverApi.keyId = @"";
        staffTurnOverApi.employeeKeyId = identifyEntity.uId;
        staffTurnOverApi.employeeName = identifyEntity.uName;
        staffTurnOverApi.employeeDeptKeyId = identifyEntity.departId;
        staffTurnOverApi.employeeDeptName = identifyEntity.departName;
        staffTurnOverApi.operationType = @"0";
        [_manager sendRequest:staffTurnOverApi];


    }
    // 版本更新地址、更新内容
    NSString *updateUrl = [[NSUserDefaults standardUserDefaults]stringForKey:UpdateVersionUrl];
    NSString *udpateContent = [[NSUserDefaults standardUserDefaults]stringForKey:UpdateContent];
    
    switch (alertView.tag) {
        case ForceUpdateAlertTag:
        {
            // 强制更新alert
            UIAlertView *forceUpdateAlert = [[UIAlertView alloc]initWithTitle:@"有版本更新"
                                                                      message:udpateContent
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:@"更新", nil];
            forceUpdateAlert.tag = ForceUpdateAlertTag;
            
            [forceUpdateAlert show];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
            
            exit(0);
        }
            break;
        case NormalUpdateAlertTag:
        {
            // 正常更新alert
            switch (buttonIndex) {
                case 1:
                {
                    // 去更新
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                    
                    exit(0);
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        default:
            break;
    }
}



#pragma mark <UIWebViewDelegate>
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _uiWebView.delegate = self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"首页H5Url:%@",_URL);
    
  [_uiWebView.scrollView headerEndRefreshing];
    NSString *cityName = [[NSUserDefaults standardUserDefaults] stringForKey:UserCompanyName];
    
    if ([cityName isEqualToString:@"横琴"]||[cityName isEqualToString:@"澳门"])
    {
        _navLeftButton.width = 80;
        [_navLeftButton setTitle:@" 中原地产" forState:UIControlStateNormal];
    }
    else
    {
        
        NSString *userCompanyName = [[NSUserDefaults standardUserDefaults] stringForKey:UserCompanyName];
        
        NSString *cityName = [userCompanyName stringByReplacingOccurrencesOfString:@"中原" withString:@""];
        CGFloat labelHeight = [cityName widthWithLabelFont:[UIFont fontWithName:FontName size:14.0f]];
        
        _navLeftButton.width = labelHeight + 40;
        [_navLeftButton setTitle:[NSString stringWithFormat:@"  %@",[cityName substringToIndex:2]] forState:UIControlStateNormal];
    }
  

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    //  NSString *url = @"http://cces3.centaline.com.cn/ReferralAPP/External/EstateList.aspx";
    NSRange range = [url rangeOfString:@"jump"];
    
    if (range.length > 0) {
        
        // URL解码
        NSString *shareUrl =[[[NSString stringWithFormat:@"%@", request.URL] substringFromIndex:5]
                             stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        // 手动转换JSON字符串
        NSString *shareRightUrl0 = [shareUrl stringByReplacingOccurrencesOfString:@"Function" withString:@"\"Function\""];
        NSString *shareRightUrl1 = [shareRightUrl0 stringByReplacingOccurrencesOfString:@"HttpUrl" withString:@"\"HttpUrl\""];
        NSString *shareRightUrl2 = [shareRightUrl1 stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        NSString *shareRightUrl3 = [shareRightUrl2 stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];
        NSString *shareRightUrl4 = [shareRightUrl3 stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];
        
        // JSON字符串转字典
        NSDictionary *jsonDict = [shareRightUrl4 jsonDictionaryFromJsonString];
        NSDictionary *jumpContent = [jsonDict objectForKey:@"JumpContent"];
        NSNumber *jumpType = [jsonDict objectForKey:@"JumpType"];
        NSString *HTTPURL = [jumpContent objectForKey:@"HttpUrl"];
        
        [CommonMethod setUserdefaultWithValue:HTTPURL forKey:CustomHelpUrl];
        if (!jumpContent) {
            return YES;
        }
        
        // 跳转到H5
        if (jumpType.intValue == 1)
        {
            AbsWebViewFilter *webviewFilter = [WebViewFilterUtil instantiation];
            if(![webviewFilter havePermissionAccess:jsonDict])
            {
                //提示没有权限
                showMsg(@"您没有相关权限");
                return NO;
            }

            _HTTPURL = [webviewFilter getFullUrl:jsonDict];


            NSString *mdescription = [jsonDict objectForKey:@"Description"];
            if ([mdescription isEqualToString:@"广告管理"]){
                //判断权限
                BOOL isHave = [AgencyUserPermisstionUtil hasMenuPermisstion:MENU_ADVERT];
                if (!isHave) {
                    showMsg(@(NotHavePermissionTip));
                    return YES;
                }
            }

            //跳转到帮助界面
            CustomHelpViewController *vc = [[CustomHelpViewController alloc] init];
            vc.helpURL = _HTTPURL;
            [self.navigationController pushViewController:vc animated:YES];
            return YES;
        }
        
        // 跳转到原生模块
        if (jumpType.intValue == 2) {
            
            NSDictionary *jumpContent = [jsonDict objectForKey:@"JumpContent"];
            NSNumber *function = [jumpContent objectForKey:@"Function"];
            
            switch (function.intValue) {
                case HomePageHTMLToNativeJumpTypeCall: {
                    // 渠道来电
                    ChannelCallViewController *channelCallViewController =
                    [[ChannelCallViewController alloc]
                     initWithNibName:@"ChannelCallViewController"
                     bundle:nil];
                    [self.navigationController pushViewController:channelCallViewController
                                                         animated:YES];
                    
                    break;
                }
                case HomePageHTMLToNativeJumpTypePublicEstate: {
                    
                    // 渠道公客池
                    ChannelCustomerViewController *channelCustomerViewController =
                    [[ChannelCustomerViewController alloc]
                     initWithNibName:@"ChannelCustomerViewController"
                     bundle:nil];
                    [self.navigationController
                     pushViewController:channelCustomerViewController
                     animated:YES];
                    
                    break;
                }
                case HomePageHTMLToNativeJumpTypeMyFavorite: {
                    
                    // 我的收藏
                    MyCollectViewController *myCollectVC = [[MyCollectViewController alloc]
                                                            initWithNibName:@"MyCollectViewController"
                                                            bundle:nil];
                    [self.navigationController pushViewController:myCollectVC animated:YES];
                    break;
                }
                case HomePageHTMLToNativeJumpTypePublishCustomer: {
                    
                    // 抢公客
                    PublishEstateOrCustomerViewController *publishEstVC =
                    [[PublishEstateOrCustomerViewController alloc]
                     initWithNibName:@"PublishEstateOrCustomerViewController"
                     bundle:nil];
                    publishEstVC.isPublishEstate = NO;
                    [self.navigationController pushViewController:publishEstVC animated:YES];
                    
                    break;
                }
                case HomePageHTMLToNativeJumpTypePublishEstate: {
                    
                    // 抢公盘
                    PublishEstateOrCustomerViewController *publishEstVC =
                    [[PublishEstateOrCustomerViewController alloc]
                     initWithNibName:@"PublishEstateOrCustomerViewController"
                     bundle:nil];
                    publishEstVC.isPublishEstate = YES;
                    [self.navigationController pushViewController:publishEstVC animated:YES];
                    
                    
                    break;
                }
                case HomePageHTMLToNativeJumpTypeAllRoundEstate: {
                    // 通盘房源
                    AllRoundViewController *allRoundViewController =
                    [[AllRoundViewController alloc]
                     initWithNibName:@"AllRoundViewController"
                     bundle:nil];
                    allRoundViewController.isPropList = YES;
                    allRoundViewController.propType = WARZONE;
                    [self.navigationController pushViewController:allRoundViewController
                                                         animated:YES];
                    
                    break;
                }
                case HomePageHTMLToNativeJumpTypeNewEstateNews: {
                    // 新盘资讯
                    
                    break;
                }
                case HomePageHTMLToNativeJumpTypeNewEstate: {
                    // 新盘
                    
                    break;
                }
                case HomePageHTMLToNativeJumpTypeCustomHelp: {
                    // 帮助快捷入口
                    CustomHelpViewController *vc = [[CustomHelpViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    break;
                }
                case HomePageHTMLToNativeJumpTypeMessage: {
                    // 消息快捷入口
                    ChatListViewController *chatListVC = [[ChatListViewController alloc]initWithNibName:@"ChatListViewController" bundle:nil];
                    [self.navigationController pushViewController:chatListVC
                                                         animated:YES];
                    
                    break;
                }
                case HomePageHTMLToNativeJumpTypeSigned:{
                    // 签到入口
                    SignedViewController *SignedVC =[[SignedViewController alloc]
                                                     initWithNibName:@"SignedViewController"
                                                     bundle:nil];
                    [self.navigationController pushViewController:SignedVC animated:YES];
                    
                    break;
                }
                case HomePageHTMLToNativeJumpTypeLeftFollow:{
                    // 跟进记录
                    FollowListViewController *followListViewController =
                    [[FollowListViewController alloc]
                     initWithNibName:@"FollowListViewController"
                     bundle:nil];
                    [self.navigationController pushViewController:followListViewController
                                                         animated:YES];
                    
                    break;
                }
                case HomePageHTMLToNativeJumpTypeMyContribution:{
                    // 房源贡献
                    AllRoundViewController *allRoundListVC = [[AllRoundViewController alloc]initWithNibName:@"AllRoundViewController" bundle:nil];
                    allRoundListVC.isPropList = NO;
                    allRoundListVC.propType = CONTRIBUTION;
                    [self.navigationController pushViewController:allRoundListVC
                                                         animated:YES];
                    
                    break;
                }
                case HomePageHTMLToNativeJumpTypeADM:{
                    // 放盘管理
                    EstateReleaseManageViewController *releaseManageVC = [[EstateReleaseManageViewController alloc]initWithNibName:@"EstateReleaseManageViewController" bundle:nil];
                    [self.navigationController pushViewController:releaseManageVC
                                                         animated:YES];
                    
                    break;
                }
                case HomePageHTMLToNativeJumpTypeMyClient:{
                    // 我的客户
                    MyClientViewController *myClientVC = [[MyClientViewController alloc]initWithNibName:@"MyClientViewController" bundle:nil];
                    [self.navigationController pushViewController:myClientVC
                                                         animated:YES];
                    
                    break;
                }
                case HomePageHTMLToNativeJumpTypeMyQuantification:{
                    // 我的量化
                    MyLiangHuaViewController *lianghuaVC = [[MyLiangHuaViewController alloc]initWithNibName:@"MyLiangHuaViewController" bundle:nil];
                    lianghuaVC.userName=[[NSUserDefaults standardUserDefaults]objectForKey:APlusUserName];
                    lianghuaVC.userDepartMent = [AgencyUserPermisstionUtil getIdentify].departName;
                    [self.navigationController pushViewController:lianghuaVC
                                                         animated:YES];
                    
                    break;
                }
                    
                case HomePageHTMLToNativeJumpTypeRealSurveyAuditing:{
                    // 实勘审核
                    RealSurveyAuditingVC *realSurveyVC = [[RealSurveyAuditingVC alloc]
                                                          initWithNibName:@"RealSurveyAuditingVC" bundle:nil];
                    [self.navigationController pushViewController:realSurveyVC animated:YES];
                    break;
                    
                }
                case HomePageHTMLToNativeJumpTypeCalendarStroke:{
                    //日历行程
                    [CommonMethod addLogEventWithEventId:@"C stroke_Click" andEventDesc:@"日历行程模块点击量"];
                    CalendarStrokeVC *calendarStrokeVC = [[CalendarStrokeVC alloc] init];
                    [self.navigationController pushViewController:calendarStrokeVC animated:YES];
                    break;
                }
                case HomePageHTMLToNativeJumpTypeTrustAuditing:{
                    //委托审核
                    [CommonMethod addLogEventWithEventId:@"A power of a_Function" andEventDesc:@"委托审核模块点击量"];
                    if ([AgencyUserPermisstionUtil hasMenuPermisstion:MENU_PROPERTY_REGISTERTRUSTS]) {
                        TrustAuditingVC *vc = [[TrustAuditingVC alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }else{
                        showMsg(@"您没有相关权限！");
                    }
                    break;
                }

            }
        }
        
        // 跳转到外部应用
        if (jumpType.intValue == 3) {
            
        }
        
    }
    
    return YES;
}


#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[AgencyBaseEntity class]]) {
        //查询是否有人员异动
        AgencyBaseEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        NSLog(@"%@",entity);
    }
    if ([modelClass isEqual:[StaffTurnEntity class]]) {
        //删除异动人员
        StaffTurnEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        NSLog(@"%@",entity);
        [LogOffUtil clearUserInfoFromLocal];
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        app.haveAlert = NO;
        [app changeDiscoverRootVCIsLogin:YES];

    }
    if([modelClass isEqual:[CheckVersonEntity class]]){
        // 获取服务端版本号成功，使用build verson更新
        CheckVersonEntity *checkVersonEntity = [DataConvert convertDic:data toEntity:modelClass];
        CheckVersonResultEntity *versonDetailEntity = checkVersonEntity.result;
        // 保存更新地址、更新内容
        [CommonMethod setUserdefaultWithValue:versonDetailEntity.updateUrl
                                       forKey:UpdateVersionUrl];
        [CommonMethod setUserdefaultWithValue:versonDetailEntity.updateContent
                                       forKey:UpdateContent];

        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleVersion"];

        if (versonDetailEntity.forceUpdate == 1) {

            // 服务端设置强制更新
            if ([versonDetailEntity.clientVer integerValue] > [app_Version integerValue]) {
                UIAlertView *forceUpdateAlert = [[UIAlertView alloc]initWithTitle:@"有版本更新"
                                                                          message:versonDetailEntity.updateContent
                                                                         delegate:self
                                                                cancelButtonTitle:nil
                                                                otherButtonTitles:@"更新", nil];
                forceUpdateAlert.tag = ForceUpdateAlertTag;
                [forceUpdateAlert show];

            }

        }else{

            if ([versonDetailEntity.clientVer integerValue] > [app_Version integerValue]) {
                // 服务端有版本更新，不要求强制更新
                UIAlertView *normalAlertView = [[UIAlertView alloc]initWithTitle:@"有版本更新"
                                                                         message:versonDetailEntity.updateContent
                                                                        delegate:self
                                                               cancelButtonTitle:@"取消"
                                                               otherButtonTitles:@"更新", nil];
                normalAlertView.tag = NormalUpdateAlertTag;
                [normalAlertView show];


            }
        }

    }
    
    if ([modelClass isEqual:[SystemParamEntity class]])
    {
        SystemParamEntity * systemParamEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        if(systemParamEntity.needUpdate)
        {
            [AgencySysParamUtil setSystemParam:systemParamEntity];
            
        }else{
            NSLog(@"系统参数不需要更新");
        }
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls{

    // 是否需要检查人员异动
    if ([_homePagePresenter NeedToCheckPersonnelAbnormalMove])
    {
        Error *failError;
        if ([error isKindOfClass:[Error class]]) {
            failError = (Error *)error;
        }else{
            failError = [[Error alloc]init];
            failError.rDescription = error.localizedDescription;
            }

        if (failError.rDescription && [failError.rDescription isEqualToString:@"人员发生异动，请重新登录"]) {
            NSLog(@"%@",failError.rDescription);
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            if (appDelegate.haveAlert == NO) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"人员异动提醒"
                                                                    message:@"人员发生异动，请重新登录"
                                                                   delegate:self
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"确定", nil];
                [alertView show]; 
                alertView.tag = 999;
                appDelegate.haveAlert = YES;
            }

            return;
        }else{
            [super respFail:error andRespClass:cls];
        }
    }
else{
        [super respFail:error andRespClass:cls];
    }
}

@end
