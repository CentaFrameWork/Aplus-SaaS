//
//  AlertInputPwdView.m
//  PanKeTong
//
//  Created by 燕文强 on 16/3/29.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "AlertInputPwdView.h"
#import "CommonMethod.h"
#import "LoginApi.h"
#import "ServiceHelper.h"
#import "CheckHttpErrorUtil.h"

#import "CAShapeLayer+Category.h"

#define WaitMinute              60  // 等待多少分
#define WaitSecond              60  // 等待多少秒
#define APlusPwdErrorTime       @"APlusPwdErrorTime"

@interface AlertInputPwdView()

@property (weak, nonatomic) IBOutlet UIView *pwdContainView;


@end

@implementation AlertInputPwdView
{
    LoginApi *_loginApi;
    RequestManager *_manager;
    
    NSInteger _count;
    BOOL isLoginStatus;
    
    Error *_error;
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //陈行修改UI新增
    [self.ensureBtn setLayerCornerRadius:5];
    [self.pwdContainView setLayerCornerRadius:5];
    self.ensureBtn.backgroundColor = YCThemeColorGreen;
    self.resultLabel.text = @"";
    self.resultLabel.textColor = CoreLockWarnColor;
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchClickWithTgr:)];
    [self addGestureRecognizer:tgr];
    
    isLoginStatus = NO;
    _manager = [RequestManager initManagerWithDelegate:self];
//    // 禁止边缘滑动
//    _keyboardScrollView.scrollEnabled = NO;
    
    _isShowPwd = 0;
    _pwdTextField.secureTextEntry = YES;
    _errorLimit = 5;
    _count = WaitMinute * WaitSecond;
    
    _pwdTextField.tag = 10;
    _pwdTextField.delegate = self;
    [_pwdTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // 获取已错误次数
    _errorCount = 0;
    NSString *lastErrorTimes = [CommonMethod getUserdefaultWithKey:ErrorTimes];
    if(lastErrorTimes){
        _errorCount = [lastErrorTimes intValue];
    }
    
    // 检查错误时间
    NSDate *date = [CommonMethod getUserdefaultWithKey:APlusPwdErrorTime];
    if(!date){
        [CommonMethod setUserdefaultWithValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:APlusPwdErrorTime];
    }
    
    
    // 检查是否达到一小时,是否还需要继续锁定状态
    BOOL forceLock = [AlertInputPwdView isForceLock];
    if(forceLock){
        NSTimeInterval timeInterval = [AlertInputPwdView getTimeIntervalForLastErrorTime];
        NSInteger timerNumber = WaitSecond * WaitMinute - (-timeInterval)/1;
        _count = timerNumber;
        
        _resultLabel.text = [NSString stringWithFormat:@"为了保护您的帐号安全，请于%ld:%.2ld分钟后重试！",_count/60,_count%60];
        
        [self startThread];
        
    }
    
    [self.pwdContainView.layer addSublayer:[CAShapeLayer shaperLayerAddLineFromPoint:CGPointMake(24, 116) toPoint:CGPointMake(APP_SCREEN_WIDTH - 36*2, 116) andColor:YCTextColorAuxiliary]];
    
}

- (void)validLoginWithPwd:(NSString *)pwd
{
    NSString *account = [CommonMethod getUserdefaultWithKey:Account];
    
    _loginApi = [LoginApi new];
    _loginApi.account = account;
    _loginApi.psd = pwd;
    [_manager sendRequest:_loginApi];
}

- (IBAction)okClick:(id)sender
{
    [self okClickEvent];
}

- (void)okClickEvent
{
    if(isLoginStatus){
        return;
    }
    isLoginStatus = YES;
    NSLog(@"======登录=====");
    
    BOOL forceLock = [AlertInputPwdView isForceLock];
    if(forceLock)
    {
        return;
    }
    
    if(_errorCount > _errorLimit){
        
        isLoginStatus = NO;
        if(_delegate) [_delegate locked];
        
        // 保存错误后强制锁定时间
        [CommonMethod setUserdefaultWithValue:[NSDate date] forKey:APlusPwdErrorTime];
        
        NSDate *date = [CommonMethod getUserdefaultWithKey:APlusPwdErrorTime];
        
        NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
        if(timeInterval > -60 * 60){
            [self startThread];
        }
        
        return;
    }
    
    [self validLoginWithPwd:_pwdTextField.text];
}

- (IBAction)closeBtnClick:(id)sender {
    
    [self removeWindow];
}

- (void)removeWindow
{
    //    [self resignKeyWindow];
    [self removeFromSuperview];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window makeKeyAndVisible];
    
}

- (void)showClose:(BOOL)isShow
{
    if(isShow){
        _closeBtn.hidden = NO;
    }else{
        _closeBtn.hidden = YES;
    }
    
    //更改UI功能
    self.isCanTouchRemoveSelf = isShow;
    
}

- (IBAction)switchPwdStatus:(id)sender {
    switch (_isShowPwd) {
        case 0:
        {
            [self endEditing:YES];
            _isShowPwd = 1;
            _pwdTextField.secureTextEntry = NO;
            [_swithPwdBtn setImage:[UIImage imageNamed:@"icon_jm_login_show_pwd"] forState:UIControlStateNormal];
        }
            
            break;
            
        case 1:
        {
            [self endEditing:YES];
            _isShowPwd = 0;
            _pwdTextField.secureTextEntry = YES;
            [_swithPwdBtn setImage:[UIImage imageNamed:@"icon_jm_login_no_show_pwd"] forState:UIControlStateNormal];
            
        }
            
            break;
            
        default:
            break;
    }
    
}

- (void)startThread
{
    __block typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        BOOL loop = YES;
        while (loop) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                weakSelf.resultLabel.text = [NSString stringWithFormat:@"为了保护您的帐号安全，请于%ld:%.2ld分钟后重试！",_count/60,_count%60];
            });
            
            [NSThread sleepForTimeInterval:1];
            
            _count--;
            
            if(_count <= 0){
                loop = NO;
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            weakSelf.resultLabel.text = @"";
            [weakSelf reset];
        });
    });
}

#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self okClickEvent];
    return YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger tag = textField.tag;
    
    if (tag==10)
    {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > PwdInputLength) {
            return NO;
        }
    }
    
    return YES;
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.tag == 10) {
        if (textField.text.length > PwdInputLength) {
            textField.text = [textField.text substringToIndex:PwdInputLength];
        }
    }
}


+ (NSTimeInterval)getTimeIntervalForLastErrorTime
{
    NSDate *date = [CommonMethod getUserdefaultWithKey:APlusPwdErrorTime];
    NSTimeInterval  timeInterval = 0;
    if (!date) {
        timeInterval = -[[NSDate date] timeIntervalSince1970];
    }else{
        timeInterval = [date timeIntervalSinceNow];
    }
    return timeInterval;
}

+ (BOOL)isForceLock
{
    NSTimeInterval  timeInterval = [self getTimeIntervalForLastErrorTime];
    if(timeInterval > -WaitSecond * WaitMinute){
        return YES;
    }
    return NO;
}

- (void)reset{
    _errorCount = 0;
    //重置错误次数
    [AlertInputPwdView resetErrorTimes];
    _count = WaitMinute;
}

+ (void)resetErrorTimes
{
    [CommonMethod setUserdefaultWithValue:0 forKey:ErrorTimes];
}

#pragma mark-ResponseDelegate

- (void)respSuc:(id)data andRespClass:(id)cls
{
    isLoginStatus = NO;
    
    id perUser = [DataConvert convertDic:data toEntity:cls];
    
    if([perUser isKindOfClass:[BaseEntity class]]){
        // 上海
        id checkData = [ServiceHelper checkHKData:data];
        
        if ([checkData isKindOfClass:[Error class]]) {
            
            // 统一处理错误的消息
            _error = (Error *)checkData;
            [self handleError:_error];
            
            return;
        }
    }
    
    LoginEntity * loginEntity = [DataConvert convertDic:data toEntity:cls];
    LoginResultEntity *result=loginEntity.result;
    
    // 验证登录
    //        if ([result.loginDomainUser.cityCode isEqualToString:@"022"]) {
    //成功
    
    //            /**
    //             *  登录管家成功后，从agency接口获取用户权限
    //             */
    //            [self getDepartmentPopedomWithUserId:@[result.loginDomainUser.staffNo]];
    NSString *userName = [NSString nilToEmptyWithStr:result.loginDomainUser.cnName];
    [CommonMethod setUserdefaultWithValue:userName
                                   forKey:UserName];
    
    NSString *userStaffNumber = [NSString nilToEmptyWithStr:result.loginDomainUser.staffNo];
    [CommonMethod setUserdefaultWithValue:userStaffNumber
                                   forKey:UserStaffNumber];
    
    NSString *houseKeeperSession = [NSString nilToEmptyWithStr:result.seccion];
    [CommonMethod setUserdefaultWithValue:houseKeeperSession
                                   forKey:HouseKeeperSession];
    
    NSString *cityCode = [NSString nilToEmptyWithStr:result.loginDomainUser.cityCode];
    [CommonMethod setUserdefaultWithValue:cityCode
                                   forKey:CityCode];
    
    NSString *userStaffMobile = [NSString nilToEmptyWithStr:result.loginDomainUser.mobile];
    [CommonMethod setUserdefaultWithValue:userStaffMobile
                                   forKey:UserStaffMobile];
    
    NSString *userDeptName = [NSString nilToEmptyWithStr:result.loginDomainUser.deptName];
    [CommonMethod setUserdefaultWithValue:userDeptName
                                   forKey:UserDeptName];
    
    
    [self removeWindow];
    [self reset];
    
    if(_delegate) [_delegate validSuc];
    
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    isLoginStatus = NO;
    
    Error *failError = [[Error alloc]init];
    
    failError.rDescription = error.localizedDescription;
    
    [self handleError:failError];
}

- (void)handleError:(Error *)error
{
    NSString *errorMsg = [CheckHttpErrorUtil handleError:error];
    
    if ([NSString isNilOrEmpty:errorMsg]) {
        return;
    }
    
    
    if ([errorMsg contains:@"已锁定"]) {
        
        _resultLabel.text = errorMsg;
        
        // 保存锁定状态
        [CommonMethod setUserdefaultWithValue:@(true) forKey:AccountLockStatus];
        
        return;
    }
    
    if ([errorMsg contains:@"账号或密码错误"])
    {
        _errorCount++;
        
        int elseTime = _errorLimit-_errorCount;
        if(elseTime <= 0){
            isLoginStatus = NO;
            if(_delegate) [_delegate locked];
            
            // 保存错误后强制锁定时间
            [CommonMethod setUserdefaultWithValue:[NSDate date] forKey:APlusPwdErrorTime];
            
            NSDate *date = [CommonMethod getUserdefaultWithKey:APlusPwdErrorTime];
            
            NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
            if(timeInterval > -60*60){
                [self startThread];
            }
        }else{
            //        [self handleError:error];
            _resultLabel.text = [NSString stringWithFormat:@"登录密码错误，你还可以输入%d次",_errorLimit-_errorCount];
            // 保存错误次数
            [CommonMethod setUserdefaultWithValue:[NSString stringWithFormat:@"%d",_errorCount] forKey:ErrorTimes];
        }
    }
    else
    {
         _resultLabel.text = errorMsg;
    }
    
}

- (void)touchClickWithTgr:(UITapGestureRecognizer *)tgr{
    
    if (self.isCanTouchRemoveSelf) {
        
        [self closeBtnClick:nil];
        
    }
    
}


@end
