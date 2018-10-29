//
//  AdLoadingViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/12.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AdLoadingViewController.h"

#import "JMAlertExitAppView.h"

#import "LogOffUtil.h"
#import "ManageAccountLockStatusApi.h"
#import "LockStatusEntity.h"
#import "GetSystemParamApi.h"
#import "GetAdApi.h"
#import "GetAdEntity.h"


@interface AdLoadingViewController ()<MessageChangeDelegate,UIWebViewDelegate>
{
    GetSystemParamApi *_systemParamApi;

    
    UIImageView * _adLoadingLogoImageView;          //APP的logo
    UIImageView * _adLoadingRedCircleImageView;     //红色的logo背景图
    UIImageView * _adLoadingWhiteBgImageView;       //白色镂空背景
    UIImageView * _adLoadingButtomEstateImageView;  //底部房子图片
    
    UILabel *_adLoadingButtomVersion;               //底部APP版本号
    
    __weak IBOutlet UIImageView *_adLoadingRedBgImageView;

    UIWebView *_webView;
    UIView *_interimView;
    
    
    BOOL _loadAnimationSuccess;         //是否完成动画过程
    BOOL _isNowRequest;                 //是否正在请求系统参数
    BOOL _systemParamDone;              //是否完成获取系统参数
    BOOL _unlockInfoDone;               //是否完成获取解锁状态
}

@property (nonatomic, assign) BOOL isLockAccount;//是否锁定账号

@end

@implementation AdLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _unlockInfoDone = NO;
    _systemParamDone = NO;
    
    _loadAnimationSuccess = NO;
    [self sharedAppDelegate].messageDelegate = self;

    [self requestAdView];
}

#pragma mark - *******加载广告页********

- (void)requestAdView {
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    _webView.delegate = self;
    _webView.hidden = YES;
    _webView.scalesPageToFit = YES;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.scrollEnabled = NO;
    [self.view addSubview:_webView];

    _interimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    [self.view addSubview:_interimView];
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake((APP_SCREEN_WIDTH - 70) / 2, 180, 70, 70)];
    logoImgView.tag = 1111;
    logoImgView.contentMode = UIViewContentModeScaleAspectFit;
//    logoImgView.image = [UIImage imageNamed:@"appsss"];
    [_interimView addSubview:logoImgView];
    UIImageView *bottomImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,APP_SCREEN_HEIGHT - 61 , APP_SCREEN_WIDTH, 61)];
    bottomImgView.tag = 2222;
    bottomImgView.image = [UIImage imageNamed:@"adLoadingButtomShortEstateImage"];
    [_interimView addSubview:bottomImgView];

    GetAdApi *getAdApi = [[GetAdApi alloc] init];
    [_manager sendRequest:getAdApi];
}

#pragma mark － <加载启动动画>
-(void)initLoadView
{
    // UIImage *redCircleImage = [UIImage imageNamed:@"adLoadingRedCircleBg"];
    UIImage *appLogoImage = [UIImage imageNamed:@"appsss"];
    UIImage *buttomEstateImage = [UIImage imageNamed:@"adLoadingButtomEstateImageView"];

    _adLoadingRedCircleImageView = [[UIImageView alloc]init];
    
    [_adLoadingRedCircleImageView setFrame:CGRectMake(APP_SCREEN_WIDTH/2-80,
                                                      152,
                                                      160,
                                                      160)];
    [self.view addSubview:_adLoadingRedCircleImageView];

    _adLoadingLogoImageView = [[UIImageView alloc]init];
    [_adLoadingLogoImageView setImage:appLogoImage];
    [_adLoadingLogoImageView setFrame:CGRectMake(APP_SCREEN_WIDTH/2-35,
                                                 64,
                                                 70,
                                                 70)];
    [self.view addSubview:_adLoadingLogoImageView];

    _adLoadingButtomEstateImageView = [[UIImageView alloc]init];
    [_adLoadingButtomEstateImageView setImage:buttomEstateImage];
    [_adLoadingButtomEstateImageView setFrame:CGRectMake(0,
                                                         APP_SCREEN_HEIGHT - 62.0,
                                                         APP_SCREEN_WIDTH/320.0*640,
                                                         62.0)];
    [self.view addSubview:_adLoadingButtomEstateImageView];

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [NSString stringWithFormat:@"版本号：%@",
                             [infoDictionary objectForKey:@"CFBundleShortVersionString"]];

   CGFloat btnY = IS_iPhone_X ?APP_SCREEN_HEIGHT-62:APP_SCREEN_HEIGHT-28;
    
    _adLoadingButtomVersion = [[UILabel alloc]init];
    [_adLoadingButtomVersion setFont:[UIFont fontWithName:FontName
                                                     size:14.0]];
    [_adLoadingButtomVersion setFrame:CGRectMake(0,
                                                 btnY,
                                                 APP_SCREEN_WIDTH,
                                                 16)];
    [_adLoadingButtomVersion setTextAlignment:NSTextAlignmentCenter];
    [_adLoadingButtomVersion setBackgroundColor:[UIColor clearColor]];
    [_adLoadingButtomVersion setTextColor:LITTLE_BLACK_COLOR];
    [_adLoadingButtomVersion setText:app_Version];

    [self.view addSubview:_adLoadingButtomVersion];

    [self performSelector:@selector(createAnimation)
               withObject:nil
               afterDelay:0.5];
}

#pragma mark-移除伪造背景试图
- (void)removeAllView{
    UIImageView *imgView1 = [_interimView viewWithTag:1111];
    UIImageView *imgView2 = [_interimView viewWithTag:2222];
    [imgView1 removeFromSuperview];
    imgView1 = nil;
    [imgView2 removeFromSuperview];
    imgView2 = nil;
    [_interimView removeFromSuperview];
    _interimView = nil;
    [_webView removeFromSuperview];
    _webView = nil;
}

#pragma mark - <获取系统参数>

- (void)requestSystemPara{
    /**
     *  获取系统参数
     */

    _isNowRequest = YES;

    NSString *sysParamNewUpdTime = [AgencySysParamUtil getSysParamNewUpdTime];

    NSLog(@"上次系统参数更新时间%@",sysParamNewUpdTime);

    GetSystemParamApi *systemParamApi = [[GetSystemParamApi alloc] init];
    systemParamApi.updateTime = sysParamNewUpdTime;

    NSString *staffNum = [CommonMethod getUserdefaultWithKey:UserStaffNumber];
    if (staffNum.length > 0) {

        _systemParamApi = [GetSystemParamApi new];
        _systemParamApi.updateTime = sysParamNewUpdTime;
        [_manager sendRequest:_systemParamApi];

    }else{

        _systemParamDone = YES;
    }

    NSString *session = [[NSUserDefaults standardUserDefaults]stringForKey:HouseKeeperSession];

    if (!session || [session isEqualToString:@""]) {
        _unlockInfoDone = YES;
    }else{
        ManageAccountLockStatusApi *manageAccountLockStatusApi = [[ManageAccountLockStatusApi alloc] init];
        manageAccountLockStatusApi.ManageAccountLockStatusType = GetAccountLockStatus;
        manageAccountLockStatusApi.mobile = [CommonMethod getUserdefaultWithKey:UserStaffMobile];
        [_manager sendRequest:manageAccountLockStatusApi];
    }
}


#pragma mark - <UIWebViewDelegate>
//网页成功加载完成之后
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIView animateWithDuration:0.5 animations:^{
        [_interimView removeFromSuperview];
        _webView.hidden = NO;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(checkSysParamMethod) withObject:nil afterDelay:5];
    }];
}

//网页加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //删除伪造背景
    [self removeAllView];

    //显示加载动画
    [self initLoadView];

    //加载系统参数
    [self requestSystemPara];

}




#pragma mark - AnimationMethod
-(void)createAnimation
{
    
    __weak typeof (self)weakSelf = self;
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         
                         [weakSelf moveButtomEstImageMethod];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              
                                              [weakSelf changeLogoBgImageMethod];
                                          }
                                          completion:^(BOOL finished) {
                                              
                                              [UIView animateWithDuration:0.5
                                                               animations:^{
                                                                  
                                                                  // [weakSelf moveAppIconImageMethod];
                                                               }
                                                               completion:^(BOOL finished) {
                                                                   
                                                                   [weakSelf checkSysParamMethod];
                                                               }];
                                          }];
                     }];
    
}

-(void)moveButtomEstImageMethod
{
    
    [_adLoadingButtomEstateImageView setFrame:CGRectMake(-320,
                                                         _adLoadingButtomEstateImageView.frame.origin.y,
                                                         _adLoadingButtomEstateImageView.frame.size.width,
                                                         _adLoadingButtomEstateImageView.frame.size.height)];
}

-(void)changeLogoBgImageMethod
{
    
    _adLoadingRedBgImageView.alpha = 1.0;
    _adLoadingRedCircleImageView.transform = CGAffineTransformMakeScale(10.0, 10.0);
    _adLoadingRedCircleImageView.alpha = 0;
}

-(void)moveAppIconImageMethod
{
    
    [_adLoadingLogoImageView setFrame:CGRectMake(_adLoadingLogoImageView.frame.origin.x,
                                                 80,
                                                 _adLoadingLogoImageView.bounds.size.width,
                                                 _adLoadingLogoImageView.bounds.size.height)];
}

#pragma mark - NetWorkDelegate
-(void)networkStatusChanged:(BOOL)isReachable
{
    SystemParamEntity *sysParamEntity = [AgencySysParamUtil getSystemParam];
    
    if (isReachable &&
        !_isNowRequest &&
        !sysParamEntity) {
        
        _isNowRequest = YES;

        NSString *staffNum = [CommonMethod getUserdefaultWithKey:UserStaffNumber];
        if (staffNum.length > 0){
            NSString *sysParamNewUpdTime = [AgencySysParamUtil getSysParamNewUpdTime];
            // sysParamNewUpdTime = @"2015-02-03";
            _systemParamApi = [GetSystemParamApi new];
            _systemParamApi.updateTime = sysParamNewUpdTime;
            [_manager sendRequest:_systemParamApi];

        }
    }
}

#pragma mark - 做完动画后检查“系统参数”是否获取完成
-(void)checkSysParamMethod{
    
    if (self.isLockAccount) {
        
        return;
        
    }
    
    _loadAnimationSuccess = YES;

    
    if(_unlockInfoDone && _systemParamDone){
        [_delegate getSysParamSuccessed];
    }
    
}


#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[GetAdEntity class]]) {
        GetAdEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        NSLog(@"%@",entity);
        if (entity.result.length > 0) {
            //加载系统参数
            [self requestSystemPara];

            NSURL *requestUrl = [NSURL URLWithString:entity.result];
            NSURLRequest *mrequest = [NSURLRequest requestWithURL:requestUrl
                                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                  timeoutInterval:5.0];//不自动缓存
            [_webView loadRequest:mrequest];
        }else{
            //删除网页
            //删除伪造背景
            [self removeAllView];

            //显示加载动画
            [self initLoadView];

            //加载系统参数
            [self requestSystemPara];

        }
    }


    if ([modelClass isEqual:[SystemParamEntity class]])
    {
        _isNowRequest = NO;
        _systemParamDone = YES;
        
        SystemParamEntity * systemParamEntity = [DataConvert convertDic:data toEntity:modelClass];
        if(systemParamEntity.needUpdate)
        {
            [AgencySysParamUtil setSystemParam:systemParamEntity];
            NSLog(@"系统参数有更新");
            if (_loadAnimationSuccess) {
                
                [self checkSysParamMethod];
            }
        }else{
            NSLog(@"系统参数不需要更新");
        }
    }


    if ([modelClass isEqual:[LockStatusEntity class]])
    {
        _unlockInfoDone = YES;
        
        LockStatusEntity *lockStatusEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        BOOL isLocked = [lockStatusEntity.result boolValue];
        
        if (isLocked == true) {//锁定
            
            JMAlertExitAppView * exitView = [JMAlertExitAppView viewFromXib];
            
            exitView.frame = self.view.bounds;
            
            self.isLockAccount = YES;
            
            [self.view addSubview:exitView];
            
        }else{
            
            if (isLocked == true) {
                [self sharedAppDelegate].isForceUnLock = YES;
            }else{
                [self sharedAppDelegate].isForceUnLock = NO;
            }
            NSLog(@"是否要强制解锁:%@",[self sharedAppDelegate].isForceUnLock?@"是":@"否");
            if (_loadAnimationSuccess) {
                
                [self checkSysParamMethod];
            }
            if ([lockStatusEntity.result integerValue] == 1) {
                //清空原来手势密码
                [CLLockVC clearCoreLockPWDKey];
            }
            
        }
        
    }

}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    if([cls isEqual:[LockStatusEntity class]]){
        _unlockInfoDone = YES;
        //需要跳转到登录页

        /**
         *  用户退出登录后清除用户信息
         */
        [LogOffUtil clearUserInfoFromLocal];

        [[self sharedAppDelegate] changeDiscoverRootVCIsLogin:YES];
    }

    _isNowRequest = NO;

    if (_loadAnimationSuccess) {

        [self checkSysParamMethod];
    }

    if ([cls isEqual:[GetAdEntity class]]) {
        //删除伪造背景
        [self removeAllView];

        //显示加载动画
        [self initLoadView];

        //加载系统参数
        [self requestSystemPara];
    }

}



@end
