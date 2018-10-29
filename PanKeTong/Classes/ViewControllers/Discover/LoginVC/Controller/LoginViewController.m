//
//  LoginViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginEntity.h"
#import "LoginResultDomainUserEntity.h"
#import "DepartmentInfoEntity.h"
#import "DepartmentInfoResultEntity.h"
#import "AgencyUserPermisstionUtil.h"
#import "CustomActionSheet.h"
#import "CommonWebView.h"
#import "NotificationNameDefine.h"
#import "PersonalInfoEntity.h"
#import "JMVerifyButton.h"
#import "LoginApi.h"
#import "CityConfigApi.h"
#import "AgencyUserInfoApi.h"
#import "GetPersonalApi.h"
#import "LogOffUtil.h"
#import "DascomUtil.h"
#import "CheckFaceUtils.h"
#import "CAShapeLayer+Category.h"

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface LoginViewController ()<UIPickerViewDataSource,
UIPickerViewDelegate,doneSelect,UITextFieldDelegate>
{
    
    LoginApi *_loginApi;
    CityConfigApi *_cityCfgApi;
    AgencyUserInfoApi *_userInfoApi;
    GetPersonalApi *_getPersonalApi;
    
    __weak IBOutlet UITextField *_hostAccountTextfield;
    __weak IBOutlet UITextField *_hostPasswordTextfield;
    __weak IBOutlet UIButton *_loginBtn;
    __weak IBOutlet UILabel *_curAppVerson;
    UIPickerView *_mainPickerView;
    
    DepartmentInfoEntity *_departmentEntity;
    NSInteger selectedUserIndex;
    NSMutableArray *_departArray;
}

@property (weak, nonatomic) IBOutlet UIView *accountPwdConView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noCanLoginLabelBottomCon;



@end

@implementation LoginViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
    
    _curAppVerson.text =  [[NSUserDefaults standardUserDefaults] stringForKey:CurrentAppVerson];;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES
                                             animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO
                                             animated:YES];
}

- (void)initView {
    
    _departArray = [NSMutableArray arrayWithCapacity:0];
     
    self.noCanLoginLabelBottomCon.constant = BOTTOM_SAFE_HEIGHT + 23;
    
    [_loginBtn setLayerCornerRadius:5];

    
    {
        CAShapeLayer * accountLayer = [CAShapeLayer shaperLayerAddLineFromPoint:CGPointMake(36, 50) toPoint:CGPointMake(APP_SCREEN_WIDTH - 36, 50) andColor:YCTextColorGray];
        
        [self.accountPwdConView.layer addSublayer:accountLayer];
    }
    {
        CAShapeLayer * pwdLayer = [CAShapeLayer shaperLayerAddLineFromPoint:CGPointMake(36, 112) toPoint:CGPointMake(APP_SCREEN_WIDTH - 36, 112) andColor:YCTextColorGray];
        
        [self.accountPwdConView.layer addSublayer:pwdLayer];
    }
    
    _hostPasswordTextfield.delegate = self;
    
    [_hostAccountTextfield.rac_textSignal  subscribeNext:^(id x) {
       
        if (_hostAccountTextfield.text.length > 11) {
            _hostAccountTextfield.text = [_hostAccountTextfield.text substringToIndex:11];
        }
        
        _loginBtn.enabled = _hostPasswordTextfield.text.length == 6 && _hostAccountTextfield.text.length == 11;
        
        
    }];
    
    [_hostPasswordTextfield.rac_textSignal subscribeNext:^(id x) {
        
        
        if (_hostPasswordTextfield.text.length > 6) {
            _hostPasswordTextfield.text = [_hostPasswordTextfield.text substringToIndex:6];
        }
        
        _loginBtn.enabled = _hostPasswordTextfield.text.length == 6 && _hostAccountTextfield.text.length == 11;
    }];
        
}




- (void)initShadowView
{
    _mainPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, APP_SCREEN_WIDTH, 180)];
    _mainPickerView.dataSource = self;
    _mainPickerView.delegate = self;

    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithView:_mainPickerView AndHeight:220];
    sheet.doneDelegate = self;
    [sheet showInView:self.view];
}

/// 获取虚拟号配置
- (void)initMsisdnMethod
{
    [DascomUtil shareDascomUtil].fromeVC = @"login";
    [[DascomUtil shareDascomUtil] requestMsisdn:^{
        
        
    }];
}

#pragma mark - CustomMethod

/// 保存个人信息(A+返回)
- (void)saveAPlusPersonalInformation:(PersonalInfoEntity *)staffInfoEntity
{
    [CommonMethod setUserdefaultWithValue:staffInfoEntity.employeeName forKey:APlusUserName];
    [CommonMethod setUserdefaultWithValue:staffInfoEntity.mobile forKey:APlusUserMobile];
    [CommonMethod setUserdefaultWithValue:staffInfoEntity.departmentName forKey:APlusUserDepartName];
    [CommonMethod setUserdefaultWithValue:staffInfoEntity.position forKey:APlusUserRoleName];
    [CommonMethod setUserdefaultWithValue:staffInfoEntity.photoPath forKey:APlusUserPhotoPath];
    [CommonMethod setUserdefaultWithValue:staffInfoEntity.extendTel forKey:APlusUserExtendMobile];
}

#pragma mark - ClickEvents

/// 选择部门后的操作
- (void)doneSelectItemMethod
{
    DepartmentInfoResultEntity *userInfo = _departmentEntity.result[selectedUserIndex];
    [AgencyUserPermisstionUtil saveUserInfo:userInfo];
    [CommonMethod setUserdefaultWithValue:userInfo.identify.uName forKey:APlusUserName];
    [CommonMethod setUserdefaultWithValue:userInfo.identify.uName forKey:APlusUserName];
    
    [[self sharedAppDelegate] changeDiscoverRootVCIsLogin:NO];
    [_departArray removeAllObjects];
    
    // 获取虚拟号配置
    [self initMsisdnMethod];
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:nil];
}



/// 点击“帮助中心”
- (IBAction)clickHelpCenterMethod:(id)sender
{
    // 帮助中心
    CommonWebView *commonWebView = [[CommonWebView alloc]initWithNibName:@"CommonWebView"
                                                                  bundle:nil];
    commonWebView.pageSourceUrl = [[BaseApiDomainUtil getApiDomain] getCommonHelpURL];

    [self.navigationController pushViewController:commonWebView
                                         animated:YES];
}

- (IBAction)getVerifyBtnClick:(JMVerifyButton *)btn {
    
    [AFUtils POST:Get_VerifyCode parameters:@{@"Mobile":_hostAccountTextfield.text} controller:self successfulDict:^(NSDictionary *successfuldict) {
        
        NSString *string = successfuldict[@"RMessage"];
        btn.durationToValidity = string.doubleValue;

        [btn startUpTimer];
        
    if ([successfuldict[@"Result"] isKindOfClass: [NSDictionary class]]) showMsg(successfuldict[@"Result"][@"ErrorMsg"]);
        
    

    } failureDict:^(NSDictionary *failuredict) {
        [btn invalidateTimer];

    } failureError:^(NSError *failureerror) {

       [btn invalidateTimer];

    }];

    
    btn.enabled = NO;
    
    
}


#pragma mark -   **********点击登录*********
- (IBAction)clickLoginBtn:(id)sender {


    [self.view endEditing:YES];
    [self showLoadingView:@"登录中..."];
    [AFUtils POST:Login_VerifyCode parameters:@{@"Mobile":_hostAccountTextfield.text,@"Code":_hostPasswordTextfield.text} controller:nil successfulDict:^(NSDictionary *successfuldict) {
        
        LoginEntity * loginEntity = [DataConvert convertDic:successfuldict toEntity:LoginEntity.class];
        
        LoginResultEntity *result = loginEntity.result;
        
        [CommonMethod setUserdefaultWithValue:result.seccion?:@""
                                       forKey:HouseKeeperSession];
        
        
        
        LoginResultDomainUserEntity *model = result.loginDomainUser;
        
        [CommonMethod setUserdefaultWithValue:model.cnName?:@""
                                       forKey:UserName];
        [CommonMethod setUserdefaultWithValue:model.cnName?:@""
                                       forKey:APlusUserName];
        
        
        [CommonMethod setUserdefaultWithValue:model.staffNo?:@""
                                       forKey:UserStaffNumber];
        
        [CommonMethod setUserdefaultWithValue:model.cityCode?:@""
                                       forKey:CityCode];
        
        
        
        [CommonMethod setUserdefaultWithValue:model.mobile?:@""
                                       forKey:UserStaffMobile];
        
        
        
        [CommonMethod setUserdefaultWithValue:model.deptName?:@""
                                       forKey:UserDeptName];
        
        
        
        [CommonMethod setUserdefaultWithValue:model.title?:@""
                                       forKey:UserTitle];
        
        
        [CommonMethod setUserdefaultWithValue:model.agentUrl?:@""
                                       forKey:AgentUrl];
        
        
        [CommonMethod setUserdefaultWithValue:model.domainAccount?:@""
                                       forKey:APlusDomainToken];
        
        
        [CommonMethod setUserdefaultWithValue:model.CompanyName?:@""
                                       forKey:UserCompanyName];
        
        [CommonMethod setUserdefaultWithValue:model.corporationKeyId?:@"" forKey:CorporationKeyId];
        
        [CommonMethod setUserdefaultWithValue:model.corporationName?:@""
                                       forKey:CorporationName];
        
      
//        [CommonMethod registPushWithState:YES];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IsLoginSuccess];
       
        /// 城市配置
        
        _cityCfgApi = [CityConfigApi new];
        [_manager sendRequest:_cityCfgApi];
        
        
    } failureDict:^(NSDictionary *failuredict) {
        
        [self hiddenLoadingView];
        
    } failureError:^(NSError *failureerror) {
        
        [self hiddenLoadingView];
        
    }];

    
}

//- (void)loginByAccountAndPwd{
//
//    _loginBtn.userInteractionEnabled = NO;
//    [_hostAccountTextfield resignFirstResponder];
//    [_hostPasswordTextfield resignFirstResponder];
//
//    [self showLoadingView:@"登录中..."];
//
//    _loginApi = [LoginApi new];
//    _loginApi.account = _hostAccountTextfield.text;
//    _loginApi.psd = _hostPasswordTextfield.text;
//    [_manager sendRequest:_loginApi];
//
//}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
}


#pragma mark - <PickerViewDelegate>

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _departArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel *cusPicLabel = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 20.0f)];
    
    NSString *cusStr = [_departArray objectAtIndex:row];
    cusPicLabel.text = cusStr;
    [cusPicLabel setFont:[UIFont systemFontOfSize:18.0]];
    [cusPicLabel setTextAlignment:NSTextAlignmentCenter];
    cusPicLabel.backgroundColor = [UIColor clearColor];
    
    return cusPicLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedUserIndex = row;
}

#pragma mark - ****网络响应****

- (void)dealData:(id)data andClass:(id)modelClass {
  
    
        
    if ([modelClass isEqual:CityConfigEntity.class]) {
        // 获取城市域名及保存
        CityConfigEntity * cityConfigEntity = [DataConvert convertDic:data toEntity:modelClass];
        [[BaseApiDomainUtil getApiDomain] saveApiDomainInfo:cityConfigEntity];
        
        // 登录管家成功后，从agency接口获取用户权限
        NSString *staff = [CommonMethod getUserdefaultWithKey:UserStaffNumber];
        NSString *lastUserName = [CommonMethod getUserdefaultWithKey:LastStaffNo];

        AppDelegate *app = [self sharedAppDelegate];
        app.lastRequestNewPropTime = nil;

      
        // 清除非三级市场员工提示
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:NO] forKey:Have_Alert_Msg];

        // 清除首页模块
        if (![lastUserName isEqualToString:staff])
        {
            [CommonMethod setUserdefaultWithValue:nil forKey:Home_Default];
        }
        
         /// 用户权限
        _userInfoApi = [AgencyUserInfoApi new];
        _userInfoApi.staffNo = @[staff];
        [_manager sendRequest:_userInfoApi];
    }else if ([modelClass isEqual:[DepartmentInfoEntity class]]) {

        
        _departmentEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        if (_departmentEntity.result.count == 0) {
         
            showMsg(@"部门不存在");
            
            // 忽略本次登录的 域名Url / 用户信息
            [LogOffUtil clearUserInfoFromLocal];
            return;
        }
        
        // 保存帐号，为验证A+密码提供帐号
        NSString *account = _hostAccountTextfield.text;
        [CommonMethod setUserdefaultWithValue:account forKey:Account];
        
        
        if (_departmentEntity.result.count == 1) {
            DepartmentInfoResultEntity *userInfo = _departmentEntity.result[0];
            [AgencyUserPermisstionUtil saveUserInfo:userInfo];
            
            [[self sharedAppDelegate] changeDiscoverRootVCIsLogin:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:nil];
            
            NSString *userCityCode = [CommonMethod getUserdefaultWithKey:CityCode];
            NSString *staffNo = [CommonMethod getUserdefaultWithKey:UserStaffNumber];

            ///获取员工个人信息
            _getPersonalApi = [[GetPersonalApi alloc] init];
            _getPersonalApi.staffNo = staffNo;
            _getPersonalApi.cityCode = userCityCode;
            [_manager sendRequest:_getPersonalApi];
            
            // 获取虚拟号配置
            [self initMsisdnMethod];
     
        }else{
            
            [_departArray removeAllObjects];
            for (int i = 0; i < _departmentEntity.result.count; i++)
            {
                DepartmentInfoResultEntity *entity=_departmentEntity.result[i];
                [_departArray addObject:entity.identify.departName];
            }
            
            [self initShadowView];
        }
    }else if ([modelClass isEqual:[PersonalInfoEntity class]]) {
        
        PersonalInfoEntity *staffInfoEntity = [DataConvert convertDic:data toEntity:modelClass];
        [self saveAPlusPersonalInformation:staffInfoEntity];
        
          [self hiddenLoadingView];
        
        
    }
    
    
}

- (void)respFail:(NSError *)error andRespClass:(id)cls {
    
    [LogOffUtil clearUserInfoFromLocal];
  
    [super respFail:error andRespClass:cls];
    
}

@end
