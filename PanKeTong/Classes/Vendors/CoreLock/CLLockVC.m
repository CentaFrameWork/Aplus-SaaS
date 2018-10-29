//
//  CLLockVC.m
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockVC.h"
#import "CLLockNavVC.h"
#import "JMAlertResetGesturesViewController.h"

#import "JMAlertExitAppView.h"
#import "CLLockLabel.h"
#import "CLLockView.h"

#import "ManageAccountLockStatusApi.h"
#import "LockStatusEntity.h"
#import "LogOffUtil.h"
#import "CoreLockConst.h"
#import "RequestManager.h"
#import "HudViewUtil.h"

#import "NotificationNameDefine.h"
#import "AppDelegate.h"

#import "UIViewController+Category.h"

@interface CLLockVC ()<ResponseDelegate>

/** 操作成功：密码设置成功、密码验证成功 */
@property (nonatomic,copy) void (^successBlock)(CLLockVC *lockVC,NSString *pwd);

@property (nonatomic,copy) void (^forgetPwdBlock)(CLLockVC *lockVC);

@property (nonatomic,copy) void (^achieveErrorLimitBlock)(CLLockVC *lockVC);

@property (nonatomic, strong) JMAlertResetGesturesViewController * alertRGCon;

@property (weak, nonatomic) IBOutlet CLLockLabel *label;

@property (weak, nonatomic) IBOutlet CLLockView *lockView;

@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forgetPwdBtnBottomCon;

//@property (weak, nonatomic) IBOutlet UIView *actionView;

//@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;

@property (nonatomic, strong) RequestManager * manager;

@property (nonatomic, strong) HudViewUtil * hudViewUtil;

@property (nonatomic,copy) NSString *msg;

@property (nonatomic,weak) UIViewController *vc;

@property (nonatomic,strong) UIBarButtonItem *resetItem;

@property (nonatomic,copy) NSString *modifyCurrentTitle;

@property (nonatomic,assign) BOOL isShowNavClose;

/** 直接进入修改页面的 */
@property (nonatomic,assign) BOOL isDirectModify;

//是否可以在点击返回按钮的时候展示此提醒
@property (nonatomic, assign) BOOL isCanAlertRGCon;

@property (nonatomic, assign) BOOL isLockAccount;//是否锁定账号



@end

@implementation CLLockVC

- (instancetype)init{
    
    return [CLLockVC viewControllerFromStoryboard];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //初始化界面
    [self loadMainView];
    [self loadNavigationBar];
    
    //控制器准备
    [self vcPrepare];
    
    //数据传输
    [self dataTransfer];
    
    //事件
    [self event];
    
    //获取账号锁定状态
    BOOL accountLockStatus = [[CommonMethod getUserdefaultWithKey:AccountLockStatus] boolValue];
    if (accountLockStatus == true) {
        
        [self requestForGetLockStatus];
        
    }
}

- (void)loadMainView{
    
    self.hudViewUtil = [[HudViewUtil alloc] init];
    
    self.forgetPwdBtnBottomCon.constant = BOTTOM_SAFE_HEIGHT + 23*NewRatio;
    
    self.lockView.backgroundColor = [UIColor whiteColor];
    
    self.backBtn.hidden = YES;
    
    self.isCanAlertRGCon = false;
    
    self.forgetPwdBtn.hidden = self.forgetPwdBlock == nil;
    
}

- (void)loadNavigationBar{
    
    self.navigationController.navigationBarHidden = YES;
    
}

/*
 *  事件
 */
-(void)event {
    
    self.resetBtn.hidden = YES;
    
    __block typeof(self) weakSelf = self;
    
    /*
     *  设置密码
     */
    
    /** 开始输入：第一次 */
    self.lockView.setPWBeginBlock = ^(){
        
        [self.label showNormalMsg:CoreLockPWDTitleFirst];
    };
    
    /** 开始输入：确认 */
    self.lockView.setPWConfirmlock = ^(){
        
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
    };
    
    
    /** 密码长度不够 */
    self.lockView.setPWSErrorLengthTooShortBlock = ^(NSUInteger currentCount){
        
        [self.label showWarnMsg:[NSString stringWithFormat:@"请连接至少%@个点",@(CoreLockMinItemCount)]];
    };
    
    /** 两次密码不一致 */
    self.lockView.setPWSErrorTwiceDiffBlock = ^(NSString *pwd1,NSString *pwdNow){
        
        [self.label showWarnMsg:CoreLockPWDDiffTitle];
        
        weakSelf.resetBtn.hidden = NO;
        
        self.navigationItem.rightBarButtonItem = self.resetItem;
    };
    
    /** 第一次输入密码：正确 */
    self.lockView.setPWFirstRightBlock = ^(){
        
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
        
        //在第一次输入正确情况下，第二次误触返回按钮
        weakSelf.isCanAlertRGCon = true;
        
    };
    
    /** 再次输入密码一致 */
    self.lockView.setPWTwiceSameBlock = ^(NSString *pwd){
        
        [self.label showNormalMsg:CoreLockPWSuccessTitle];
        
        //存储密码
        [CLLockVC setStr:pwd key:CoreLockPWDKey];
        
        //禁用交互
        self.view.userInteractionEnabled = NO;
        
        if(_successBlock != nil) _successBlock(self,pwd);
        
        if(CoreLockTypeModifyPwd == _type){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    };
    
    
    
    /*
     *  验证密码
     */
    
    /** 开始 */
    self.lockView.verifyPWBeginBlock = ^(){
        
        [self.label showNormalMsg:CoreLockVerifyNormalTitle];
    };
    
    /** 验证 */
    self.lockView.verifyPwdBlock = ^(NSString *pwd)
    {
        //取出本地密码
        NSString *pwdLocal = [CLLockVC strForKey:CoreLockPWDKey];
        
        BOOL res = [pwdLocal isEqualToString:pwd];
        
        if(res)
        {
            //密码一致
            [self.label showNormalMsg:CoreLockVerifySuccesslTitle];
            
            if(CoreLockTypeVeryfiPwd == _type)
            {
                //禁用交互
                self.view.userInteractionEnabled = NO;
                
            }
            else if (CoreLockTypeModifyPwd == _type)
            {
                //修改密码
                [self.label showNormalMsg:CoreLockPWDTitleFirst];
                self.modifyCurrentTitle = CoreLockPWDTitleFirst;
            }
            
            if(CoreLockTypeVeryfiPwd == _type)
            {
                if(_successBlock != nil) _successBlock(self,pwd);
            }
        }
        else
        {
            
            if(_errorCount >= _errorLimit-1){
                //禁用交互
                self.lockView.userInteractionEnabled = NO;
                //密码错误次数达到上限
                [self.label showWarnMsg:CoreLockVerifyErrorLimitTitle];
                
                //修改334bug新增写入本地，保存错误次数
                [CommonMethod setUserdefaultWithValue:[NSString stringWithFormat:@"%ld", _errorCount + 1] forKey:ErrorTimes];
                
                if(_achieveErrorLimitBlock != nil)
                    
                    _achieveErrorLimitBlock(self);
                
                return res;
                
            }else{
                
                _errorCount++;
                
                [self.label showWarnMsg:[NSString stringWithFormat:@"密码错误，你还可以再输入%ld次",_errorLimit-_errorCount]];
                
                // 保存错误次数
                [CommonMethod setUserdefaultWithValue:[NSString stringWithFormat:@"%d",(int)_errorCount] forKey:ErrorTimes];
                
            }
            
        }
        
        return res;
    };
    
    
    
    /*
     *  修改
     */
    
    /** 开始 */
    self.lockView.modifyPwdBlock =^(){
        
        [self.label showNormalMsg:self.modifyCurrentTitle];
    };
}

/*
 *  数据传输
 */
-(void)dataTransfer{
    
    [self.label showNormalMsg:self.msg];
    
    //传递类型
    self.lockView.type = self.type;
}

/*
 *  控制器准备
 */
-(void)vcPrepare {
    
    NSString *lastErrorTimes = [CommonMethod getUserdefaultWithKey:ErrorTimes];
    if(lastErrorTimes)
    {
        _errorCount = [lastErrorTimes intValue];
    }
    
    //设置背景色
    self.view.backgroundColor = CoreLockViewBgColor;
    BOOL isOn = [[CommonMethod getUserdefaultWithKey:FaceRecogSwitch] boolValue];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (appDelegate.showFaceRecog && isOn && [self.title isEqualToString:@"手势解锁"] && [CityCodeVersion isTianJin])
    {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, 92*NewRatio, 29*NewRatio);
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBtn setTitle:@"刷脸登录" forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14*NewRatio];
        rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [rightBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                target:nil
                                                action:nil];
        rightNegativeSpacer.width = -15*NewRatio;
        //初始情况隐藏
        self.navigationItem.rightBarButtonItems = @[rightNegativeSpacer,rightBar];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //默认标题
    self.modifyCurrentTitle = CoreLockModifyNormalTitle;
    
    if(CoreLockTypeModifyPwd == _type||CoreLockTypeSetPwd ==_type) {
        
        //修改UI去掉
        //        _actionView.hidden = YES;
        //
        //        [_actionView removeFromSuperview];
        
        if(_isDirectModify) return;
        
        if(_isShowNavClose){
            
            self.backBtn.hidden = NO;
            
            UIButton *leftButton = [self customBarItemButton:@"关闭" sel:@selector(dismiss)];
            
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        }
    }
    
    if(![self.class hasPwd]) {
        //修改UI去掉
        //        [_modifyBtn removeFromSuperview];
    }
}

-(void)dismiss {
    [self dismiss:0];
}

/*
 *  密码重设
 */
-(void)setPwdReset{
    
    [self.label showNormalMsg:CoreLockPWDTitleFirst];
    
    //隐藏
    self.navigationItem.rightBarButtonItem = nil;
    
    //通知视图重设
    [self.lockView resetPwd];
}

/*
 *  忘记密码
 */
-(void)forgetPwd{
    
}

/*
 *  修改密码
 */
-(void)modiftyPwd{
    
}

/*
 *  是否有本地密码缓存？即用户是否设置过初始密码？
 */
+(BOOL)hasPwd{
    
    NSString *pwd = [CLLockVC strForKey:CoreLockPWDKey];
    
    return pwd !=nil;
}




/*
 *  展示设置密码控制器
 */
+(instancetype)showSettingLockVCInVC:(UIViewController *)vc
                        successBlock:(void(^)(CLLockVC *lockVC,NSString *pwd))successBlock
                      isShowNavClose:(BOOL)isShowNavClose
{
    
    CLLockVC *lockVC = [self lockVC:vc];
    lockVC.isShowNavClose = isShowNavClose;
    
    lockVC.title = @"设置手势密码";
    
    //设置类型
    lockVC.type = CoreLockTypeSetPwd;
    
    //保存block
    lockVC.successBlock = successBlock;
    
    return lockVC;
}

/*
 *  展示验证密码输入框
 */
+(instancetype)showVerifyLockVCInVC:(UIViewController *)vc
                     forgetPwdBlock:(void(^)(CLLockVC *lockVC))forgetPwdBlock
                       successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock
                         errorLimit:(NSInteger)errorLimit
             achieveErrorLimitBlock:(void(^)(CLLockVC *lockVC))achieveErrorLimitBlock
{
    
    CLLockVC *lockVC = [self lockVC:vc];
    lockVC.errorLimit = errorLimit;
    lockVC.errorCount = 0;
    lockVC.achieveErrorLimitBlock = achieveErrorLimitBlock;
    
    lockVC.title = @"手势解锁";
    
    //设置类型
    lockVC.type = CoreLockTypeVeryfiPwd;
    
    //保存block
    lockVC.successBlock = successBlock;
    lockVC.forgetPwdBlock = forgetPwdBlock;
    
    return lockVC;
}

- (void)dismissVC
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ChangeVerifyType object:@"Face"];
}

/*
 *  展示验证密码输入框
 */
+(instancetype)showModifyLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock{
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"修改密码";
    
    //设置类型
    lockVC.type = CoreLockTypeModifyPwd;
    
    //记录
    lockVC.successBlock = successBlock;
    
    return lockVC;
}

+(instancetype)lockVC:(UIViewController *)vc{
    
    CLLockVC *lockVC = [[CLLockVC alloc] init];
    
    lockVC.vc = vc;
    
    CLLockNavVC *navVC = [[CLLockNavVC alloc] initWithRootViewController:lockVC];
    
    [vc presentViewController:navVC animated:YES completion:nil];
    
    return lockVC;
}

-(void)setType:(CoreLockType)type{
    
    _type = type;
    
    //根据type自动调整label文字
    [self labelWithType];
}

/*
 *  根据type自动调整label文字
 */
-(void)labelWithType{
    
    if(CoreLockTypeSetPwd == _type){//设置密码
        
        self.msg = CoreLockPWDTitleFirst;
        
    }else if (CoreLockTypeVeryfiPwd == _type){//验证密码
        
        self.msg = CoreLockVerifyNormalTitle;
        
    }else if (CoreLockTypeModifyPwd == _type){//修改密码
        
        self.msg = CoreLockModifyNormalTitle;
    }
}

/*
 *  消失
 */
-(void)dismiss:(NSTimeInterval)interval{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            if ([CityCodeVersion isNanJing]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Dismiss" object:nil];
            }
            else if ([CityCodeVersion isTianJin])
            {
                //天津新增约看时---处理收到约看推送时跳转到约看列表
                NSInteger intNum = [[CommonMethod getUserdefaultWithKey:AddTakingSeeRemind] integerValue];
                if (intNum == 1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"HaveDismiss" object:nil];
                }
                
            }
        }];
    });
}

- (void)dismissNow{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 *  重置
 */
-(UIBarButtonItem *)resetItem{
    
    if(_resetItem == nil){
        //添加右按钮
        //        _resetItem= [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(setPwdReset)];
        UIButton *rightButton = [self customBarItemButton:@"重设"
                                                      sel:@selector(setPwdReset)];
        
        _resetItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    }
    
    return _resetItem;
    
}


- (UIButton *)customBarItemButton:(NSString *)title
                              sel:(SEL)sel {
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIFont *font = [UIFont fontWithName:FontName
                                   size:15*NewRatio];
    
    CGFloat titleWidth = [title getStringWidth:[UIFont fontWithName:FontName
                                                               size:15*NewRatio]
                                        Height:44*NewRatio
                                          size:15*NewRatio];
    
    if (!title ||
        [title isEqualToString:@""]) {
        
        titleWidth = 45*NewRatio;
    }
    [customBtn setFrame:CGRectMake(0, 0, titleWidth, 44*NewRatio)];
    [customBtn setBackgroundColor:[UIColor clearColor]];
    [customBtn setTitleShadowColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
    customBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    
    
    if (title) {
        
        [customBtn setTitle:title forState:UIControlStateNormal];
    }
    
    [customBtn.titleLabel setFont:font];
    [customBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (sel) {
        [customBtn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    }
    
    return customBtn;
}

#pragma mark - 按钮点击事件
- (IBAction)forgetPwdAction:(id)sender {
    
    //    [self dismiss:0];
    if(_forgetPwdBlock != nil) _forgetPwdBlock(self);
}

- (IBAction)backBtnClick:(UIButton *)sender {
    
    if (self.isCanAlertRGCon) {
        
        [self.view bringSubviewToFront:self.alertRGCon.view];
        
        self.alertRGCon.view.hidden = NO;
        
    }else{
        
        [self dismiss:0];
        
    }
    
}


- (IBAction)resetBtnClick:(UIButton *)sender {
    
    [self setPwdReset];
    
    self.resetBtn.hidden = YES;
    
    self.isCanAlertRGCon = false;
    
}


- (IBAction)modifyPwdAction:(id)sender {
    
    CLLockVC *lockVC = [[CLLockVC alloc] init];
    lockVC.errorLimit = _errorLimit;
    
    lockVC.title = @"修改密码";
    
    lockVC.isDirectModify = YES;
    
    //设置类型
    lockVC.type = CoreLockTypeModifyPwd;
    
    [self.navigationController pushViewController:lockVC animated:YES];
}

#pragma mark - private & public
//保存普通对象
+(void)setStr:(NSString *)str key:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //保存
    [defaults setObject:str forKey:key];
    
    //立即同步
    [defaults synchronize];
    
}

//读取
+(NSString *)strForKey:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    NSString *str=(NSString *)[defaults objectForKey:key];
    
    return str;
    
}

/*
 *  清空手势密码
 */
+ (void)clearCoreLockPWDKey
{
    [CommonMethod setUserdefaultWithValue:nil forKey:CoreLockPWDKey];
}

-(void)resetValidPwd
{
    [self.label showNormalMsg:CoreLockVerifyNormalTitle];
    self.lockView.userInteractionEnabled = YES;
    _errorCount = 0;
}

-(void)userInteractionDisEnabled
{
    self.lockView.userInteractionEnabled = NO;
}

- (JMAlertResetGesturesViewController *)alertRGCon{
    
    if (!_alertRGCon) {
        
        _alertRGCon = [[JMAlertResetGesturesViewController alloc] init];
        
        _alertRGCon.view.backgroundColor = rgba(0, 0, 0, 0.3);
        
        __block typeof(self) weakSelf = self;
        
        [_alertRGCon setCancleBtnClickBlock:^{
            
            weakSelf.alertRGCon.view.hidden = YES;
            
        }];
        
        [_alertRGCon setEnsureBtnClickBlock:^{
            
            [weakSelf.alertRGCon.view removeFromSuperview];
            
            weakSelf.alertRGCon = nil;
            
            [weakSelf dismiss:0];
            
        }];
        
        [self.view addSubview:_alertRGCon.view];
        
        [self addChildViewController:_alertRGCon];
        
    }
    
    return _alertRGCon;
    
}

- (AppDelegate *)sharedAppDelegate{
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - request
- (void)requestForGetLockStatus{
    [self.hudViewUtil showLoadingView:nil];
    RequestManager * manager = [RequestManager initManagerWithDelegate:self];
    ManageAccountLockStatusApi *manageAccountLockStatusApi = [[ManageAccountLockStatusApi alloc] init];
    manageAccountLockStatusApi.ManageAccountLockStatusType = GetAccountLockStatus;
    manageAccountLockStatusApi.mobile = [CommonMethod getUserdefaultWithKey:UserStaffMobile];
    [manager sendRequest:manageAccountLockStatusApi];
    self.manager = manager;
    
}
#pragma mark - <ResponseDelegate>
- (void)respSuc:(id)data andRespClass:(id)cls{
    
    [self.hudViewUtil hiddenLoadingView];
    
    if ([cls isEqual:[LockStatusEntity class]]){
        
        LockStatusEntity *lockStatusEntity = [DataConvert convertDic:data toEntity:cls];
        
        BOOL isLocked = [lockStatusEntity.result boolValue];
        
        if (isLocked == true) {//锁定
            
            JMAlertExitAppView * exitView = [JMAlertExitAppView viewFromXib];
            
            exitView.frame = self.view.bounds;
            
            self.isLockAccount = YES;
            
            UIWindow * window = [UIApplication sharedApplication].keyWindow;
            
            [window addSubview:exitView];
            
        }else{
            
            [self sharedAppDelegate].isForceUnLock = NO;
            
            // 保存锁定状态
            [CommonMethod setUserdefaultWithValue:@(false) forKey:AccountLockStatus];
            //清空手势错误次数
            [CommonMethod setUserdefaultWithValue:@"0" forKey:ErrorTimes];
            
            _errorCount = 0;
            
//            NSInteger errorTimes = [[NSString stringWithFormat:@"%@", [CommonMethod getUserdefaultWithKey:ErrorTimes]] integerValue];
            
//            if ([lockStatusEntity.result integerValue] == 1) {
//                //清空原来手势密码
//                [CLLockVC clearCoreLockPWDKey];
//            }
            
            
            
        }
        
    }
    
}

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    
    [self.hudViewUtil hiddenLoadingView];
    
    if([cls isEqual:[LockStatusEntity class]]){
        //需要跳转到登录页
        
        /**
         *  用户退出登录后清除用户信息
         */
        [LogOffUtil clearUserInfoFromLocal];
        
        [[self sharedAppDelegate] changeDiscoverRootVCIsLogin:YES];
    }
    
}


#pragma mark - 系统协议
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    NSLog(@"-------->%@", key);
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

@end
