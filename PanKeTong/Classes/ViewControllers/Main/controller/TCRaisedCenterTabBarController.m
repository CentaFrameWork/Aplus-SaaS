
//  TCRaisedCenterTabBarController.m
//  TCRaisedCenterTabBar_Demo
//
//  Created by TailC on 16/3/18.
//  Copyright © 2016年 TailC. All rights reserved.
//

#import "TCRaisedCenterTabBarController.h"
#import "CustomPanNavgationController.h"
#import "JMMessageViewController.h"
#import "MineViewController.h"
#import "NewHomePageVC.h"

#import "JDStatusBarNotification.h"
#import "TCPopMenuView.h"

#import "TCTabBar.h"
#import "TCNavigationController.h"
#import "VideoUploadViewController.h"
#import "AllRoundVC.h"
#import "NotificationNameDefine.h"
#import "PersonalInfoEntity.h"
#import "CheckVersonEntity.h"
#import "CheckAppVersonApi.h"
#import "GetPersonalApi.h"
#import "CheckVersonUtils.h"
#import "APUploadFile.h"
#import "APUploadVideo.h"
#import "APPConfigApi.h"

#import "CAShapeLayer+Category.h"
#import "UIColor+Custom.h"
#import "UITabBar+badge.h"

#define ForceUpdateAlertTag         5000    // 强制版本更新提示框
#define NormalUpdateAlertTag        6000    // 正常版本更新提示框

static TCRaisedCenterTabBarController *tabBar;

@interface TCRaisedCenterTabBarController ()<UITabBarDelegate,TCTabBarDelegate,UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
{
    GetPersonalApi *_getPersonalApi;
    TCNavigationController *_nav;
    TCTabBar *_customTabBar;

}

@property (strong,nonatomic) TCPopMenuView *popMenuView;		// 弹出的中间View

@property (nonatomic, readwrite, strong) UIViewController *home;
@property (nonatomic, readwrite, strong) JMMessageViewController *message;
@property (nonatomic, readwrite, strong) MineViewController *mine;
@property (nonatomic, strong) VideoUploadViewController *videoUploadVC;

@end


@implementation TCRaisedCenterTabBarController



- (void)viewDidLoad {
	
	[super viewDidLoad];

    _manager = [RequestManager initManagerWithDelegate:self];
	
	// 1.添加所有的自控制器
	[self addAllChildVC];

	[self checkUnreadMessage];

	// 监听是否有未读消息
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(checkUnreadMessage)
												 name:UnreadNotification
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didReceiveLoginSuccessNotification:)
												 name:LoginSuccessNotification
											   object:nil];

    [self networksStatus];
    
    self.tabBar.tintColor = YCThemeColorGreen;
    
    //去黑线
    self.tabBar.translucent = NO;
    self.tabBar.barStyle = UIBarStyleBlack;
    self.tabBar.barTintColor = [UIColor whiteColor];
    
    //加shadow
    self.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -2);
    self.tabBar.layer.shadowRadius = 5;
    self.tabBar.layer.shadowOpacity = 0.1;
    
    
    [self requestPhone];
}

- (void)viewWillAppear:(BOOL)animated {
    
	[super viewWillAppear:animated];
	
    
    [self requestHomeMoudleData];
	[self.selectedViewController beginAppearanceTransition:YES animated:animated];
	
}

#pragma mark - 请求首页模块
- (void)requestHomeMoudleData {
   
    NSArray *dataArr = [CommonMethod getUserdefaultWithKey:Home_Default];
    
    if (!dataArr) {
        APPConfigApi *appConfig = [[APPConfigApi alloc] init];
        appConfig.location = Home_Default;
        [_manager sendRequest:appConfig
                     sucBlock:^(id result) {

                         NSArray *array = [result objectForKey:@"Result"];
                         [CommonMethod setUserdefaultWithValue:array forKey:Home_Default];
                         [[NSNotificationCenter defaultCenter] postNotificationName:Home_Default object:nil];

                     } failBlock:^(NSError *error) {
                         
                         
                         showMsg(error.description);
                     }];
    }
}


#pragma mark Private Method

/// 监听网络状态
- (void)networksStatus
{
    // 监听文件上传过程中的网络状态（放在首页可以监听所有页面）
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    APUploadVideo *uploadVideo = [APUploadVideo sharedUploadVideo];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 网络状态改变时如果有文件正在上传则做出相应处理
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                if ([uploadVideo isHaveUploadTask])
                {
                    // 先暂停
                    [uploadVideo pauseUploadWithUploadFile:[uploadVideo getUploadTaskArr][uploadVideo.currentUploadIndex]];
                    
                    [self.viewControllers[0] AlertWithTitle:@"当前网络为4G，是否继续上传?" message:nil andOthers:@[@"继续",@"取消"] animated:YES action:^(NSInteger index) {
                        
                        if (index == 0)
                        {
                            // 继续
                            [uploadVideo continueUploadWithUploadFile:[uploadVideo getUploadTaskArr][uploadVideo.currentUploadIndex]];
                        }
                        else
                        {
                            // 取消
                            APUploadFile *uploadFile = [uploadVideo getUploadTaskArr][uploadVideo.currentUploadIndex];
                            uploadFile.uploadState = UploadStatusPause;
                            
                            if (self.videoUploadVC)
                            {
                                [self.videoUploadVC.uploadListTab reloadData];
                            }
                        }
                    }];
                    
                }
            }
                
                break;
                
            default:
                
            {
                
                showJDStatusStyleErrorMsg(@"似乎已断开与互联网的连接");
                
                if ([uploadVideo isHaveUploadTask]){
                    // 暂停
                    [uploadVideo pauseUploadWithUploadFile:[uploadVideo getUploadTaskArr][uploadVideo.currentUploadIndex]];
                    
                    APUploadFile *uploadFile = [uploadVideo getUploadTaskArr][uploadVideo.currentUploadIndex];
                    uploadFile.uploadState = UploadStatusPause;
                    
                    if (self.videoUploadVC)
                    {
                        [self.videoUploadVC.uploadListTab reloadData];
                    }
                }
                
            }
                
//                [self.viewControllers[0] AlertWithTitle:@"似乎已断开与互联网的连接" message:nil andOthers:@[@"确定"] animated:YES action:^(NSInteger index) {
//
//
//                }];
                
                break;
        }
    }];
    
    // 开始监控
    [manager startMonitoring];
}
/**
 *  请求版本更新
 */
- (void)checkAppVerson
{
//    CheckVersonUtils *checkVerson = [CheckVersonUtils shareCheckVersonUtils];
//
//    [checkVerson checkAppVerson];
}


/*
 *  请求个人资料
 */
- (void)requestPhone
{
    NSString *userCityCode = [[NSUserDefaults standardUserDefaults]stringForKey:CityCode];
    NSString *staffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
    
    _getPersonalApi = [[GetPersonalApi alloc] init];
    _getPersonalApi.staffNo = staffNo;
    _getPersonalApi.cityCode = userCityCode;
    [_manager sendRequest:_getPersonalApi];
}

/** 
 *  登陆成功后，更改到首页
 */
- (void)didReceiveLoginSuccessNotification:(NSNotification *)notification
{
    [self addAllChildVC];
    

    if (_customTabBar) {
        [_customTabBar setPlusButtonImage];
    }
    
    self.selectedViewController = [self.viewControllers objectAtIndex:0];
}

- (void)addAllChildVC
{
    NSArray *imgNameArr;
    NSArray *selectImgNameArr;
    
    
    imgNameArr = @[@"tab_home",@"tab_message",@"tab_my"];
    selectImgNameArr = @[@"tab_home_selected",@"tab_massage_selected",@"tab_my_selected"];
    
    
    NewHomePageVC *home = [[NewHomePageVC alloc] init];
    TCNavigationController *homePageNav = [self addOneChildVc:home title:@"首页" imageName:imgNameArr[0] selectedImageName:selectImgNameArr[0]];
    
    JMMessageViewController * message = [[JMMessageViewController alloc] init];
//    MessageViewController *message = [[MessageViewController alloc] init];
    TCNavigationController *messageNav = [self addOneChildVc:message title:@"消息" imageName:imgNameArr[1] selectedImageName:selectImgNameArr[1]];
    message.showNavigationLeftItem = NO;
    
    

    MineViewController *mine = [[MineViewController alloc] init];
    TCNavigationController *mineNav = [self addOneChildVc:mine title:@"我的" imageName:imgNameArr[2] selectedImageName:selectImgNameArr[2]];
    
    [self setViewControllers:@[homePageNav,messageNav,mineNav] animated:NO];
}

/// 添加一个子控制器
- (TCNavigationController *)addOneChildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
	// 设置标题
	childVc.title = title;
	// 设置图标
	childVc.tabBarItem.image = [UIImage imageNamed:imageName];
	
	// 设置选中图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];

	childVc.tabBarItem.selectedImage = selectedImage;
	
	// 添加导航控制器
	TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:childVc];
    
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:YCThemeColorGreen} forState:UIControlStateSelected];
//    [self addChildViewController:nav];
    
    return nav;
}



- (void)showPopMenu
{
	self.popMenuView = [[TCPopMenuView alloc] initWithFrame:CGRectMake(0,
																	   0,
																	   self.view.frame.size.width,
																	   self.view.frame.size.height)];

	[self.view addSubview:self.popMenuView];
    
  
    self.popMenuView.transmitListView.hidden = YES;
    
    
    [self.popMenuView showViewAnimation];
	
	 __weak typeof(self) weakSelf = self;
    
	[self.popMenuView onCLickButtonsWithBlock:^(NSInteger tag) {
        
        if (tag == 100)
        {
            // 实勘
            UIImagePickerController* _imagePicker = [[UIImagePickerController alloc] init];
            _imagePicker.delegate = weakSelf;
            _imagePicker.allowsEditing = NO;
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                // 视频和相册
                NSArray *temp_MediaTypes = [UIImagePickerController availableMediaTypesForSourceType:_imagePicker.sourceType];
                _imagePicker.mediaTypes = temp_MediaTypes;
                [weakSelf presentViewController:_imagePicker animated:YES completion:nil];
            }
            else
            {
                showMsg(@"相机不可用!");
            }
        }
        else if(tag == 101)
        {
            // 首页录音
//            HomePageRecordViewController *homePageRecordVC = [[HomePageRecordViewController alloc]initWithNibName:@"HomePageRecordViewController"
//                                                                                                  bundle:nil];
//            CustomPanNavgationController *nopassNav = [[CustomPanNavgationController alloc] initWithRootViewController:homePageRecordVC];
//            
//            [weakSelf presentViewController:nopassNav
//                                   animated:YES
//                                 completion:nil];
        }
        else
        {
            // 传输列表
            self.videoUploadVC = [[VideoUploadViewController alloc] init];
            CustomPanNavgationController *videoUploadNav = [[CustomPanNavgationController alloc] initWithRootViewController:self.videoUploadVC];
            
            [weakSelf presentViewController:videoUploadNav
                                   animated:YES
                                 completion:^{
                                     [weakSelf.popMenuView hiddenViewAnimation];
                                 }];

        }
	}];
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"])
    {
        // 拍照
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
    else
    {
        // 视频public.movie
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([videoURL path]);
        if (compatible)
        {
            UISaveVideoAtPathToSavedPhotosAlbum([videoURL path], self, nil, nil);
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/// 此方法就在UIImageWriteToSavedPhotosAlbum的上方
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
}

/**
 *  检查未读消息
 */
- (void)checkUnreadMessage
{
	
	BOOL officalMsg = [[NSUserDefaults standardUserDefaults]boolForKey:OfficalMessageRemind];
	BOOL propMsg = [[NSUserDefaults standardUserDefaults] boolForKey:PropMessageRemind];
	BOOL customerMsg = [[NSUserDefaults standardUserDefaults]boolForKey:CustomerMessageRemind];
	BOOL dealMsg = [[NSUserDefaults standardUserDefaults]boolForKey:DealMessageRemind];
	BOOL privateMsg = [[NSUserDefaults standardUserDefaults] boolForKey:PrivateMessageRemind];
	
	if (officalMsg || propMsg || customerMsg || dealMsg || privateMsg)
    {
		[self.tabBar showBadgeOnItemIndex:1];
	}
    else
    {
		[self.tabBar hideBadgeOnItemIndex:1];
	}
}

#pragma mark - ObserveValueForKeyPath

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"UserLoginSuccess"])
    {
        if ([[change objectForKey:@"new"] intValue] == 1)
        {
            // 登录成功，检查服务端版本号，看是否需要更新版本
            CheckAppVersonApi *checkAppVersonApi = [[CheckAppVersonApi alloc] init];
            [_manager sendRequest:checkAppVersonApi];
//            _settingService = [SettingService shareSettingService];
//            _settingService.delegate = self;
//            [_settingService checkAppVersonFromServer];
        }
    }
}

#pragma mark Life Cycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - <AlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
            if (buttonIndex == 1)
            {
                // 去更新
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
                
                exit(0);
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - <TCTabBarDelegate>

- (void)tabBarDidClickedPlusButton:(TCTabBar *)tabBar
{
	[self showPopMenu];
}

#pragma mark <UITabBarDelegate>
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
	
}

#pragma mark-<ResponseDelegate>

- (void)respSuc:(id)data andRespClass:(id)cls
{
    if ([cls isEqual:[CheckVersonEntity class]])
    {
        // 获取服务端版本号成功，使用build verson更新
        CheckVersonEntity *checkVersonEntity = [DataConvert convertDic:data toEntity:cls];
        CheckVersonResultEntity *versonDetailEntity = checkVersonEntity.result;

        // 保存更新地址、更新内容
        [CommonMethod setUserdefaultWithValue:versonDetailEntity.updateUrl
                                       forKey:UpdateVersionUrl];
        [CommonMethod setUserdefaultWithValue:versonDetailEntity.updateContent
                                       forKey:UpdateContent];

        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleVersion"];

        if (versonDetailEntity.forceUpdate == 1)
        {
            // 服务端设置强制更新
            if ([versonDetailEntity.clientVer integerValue] > [app_Version integerValue])
            {
                UIAlertView *forceUpdateAlert = [[UIAlertView alloc]initWithTitle:@"有版本更新"
                                                                          message:versonDetailEntity.updateContent
                                                                         delegate:self
                                                                cancelButtonTitle:nil
                                                                otherButtonTitles:@"更新", nil];
                forceUpdateAlert.tag = ForceUpdateAlertTag;

                [forceUpdateAlert show];
            }
            else
            {
               // 登录成功
                // [self loginSuccessMethod];
            }
            
        }else{
            
            if ([versonDetailEntity.clientVer integerValue] > [app_Version integerValue])
            {
               // 服务端有版本更新，不要求强制更新
                UIAlertView *normalAlertView = [[UIAlertView alloc]initWithTitle:@"有版本更新"
                                                                         message:versonDetailEntity.updateContent
                                                                        delegate:self
                                                               cancelButtonTitle:@"取消"
                                                               otherButtonTitles:@"更新", nil];
                normalAlertView.tag = NormalUpdateAlertTag;

                [normalAlertView show];
            }
            else
            {

                /**
                 *  登录成功
                 */
                // [self loginSuccessMethod];
            }
        }
    }
    // 存储用户手机号
    else if ([cls isEqual:[PersonalInfoEntity class]])
    {
        PersonalInfoEntity *staffInfoEntity = [DataConvert convertDic:data toEntity:cls];
        [CommonMethod setUserdefaultWithValue:staffInfoEntity.mobile forKey:APlusUserMobile];

        [CommonMethod setUserdefaultWithValue:staffInfoEntity.departmentName forKey:APlusUserDepartName];
        [CommonMethod setUserdefaultWithValue:staffInfoEntity.position forKey:APlusUserRoleName];
        [CommonMethod setUserdefaultWithValue:staffInfoEntity.photoPath forKey:APlusUserPhotoPath];
    }

    // 系统参数
    else if ([cls isEqual:[SystemParamEntity class]])
    {
        SystemParamEntity * systemParamEntity = [DataConvert convertDic:data toEntity:cls];
        if(systemParamEntity.needUpdate)
        {
            [AgencySysParamUtil setSystemParam:systemParamEntity];
        }
        else
        {
            NSLog(@"系统参数不需要更新");
        }
    }

}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{

}

@end
