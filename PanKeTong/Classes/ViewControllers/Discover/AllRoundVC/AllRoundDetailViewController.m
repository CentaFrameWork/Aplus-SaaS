//
//  AllRoundDetailViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AllRoundDetailViewController.h"
#import "AllRoundDetailMoreItemCell.h"
#import "BaiduMobStat.h"
#import "AllRoundDetailBasicMsgCell.h"
#import "AllRoundDetailOnlyTextCell.h"
#import "PropPageDetailEntity.h"
#import "EditHouseVO.h"
#import "ArrowSignTextCell.h"
#import "PropFollowRecordCell.h"
#import "FollowRecordEntity.h"
#import "UploadRealSurveyViewController.h"
#import "DataBaseOperation.h"
#import "MoreFollowListViewController.h"
#import "PropAroundMapViewController.h"
#import "VoiceRecordViewController.h"
#import "PropertyStatusCategoryEnum.h"
#import "PersonalInfoEntity.h"
#import "CityCodeVersion.h"
#import "CheckRealProtectedEntity.h"
#import "CheckRealProtectedDurationApi.h"
#import "GetPropDetailApi.h"
#import "CollectPropApi.h"
#import "GetFollowRecordApi.h"
#import "GetTrustorsApi.h"
#import "TrustorEntity.h"
#import "PropertyStatusCategoryEnum.h"
#import "NSDate+Format.h"
#import "EditViewController.h"                  // 编辑房源
#import "PropTrustorsInfoForShenZhenEntity.h"
#import "GetEstAgentQuotaApi.h"
#import "AgentQuotaEntity.h"
#import "WebViewModuleVC.h"                     // 发布房源
#import "FindIsExitAdApi.h"
#import "FindIsExitEntity.h"
#import "GetEstOnlineOrOfflineApi.h"            // 上架／下架广告
#import "EstReleaseOnLineOrOffLineEntity.h"
#import "GetAllRealSurveyPhotoApi.h"            // 获取全部实勘
#import "CheckRealSurveyEntity.h"
#import "FindHasRegisterTrustApi.h"
#import "FindRegisterTrustEntity.h"
#import "MBProgressHUD.h"
#import "CallRecordViewController.h"
#import "AddEntrustFilingVC.h"                  // 新增备案
#import "EditEntrustFilingVC.h"                 // 编辑备案
#import "AddEventView.h"
#import "PropZJDetailPresenter.h"

#import "StateChangesViewController.h"          // 状态修改
#import "AppendInfoViewController.h"            // 状态修改测试用

#import "WJContactViewController.h"
#import "AdjustThePriceVC.h"

#define ButtomMoreItemBtnTag        1000
#define TopMoreItemActionTag        2000
#define CheckHouseNoActionTag       3000
#define CallRealPhoneAlertTag       4000
#define PublishPropertyAlertTag     5000
#define DSJAlertTag                 6000    // 待上架
#define PublishListAlertTag         7000    // 推送列表
#define ExceedingCommitAlerttag     8000    // 发布数量超限制提示
#define HaveOnlineAdAlertTag        1111    // 已在上架区的弹框

@interface AllRoundDetailViewController ()<UITableViewDataSource, UITableViewDelegate, FreshFollowListDelegate,AddEventDelegate,ApplyTransferEstDelegate>
{
    CheckRealProtectedDurationApi *_checkRealProtectedApi;
    GetPropDetailApi *_getPropDetailApi;
    CollectPropApi *_collectPropApi;
    GetFollowRecordApi *_getFollowApi;
    GetTrustorsApi *_getTrustorsApi;
    
    __weak IBOutlet UITableView *_mainTableView;
     MBProgressHUD *_showMbHUD;
    
    PropPageDetailEntity *_propDetailEntity;
    PropFollowRecordDetailEntity *_followRecordEntity;
    DataBaseOperation *_dataBaseOperation;
    PersonalInfoEntity *_resultEntity;
    CheckRealSurveyEntity *_checkRealSurveyEntity;          // 全部实勘
    PropTrustorsInfoEntity *_propTrustorsInfoEntity;
    PropTrustorsInfoForShenZhenEntity *_propTrustorsForSZ;
    FindIsExitEntity *_findIsExitEntity;                    // 是否发过广告
    AgentQuotaEntity *_agentQuotaEntity;                    // 发布权限及数量
    FindRegisterTrustEntity *_findRegisterTrustEntity;      // 判断是不是委托房源

    AllRoundDetailPresenter *_propDetailPresenter;

    AddEventView *_addEventView;                            // 新增事件视图
    UIView *_shadowView;
    
    BOOL _isCheckedHouseNum;                                // 是否已查看过房号
    BOOL _isCollected;                                      // 是否已收藏当前房源
    BOOL _isAllHouseNum;                                    // 是否显示全部房号
    BOOL _isOnlineAd;                                       // 是否要上架广告
    NSInteger _selectIndex;
    NSString *_mobile;
    NSString *_propTitleStr;
    NSString *_right;
    NSString *_trustType;                                   // 发布房源的租售类型
    NSString *_propertyNo;                                  // 房源编号
    NSArray *_trustors;
}

@end

@implementation AllRoundDetailViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPresenter];
    [self initView];
    // 房源状态更改
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeTradingState:)
                                                 name:ChangeTradingState
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initData];
    [self isCheckedRoomNum];
    NSString *isCollection = [NSString stringWithFormat:@"%@",_isCollected ? @"取消收藏" : @"收藏"];
    NSArray *titltArr = [_propDetailPresenter rightNavTitleArr:isCollection];
    if ([titltArr containsObject:@"发布房源"])
    {
        [self requestAllRealSurvey];
    }
}

#pragma mark - init

- (void)initView
{
    [self setNavTitle:@""
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"topBar_btn_more_icon_img"
                                            sel:@selector(clickMoreItemMethod)]];
}

- (void)initPresenter
{

        _propDetailPresenter = [[PropZJDetailPresenter alloc] initWithDelegate:self];
    

    _propDetailPresenter.propKeyId = self.propKeyId;
}

- (void)initData
{
    // 是否可以查看全部房号
    _isAllHouseNum = [_propDetailPresenter isAllHouseNum];
    
    _checkRealProtectedApi = [CheckRealProtectedDurationApi new];
    _getPropDetailApi = [GetPropDetailApi new];
    _collectPropApi = [CollectPropApi new];
    _getFollowApi = [GetFollowRecordApi new];
    _getTrustorsApi = [GetTrustorsApi new];

    // 获取房源详情
    _getPropDetailApi.propKeyId = _propKeyId;
    [_manager sendRequest:_getPropDetailApi];
    [self showHUDLoadingView:nil];
}

- (void)initShowHUDView
{
    [_showMbHUD removeFromSuperview];
    _showMbHUD = nil;
    _showMbHUD = [[MBProgressHUD alloc]initWithView:self.view];
    _showMbHUD.mode = MBProgressHUDModeCustomView;
    
    UIImageView *hudBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-5, -6, 45, 45)];
    [hudBgImageView setImage:[UIImage imageNamed:@"spinner_outer"]];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.duration = MAXFLOAT * 0.4;
    animation.additive = YES;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:MAXFLOAT];
    animation.repeatCount = MAXFLOAT;
    [hudBgImageView.layer addAnimation:animation forKey:nil];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(5, -3, 35, 35)];
    [iconView setImage:[UIImage imageNamed:@"zy_icon"]];
    [iconView addSubview:hudBgImageView];
    
    _showMbHUD.customView = iconView;
    [self.view addSubview:_showMbHUD];
}

#pragma mark -  拨打电话


- (void)doneSelectItemMethod
{
    // 是否使用虚拟号拨打
    BOOL isVirtualCall = NO;
    
    NSString *errorMsg = [_propDetailPresenter callTrustorsMsgSelectIndex:_selectIndex];
    
    if (![NSString isNilOrEmpty:errorMsg])
    {
        showMsg(errorMsg);
        return;
    }
    
    isVirtualCall = [_propDetailPresenter isCallVirtualPhone];
    NSString *tel = [_propDetailPresenter getCallNumSelectIndex:_selectIndex];
    _mobile = tel;
    
#warning A For VirtualCall Debug 需注释!
    //    isAPlusVirtualCall = YES;
    //    isVirtualCall = NO;
    
    // 使用虚拟号
    if (isVirtualCall)
    {
        [_propDetailPresenter callVirtualPhoneSelectIndex:_selectIndex andMobil:_mobile andPropKeyId:_propKeyId andPropertyNo:_propertyNo];
    }
    // 不使用虚拟号
    else
    {
        // 删除当日拨打记录
        [CallRealPhoneLimitUtil deleteNotToday];
        
        // keyId是否存在
        if ([CallRealPhoneLimitUtil isExistWithPropKeyId:self.propKeyId])
        {
            NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",tel];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
            
            return;
        }
        
        NSInteger limit = [_propDetailPresenter getCallLimit];
        NSInteger curCount = [CallRealPhoneLimitUtil getCountForToday];
        
        if (curCount >= limit)
        {
            showMsg(@"您今日拨打电话次数已用完！");
            return;
        }
        
        NSString *msg = [NSString stringWithFormat:@"剩余拨打次数：%@，您确定要拨打吗？",@(limit - curCount)];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:msg
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定", nil];
        alertView.tag = CallRealPhoneAlertTag;
        [alertView show];
    }
}

/// MoreItemBtnClickMethod
- (void)moreItemPushMethodWithBtn:(UIButton *)button
{
    switch (button.tag - ButtomMoreItemBtnTag)
    {
        case 0:
        {
            BOOL isAble = [_propDetailPresenter canViewUploadrealSurvey:_propDetailEntity.departmentPermissions];
            if (isAble)
            {
                // 实堪
                RealListViewController *realListViewController = [[RealListViewController alloc]initWithNibName:@"RealListViewController"
                                                                                                         bundle:nil];
                realListViewController.keyId = _propKeyId;
                realListViewController.estateName = _propTitleStr;
                
                [self.navigationController pushViewController:realListViewController animated:YES];
            }
            else
            {
                showMsg(@(NotHavePermissionTip));
            }
        }
            break;
            
        case 1:
        {
            // 编辑钥匙  需要
            PropKeyViewController *propKeyVC = [[PropKeyViewController alloc] init];
            propKeyVC.keyId = _propKeyId;
            [self.navigationController pushViewController:propKeyVC animated:YES];

        }
            break;
            
        case 2:
        {
            // 独家
            OnlyTrustViewController *onlyTrustViewController = [[OnlyTrustViewController alloc]initWithNibName:@"OnlyTrustViewController" bundle:nil];
            onlyTrustViewController.keyId = _propKeyId;
            onlyTrustViewController.titleName = [_propDetailPresenter getOnlyTrustString];
            
            [self.navigationController pushViewController:onlyTrustViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

/// 拨打电话
- (void)callPhonePress
{
    // 查看联系人权限
    BOOL hasPermisstion = [_propDetailPresenter canViewTrustors:_propDetailEntity.departmentPermissions];
    if (hasPermisstion)
    {
        NSString *phoneNum = [[NSUserDefaults standardUserDefaults] stringForKey:APlusUserMobile];
        if (!phoneNum)
        {
            phoneNum = @"";
        }
        
        NSString *userKeyId = [AgencyUserPermisstionUtil getIdentify].uId;
        NSString *departId = [AgencyUserPermisstionUtil getIdentify].departId;
        
        _getTrustorsApi.userKeyId = userKeyId;
        _getTrustorsApi.departmentKeyId = departId;
        _getTrustorsApi.userPhone = phoneNum;
        _getTrustorsApi.keyId = self.propKeyId;
        [_manager sendRequest:_getTrustorsApi];
    }
    else
    {
        showMsg(@(NotHavePermissionTip));
        return;
    }
    
    //  重置selectIndex
    _selectIndex = 0;
    [self showLoadingView:@"正在获取联系人信息..."];
}

/// 显示联系人
- (void)showTrustors
{
    [self hiddenLoadingView];
    
    NSString *errorMsg = [_propDetailPresenter showTrustorsErrorMsg];
    if (![NSString isNilOrEmpty:errorMsg])
    {
        showMsg(errorMsg); 
        return;
    }
    
    [self showPickView];
}

- (CustomActionSheet *)showPickView
{
    UIPickerView *mPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, APP_SCREEN_WIDTH, 180)];
    mPickerView.dataSource = self;
    mPickerView.delegate = self;
    
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithView:mPickerView AndHeight:300];
    sheet.doneDelegate = self;
    [sheet showInView:self.view];
    
    return sheet;
}

#pragma mark - PrivateMethod

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(editRefresh:)])
    {
        [self.myDelegate editRefresh:_propDetailEntity];
    }
}

- (void)changeTradingState:(NSNotification *)noti
{
    [self loadView];
    NSString *tradingState = noti.object;
    _propTrustType = tradingState;
}

/// 检查出售预订房源的查看权限
- (BOOL)isSaleAndOrder
{
    BOOL view = NO;
    
    NSInteger status = [_propDetailEntity.propertyStatusCategory integerValue];
    NSInteger ccaiType = -1;
    if (_propDetailEntity.cCAIReturnTrustType)
    {
        ccaiType = [_propDetailEntity.cCAIReturnTrustType integerValue];
    }
    
    if (status == PREORDAIN)
    {
        // 房源所属人
        NSString *propertyChiefKeyId = _propDetailEntity.propertyChiefKeyId;
        
        // 房源所属部门
        NSString *propertyChiefDepartmentKeyId = _propDetailEntity.propertyChiefDepartmentKeyId;
        
        // 房源交易人
        NSString *propertyTraderKeyId = _propDetailEntity.propertyTraderKeyId;
        
        // 房源交易人所属部门
        NSString *propertyTraderDepartmentKeyId = _propDetailEntity.propertyTraderDepartmentKeyId;
        
        // 预定房源查看权限 本人 本部 全部
        if (ccaiType == SALE)
        {
            // 全部权限，直接有权限查看
            if ([AgencyUserPermisstionUtil hasRight:PROPERTY_PREORDAINPROPERTY_SEARCH_ALL])
            {
                return YES;
            }
            
            // 本人权限
            if ([AgencyUserPermisstionUtil hasRight:PROPERTY_PREORDAINPROPERTY_SEARCH_MYSELF])
            {
                NSString *userKeyId = [AgencyUserPermisstionUtil getIdentify].uId;
                if ([userKeyId isEqualToString:propertyChiefKeyId]
                   || [userKeyId isEqualToString:propertyTraderKeyId])
                {
                    return YES;
                }
                else
                {
                    return NO;
                }
            }
            
            // 本部权限
            if ([AgencyUserPermisstionUtil hasRight:PROPERTY_PREORDAINPROPERTY_SEARCH_MYDEPARTMENT])
            {
                NSString *departmentKeyIds = [AgencyUserPermisstionUtil getAgencyPermisstion].departmentKeyIds;
                BOOL isContainsDepartment = [AgencyUserPermisstionUtil Content:departmentKeyIds
                                                                  ContainsWith:propertyChiefDepartmentKeyId];
                BOOL isContainsTrade = [AgencyUserPermisstionUtil Content:departmentKeyIds
                                                             ContainsWith:propertyTraderDepartmentKeyId];
                
                if (isContainsDepartment || isContainsTrade)
                {
                    return YES;
                }
                else
                {
                    return NO;
                }
            }
        }
        else if (ccaiType == RENT)
        {
            view = YES;
        }
        else
        {
            view = NO;
        }
    }
    else
    {
        view = YES;
    }
    
    return view;
}

/// 判断发布权限网络请求
- (void)pushPermiss
{
    NSString *pulishPropertyUrl = [[BaseApiDomainUtil getApiDomain] getPulishPropertyUrl];
    
    if (![NSString isNilOrEmpty:pulishPropertyUrl])
    {
        GetEstAgentQuotaApi *getEstAgentQuotaApi = [[GetEstAgentQuotaApi alloc] init];
        [_manager sendRequest:getEstAgentQuotaApi];
        [self showHUDLoadingView:@"正在验证房源..."];
    }
}

/// 获得第一条房源跟进
- (void)getFollowRecord
{
    BOOL isAble = [_propDetailPresenter canViewFollowList:_propDetailEntity.departmentPermissions];
    if (isAble)
    {
        _getFollowApi.pageIndex = @"2";
        _getFollowApi.pageSize = [_propDetailPresenter getPageSize];
        _getFollowApi.isDetails = @"true";
        _getFollowApi.propKeyId = _propKeyId;
        _getFollowApi.followTypeKeyId = @"";
        [_manager sendRequest:_getFollowApi];
    }
    else
    {
        [self hiddenHUDLoadingView];
    }
}

/// 查看房号
- (void)clickCheckHouseNoMethod
{
    if (!_isCheckedHouseNum)
    {
        NSInteger checkHouseNoTimes = [CheckRoomNumUtil timesOfCheckNum];
        if (checkHouseNoTimes == 0)
        {
            showMsg(@"您今天浏览房号次数已用完！");
        }
        else
        {
            NSString *actionTitleStr = [NSString stringWithFormat:@"您今天剩余查看次数：%@，是否继续查看?",
                                        @(checkHouseNoTimes)];
            
            
            UIAlertView * av = [[UIAlertView alloc] initWithTitle:actionTitleStr message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            av.tag = CheckHouseNoActionTag;
            
            [av show];

//            BYActionSheetView *checkHouseNoAction = [[BYActionSheetView alloc]initWithTitle:actionTitleStr
//                                                                                   delegate:self
//                                                                          cancelButtonTitle:@"取消"
//                                                                          otherButtonTitles:@"确定", nil];
//            checkHouseNoAction.tag = CheckHouseNoActionTag;
//
//            [checkHouseNoAction show];
        }
    }
}

/// 上传实勘
- (void)uploadrealSurveyMethod
{
    BOOL isAble = [_propDetailPresenter canAddUploadrealSurvey:_propDetailEntity.departmentPermissions];
    if (isAble)
    {
        // 是否需要验证实勘保护期
        if ([_propDetailPresenter isCheckRealProtected])
        {
            // 是否需要检查房源状态
            if ([_propDetailPresenter isCheckPropertyStatus])
            {
                if ([_propertyStatus  integerValue] != VALID)
                {
                    showMsg(@"非有效房源无法上传实勘!");
                    return;
                }
            }
            
            // 验证实堪保护期
            _checkRealProtectedApi.keyId = _propKeyId;
            [_manager sendRequest:_checkRealProtectedApi];
        }
        else
        {
            UploadRealSurveyViewController *uploadRealSurveyVC = [[UploadRealSurveyViewController alloc]initWithNibName:@"UploadRealSurveyViewController"
                                                                                                                 bundle:nil];
            uploadRealSurveyVC.propKeyId = _propKeyId;
            
            [self.navigationController pushViewController:uploadRealSurveyVC animated:YES];
        }
    }
    else
    {
        showMsg(@(NotHavePermissionTip));
    }
}

/// 遍历已查看过房号的房源id，看当前房源是否查看过房号
- (void)isCheckedRoomNum {
   
    if (_isAllHouseNum){
        _isCheckedHouseNum = YES;
        
        _propTitleStr = [NSString stringWithFormat:@"%@%@%@",
                         _propNameStr ? _propNameStr : @"",
                         _propBuildingName ? _propBuildingName : @"",
                         _propHouseNo ? _propHouseNo : @""];
    
    }else{
        
        _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
        
        NSString *curStaffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
        NSMutableArray *checkedHouseNumList = [_dataBaseOperation selectAllKeyIdOfCheckedRoomNumWithStaffNo:curStaffNo
                                                                                                    andDate:[NSDate stringWithSimpleDate:[NSDate date]]];
        for (NSString *keyId in checkedHouseNumList)
        {
            if ([keyId isEqualToString:_propKeyId])
            {
                // 当前房源已查看过房号
                _isCheckedHouseNum = YES;
                _propTitleStr = [NSString stringWithFormat:@"%@%@%@",
                                 _propNameStr ? _propNameStr : @"",
                                 _propBuildingName ? _propBuildingName : @"",
                                 _propHouseNo ? _propHouseNo : @""];
                break;
            }
        }
        
        if (checkedHouseNumList.count == 0 || !_isCheckedHouseNum)
        {
            // 当前房源未查看过房号
            _isCheckedHouseNum = NO;
            _propTitleStr = [NSString stringWithFormat:@"%@%@",
                             _propNameStr ? _propNameStr : @"",
                             _propBuildingName ?  _propBuildingName : @""];
        }
    }
    
    self.title = [_propTitleStr isEqualToString:@"(null)(null)"] ? @"" : _propTitleStr;
}

/// 右上角"更多"列表
- (void)clickMoreItemMethod
{
    // 加载完成后点击显示
    if (_addEventView || _showMbHUD.alpha == 1.0)
    {
        [_shadowView removeFromSuperview];
        [_addEventView removeFromSuperview];
        _addEventView = nil;
        return;
    }
    // 新增事件按钮
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - APP_NAV_HEIGHT)];
    _shadowView.backgroundColor = [UIColor blackColor];
    _shadowView.alpha = 0.2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_shadowView addGestureRecognizer:tap];
    [self.view addSubview:_shadowView];

    NSString *isCollection = [NSString stringWithFormat:@"%@",_isCollected ? @"取消收藏" : @"收藏"];

    _propDetailPresenter.propDetailEntity = _propDetailEntity;
    NSArray *titltArr = [_propDetailPresenter rightNavTitleArr:isCollection];
    CGFloat width = 155;
    CGFloat height = titltArr.count * RowHeight + ArrowHeight;
    _addEventView = [[AddEventView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH - width - 10, 5, width, height)];
    _addEventView.backgroundColor = [UIColor clearColor];
    _addEventView.isHaveImage = YES;
    _addEventView.titleArr = titltArr;
    _addEventView.isAllRoundDetailNavRightBtn = YES;
    _addEventView.addEventDelegate = self;
    [self.view addSubview:_addEventView];
}

#pragma mark - <AddEventDelegate>

- (void)addEventClickWithBtnTitle:(NSString *)title
{
    // 新增视图移除
    [_shadowView removeFromSuperview];
    [_addEventView removeFromSuperview];
    _addEventView = nil;

    if ([title contains:@"新增备案"])
    {
        if ([_propDetailEntity.trustType integerValue] < 1)
        {
            showMsg(FINAL_ESTATE_HAS_NO_TRUST_TYPE)
            return;
        }
        AddEntrustFilingVC * addEntrustFilingVC = [[AddEntrustFilingVC alloc] initWithNibName:@"AddEntrustFilingVC"
                                                                                       bundle:nil];
        addEntrustFilingVC.signType = _propDetailEntity.trustType;
        addEntrustFilingVC.propertyKeyId = _propKeyId;
        addEntrustFilingVC.view.backgroundColor = [UIColor whiteColor];

        [self.navigationController pushViewController:addEntrustFilingVC animated:YES];
    }

    if ([title contains:@"编辑备案"])
    {
        if ([_propDetailEntity.trustType integerValue] < 1)
        {
            showMsg(FINAL_ESTATE_HAS_NO_TRUST_TYPE)
            return;
        }
        
        EditEntrustFilingVC *editEntrustFilingVC = [[EditEntrustFilingVC alloc] initWithNibName:@"EditEntrustFilingVC"
                                                                                         bundle:nil];
        editEntrustFilingVC.signType = _propDetailEntity.trustType;
        editEntrustFilingVC.propertyKeyId = _propKeyId;
//        editEntrustFilingVC.trustAuditState = _propDetailEntity.trustAuditState;
        editEntrustFilingVC.view.backgroundColor = [UIColor whiteColor];

        [self.navigationController pushViewController:editEntrustFilingVC animated:YES];
    }

    if ([title contains:@"分享"])
    {
        [self sendSharePropDetailWithKeyId:_propKeyId andImgUrl:_propImgUrl andEstName:_propNameStr];
        return;
    }

    if ([title contains:@"编辑房源"])
    {
        // 判断是否有权限
        BOOL isHavePremiss = [self isHavePermission];
        BOOL hasPermisstion = YES;

        if (_propDetailEntity.departmentPermissions)
        {
            hasPermisstion =   [_propDetailEntity.departmentPermissions contains:DEPARTMENT_PROPERTY_PROPERTY_MODIFY_ALL];
        }

        if (isHavePremiss && hasPermisstion)
        {
            EditViewController *vc = [[EditViewController alloc] init];
            vc.propTrustType = _propTrustType;
            vc.propertyKeyId = _propKeyId;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            showMsg(@"您没有编辑房源权限!");
        }
        
        return;
    }

    if ([title contains:@"上传实勘"])
    {
        // 验证实勘保护期
        [self uploadrealSurveyMethod];
        return;
    }

    if ([title isEqualToString:@"收藏"])
    {
        _collectPropApi.isCollect = YES;
        _collectPropApi.propKeyId = _propKeyId;
        [_manager sendRequest:_collectPropApi];
        return;
    }

    if ([title isEqualToString:@"取消收藏"])
    {
        _collectPropApi.propKeyId = _propKeyId;
        _collectPropApi.isCollect = NO;
        [_manager sendRequest:_collectPropApi];
        return;
    }

    if ([title contains:@"录音"])
    {
        VoiceRecordViewController *voiceRecordVC = [[VoiceRecordViewController alloc]initWithNibName:@"VoiceRecordViewController" bundle:nil];
        voiceRecordVC.propId = _propKeyId;

        [self.navigationController pushViewController:voiceRecordVC animated:YES];
        return;
    }

    if ([title contains:@"周边"])
    {
        PropAroundMapViewController *propMapVC = [[PropAroundMapViewController alloc]
                                                  initWithNibName:@"PropAroundMapViewController"
                                                  bundle:nil];
        propMapVC.latitude = _propDetailEntity.latitude.doubleValue;
        propMapVC.longitude = _propDetailEntity.longitude.doubleValue;
        propMapVC.propTitleString = _propNameStr;

        [self.navigationController pushViewController:propMapVC animated:YES];
        return;
    }
    
    if ([title contains:@"状态修改"])
    {
        StateChangesViewController *stateChangesVC = [[StateChangesViewController alloc] init];
        stateChangesVC.propKeyId = _propKeyId;
        if ([_propertyStatus isEqualToString:@"1"]) {
            stateChangesVC.propertyStatus = 0;
        }else {
            stateChangesVC.propertyStatus = 1;
        }
        [self.navigationController pushViewController:stateChangesVC animated:YES];
        
//        // 信息补全 或 洗盘
//        AppendInfoViewController *appendMsgVC = [[AppendInfoViewController alloc]initWithNibName:@"AppendInfoViewController" bundle:nil];
//        appendMsgVC.appendMessageType = PropertyFollowTypeInfoAdd;
//        appendMsgVC.propertyKeyId = _propKeyId;
//        appendMsgVC.delegate = self;
//        [self.navigationController pushViewController:appendMsgVC
//                                             animated:YES];
        
        return;
    }

    if ([title contains:@"发布房源"])
    {
        // 发布房源
        // 1.判断发布权限及次数
        [self pushPermiss];
        return;
    }

    if ([title contains:@"通话记录"])
    {
        // 是否可以进入通话记录
        if ([_propDetailPresenter haveCallRecordPermission])
        {
            CallRecordViewController *callRecordVC = [CallRecordViewController new];
            callRecordVC.propertyKeyId = self.propKeyId;

            [self.navigationController pushViewController:callRecordVC animated:YES];
            return;
        }
    }
    if ([title contains:@"新增联系人"]) {
        WJContactViewController *contantVC = [WJContactViewController new];
        contantVC.propertyKeyId = self.propKeyId;
        [self.navigationController pushViewController:contantVC animated:YES];
        return;
    }
    if ([title contains:@"调价"]) {
        AdjustThePriceVC *adjustThePriceVC = [AdjustThePriceVC new];
        adjustThePriceVC.keyId = _propKeyId;
        adjustThePriceVC.type = _propTrustType.intValue;
        [self.navigationController pushViewController:adjustThePriceVC animated:YES];
        return;
    }
}

#pragma mark - 背景视图点击手势

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    // 新增视图移除
    [_shadowView removeFromSuperview];
    [_addEventView removeFromSuperview];
    _addEventView = nil;
}


#pragma mark - <MBProgressHUD>

- (void)showHUDLoadingView:(NSString *)message
{
    [self initShowHUDView];

    _showMbHUD.labelText = message ? message : @"";
    [_showMbHUD show:YES];
}

- (void)hiddenHUDLoadingView
{
    if (_showMbHUD)
    {
        [_showMbHUD hide:YES];
    }
}

//#pragma mark - <BYActionSheetDelegate>
//
//- (void)actionSheetView:(BYActionSheetView *)alertView
//   clickedButtonAtIndex:(NSInteger)buttonIndex
//         andButtonTitle:(NSString *)buttonTitle
//{
//    if (CheckHouseNoActionTag)
//    {
//        // 查看房号action
//        if (buttonIndex == 1)
//        {
//            [self checkRoomNum];
//    }
//  }
//}

#pragma mark - <FreshFollowListDelegate>

- (void)freshFollowListMethod
{
    // 获取最新房源跟进
    [self getFollowRecord];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_propDetailEntity)
    {
        return 3;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            NSInteger firstSectionRows = 2;
            
            if (_propDetailEntity.propertyTags.length > 0)
            {
                firstSectionRows += 1;
            }
            
            return firstSectionRows;
        }
            break;
            
        case 1:
        {
            return 1;
        }
            break;
            
        case 2:
        {
            return 1;
        }
            break;
            
        default:
            
            return 0;
            
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView *followTitleView = [[UIView alloc]init];
        [followTitleView setFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 42)];
        [followTitleView setBackgroundColor:[UIColor clearColor]];
        
        UILabel *followTitleLabel = [[UILabel alloc]init];
        [followTitleLabel setFrame:CGRectMake(12, 20, APP_SCREEN_WIDTH-24, 15)];
        [followTitleLabel setFont:[UIFont fontWithName:FontName size:13.0]];
        [followTitleLabel setTextColor:LITTLE_BLACK_COLOR];
        [followTitleLabel setBackgroundColor:[UIColor clearColor]];
        [followTitleLabel setText:@"房源跟进"];
        
        [followTitleView addSubview:followTitleLabel];
        
        return followTitleView;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *basicItemCellIdetntifier = @"allRoundDetailBasicMsgCell";
    static NSString *moreItemCellIdentifier = @"allRoundDetailMoreItemCell";
    static NSString *propTagsCellIdentifier = @"arrowSignTextCell";
    static NSString *onlyTextCellIdentifier = @"allRoundDetailOnlyTextCell";
    static NSString *propFollowCellIdentifier = @"propFollowRecordCell";
    
    AllRoundDetailBasicMsgCell *allRoundDetailBasicMsgCell = [tableView dequeueReusableCellWithIdentifier:basicItemCellIdetntifier];
    AllRoundDetailMoreItemCell *allRoundDetailMoreItemCell = [tableView dequeueReusableCellWithIdentifier:moreItemCellIdentifier];
    ArrowSignTextCell *allRoundTagsCell = [tableView dequeueReusableCellWithIdentifier:propTagsCellIdentifier];
    AllRoundDetailOnlyTextCell *allRoundDetailOnlyTextCell = [tableView dequeueReusableCellWithIdentifier:onlyTextCellIdentifier];
    PropFollowRecordCell *propFollowRecordCell = [tableView dequeueReusableCellWithIdentifier:propFollowCellIdentifier];
    
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == 0)
            {
                    // 基本信息
                    if (!allRoundDetailBasicMsgCell)
                    {
                        [tableView registerNib:[UINib nibWithNibName:@"AllRoundDetailBasicMsgCell"
                                                              bundle:nil]
                        forCellReuseIdentifier:basicItemCellIdetntifier];
                        
                        allRoundDetailBasicMsgCell = [tableView dequeueReusableCellWithIdentifier:basicItemCellIdetntifier];
                    }
                    
                    // 委托类型（出售=1、出租=2、租售=3）
                    // 售价超过“亿”，转换单位，数据是以“万”为单位
                    NSString *propSalePriceResultStr ;      // 房源售价
                    NSString *propRentPriceResultStr ;      // 房源租价
                    NSString *propSalePriceUnitStr;         // 售价单位
                    NSString *propSquareResultStr;          // 房屋面积
                    
                    // 计算售价
                    if (_propDetailEntity.salePrice.floatValue >= 10000)
                    {
                        propSalePriceResultStr = [NSString stringWithFormat:@"%.2f",
                                                  _propDetailEntity.salePrice.floatValue / 10000];
                        propSalePriceUnitStr = @"亿";
                    }
                    else
                    {
                        propSalePriceResultStr = [NSString stringWithFormat:@"%.2f",
                                                  _propDetailEntity.salePrice.floatValue];
                        propSalePriceUnitStr = @"万";
                    }
                    
                    if ([propSalePriceResultStr rangeOfString:@".00"].location != NSNotFound)
                    {
                        // 不是有效的数字，去除小数点后的0
                        propSalePriceResultStr = [propSalePriceResultStr
                                                  substringToIndex:propSalePriceResultStr.length - 3];
                    }
                    
                    propSquareResultStr = [NSString stringWithFormat:@"%.2f",
                                           _propDetailEntity.square.floatValue];
                    
                    if ([propSquareResultStr rangeOfString:@".00"].location != NSNotFound)
                    {
                        // 不是有效面积，去掉小数点后面的0
                        propSquareResultStr = [propSquareResultStr
                                               substringToIndex:propSquareResultStr.length - 3];
                    }
                    
                    propSalePriceResultStr = [NSString stringWithFormat:@"%@%@/%@㎡"
                                              ,propSalePriceResultStr
                                              ,propSalePriceUnitStr
                                              ,propSquareResultStr];

                    // 售价处显示的不同颜色字体
                    NSMutableAttributedString *propSaleAttriStr;
                    
                    if (propSalePriceResultStr)
                    {
                        propSaleAttriStr = [[NSMutableAttributedString alloc] initWithString:propSalePriceResultStr];
                        
                        NSInteger grayColorStarIndex = propSalePriceResultStr.length - propSquareResultStr.length - 2;
                        NSInteger grayColorLength = propSquareResultStr.length + 2;
                        
                        [propSaleAttriStr addAttribute:NSForegroundColorAttributeName
                                                 value:LITTLE_GRAY_COLOR
                                                 range:NSMakeRange(grayColorStarIndex,
                                                                   grayColorLength)];
                        [propSaleAttriStr addAttribute:NSFontAttributeName
                                                 value:[UIFont fontWithName:FontName
                                                                       size:11.0]
                                                 range:NSMakeRange(grayColorStarIndex,
                                                                   grayColorLength)];
                    }
                    
                    // 计算售单价
                    NSString *propSaleUnitPriceValueStr = [NSString stringWithFormat:@"%.2f",_propDetailEntity.saleUnitPrice.floatValue];
                    
                    if ([propSaleUnitPriceValueStr rangeOfString:@".00"].location != NSNotFound)
                    {
                        // 不是有效面积，去掉小数点后面的0
                        propSaleUnitPriceValueStr = [propSaleUnitPriceValueStr
                                                     substringToIndex:propSaleUnitPriceValueStr.length - 3];
                    }
                    propSaleUnitPriceValueStr = [NSString stringWithFormat:@"%@元/㎡",propSaleUnitPriceValueStr];
                    
                    // 计算租价
                    propRentPriceResultStr = [NSString stringWithFormat:@"%.2f",
                                              _propDetailEntity.rentPrice.floatValue];
                    if ([propRentPriceResultStr rangeOfString:@".00"].location != NSNotFound)
                    {
                        //不是有效的数字，去除小数点后的0
                        propRentPriceResultStr = [propRentPriceResultStr
                                                  substringToIndex:propRentPriceResultStr.length - 3];
                    }
                    propRentPriceResultStr = [NSString stringWithFormat:@"%@元/月"
                                              ,propRentPriceResultStr];
                    
                    // 租价处显示的不同颜色字体
                    NSMutableAttributedString *propRentAttriStr;
                    
                    if (propRentPriceResultStr)
                    {
                        propRentAttriStr= [[NSMutableAttributedString alloc] initWithString:propRentPriceResultStr];
                        
                        [propRentAttriStr addAttribute:NSForegroundColorAttributeName
                                                 value:LITTLE_GRAY_COLOR
                                                 range:NSMakeRange(propRentPriceResultStr.length - 3, 3)];
                        [propRentAttriStr addAttribute:NSFontAttributeName
                                                 value:[UIFont fontWithName:FontName
                                                                       size:11.0]
                                                 range:NSMakeRange(propRentPriceResultStr.length - 3, 3)];
                    }
                    
                    allRoundDetailBasicMsgCell.propSalePriceUnitTitleLabel.hidden = NO;
                    allRoundDetailBasicMsgCell.propSalePriceUnitLabel.hidden = NO;
                    allRoundDetailBasicMsgCell.propRentTitleLabel.hidden = NO;
                    allRoundDetailBasicMsgCell.propRentValueTitleLabel.hidden = NO;
                    
                    // 设置页面价格
                    if ([_propTrustType integerValue] == SALE)
                    {
                        allRoundDetailBasicMsgCell.propFirstPriceTitleLabel.text = @"售价：";
                        [allRoundDetailBasicMsgCell.propSalePriceLabel setAttributedText:propSaleAttriStr];
                        allRoundDetailBasicMsgCell.propSalePriceUnitLabel.text = propSaleUnitPriceValueStr;
                    }
                    else if ([_propTrustType integerValue] == RENT)
                    {
                        // 只有租价的时候，显示的格式为：租价/平米
                        propRentPriceResultStr = [NSString stringWithFormat:@"%@/%@㎡",
                                                  propRentPriceResultStr,
                                                  propSquareResultStr];
                        
                        NSMutableAttributedString *onlyPropRentPriceAttrStr;
                        
                        if (propRentPriceResultStr)
                        {
                            onlyPropRentPriceAttrStr= [[NSMutableAttributedString alloc] initWithString:propRentPriceResultStr];
                            
                            [onlyPropRentPriceAttrStr addAttribute:NSForegroundColorAttributeName
                                                     value:LITTLE_GRAY_COLOR
                                                     range:NSMakeRange(propRentPriceResultStr.length-propSquareResultStr.length-5,
                                                                       propSquareResultStr.length+5)];
                            [onlyPropRentPriceAttrStr addAttribute:NSFontAttributeName
                                                     value:[UIFont fontWithName:FontName
                                                                           size:11.0]
                                                     range:NSMakeRange(propRentPriceResultStr.length-propSquareResultStr.length-5,
                                                                       propSquareResultStr.length+5)];
                        }
                        
                        allRoundDetailBasicMsgCell.propFirstPriceTitleLabel.text = @"租价：";
                        [allRoundDetailBasicMsgCell.propSalePriceLabel setAttributedText:onlyPropRentPriceAttrStr];
                        allRoundDetailBasicMsgCell.propSalePriceUnitTitleLabel.hidden = YES;
                        allRoundDetailBasicMsgCell.propSalePriceUnitLabel.hidden = YES;
                        allRoundDetailBasicMsgCell.propRentTitleLabel.hidden = YES;
                        allRoundDetailBasicMsgCell.propRentValueTitleLabel.hidden = YES;
                    }
                    else if ([_propTrustType integerValue] == BOTH)
                    {
                        allRoundDetailBasicMsgCell.propFirstPriceTitleLabel.text = @"售价：";
                        allRoundDetailBasicMsgCell.propRentTitleLabel.text = @"租价：";
                        allRoundDetailBasicMsgCell.propRentPriceTitleTopHeight.constant = 15.0;
                        allRoundDetailBasicMsgCell.propRentPriceValueTopHeight.constant = 15.0;
                        
                        [allRoundDetailBasicMsgCell.propSalePriceLabel setAttributedText:propSaleAttriStr];
                        [allRoundDetailBasicMsgCell.propRentValueTitleLabel setAttributedText:propRentAttriStr];
                        allRoundDetailBasicMsgCell.propSalePriceUnitLabel.text = propSaleUnitPriceValueStr;
                    }
                    
                    allRoundDetailBasicMsgCell.propHouseTypeLabel.text = _propDetailEntity.roomType;
                    allRoundDetailBasicMsgCell.propFloorLabel.text = _propDetailEntity.floor;
                    allRoundDetailBasicMsgCell.propRightLabel.text = _propDetailEntity.propertyCardClassName;
                    allRoundDetailBasicMsgCell.propDirectionLabel.text = _propDetailEntity.houseDirection;
                    allRoundDetailBasicMsgCell.propHouseSituationLabel.text = _propDetailEntity.propertySituation;
                    allRoundDetailBasicMsgCell.propBringSeeTimesLabel.text = _propDetailEntity.takeSeeCount ? [NSString stringWithFormat:@"%@",_propDetailEntity.takeSeeCount] : _takeSeeCount ;
                
                    if ([_propDetailPresenter haveSquareOrSquareUseOrDecorationSituationOrPropertyUsage])
                    {
                        allRoundDetailBasicMsgCell.buildingAreaValue.text = [_propDetailEntity.square isEqualToString:@"㎡"] ? @"" : _propDetailEntity.square; // 建筑面积
                        allRoundDetailBasicMsgCell.practicalAreaValue.text = [_propDetailEntity.squareUse isEqualToString:@"㎡"] ? @"" : _propDetailEntity.squareUse; // 实用面积
                        allRoundDetailBasicMsgCell.decorationSituationValue.text = _propDetailEntity.decorationSituation; //装修情况
                        allRoundDetailBasicMsgCell.houseUseingValue.text = _propDetailEntity.propertyUsage; // 房屋用途
                    }
                  
                    return allRoundDetailBasicMsgCell;
                }
            
                if (indexPath.row == 1)
                {
                    // 特色
                    if (_propDetailEntity.propertyTags
                        && ![_propDetailEntity.propertyTags isEqualToString:@""])
                    {
                        if (!allRoundDetailOnlyTextCell)
                        {
                            [tableView registerNib:[UINib nibWithNibName:@"AllRoundDetailOnlyTextCell"
                                                                  bundle:nil]
                            forCellReuseIdentifier:onlyTextCellIdentifier];
                            
                            allRoundDetailOnlyTextCell = [tableView dequeueReusableCellWithIdentifier:onlyTextCellIdentifier];
                        }
                        
                        allRoundDetailOnlyTextCell.onlyTextLabel.text = _propDetailEntity.propertyTags;
                        
                        return allRoundDetailOnlyTextCell;
                    }
                    else
                    {
                        // 房源title
                        if (!allRoundTagsCell)
                        {
                            [tableView registerNib:[UINib nibWithNibName:@"ArrowSignTextCell"
                                                                  bundle:nil]
                            forCellReuseIdentifier:propTagsCellIdentifier];
                            allRoundTagsCell = [tableView dequeueReusableCellWithIdentifier:propTagsCellIdentifier];
                        }
                        
                        allRoundTagsCell.leftTextLabel.font = [UIFont fontWithName:FontName size:15.0];
                        allRoundTagsCell.leftTextLabel.text = _propTitleStr;
                        
                        // 查看过房号后隐藏查看房号“按钮”
                        if (_isCheckedHouseNum)
                        {
                            allRoundTagsCell.rightArrowImageView.hidden = YES;
                            allRoundTagsCell.rightTextLabel.text = @"";
                        }
                        else
                        {
                            allRoundTagsCell.rightArrowImageView.hidden = NO;
                            allRoundTagsCell.rightTextLabel.text = @"查看房号";
                        }
                        
                        return allRoundTagsCell;
                    }
                }

                if (indexPath.row == 2)
                {
                    // 房源的title
                    if (!allRoundTagsCell)
                    {
                        [tableView registerNib:[UINib nibWithNibName:@"ArrowSignTextCell"
                                                              bundle:nil]
                        forCellReuseIdentifier:propTagsCellIdentifier];
                        allRoundTagsCell = [tableView dequeueReusableCellWithIdentifier:propTagsCellIdentifier];
                    }
                    allRoundTagsCell.leftTextLabel.font = [UIFont fontWithName:FontName
                                                                          size:15.0];
                    allRoundTagsCell.leftTextLabel.text = _propTitleStr;
                    
                    // 查看过房号后隐藏查看房号“按钮”
                    if (_isCheckedHouseNum)
                    {
                        allRoundTagsCell.rightArrowImageView.hidden = YES;
                        allRoundTagsCell.rightTextLabel.text = @"";
                    }
                    else
                    {
                        allRoundTagsCell.rightArrowImageView.hidden = NO;
                        allRoundTagsCell.rightTextLabel.text = @"查看房号";
                    }
                    
                    return allRoundTagsCell;
                }
        }
            break;
            
        case 1:
        {
            // 房源跟进
            if (!propFollowRecordCell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"PropFollowRecordCell"
                                                      bundle:nil]
                forCellReuseIdentifier:propFollowCellIdentifier];
                propFollowRecordCell = [tableView dequeueReusableCellWithIdentifier:propFollowCellIdentifier];
            }
        
            BOOL departmentPermission = YES;
            
            if (![NSString isNilOrEmpty:_propDetailEntity.departmentPermissions])
            {
                departmentPermission = [_propDetailEntity.departmentPermissions contains:DEPARTMENT_PROPERTY_FOLLOW_SEARCH_ALL];
            }
            
            if (_followRecordEntity && departmentPermission)
            {
                propFollowRecordCell.propFollowOtherMsgLabel.hidden = NO;
                propFollowRecordCell.followType.hidden = NO;
                propFollowRecordCell.followTime.hidden = NO;
                
                NSString *detaileFormatDate = [CommonMethod getDetailedFormatDateStrFromTime:_followRecordEntity.followTime];
                
                propFollowRecordCell.propFollowDetailLabel.text = _followRecordEntity.followContent;
                propFollowRecordCell.propFollowOtherMsgLabel.text = _followRecordEntity.follower ? _followRecordEntity.follower : @"";
                propFollowRecordCell.propFollowOtherMsgLabel.textColor = rgba(71, 151, 202, 1);
                propFollowRecordCell.followType.text = _followRecordEntity.followType?_followRecordEntity.followType:@"";
                propFollowRecordCell.followTime.text = detaileFormatDate;
                
                if ([NSString isNilOrEmpty:_followRecordEntity.confirmUserName])
                {
                    propFollowRecordCell.imgConfirm.hidden = YES;
                }
                else
                {
                    propFollowRecordCell.imgConfirm.hidden = NO;
                }
            }
            else
            {
                propFollowRecordCell.propFollowDetailLabel.text = @"暂无";
                
                BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_SEARCH_ALL];
                
                if (!isAble || !departmentPermission)
                {
                     propFollowRecordCell.propFollowDetailLabel.text = @NotHavePermissionTip;
                }
                
                propFollowRecordCell.propFollowOtherMsgLabel.hidden = YES;
                propFollowRecordCell.followType.hidden = YES;
                propFollowRecordCell.followTime.hidden = YES;
            }
            
            return propFollowRecordCell;
        }
            break;
            
        case 2:
        {
                // 更多功能：实堪、钥匙、独家
            if (indexPath.row == 0)
            {
                if (!allRoundDetailMoreItemCell)
                {
                    if (!allRoundDetailMoreItemCell)
                    {
                        [tableView registerNib:[UINib nibWithNibName:@"AllRoundDetailMoreItemCell"
                                                              bundle:nil]
                        forCellReuseIdentifier:moreItemCellIdentifier];
                        allRoundDetailMoreItemCell = [tableView dequeueReusableCellWithIdentifier:moreItemCellIdentifier];
                    }
                    
                    allRoundDetailMoreItemCell.middleSepLineHeight.constant = 0.5;
                    [allRoundDetailMoreItemCell.takePhotoItemBtn addTarget:self
                                                                    action:@selector(moreItemPushMethodWithBtn:)
                                                          forControlEvents:UIControlEventTouchUpInside];
                    [allRoundDetailMoreItemCell.keyItemBtn addTarget:self
                                                              action:@selector(moreItemPushMethodWithBtn:)
                                                    forControlEvents:UIControlEventTouchUpInside];
                    [allRoundDetailMoreItemCell.onlySelfItemBtn addTarget:self
                                                                   action:@selector(moreItemPushMethodWithBtn:)
                                                         forControlEvents:UIControlEventTouchUpInside];
                    
                    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callPhonePress)];
                    [allRoundDetailMoreItemCell.callPhoneView addGestureRecognizer:singleTap];
                    
                    return allRoundDetailMoreItemCell;
                }
                
                allRoundDetailMoreItemCell.middleSepLineHeight.constant = 0.5;
                
                [allRoundDetailMoreItemCell.takePhotoItemBtn addTarget:self
                                                                action:@selector(moreItemPushMethodWithBtn:)
                                                      forControlEvents:UIControlEventTouchUpInside];
                [allRoundDetailMoreItemCell.keyItemBtn addTarget:self
                                                          action:@selector(moreItemPushMethodWithBtn:)
                                                forControlEvents:UIControlEventTouchUpInside];
                [allRoundDetailMoreItemCell.onlySelfItemBtn addTarget:self
                                                               action:@selector(moreItemPushMethodWithBtn:)
                                                     forControlEvents:UIControlEventTouchUpInside];
                
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                           action:@selector(callPhonePress)];
                [allRoundDetailMoreItemCell.callPhoneView addGestureRecognizer:singleTap];
                
                return allRoundDetailMoreItemCell;
            }
        }
            break;
            
        default:
            return [[UITableViewCell alloc] init];
            break;
    }
    
    return [[UITableViewCell alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
                if (indexPath.row == 0)
                {
                    float GZAddFieldHeight = [_propDetailPresenter haveSquareOrSquareUseOrDecorationSituationOrPropertyUsageAddHight];
                    // 租售
                    if ([_propTrustType integerValue] == BOTH)
                    {
                        return 164 + GZAddFieldHeight;
                    }
                    else
                    {
                        return 133 + GZAddFieldHeight;
                    }
                }
                else if (indexPath.row == 1)
                {
                    if (_propDetailEntity.propertyTags
                        && ![_propDetailEntity.propertyTags isEqualToString:@""])
                    {
                        
                        CGFloat propertyTagsWidth = [_propDetailEntity.propertyTags
                                                     getStringHeight:[UIFont fontWithName:FontName
                                                                                     size:15.0]
                                                     width:APP_SCREEN_WIDTH-24
                                                     size:15.0];
                        propertyTagsWidth = propertyTagsWidth < 15 ? 15:propertyTagsWidth;
                        
                        return propertyTagsWidth + 28;
                    }
                    
                    return 44.0;
                }
            
                else if (indexPath.row == 2)
                {
                    return 44;
                }
                else
                {
                    return 0;
                }
        }
            break;
            
        case 1:
        {
            if (indexPath.row == 0)
            {
                 return 82;
            }
            else
            {
               return 0;
            }
        }
            break;
            
        case 2:
        {
            if (indexPath.row == 0)
            {
                return 165;
            }
            else
            {
                return 0;
            }
        }
        default:
            
            return 0;
            
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 0.1;
        }
            break;
            
        case 1:
        {
            return 42.0;
        }
            break;
            
        case 2:
        {
            return 0.1;
        }
            break;
            
        default:
            return 0.1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 4.0;
    }
    
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        // 如果房源有特色，则查看房号位于第三行，若没有，则位于第二行
        if (_propDetailEntity.propertyTags
            && ![_propDetailEntity.propertyTags isEqualToString:@""])
        {
            if (indexPath.row == 2)
            {
                [self clickCheckHouseNoMethod];
            }
        }
        else
        {
            if (indexPath.row == 1)
            {
                [self clickCheckHouseNoMethod];
            }
        }
    }
    else if (indexPath.section == 1)
    {
        BOOL isAble = [_propDetailPresenter canViewFollowList:_propDetailEntity.departmentPermissions];
        if (isAble)
        {
            // 跟进列表
            MoreFollowListViewController *moreFollowListVC = [[MoreFollowListViewController alloc]initWithNibName:@"MoreFollowListViewController"
                                                                                                           bundle:nil];
            moreFollowListVC.freshFollowListDelegate = self;
            moreFollowListVC.propKeyId = _propKeyId;
			moreFollowListVC.propertyStatusCategory = _propDetailEntity.propertyStatusCategory;
			moreFollowListVC.propDetailEntity = _propDetailEntity;
			moreFollowListVC.propModelEntity = _propModelEntity;
            moreFollowListVC.departmentPermisstion = _propDetailEntity.departmentPermissions;
            moreFollowListVC.propTrustType = _propTrustType;
            moreFollowListVC.propertyStatus = _propDetailEntity.propertyStatus;
            
            [self.navigationController pushViewController:moreFollowListVC animated:YES];
        }
        else
        {
            showMsg(@(NotHavePermissionTip));
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MODEL_VERSION >= 7.0)
    {
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if (MODEL_VERSION >= 8.0)
        {
            // Prevent the cell from inheriting the Table View's margin settings
            if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
            {
                [cell setPreservesSuperviewLayoutMargins:NO];
            }
            
            // Explictly set your cell's layout margins
            if ([cell respondsToSelector:@selector(setLayoutMargins:)])
            {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    }
}

#pragma mark - <PickerViewDelegate>

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *nameArr = [_propDetailPresenter getTrustorsName];
    return nameArr.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *cusPicLabel = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 20.0f)];
    
    NSArray *nameArr = [_propDetailPresenter getTrustorsName];
    
    cusPicLabel.text = nameArr[row];
    [cusPicLabel setFont:[UIFont systemFontOfSize:18.0]];
    [cusPicLabel setTextAlignment:NSTextAlignmentCenter];
    cusPicLabel.backgroundColor = [UIColor clearColor];
    
    return cusPicLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectIndex = row;
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == CallRealPhoneAlertTag)
    {
        switch (buttonIndex)
        {
            case 1:
            {
                [CallRealPhoneLimitUtil addCallRealPhoneRecordWithPropKeyId:self.propKeyId];
                
                NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",_mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
            }
                break;
                
            default:
                break;
        }
    }
    // 选择发布房源租售类型的弹框提示
    else if (alertView.tag == PublishPropertyAlertTag)
    {
        if (buttonIndex == 0)
        {
            return;
        }

        if (buttonIndex == 1)
        {
            //出售
            _trustType = [NSString stringWithFormat:@"%d",SALE];
        }
        else if (buttonIndex == 2)
        {
            //出租
            _trustType = [NSString stringWithFormat:@"%d",RENT];
        }

        //3.判断是否发过房源广告
        FindIsExitAdApi *findIsExitAdApi = [[FindIsExitAdApi alloc] init];
        findIsExitAdApi.propertyKeyId = _propKeyId;
        findIsExitAdApi.tradeType = _trustType;
        [_manager sendRequest:findIsExitAdApi];
        
        [self showLoadingView:@"正在验证房源..."];
    }
    // 待上架提示
    else if (alertView.tag == DSJAlertTag)
    {
        if (buttonIndex == 0)
        {
            // 取消
            return;
        }
        if (buttonIndex == 1)
        {
            // 4.编辑广告---跳转到发布房源界面
            _isOnlineAd = NO;
            // 5.判断房源详情的字断是否符合要求
            [self isLogicalPramar];
        }
        else if (buttonIndex == 2)
        {
            // 4.上架广告
            // 验证非有效房源
            if ([_propertyStatus  integerValue] != VALID)
            {
                showMsg(@"此房源为非有效房源，无法上架广告!");
                return;
            }

            // 编辑广告----跳转到发布房源界面
            _isOnlineAd = YES;
            // 5.判断房源详情的字断是否符合要求
            [self isLogicalPramar];
        }
    }
    // 推送列表弹框提示
    else if (alertView.tag == PublishListAlertTag)
    {
        if (buttonIndex == 1)
        {
            // 编辑广告----跳转到发布房源界面
            _isOnlineAd = NO;
            // 4.判断房源详情的字断是否符合要求
            [self isLogicalPramar];
        }
    }
    // 发布房源数量超过限制的弹框提示
    else if (alertView.tag == ExceedingCommitAlerttag)
    {
        if (buttonIndex == 0)
        {
            //不保存到待上架区
            return;
        }
        else if (buttonIndex == 1)
        {
            //保存到待上架区
            //跳转到发布房源界面
            [self pushProperty];
        }
    }
    // 已在上架区的弹框提示
    else if (alertView.tag == HaveOnlineAdAlertTag)
    {
        if (buttonIndex == 1)
        {
            // 4.编辑广告
            // 编辑广告----跳转到发布房源界面
            _isOnlineAd = NO;
            // 5.判断房源详情的字断是否符合要求
            [self isLogicalPramar];
        }
    }
    else if (alertView.tag == CheckHouseNoActionTag){
        //查看房号
        if (buttonIndex != alertView.cancelButtonIndex) {
            
            [self checkRoomNum];
            
        }
        
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - private
- (void)checkRoomNum{
    
    NSString *staffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
    
    _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
    // 保存到本地查看过的房号
    [_dataBaseOperation insertKeyIdOfCheckedRoomNum:_propKeyId
                                         andStaffNo:staffNo
                                            andDate:[NSDate stringWithSimpleDate:[NSDate date]]];
    // 查看房号
    [CheckRoomNumUtil useCheckRoomNumLimit];
    
    _isCheckedHouseNum = YES;
    if ([_propDetailPresenter isShowPinPropertyTitle])
    {
        _propTitleStr = [NSString stringWithFormat:@"%@%@%@",_propDetailEntity.estateName,_propDetailEntity.buildingName,_propDetailEntity.houseNo];
    }
    else
    {
        _propTitleStr = _propHouseNo;
    }
    
    self.title = _propTitleStr ? _propTitleStr : @"";
    [_mainTableView reloadData];
    
}

#pragma mark - 发布房源 / 编辑房源

/// 判断编辑房源权限
- (BOOL)isHavePermission
{
    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_PROPERTY_MODIFY_NONE])
    {
        // 无
        return NO;
    }
    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_PROPERTY_MODIFY_MYSELF])
    {
        // 本人---判断该房源是否是本人房源
        NSString *propertyChiefKeyId = _propDetailEntity.propertyChiefKeyId;//房源所属人
        IdentifyEntity *idenEntity = [AgencyUserPermisstionUtil getIdentify];
        if ([propertyChiefKeyId isEqualToString:idenEntity.uId])
        {
            return YES;
        }
        
        return NO;
    }
    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_PROPERTY_MODIFY_MYDEPARTMENT])
    {
        // 本部---判断该房源是否是本部房源
        NSString *propertyChiefDepartmentKeyId = _propDetailEntity.propertyChiefDepartmentKeyId;//所属部门
        IdentifyEntity *idenEntity = [AgencyUserPermisstionUtil getIdentify];
        if ([propertyChiefDepartmentKeyId isEqualToString:idenEntity.departId])
        {
            return YES;
        }
        
        return NO;
    }
    
    // 全部
    return YES;
}

/// 判断备案
- (void)findRestisterTrust
{
    NSInteger registerTrustStatusNum = [_findRegisterTrustEntity.status integerValue];

    // 2.********1－业主委托  2－备案审核
    if ([_agentQuotaEntity.registerTrustsOnOff isEqualToString:@"1"])
    {
        // 1开启
        if ([_agentQuotaEntity.registerTrustAudit isEqualToString:@"1"])
        {
            // 2开启
            if (registerTrustStatusNum == -1 || registerTrustStatusNum == 0 ||registerTrustStatusNum == 2)
            {
                showMsg(@"此房源无委托或委托未审核通过，无法发布房源");
                return;
            }
        }
        else
        {
            // 2关闭
            if (registerTrustStatusNum == -1)
            {
                showMsg(@"此房源无委托或委托未审核通过，无法发布房源");
                return;
            }
        }
    }
    
    // 1－关闭，不进行任何判断

    // 3.判断租售状态选择？
    if ([_propModelEntity.trustType integerValue] == 1)
    {
        // 出售
        _trustType = @"1";
    }
    else if ([_propModelEntity.trustType integerValue] == 2)
    {
        // 出租
        _trustType = @"2";
    }
    else
    {
        // 租售
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"此房源为租售类型，请选择发布类型"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"发布出售",@"发布出租", nil];
        alertView.tag = PublishPropertyAlertTag;
        [alertView show];
        return;
    }

    // 4.判断是否发过房源广告网络请求
    FindIsExitAdApi *findIsExitAdApi = [[FindIsExitAdApi alloc] init];
    findIsExitAdApi.propertyKeyId = _propKeyId;
    findIsExitAdApi.tradeType = _trustType;
    [_manager sendRequest:findIsExitAdApi];
    
    [self showLoadingView:@"正在验证房源..."];
}

/// 是否发过广告
- (void)isPushAd
{
    if ([_findIsExitEntity.status integerValue] == 0 && _findIsExitEntity.adNo.length > 0)
    {
        // 已上架
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"房源广告已在上架区，无法再次发布!"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消" otherButtonTitles:@"编辑广告", nil];
        alertView.tag = HaveOnlineAdAlertTag;
        [alertView show];
        return;
    }
    else if ([_findIsExitEntity.status integerValue] == 1)
    {
        // 已在待上架区
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"房源广告已在待上架区中，无法再次推送!"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"编辑广告",@"上架广告", nil];
        alertView.tag= DSJAlertTag;
        [alertView show];
        return;
    }
    else if ([_findIsExitEntity.status integerValue] == 2)
    {
        // 已在推送列表
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"房源广告已在推送列表中，无法再次推送!"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"编辑广告", nil];
        alertView.tag = PublishListAlertTag;
        [alertView show];
        return;
    }

    // 4.如果没有发过广告，就判断房源详情的字断是否符合要求
    _isOnlineAd = NO;
    
    [self isLogicalPramar];
}

/// 判断房源详情的字断是否符合要求
- (void)isLogicalPramar
{
    EditHouseVO *checkHouseInfoEntity = [EditHouseVO new];
    // 房源面积
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                         message:nil
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"好", nil];
    
    // 判断房源详情的字断是否符合要求
    checkHouseInfoEntity = [_propDetailPresenter needCheckHouseSquare:_propDetailEntity
                                              andCheckHouseInfoEntity:checkHouseInfoEntity];
    if (checkHouseInfoEntity.title.length > 0)
    {
        alertView.title = checkHouseInfoEntity.title;
        alertView.message = checkHouseInfoEntity.message;
        [alertView show];
        
        return;
    }
  
    // 检查房源价格(租价, 售价)
    checkHouseInfoEntity = [_propDetailPresenter needCheckHousePrice:_propDetailEntity
                                                        andTrustType:_trustType
                                             andCheckHouseInfoEntity:checkHouseInfoEntity];
    if (checkHouseInfoEntity.title.length > 0)
    {
        alertView.title = checkHouseInfoEntity.title;
        alertView.message = checkHouseInfoEntity.message;
        [alertView show];
        return;
    }


    // 是否需要验证房屋朝向
    checkHouseInfoEntity = [_propDetailPresenter needCheckHouseDirection:_propDetailEntity
                                                 andCheckHouseInfoEntity:checkHouseInfoEntity];
    if (checkHouseInfoEntity.title.length > 0)
    {
        alertView.title = checkHouseInfoEntity.title;
        alertView.message = checkHouseInfoEntity.message;
        [alertView show];
        return;
    }

    
    // 是否需要验证产权性质
    checkHouseInfoEntity = [_propDetailPresenter needCheckHousePropertyRight:_propDetailEntity
                                                     andCheckHouseInfoEntity:checkHouseInfoEntity];
    if (checkHouseInfoEntity.title.length > 0)
    {
        alertView.title = checkHouseInfoEntity.title;
        alertView.message = checkHouseInfoEntity.message;
        [alertView show];
        return;
    }
    
    // 房屋用途
    checkHouseInfoEntity = [_propDetailPresenter needCheckHousePropertyType:_propDetailEntity
                                                    andCheckHouseInfoEntity:checkHouseInfoEntity];
    if (checkHouseInfoEntity.title.length > 0)
    {
        alertView.title = checkHouseInfoEntity.title;
        alertView.message = checkHouseInfoEntity.message;
        [alertView show];
        return;
    }
    
    checkHouseInfoEntity = [_propDetailPresenter needCheckHouseFloor:_propDetailEntity
                                             andCheckHouseInfoEntity:checkHouseInfoEntity];
    if (checkHouseInfoEntity.title.length > 0)
    {
        alertView.title = checkHouseInfoEntity.title;
        alertView.message = checkHouseInfoEntity.message;
        [alertView show];
        return;
    }

    // 实勘
    checkHouseInfoEntity = [_propDetailPresenter needCheckHouseRealSurvey:_checkRealSurveyEntity
                                                  andCheckHouseInfoEntity:checkHouseInfoEntity];
    if (checkHouseInfoEntity.title.length > 0)
    {
        alertView.title = checkHouseInfoEntity.title;
        alertView.message = checkHouseInfoEntity.message;
        [alertView show];
        return;
    }
    
    // 房型
    checkHouseInfoEntity = [_propDetailPresenter needCheckHouseRoomType:_propDetailEntity
                                                andCheckHouseInfoEntity:checkHouseInfoEntity];
    if (checkHouseInfoEntity.title.length > 0)
    {
        alertView.title = checkHouseInfoEntity.title;
        alertView.message = checkHouseInfoEntity.message;
        [alertView show];
        return;
    }
    alertView = nil;

    // 5.判断如果发布房源次数超过数量，保存到待上架区
    [self pushCommintNumIsEmpty];

}

/// 发布房源数量为0时保存到待上架区
- (void)pushCommintNumIsEmpty
{
    // 如果超过发布数量
        if (_agentQuotaEntity.countPropertyAd == 0)
        {
            if (_isOnlineAd)
            {
                // 在待上架区的不用显示是否
                showMsg(@"已超过上架数量，无法上架！");
                return;
            }
            else
            {
                if ([_findIsExitEntity.status integerValue] == 0 && _findIsExitEntity.adNo.length > 0)
                {
                    // 已在上架区，不弹提示
                    
                }
                else if ([_findIsExitEntity.status integerValue] == 1)
                {
                    // 在待上架区，不弹提示
                }
                else
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已超过发布数量，是否保存到待上架区？"
                                                                        message:nil
                                                                       delegate:self
                                                              cancelButtonTitle:@"否"
                                                              otherButtonTitles:@"是", nil];
                    alertView.tag = ExceedingCommitAlerttag;
                    [alertView show];
                    return;
                }
            }
    }

    // 6.跳转到发布房源界面／上架广告
    if (!_isOnlineAd)
    {
        // 发布房源
        [self pushProperty];
    }
    else
    {
        // 上架广告
        [self onlineAd];
    }
}

/// 上架广告
- (void)onlineAd
{
    [self showLoadingView:nil];
    
    GetEstOnlineOrOfflineApi *getEstOnlineOrOfflineApi = [[GetEstOnlineOrOfflineApi alloc] init];
    getEstOnlineOrOfflineApi.getEstSetType = OnLine;
    getEstOnlineOrOfflineApi.keyIds = @[_findIsExitEntity.keyId];
    [_manager sendRequest:getEstOnlineOrOfflineApi];
}

/// 跳转发布房源
- (void)pushProperty
{
    WebViewModuleVC *vc = [[WebViewModuleVC alloc] init];

    if ([_trustType isEqualToString:@"1"])
    {
        // 出售
        vc.tradeType = @"S";
    }
    else if ([_trustType isEqualToString:@"2"])
    {
        // 出租
        vc.tradeType = @"R";
    }
    
    if (_findIsExitEntity.adNo.length > 0)
    {
        vc.adKeyId = _findIsExitEntity.keyId;
    }
    else
    {
        vc.adKeyId = @"";
    }
    
    vc.requestUrl = [[BaseApiDomainUtil getApiDomain] getPulishPropertyUrl];
    vc.propModelEntity = _propModelEntity;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 获取全部实勘
- (void)requestAllRealSurvey
{
    GetAllRealSurveyPhotoApi *getAllRealSurveyPhotoApi = [[GetAllRealSurveyPhotoApi alloc] init];
    getAllRealSurveyPhotoApi.keyId = _propKeyId;
    [_manager sendRequest:getAllRealSurveyPhotoApi];
}

- (void)addCallPhoneView:(UIView *)callView
{
    [self.view addSubview:callView];
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    [self hiddenLoadingView];
    
    if ([modelClass isEqual:[PropPageDetailEntity class]])
    {
        // 房源详情
        _propDetailEntity = [DataConvert convertDic:data toEntity:modelClass];
        _propertyNo = _propDetailEntity.propertyNo.length > 0?_propDetailEntity.propertyNo:@"";

        if ([self isSaleAndOrder])
        {
            _isCollected = _propDetailEntity.isFavorite;
            _propertyStatus = [NSString stringWithFormat:@"%@",_propDetailEntity.propertyStatusCategory];
            [_mainTableView reloadData];
            
            // 图片路径
            _propImgUrl = [NSString isNilOrEmpty:_propDetailEntity.photoPath] ? _propImgUrl : _propDetailEntity.photoPath;
            // type
            _propTrustType = _propTrustType ? _propTrustType : _propDetailEntity.trustType;
            _propTrustType = [NSString stringWithFormat:@"%@",_propTrustType];
            
            // 房号
            if (_isCheckedHouseNum)
            {
                _propTitleStr =  _propDetailEntity.allHouseInfo ? _propDetailEntity.allHouseInfo : @"";
                self.title = _propTitleStr ? _propTitleStr :@"";
            }
            else
            {
                if ([_propDetailPresenter isShowPinPropertyTitle])
                {
                    _propHouseNo = _propDetailEntity.houseNo;
                    _propTitleStr =  [NSString stringWithFormat:@"%@%@",_propDetailEntity.estateName,_propDetailEntity.buildingName];
                    self.title = _propTitleStr;
                }
                else
                {
                    _propHouseNo = _propDetailEntity.allHouseInfo;
                }
            }
            // 获取房源跟进第一条记录
            [self getFollowRecord];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"您无权限查看该售预定房源"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确认", nil];
            [alertView show];
        }
    }
    else if ([modelClass isEqual:[CheckRealProtectedEntity class]])
    {
        // 验证实勘保护期
        CheckRealProtectedEntity *checkRealProtectedEntity = [DataConvert convertDic:data toEntity:modelClass];

        BOOL isAble = [_propDetailPresenter canAddUploadrealSurvey:_propDetailEntity.departmentPermissions];
        if (isAble)
        {
            NSString *isLockRoom = [NSString stringWithFormat:@"%d",checkRealProtectedEntity.isLockRoom];

            UploadRealSurveyViewController *uploadRealSurveyVC = [[UploadRealSurveyViewController alloc]initWithNibName:@"UploadRealSurveyViewController"
                                                                                                                 bundle:nil];
            uploadRealSurveyVC.propKeyId = _propKeyId;
            uploadRealSurveyVC.imgUploadCount = [checkRealProtectedEntity.imgUploadCount integerValue];

            if (![NSString isNilOrEmpty:checkRealProtectedEntity.width])
            {
                uploadRealSurveyVC.widthScale = [checkRealProtectedEntity.width integerValue];
            }
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.high])
            {
                uploadRealSurveyVC.hightScale = [checkRealProtectedEntity.high integerValue];
            }
            if (![NSString isNilOrEmpty:isLockRoom])
            {
                uploadRealSurveyVC.isLockRoom = checkRealProtectedEntity.isLockRoom;
            }
            
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.imgRoomMaxCount])
            {
                uploadRealSurveyVC.imgRoomMaxCount = [checkRealProtectedEntity.imgRoomMaxCount integerValue];
            }
            
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.imgAreaMaxCount])
            {
                uploadRealSurveyVC.imgAreaMaxCount = [checkRealProtectedEntity.imgAreaMaxCount integerValue];
            }
            
            [self.navigationController pushViewController:uploadRealSurveyVC animated:YES];
        }
        else
        {
            showMsg(@(NotHavePermissionTip));
        }
    }
    else if ([modelClass isEqual:[FollowRecordEntity class]])
    {
        // 最新的跟进列表（第一条）
        [self hiddenHUDLoadingView];
        FollowRecordEntity *followRecordEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        if (followRecordEntity.propFollows.count > 0)
        {
            _followRecordEntity = [followRecordEntity.propFollows objectAtIndex:0];
            [_mainTableView reloadData];
        }
    }
    else if ([modelClass isEqual:[PropTrustorsInfoEntity class]])
    {
        [_propDetailPresenter getDataSource:data];
        [self showTrustors];
    }
    else if ([modelClass isEqual:[PropTrustorsInfoForShenZhenEntity class]])
    {
        [_propDetailPresenter getDataSource:data];
        [self showTrustors];
    }
    else if ([modelClass isEqual:[AgencyBaseEntity class]])
    {
        // 收藏、取消收藏
        AgencyBaseEntity *collectResultEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        if (collectResultEntity.flag)
        {
            if (_isCollected)
            {
                [CustomAlertMessage showAlertMessage:@"取消收藏成功\n\n" andButtomHeight:APP_SCREEN_HEIGHT/2];
            }
            else
            {
                [CustomAlertMessage showAlertMessage:@"收藏成功\n\n" andButtomHeight:APP_SCREEN_HEIGHT/2];
            }
            _isCollected = !_isCollected;
        }
    }
    else if ([modelClass isEqual:[CheckRealSurveyEntity class]])
    {
        // 获取全部的实勘
        _checkRealSurveyEntity = [DataConvert convertDic:data toEntity:modelClass];
    }
    else if ([modelClass isEqual:[AgentQuotaEntity class]])
    {
        // 1.判断发布房源权限
        _agentQuotaEntity = [DataConvert convertDic:data toEntity:modelClass];
        if (!_agentQuotaEntity.admPermission)
        {
            [self hiddenHUDLoadingView];
            showMsg(@"您没有发布房源的权限！");
            return;
        }

        // 2. 判断是否有业主委托
        FindHasRegisterTrustApi *findHasRegisterTrustApi = [[FindHasRegisterTrustApi alloc] init];
        findHasRegisterTrustApi.propertyKeyId = _propKeyId;
        [_manager sendRequest:findHasRegisterTrustApi];
    }
    else if ([modelClass isEqual:[FindRegisterTrustEntity class]])
    {
        // 是否有业主委托
        [self hiddenHUDLoadingView];
        _findRegisterTrustEntity = [DataConvert convertDic:data toEntity:modelClass];

        [self findRestisterTrust];
    }
    else if ([modelClass isEqual:[FindIsExitEntity class]])
    {
        // 该房源是否发过广告
        _findIsExitEntity = [DataConvert convertDic:data toEntity:modelClass];
        [self isPushAd];
    }
    else if ([modelClass isEqual:[EstReleaseOnLineOrOffLineEntity class]])
    {
        // 6.上架广告
        EstReleaseOnLineOrOffLineEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        if (entity.operateResult.operateResult == YES)
        {
            showMsg(@"上架成功");
        }
        else
        {
            NSString *failreson = entity.operateResult.faildReason;
            showMsg(failreson);
        }
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    [self hiddenHUDLoadingView];
}

@end
