//
//  AllRoundDetailViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/26.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "HQAllRoundDetailVC.h"
#import "AllRoundDetailMoreItemCell.h"
#import "BaiduMobStat.h"
#import "AllRoundDetailBasicMsgCell.h"
#import "AllRoundDetailOnlyTextCell.h"
#import "PropPageDetailEntity.h"
#import "ArrowSignTextCell.h"
#import "PropFollowRecordCell.h"
#import "FollowRecordEntity.h"
#import "UploadRealSurveyViewController.h"
#import "DataBaseOperation.h"
#import "MoreFollowListViewController.h"
#import "PropAroundMapViewController.h"
#import "VoiceRecordViewController.h"
//#import "PropertyStatusCategoryDefine.h"
//#import "TrustTypeDefine.h"
#import "PropertyStatusCategoryEnum.h"
#import "PersonalInfoEntity.h"
#import "CheckRealProtectedEntity.h"
#import "CheckRealProtectedDurationApi.h"
#import "GetPropDetailApi.h"
#import "CollectPropApi.h"
#import "GetFollowRecordApi.h"
#import "GetTrustorsApi.h"
#import "TrustorEntity.h"
#import "PropertyStatusCategoryEnum.h"
#import "HQAllRoundDetailBasicMsgCell.h"
#import "VirtualCallPhoneApi.h"
#import "HQCallNumberEntity.h"
#import "NSDate+Format.h"
#import "PropTrustorsInfoForShenZhenEntity.h"
#import "TelServiceApi.h"



#define ButtomMoreItemBtnTag        1000
#define TopMoreItemActionTag        2000
#define CheckHouseNoActionTag       3000
#define CallRealPhoneAlertTag       4000
#define CallZeroAlertTag            5000


@interface HQAllRoundDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    
    CheckRealProtectedDurationApi *_checkRealProtectedApi;
    GetPropDetailApi *_getPropDetailApi;
    CollectPropApi *_collectPropApi;
    GetFollowRecordApi *_getFollowApi;
    GetTrustorsApi *_getTrustorsApi;
    VirtualCallPhoneApi *_virtualCallPhoneApi;
    
    __weak IBOutlet UITableView *_mainTableView;
    
    PropPageDetailEntity *_propDetailEntity;
    PropFollowRecordDetailEntity *_followRecordEntity;
    DataBaseOperation *_dataBaseOperation;
    PersonalInfoEntity *_resultEntity;
    
    NSString *_propTitleStr;
    BOOL _isCheckedHouseNum;    //是否已查看过房号
    PropTrustorsInfoEntity *_propTrustorsInfoEntity;
    PropTrustorsInfoForShenZhenEntity *_propTrustorsForSZ;
    NSInteger _selectIndex;
    NSString *_mobile;
    
    NSString *_right;
    NSString *_phoneId;     // 业主id
    NSString *_isMobile;     //  1手机 0座机
    
    BOOL _isCollected;  //是否已收藏当前房源
    BOOL _isAllHouseNum; //是否显示全部房号
    
    // 是否是真实拨打虚拟号状态
//    BOOL _isReallyState;
}

@end

@implementation HQAllRoundDetailVC

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    [self initData];
    [self isCheckedRoomNum];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取最新房源跟进
    [self getFollowRecord];
}

#pragma mark - Init

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

- (void)initData
{
    [self showLoadingView:nil];
    
    // 可以直接查看真实房号
    _isAllHouseNum = YES;
    
    _checkRealProtectedApi = [CheckRealProtectedDurationApi new];
    _getPropDetailApi = [GetPropDetailApi new];
    _collectPropApi = [CollectPropApi new];
    _getFollowApi = [GetFollowRecordApi new];
    _getTrustorsApi = [GetTrustorsApi new];
    _virtualCallPhoneApi = [VirtualCallPhoneApi new];
    
    // 获取房源详情
    _getPropDetailApi.propKeyId = _propKeyId;
    [_manager sendRequest:_getPropDetailApi];
}


// 检查出售预订房源的查看权限
- (BOOL)isSaleAndOrder
{
    BOOL view = NO;
    
    NSInteger status = [_propDetailEntity.propertyStatusCategory integerValue];
    NSInteger ccaiType = -1;
    if(_propDetailEntity.cCAIReturnTrustType)
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
            if([AgencyUserPermisstionUtil hasRight:PROPERTY_PREORDAINPROPERTY_SEARCH_ALL])
            {
                return YES;
            }
            
            // 本人权限
            if([AgencyUserPermisstionUtil hasRight:PROPERTY_PREORDAINPROPERTY_SEARCH_MYSELF])
            {
                
                NSString *userKeyId = [AgencyUserPermisstionUtil getIdentify].uId;
                if([userKeyId isEqualToString:propertyChiefKeyId] || [userKeyId isEqualToString:propertyTraderKeyId])
                {
                    return YES;
                }
                else
                {
                    return NO;
                }
            }
            
            // 本部权限
            if([AgencyUserPermisstionUtil hasRight:PROPERTY_PREORDAINPROPERTY_SEARCH_MYDEPARTMENT])
            {
                NSString *departmentKeyIds = [AgencyUserPermisstionUtil getAgencyPermisstion].departmentKeyIds;
                BOOL isContainsDepartment = [AgencyUserPermisstionUtil Content:departmentKeyIds ContainsWith:propertyChiefDepartmentKeyId];
                BOOL isContainsTrade = [AgencyUserPermisstionUtil Content:departmentKeyIds ContainsWith:propertyTraderDepartmentKeyId];
                
                if(isContainsDepartment || isContainsTrade)
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

/// 遍历已查看过房号的房源id，看当前房源是否查看过房号
- (void)isCheckedRoomNum
{
    if (_isAllHouseNum)
    {
        _isCheckedHouseNum = YES;
        _propTitleStr = [NSString stringWithFormat:@"%@%@%@",
                         _propNameStr,
                         _propBuildingName,
                         _propHouseNo?_propHouseNo:@""];
    }
    else
    {
        _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
        
        NSString *curStaffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
        NSMutableArray *checkedHouseNumList = [_dataBaseOperation selectAllKeyIdOfCheckedRoomNumWithStaffNo:curStaffNo andDate:[NSDate stringWithSimpleDate:[NSDate date]]];
        
        for (NSString *keyIdStr in checkedHouseNumList)
        {
            if ([keyIdStr isEqualToString:_propKeyId])
            {
                // 当前房源已查看过房号
                _isCheckedHouseNum = YES;
                _propTitleStr = [NSString stringWithFormat:@"%@%@%@",
                                 _propNameStr,
                                 _propBuildingName,
                                 _propHouseNo?_propHouseNo:@""];
                break;
            }
        }
        
        if (checkedHouseNumList.count == 0 || !_isCheckedHouseNum)
        {
            // 当前房源未查看过房号
            _isCheckedHouseNum = NO;
            _propTitleStr = [NSString stringWithFormat:@"%@%@", _propNameStr, _propBuildingName];
        }
    }
    
        self.title = _propTitleStr;
}

/// 获得第一条房源跟进
- (void)getFollowRecord
{
    BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_SEARCH_ALL];
    BOOL hasPermisstion = YES;
    
    if (![NSString isNilOrEmpty:_propDetailEntity.departmentPermissions])
    {
        hasPermisstion =   [_propDetailEntity.departmentPermissions contains:DEPARTMENT_PROPERTY_FOLLOW_SEARCH_ALL];
    }
    
    if(isAble && hasPermisstion)
    {
        _getFollowApi.pageIndex = @"1";
        _getFollowApi.pageSize = @"1";
        _getFollowApi.isDetails = @"YES";
        _getFollowApi.propKeyId = _propKeyId;
        _getFollowApi.followTypeKeyId = @"";
        [_manager sendRequest:_getFollowApi];
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
//            [checkHouseNoAction show];
        }
    }
}

#pragma mark - ClickMoreItemMethod

- (void)clickMoreItemMethod
{
    if (_propDetailEntity) {
        
        NSString *isCollection = [NSString stringWithFormat:@"%@", _isCollected ? @"取消收藏" : @"收藏"];
        
        NSArray * listArr = @[@"分享", @"上传实勘", isCollection, @"录音", @"周边"];
        
        __block typeof(self) weakSelf = self;
        
        [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
            
            // 顶部更多按钮弹出的action
            switch (optionValue)
            {
                case 0:
                {
                    // 分享
                    [self sendSharePropDetailWithKeyId:_propKeyId
                                             andImgUrl:_propImgUrl
                                            andEstName:_propNameStr];
                }
                    break;
                case 1:
                {
                    // 上传实堪
                    BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_ADD_ALL];
                    BOOL hasPermisstion = YES;
                    
                    if (![NSString isNilOrEmpty:_propDetailEntity.departmentPermissions])
                    {
                        hasPermisstion =   [_propDetailEntity.departmentPermissions contains:DEPARTMENT_PROPERTY_REALSURVEY_ADD_ALL];
                    }
                    
                    if(isAble && hasPermisstion)
                    {
                        // 验证实堪保护期
                        _checkRealProtectedApi.keyId = _propKeyId;
                        [_manager sendRequest:_checkRealProtectedApi];
                        
                    }
                    else
                    {
                        showMsg(@(NotHavePermissionTip));
                    }
                }
                    break;
                case 2:
                {
                    // 收藏、取消收藏
                    if (_isCollected)
                    {
                        // 取消收藏
                        _collectPropApi.propKeyId = _propKeyId;
                        _collectPropApi.isCollect = NO;
                        [_manager sendRequest:_collectPropApi];
                    }
                    else
                    {
                        // 收藏
                        _collectPropApi.isCollect = YES;
                        _collectPropApi.propKeyId = _propKeyId;
                        [_manager sendRequest:_collectPropApi];
                    }
                }
                    break;
                case 3:
                {
                    // 录音
                    VoiceRecordViewController *voiceRecordVC = [[VoiceRecordViewController alloc]initWithNibName:@"VoiceRecordViewController"
                                                                                                          bundle:nil];
                    voiceRecordVC.propId = _propKeyId;
                    [self.navigationController pushViewController:voiceRecordVC animated:YES];
                }
                    break;
                case 4:
                {
                    // 周边
                    PropAroundMapViewController *propMapVC = [[PropAroundMapViewController alloc]
                                                              initWithNibName:@"PropAroundMapViewController"
                                                              bundle:nil];
                    propMapVC.latitude = _propDetailEntity.latitude.doubleValue;
                    propMapVC.longitude = _propDetailEntity.longitude.doubleValue;
                    propMapVC.propTitleString = _propNameStr;
                    
                    [self.navigationController pushViewController:propMapVC animated:YES];
                }
                    break;
                case 5:
                {
                    // 是否为真实状态拨打虚拟号
                    //                _isReallyState = !_isReallyState;
                }
                    
                default:
                    break;
            }
            
        }];
        
//        BYActionSheetView *byActionSheet = [[BYActionSheetView alloc]initWithTitle:nil
//                                                                          delegate:self
//                                                                 cancelButtonTitle:@"取消"
//                                                                 otherButtonTitles:
//                                            @"分享",@"上传实勘",isCollection,@"录音",@"周边", nil];
//        byActionSheet.tag = TopMoreItemActionTag;
//
//        [byActionSheet show];
    }
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
            
            if (_propDetailEntity.propertyTags)
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
    else
    {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *basicItemCellIdetntifier = @"HQAllRoundDetailBasicMsgCell";
    static NSString *moreItemCellIdentifier = @"allRoundDetailMoreItemCell";
    static NSString *propTagsCellIdentifier = @"arrowSignTextCell";
    static NSString *onlyTextCellIdentifier = @"allRoundDetailOnlyTextCell";
    static NSString *propFollowCellIdentifier = @"propFollowRecordCell";
    
    HQAllRoundDetailBasicMsgCell *allRoundDetailBasicMsgCell = [tableView dequeueReusableCellWithIdentifier:basicItemCellIdetntifier];
    AllRoundDetailMoreItemCell *allRoundDetailMoreItemCell = [tableView dequeueReusableCellWithIdentifier:moreItemCellIdentifier];
    ArrowSignTextCell *allRoundTagsCell = [tableView dequeueReusableCellWithIdentifier:propTagsCellIdentifier];
    AllRoundDetailOnlyTextCell *allRoundDetailOnlyTextCell = [tableView dequeueReusableCellWithIdentifier:onlyTextCellIdentifier];
    PropFollowRecordCell *propFollowRecordCell = [tableView dequeueReusableCellWithIdentifier:propFollowCellIdentifier];
    
    switch (indexPath.section)
    {
        case 0:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    // 基本信息
                    if (!allRoundDetailBasicMsgCell)
                    {
                        [tableView registerNib:[UINib nibWithNibName:@"HQAllRoundDetailBasicMsgCell"
                                                              bundle:nil]
                        forCellReuseIdentifier:basicItemCellIdetntifier];
                        
                        allRoundDetailBasicMsgCell = [tableView dequeueReusableCellWithIdentifier:basicItemCellIdetntifier];
                    }
                    
                    
                    if ([_isMacau boolValue])
                    {
                        [allRoundDetailBasicMsgCell.secondImage setImage:[UIImage imageNamed:@"RMB"]];
                        [allRoundDetailBasicMsgCell.firstImage setImage:[UIImage imageNamed:@"HK"]];
                    }

                    /**
                     *  计算售价
                     */
                    NSString *salePrice ;                   // 售价
                    NSString *salePriceReferent ;           // 售价参考值
                    NSString *HKPropRentPriceResultStr ;  //房源租价
                    NSString *propSquareResultStr;      //房屋面积
                    NSString *HKPropSquareResultStr;      //房屋面积
                    
                    
                    NSString *propHKSaleUnitPriceValueStr;          // 单价参考值
                    NSMutableAttributedString *propSaleUnitPriceValueStr;            // 单价
                    NSMutableAttributedString *propRentAttriStr;    // 租价
                    NSMutableAttributedString *HKPropRentAttriStr;  // 租价参考值
                    NSMutableAttributedString *propSaleAttriStr;    // 售价
                    NSMutableAttributedString *HKPropSaleAttriStr;  // 售价参考值
                    
                    NSString *propRentPriceResultStr ;  //房源租价
                    
                    
                    //售价(人民币)
                    
                    if (_propDetailEntity.salePrice ) {
                        
                        salePrice = [NSString stringWithFormat:@"%@/%@",_propDetailEntity.salePrice,_propDetailEntity.square];
                        
                        propSaleAttriStr = [[NSMutableAttributedString alloc] initWithString:salePrice];
                        
                        NSInteger grayColorStarIndex = salePrice.length - _propDetailEntity.square.length - 2;
                        NSInteger grayColorLength = _propDetailEntity.square.length + 2;
                        
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

                    
                    // 售价(参考值)
                    if (_propDetailEntity.salePriceReferent) {
                        
                        salePriceReferent = [NSString stringWithFormat:@"%@/%@",_propDetailEntity.salePriceReferent,_propDetailEntity.squareReferent];
                        
                        HKPropSaleAttriStr = [[NSMutableAttributedString alloc] initWithString:salePriceReferent];
                        
                        NSInteger grayColorStarIndex = salePriceReferent.length - _propDetailEntity.squareReferent.length - 2;
                        NSInteger grayColorLength = _propDetailEntity.squareReferent.length + 2;
                        
                        [HKPropSaleAttriStr addAttribute:NSForegroundColorAttributeName
                                                 value:LITTLE_GRAY_COLOR
                                                 range:NSMakeRange(grayColorStarIndex,
                                                                   grayColorLength)];
                        [HKPropSaleAttriStr addAttribute:NSFontAttributeName
                                                 value:[UIFont fontWithName:FontName
                                                                       size:11.0]
                                                 range:NSMakeRange(grayColorStarIndex,
                                                                   grayColorLength)];
                    }
                    
                    

                    // 租价
                    if (_propDetailEntity.rentPrice) {
                        
                        propRentAttriStr = [[NSMutableAttributedString alloc] initWithString:_propDetailEntity.rentPrice];
                        
                        NSInteger grayColorStarIndex = propRentAttriStr.length  - 3;
                        NSInteger grayColorLength =  3;
                        
                        [propRentAttriStr addAttribute:NSForegroundColorAttributeName
                                                   value:LITTLE_GRAY_COLOR
                                                   range:NSMakeRange(grayColorStarIndex,
                                                                     grayColorLength)];
                        [propRentAttriStr addAttribute:NSFontAttributeName
                                                   value:[UIFont fontWithName:FontName
                                                                         size:11.0]
                                                   range:NSMakeRange(grayColorStarIndex,
                                                                     grayColorLength)];
                    }
                    
                    // 租价(参考值)
                    if (_propDetailEntity.rentPriceReferent) {
                        
                        HKPropRentAttriStr = [[NSMutableAttributedString alloc] initWithString:_propDetailEntity.rentPriceReferent];
                        
                        NSInteger grayColorStarIndex = HKPropRentAttriStr.length - 3;
                        NSInteger grayColorLength =  3;
                        
                        [HKPropRentAttriStr addAttribute:NSForegroundColorAttributeName
                                                 value:LITTLE_GRAY_COLOR
                                                 range:NSMakeRange(grayColorStarIndex,
                                                                   grayColorLength)];
                        [HKPropRentAttriStr addAttribute:NSFontAttributeName
                                                 value:[UIFont fontWithName:FontName
                                                                       size:11.0]
                                                 range:NSMakeRange(grayColorStarIndex,
                                                                   grayColorLength)];
                    }
                    
                    // 单价
                    if ([_isMacau boolValue])
                    {
                        // 澳盘
                        if (_propDetailEntity.saleUnitPrice)
                        {
                            propSaleUnitPriceValueStr = [[NSMutableAttributedString alloc] initWithString:_propDetailEntity.saleUnitPrice];
                            
                            NSInteger grayColorStarIndex = propSaleUnitPriceValueStr.length - 5;
                            NSInteger grayColorLength =  5;
                            
                            [propSaleUnitPriceValueStr addAttribute:NSForegroundColorAttributeName
                                                              value:LITTLE_GRAY_COLOR
                                                              range:NSMakeRange(grayColorStarIndex,
                                                                                grayColorLength)];
                            [propSaleUnitPriceValueStr addAttribute:NSFontAttributeName
                                                              value:[UIFont fontWithName:FontName
                                                                                    size:11.0]
                                                              range:NSMakeRange(grayColorStarIndex,
                                                                                grayColorLength)];
                        }
                    }
                    else
                    {
                        // 非澳盘
                        if (_propDetailEntity.saleUnitPrice)
                        {
                            propSaleUnitPriceValueStr = [[NSMutableAttributedString alloc] initWithString:_propDetailEntity.saleUnitPrice];
                            
                            NSInteger grayColorStarIndex = propSaleUnitPriceValueStr.length - 3;
                            NSInteger grayColorLength =  3;
                            
                            [propSaleUnitPriceValueStr addAttribute:NSForegroundColorAttributeName
                                                              value:LITTLE_GRAY_COLOR
                                                              range:NSMakeRange(grayColorStarIndex,
                                                                                grayColorLength)];
                            [propSaleUnitPriceValueStr addAttribute:NSFontAttributeName
                                                              value:[UIFont fontWithName:FontName
                                                                                    size:11.0]
                                                              range:NSMakeRange(grayColorStarIndex,
                                                                                grayColorLength)];
                        }
                    }
                    
                    
                    
//                    propSaleUnitPriceValueStr = _propDetailEntity.saleUnitPrice;
                    propHKSaleUnitPriceValueStr = _propDetailEntity.saleUnitPriceReferent;
                    
                    propRentPriceResultStr = _propDetailEntity.rentPrice;
                    HKPropRentPriceResultStr = _propDetailEntity.rentPriceReferent;
                    
                    HKPropSquareResultStr = _propDetailEntity.squareReferent;
                    propSquareResultStr = _propDetailEntity.square;
                    
                    
                    if ([_propTrustType isEqualToString:@"1"]) {
                        
                        // 出售
                        
                         allRoundDetailBasicMsgCell.propRentPriceTopHeight.constant = 0;
                        allRoundDetailBasicMsgCell.propFirstPriceTitleLabel.text = @"售价：";
                        
                        [allRoundDetailBasicMsgCell.propSalePriceLabel setAttributedText:propSaleAttriStr];
                        [allRoundDetailBasicMsgCell.propSaleHKPriceLabel setAttributedText:HKPropSaleAttriStr];//售价(港币)
                        
                        [allRoundDetailBasicMsgCell.propSalePriceUnitLabel setAttributedText:propSaleUnitPriceValueStr];
                        allRoundDetailBasicMsgCell.propSalePriceUnitFootLabel.text = propHKSaleUnitPriceValueStr;//单价(港币)
                        
                        allRoundDetailBasicMsgCell.propRentValueLabel.hidden = YES;
                        allRoundDetailBasicMsgCell.propRentValueHKLabel.hidden = YES;//租价(港币)
                        allRoundDetailBasicMsgCell.propRentTitleLabel.hidden = YES;
                    
                        allRoundDetailBasicMsgCell.spacingWitRentTitleTopHeight.constant = 10;

                    }else if ([_propTrustType isEqualToString:@"2"]){
                        
                        // 出租
                        
                        /**
                         *  只有租价的时候，显示的格式为：租价/平米
                         */
                        
                        // 人民币
                        propRentPriceResultStr = [NSString stringWithFormat:@"%@/%@",
                                                  propRentPriceResultStr,
                                                  propSquareResultStr];
                        
                        NSMutableAttributedString *onlyPropRentPriceAttrStr; // 租价人民币
                        
                        if (propRentPriceResultStr) {
                            
                            onlyPropRentPriceAttrStr= [[NSMutableAttributedString alloc] initWithString:propRentPriceResultStr];
                            
                            [onlyPropRentPriceAttrStr addAttribute:NSForegroundColorAttributeName
                                                             value:LITTLE_GRAY_COLOR
                                                             range:NSMakeRange(propRentPriceResultStr.length-propSquareResultStr.length-4,
                                                                               propSquareResultStr.length+4)];
                            [onlyPropRentPriceAttrStr addAttribute:NSFontAttributeName
                                                             value:[UIFont fontWithName:FontName
                                                                                   size:11.0]
                                                             range:NSMakeRange(propRentPriceResultStr.length-propSquareResultStr.length-4,
                                                                               propSquareResultStr.length+4)];
                        }
                        
                        
                        
                        // 港币
                        HKPropRentPriceResultStr = [NSString stringWithFormat:@"%@/%@",
                                                  HKPropRentPriceResultStr,
                                                  HKPropSquareResultStr];
                        
                        NSMutableAttributedString *HKOnlyPropRentPriceAttrStr; // 租价人民币
                        
                        if (HKPropRentPriceResultStr) {
                            
                            HKOnlyPropRentPriceAttrStr= [[NSMutableAttributedString alloc] initWithString:HKPropRentPriceResultStr];
                            
                            [HKOnlyPropRentPriceAttrStr addAttribute:NSForegroundColorAttributeName
                                                             value:LITTLE_GRAY_COLOR
                                                             range:NSMakeRange(HKPropRentPriceResultStr.length-HKPropSquareResultStr.length-4,
                                                                               HKPropSquareResultStr.length+4)];
                            [HKOnlyPropRentPriceAttrStr addAttribute:NSFontAttributeName
                                                             value:[UIFont fontWithName:FontName
                                                                                   size:11.0]
                                                             range:NSMakeRange(HKPropRentPriceResultStr.length-HKPropSquareResultStr.length-4,
                                                                               HKPropSquareResultStr.length+4)];
                        }
                        

                        
                        allRoundDetailBasicMsgCell.propFirstPriceTitleLabel.text = @"租价：";
                        
                        // 横琴
                        [allRoundDetailBasicMsgCell.propSalePriceLabel setAttributedText:onlyPropRentPriceAttrStr];
                        [allRoundDetailBasicMsgCell.propSaleHKPriceLabel setAttributedText:HKOnlyPropRentPriceAttrStr];//租价(港币)

                       
                        // 隐藏多余租价
                        allRoundDetailBasicMsgCell.propRentValueLabel.hidden = YES;
                        allRoundDetailBasicMsgCell.propRentValueHKLabel.hidden = YES;//租价(港币)
                        allRoundDetailBasicMsgCell.propRentTitleLabel.hidden = YES;

                        // 隐藏单价
                        allRoundDetailBasicMsgCell.propSalePriceUnitTitleLabel.hidden = YES;
                        allRoundDetailBasicMsgCell.propSalePriceUnitLabel.hidden = YES;
                        allRoundDetailBasicMsgCell.propSalePriceUnitFootLabel.hidden = YES;
                        
                        allRoundDetailBasicMsgCell.propSalePriceUnitTopHeight.constant = 0;
                        allRoundDetailBasicMsgCell.propRentPriceTopHeight.constant = 0;
                        allRoundDetailBasicMsgCell.spacingWitRentTitleTopHeight.constant = 10;
                        
                    }else if ([_propTrustType isEqualToString:@"3"]){
                        
                        // 出租
                        
                        allRoundDetailBasicMsgCell.propFirstPriceTitleLabel.text = @"售价：";
                        allRoundDetailBasicMsgCell.propRentTitleLabel.text = @"租价：";
                        
                        allRoundDetailBasicMsgCell.propSalePriceUnitTopHeight.constant = 35.0;
                        allRoundDetailBasicMsgCell.propRentPriceTopHeight.constant = 35.0;
                        allRoundDetailBasicMsgCell.spacingWitRentTitleTopHeight.constant = 5;


                        [allRoundDetailBasicMsgCell.propSalePriceLabel setAttributedText:propSaleAttriStr];
                        [allRoundDetailBasicMsgCell.propSaleHKPriceLabel setAttributedText:HKPropSaleAttriStr];//售价(参考值)
                        
                        [allRoundDetailBasicMsgCell.propRentValueLabel setAttributedText:propRentAttriStr];
                        [allRoundDetailBasicMsgCell.propRentValueHKLabel setAttributedText:HKPropRentAttriStr];//租价(参考值)
                        
                        [allRoundDetailBasicMsgCell.propSalePriceUnitLabel setAttributedText:propSaleUnitPriceValueStr];
                        allRoundDetailBasicMsgCell.propSalePriceUnitFootLabel.text = propHKSaleUnitPriceValueStr;//单价(参考值)


                        
                    }else
                    {
                        // 无房源类型
                        allRoundDetailBasicMsgCell.spacingWitRentTitleTopHeight.constant = 5;
                    }
                    
                    allRoundDetailBasicMsgCell.propHouseTypeLabel.text = _propDetailEntity.roomType;
                    allRoundDetailBasicMsgCell.propFloorLabel.text = _propDetailEntity.floor;
                    allRoundDetailBasicMsgCell.propRightLabel.text = _propDetailEntity.propertyCardClassName;
                    allRoundDetailBasicMsgCell.propDirectionLabel.text = _propDetailEntity.houseDirection;
                    allRoundDetailBasicMsgCell.propHouseSituationLabel.text = _propDetailEntity.propertySituation;
                    allRoundDetailBasicMsgCell.propBringSeeTimesLabel.text = [NSString stringWithFormat:@"%@",@(_propDetailEntity.remainingBrowseCount)];

                    return allRoundDetailBasicMsgCell;
                }
                    break;
                    
                case 1:
                {
                    /**
                     *  特色
                     */
                    if (_propDetailEntity.propertyTags &&
                        ![_propDetailEntity.propertyTags isEqualToString:@""]) {
                        
                        if (!allRoundDetailOnlyTextCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"AllRoundDetailOnlyTextCell"
                                                                  bundle:nil]
                            forCellReuseIdentifier:onlyTextCellIdentifier];
                            
                            allRoundDetailOnlyTextCell = [tableView dequeueReusableCellWithIdentifier:onlyTextCellIdentifier];
                        }
                        
                        
                        allRoundDetailOnlyTextCell.onlyTextLabel.text = _propDetailEntity.propertyTags;
                        
                        return allRoundDetailOnlyTextCell;
                        
                    }else{
                        
                        /**
                         *  房源title
                         */
                        if (!allRoundTagsCell) {
                            
                            [tableView registerNib:[UINib nibWithNibName:@"ArrowSignTextCell"
                                                                  bundle:nil]
                            forCellReuseIdentifier:propTagsCellIdentifier];
                            allRoundTagsCell = [tableView dequeueReusableCellWithIdentifier:propTagsCellIdentifier];
                        }
                        
                        allRoundTagsCell.leftTextLabel.font = [UIFont fontWithName:FontName
                                                                              size:15.0];
//                        allRoundTagsCell.leftTextLabel.text = [NSString stringWithFormat:@"%@%@",_propTitleStr,_propTitleStr];
                        
                        allRoundTagsCell.leftTextLabel.lineBreakMode = NSLineBreakByTruncatingHead;
                        allRoundTagsCell.leftTextLabel.text = _propTitleStr;
                        
                        /**
                         *  查看过房号后隐藏查看房号“按钮”
                         */
                        if (_isCheckedHouseNum) {
                            
                            allRoundTagsCell.rightArrowImageView.hidden = YES;
                            allRoundTagsCell.rightTextLabel.text = @"";
                        }else{
                            
                            allRoundTagsCell.rightArrowImageView.hidden = NO;
                            allRoundTagsCell.rightTextLabel.text = @"查看房号";
                        }
                        
                        return allRoundTagsCell;
                    }
                    
                }
                    break;
                case 2:
                {
                    
                    /**
                     *  房源的title
                     */
                    if (!allRoundTagsCell) {
                        
                        [tableView registerNib:[UINib nibWithNibName:@"ArrowSignTextCell"
                                                              bundle:nil]
                        forCellReuseIdentifier:propTagsCellIdentifier];
                        allRoundTagsCell = [tableView dequeueReusableCellWithIdentifier:propTagsCellIdentifier];
                    }
                    allRoundTagsCell.leftTextLabel.font = [UIFont fontWithName:FontName
                                                                          size:15.0];
                    allRoundTagsCell.leftTextLabel.lineBreakMode = NSLineBreakByTruncatingHead;
                    allRoundTagsCell.leftTextLabel.text = _propTitleStr;
                    
                    /**
                     *  查看过房号后隐藏查看房号“按钮”
                     */
                    if (_isCheckedHouseNum) {
                        
                        allRoundTagsCell.rightArrowImageView.hidden = YES;
                        allRoundTagsCell.rightTextLabel.text = @"";
                    }else{
                        
                        allRoundTagsCell.rightArrowImageView.hidden = NO;
                        allRoundTagsCell.rightTextLabel.text = @"查看房号";
                    }
                    
                    return allRoundTagsCell;
                }
                    break;
                    
                default:
                    return [[UITableViewCell alloc]init];
                    break;
            }
        }
            break;
        case 1:
        {
            /**
             *  房源跟进
             */
            if (!propFollowRecordCell) {
                
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
            
            
            if (_followRecordEntity && departmentPermission) {
                
                propFollowRecordCell.propFollowOtherMsgLabel.hidden = NO;
                propFollowRecordCell.followType.hidden = NO;
                propFollowRecordCell.followTime.hidden = NO;
                
                
                NSString *formatDateStr = [CommonMethod getFormatDateStrFromTime:_followRecordEntity.followTime];
                
                
                propFollowRecordCell.propFollowDetailLabel.text = _followRecordEntity.followContent;
                propFollowRecordCell.propFollowOtherMsgLabel.text = _followRecordEntity.follower?_followRecordEntity.follower:@"";
                propFollowRecordCell.propFollowOtherMsgLabel.textColor = [UIColor colorWithRed:(71 / 255.0f)
                                                                                         green:(151 / 255.0f)
                                                                                          blue:(202 / 255.0f)
                                                                                         alpha:1.0f];
                propFollowRecordCell.followType.text = _followRecordEntity.followType?_followRecordEntity.followType:@"";
                propFollowRecordCell.followTime.text = formatDateStr;
                
                
                
                if(_followRecordEntity.confirmUserName){
                    propFollowRecordCell.imgConfirm.hidden = NO;
                }else{
                    propFollowRecordCell.imgConfirm.hidden = YES;
                }
                
            }else{
                
                
                propFollowRecordCell.propFollowDetailLabel.text = @"暂无";
                
                if (!departmentPermission)
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
            
            /**
             *  更多功能：实堪、钥匙、独家
             */
            switch (indexPath.row) {
                case 0:
                {
                    
                    if (!allRoundDetailMoreItemCell) {
                        
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
                    break;
                    
                default:
                    return [[UITableViewCell alloc]init];
                    break;
            }
        }
            
        default:
            return [[UITableViewCell alloc]init];
            break;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            
            switch (indexPath.row) {
                case 0:
                {
                    // 委托类型（出售=1、出租=2、租售=3）
                    
                    if ([_propTrustType isEqualToString:@"3"]) {
                        
                        return 210;
                    }else if([_propTrustType isEqualToString:@"1"]){
                        
                        return 180;
                    }else if([_propTrustType isEqualToString:@"2"]){
                        
                        return 150;
                    }else{
                        // null
                        return 210;
                    }
                }
                    break;
                case 1:
                {
                    
                    if (_propDetailEntity.propertyTags &&
                        ![_propDetailEntity.propertyTags isEqualToString:@""]) {
                        
                        CGFloat propertyTagsWidth = [_propDetailEntity.propertyTags
                                                     getStringHeight:[UIFont fontWithName:FontName size:15.0]
                                                     width:APP_SCREEN_WIDTH-24
                                                     size:15.0];
                        propertyTagsWidth = propertyTagsWidth < 15 ? 15:propertyTagsWidth;
                        
                        return propertyTagsWidth + 28;
                    }
                    
                    return 44.0;
                }
                    break;
                case 2:
                {
                    return 44;
                }
                    break;
                    
                default:
                    return 0;
                    break;
            }
            
        }
            break;
        case 1:
        {
            
            switch (indexPath.row) {
                case 0:
                {
                    
                    return 82;
                }
                    break;
                    
                default:
                    return 0;
                    break;
            }
        }
            break;
        case 2:
        {
            
            switch (indexPath.row) {
                case 0:
                {
                    
                    return 165;
                }
                    break;
                    
                default:
                    return 0;
                    break;
            }
        }
            
        default:
            
            return 0;
            
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 1) {
        
        return 4.0;
    }
    
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    if (indexPath.section == 0) {
        
        /**
         *  如果房源有特色，则查看房号位于第三行，若没有，则位于第二行
         */
        if (_propDetailEntity.propertyTags &&
            ![_propDetailEntity.propertyTags isEqualToString:@""])
        {
            
            if (indexPath.row == 2) {
                
                [self clickCheckHouseNoMethod];
            }
        }else{
            
            if (indexPath.row == 1) {
                
                [self clickCheckHouseNoMethod];
            }
        }
    }else if (indexPath.section == 1){
        
        BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_SEARCH_ALL];
        
        
        BOOL hasPermisstion = YES;
        
        if (![NSString isNilOrEmpty:_propDetailEntity.departmentPermissions]) {
            hasPermisstion =   [_propDetailEntity.departmentPermissions contains:DEPARTMENT_PROPERTY_FOLLOW_SEARCH_ALL];
        }
        
        if(isAble && hasPermisstion){
            /**
             跟进列表
             */
            MoreFollowListViewController *moreFollowListVC = [[MoreFollowListViewController alloc]initWithNibName:@"MoreFollowListViewController"
                                                                                                           bundle:nil];
            
            moreFollowListVC.propKeyId = _propKeyId;
            moreFollowListVC.propertyStatusCategory = _propDetailEntity.propertyStatusCategory;
            moreFollowListVC.propDetailEntity = _propDetailEntity;
            moreFollowListVC.propModelEntity = _propModelEntity;
            moreFollowListVC.departmentPermisstion = _propDetailEntity.departmentPermissions;
            moreFollowListVC.propTrustType = _propTrustType;

            [self.navigationController pushViewController:moreFollowListVC
                                                 animated:YES];
        }else{
            showMsg(@(NotHavePermissionTip));
        }
        
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MODEL_VERSION >= 7.0) {
        
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        if (MODEL_VERSION >= 8.0) {
            
            // Prevent the cell from inheriting the Table View's margin settings
            if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
                [cell setPreservesSuperviewLayoutMargins:NO];
            }
            
            // Explictly set your cell's layout margins
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    }
    
}

#pragma mark - MoreItemBtnClickMethod
-(void)moreItemPushMethodWithBtn:(UIButton *)button
{
    
    switch (button.tag - ButtomMoreItemBtnTag) {
        case 0:
        {
            
            BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_SEARCH_ALL];
            
            BOOL hasPermisstion = YES;
            
            if (![NSString isNilOrEmpty:_propDetailEntity.departmentPermissions]) {
                hasPermisstion =   [_propDetailEntity.departmentPermissions contains:DEPARTMENT_PROPERTY_REALSURVEY_SEARCH_ALL];
            }
            
            if(isAble && hasPermisstion){
                // 实堪
                RealListViewController *realListViewController = [[RealListViewController alloc]initWithNibName:@"RealListViewController" bundle:nil];
                realListViewController.keyId = _propKeyId;
                [self.navigationController pushViewController:realListViewController
                                                     animated:YES];
            }else{
                showMsg(@(NotHavePermissionTip));
            }
        }
            break;
        case 1:
        {
            // 钥匙
            BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_KEY_SEARCH_ALL];
            
            BOOL hasPermisstion = YES;
            
            if (![NSString isNilOrEmpty:_propDetailEntity.departmentPermissions]) {
                hasPermisstion =   [_propDetailEntity.departmentPermissions contains:PROPERTY_KEY_SEARCH_ALL];
            }
            
            if (hasPermisstion && isAble)
            {
                PropKeyViewController *pkVC = [[PropKeyViewController alloc] init];
                pkVC.keyId = _propKeyId;
                [self.navigationController pushViewController:pkVC animated:YES];
                
//                PropKeyListViewController *propKeyListViewController = [[PropKeyListViewController alloc]initWithNibName:@"PropKeyListViewController" bundle:nil];
//                propKeyListViewController.keyId = _propKeyId;
//                [self.navigationController pushViewController:propKeyListViewController
//                                                     animated:YES];
                
            }else{
                showMsg(@(NotHavePermissionTip));
            }
            
            
        }
            break;
        case 2:
        {
            // 独家
            
            BOOL hasPermisstion = YES;
            
            if (![NSString isNilOrEmpty:_propDetailEntity.departmentPermissions]) {
                hasPermisstion =   [_propDetailEntity.departmentPermissions contains:DEPARTMENT_PROPERTY_ONLYTRUST_SEARCH_ALL];
            }
            
            if (hasPermisstion) {
                OnlyTrustViewController *onlyTrustViewController = [[OnlyTrustViewController alloc]initWithNibName:@"OnlyTrustViewController" bundle:nil];
                onlyTrustViewController.keyId = _propKeyId;
                onlyTrustViewController.titleName = @"独家";
                [self.navigationController pushViewController:onlyTrustViewController
                                                     animated:YES];
            }else{
                showMsg(@(NotHavePermissionTip));
            }
            
        }
            break;
            
        default:
            break;
    }
    
}

// 拨打电话
- (void)callPhonePress
{
    //    NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:075523742200,%@",@"038541"];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];

            
    if(![AgencyUserPermisstionUtil hasRight:PROPERTY_CONTACTINFORMATION_SEARCH_ALL]){
        // 没有查看联系人权限
        showMsg(@"您无权查看联系人信息");
        return;
    }
        
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] stringForKey:APlusUserMobile];
    
    if (!phoneNum) {
        phoneNum = @"";
    }
    
    NSString *userKeyId = [AgencyUserPermisstionUtil getIdentify].uId;
    NSString *departId = [AgencyUserPermisstionUtil getIdentify].departId;
    
    _getTrustorsApi.userKeyId = userKeyId;
    _getTrustorsApi.departmentKeyId = departId;
    _getTrustorsApi.userPhone = phoneNum;
    _getTrustorsApi.keyId = self.propKeyId;
    
    [_manager sendRequest:_getTrustorsApi];
    
    //  重置selectIndex
    _selectIndex = 0;
    [self showLoadingView:@"正在获取联系人信息..."];
}

- (void)showTrustors
{
    [self hiddenLoadingView];
    if(!_propTrustorsInfoEntity){
        return;
    }
    
    if(!_propTrustorsInfoEntity.canBrowse)
    {
        showMsg(_propTrustorsInfoEntity.noCallMessage);
        return;
    }
    
    NSInteger used = _propTrustorsInfoEntity.usedBrowseCount;
    NSInteger limit = _propTrustorsInfoEntity.totalBrowseCount;
    
    // 同时为0时为开启虚拟号  不限制次数
    if (!(limit == 0 && used == 0)) {
        
        if(limit >= 0){
            if(used >= limit){
                showMsg(@"您的浏览次数已达到您的浏览次数上限！");
                return;
            }
        }
    }
    
    [self showPickView];
}

- (void)showTrustorsForShenZhen
{
    [self hiddenLoadingView];
    if(!_propTrustorsForSZ){
        return;
    }
    
    if(!_propTrustorsForSZ.canBrowse)
    {
        showMsg(_propTrustorsForSZ.noCallMessage);
        return;
    }
    
    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_CONTACTINFORMATION_SEARCH_NODEPT]) {
        // 不限制次数
        
    }else
    {
        // 限制查看次数
        int uesed = [_propTrustorsForSZ.usedBrowseCount intValue];
        int limit = [_propTrustorsForSZ.totalBrowseCount intValue];
                
        if(limit != 0 && uesed != 0){
            if(limit >= 0){
                if(uesed > limit){
                    showMsg(@"您的浏览次数已达到您的浏览次数上限！");
                    return;
                }
            }
        }
    }
    [self showPickView];
}

- (CustomActionSheet *)showPickView
{
    UIPickerView *mPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,
                                                                               40,
                                                                               APP_SCREEN_WIDTH,
                                                                               180)];
    mPickerView.dataSource = self;
    mPickerView.delegate = self;
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithView:mPickerView
                                                             AndHeight:300];
    sheet.doneDelegate = self;
    [sheet showInView:self.view];
    
    return sheet;
}


#pragma mark - PickerViewDelegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(_propTrustorsInfoEntity){
        return _propTrustorsInfoEntity.trustors.count;
    }else{
        return _propTrustorsForSZ.trustors.count;
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *cusPicLabel = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 20.0f)];
    
    if(_propTrustorsInfoEntity)
    {
        if(_propTrustorsInfoEntity.trustors)
        {
            TrustorEntity *trustor = (TrustorEntity *)_propTrustorsInfoEntity.trustors[row];
            
            NSString *cusStr = [NSString stringWithFormat:@"%@(%@)",trustor.trustorName,trustor.trustorType];
            
            cusPicLabel.text = cusStr;
            [cusPicLabel setFont:[UIFont systemFontOfSize:18.0]];
            [cusPicLabel setTextAlignment:NSTextAlignmentCenter];
            cusPicLabel.backgroundColor = [UIColor clearColor];
        }
    }else{
        if(_propTrustorsForSZ){
            if(_propTrustorsForSZ.trustors){
                
                TrustorShenZhenEntity *trustorSZ = (TrustorShenZhenEntity *)_propTrustorsForSZ.trustors[row];
                
                NSString *cusStr = [NSString stringWithFormat:@"%@(%@)",trustorSZ.trustorName,trustorSZ.trustorType];
                
                cusPicLabel.text = cusStr;
                [cusPicLabel setFont:[UIFont systemFontOfSize:18.0]];
                [cusPicLabel setTextAlignment:NSTextAlignmentCenter];
                cusPicLabel.backgroundColor = [UIColor clearColor];
            }
        }
    }
    
    return cusPicLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectIndex = row;
}

#pragma mark -拨打电话

- (void)doneSelectItemMethod
{
    BOOL isVirtualCall = [DascomUtil isVirtualCall];
    BOOL isAPlusVirtualCall = YES;
    
    NSInteger trustorsCount = _propTrustorsForSZ.trustors.count;
    
    if (trustorsCount <= 0) {
        showMsg(@"暂无联系人信息!");
        return;
    }

    isVirtualCall = [_propTrustorsForSZ.virtualCall boolValue];
    
#warning    需注释!
    //    isAPlusVirtualCall = YES;
    //    isVirtualCall = YES;
    
    // 使用虚拟号
    if(isVirtualCall && isAPlusVirtualCall)
    {
        
            NSInteger trustorsCount = _propTrustorsForSZ.trustors.count;
            
            if (trustorsCount <= 0) {
                showMsg(@"暂无联系人信息!");
                return;
            }
            
            TrustorShenZhenEntity *trustorSZ = _propTrustorsForSZ.trustors[_selectIndex];
        
            NSString *mobileSZ = trustorSZ.mobile;
            NSString *telSZ = trustorSZ.tel;
    
            if (mobileSZ.length > 0) {
                _mobile = mobileSZ;
                _isMobile = @"1";
            }else if(telSZ.length > 0){
                _mobile = telSZ;
                _isMobile = @"0";
            }else {
                NSString *msg = [NSString stringWithFormat:@"没有%@的联系方式！",trustorSZ.trustorName];
                showMsg(msg);
                return;
            }
        
            _phoneId = trustorSZ.keyId;
            
            // 横琴 澳门
            //提示是否需要加拨0
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否需要加拨0" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alertView.tag = CallZeroAlertTag;
            [alertView show];
            
            return;
        
        
    }else{
        // 不使用虚拟号
        NSInteger limit = [_propTrustorsForSZ.callLimit integerValue];;
        
        NSInteger curCount = [CallRealPhoneLimitUtil getCountForToday];
        [CallRealPhoneLimitUtil deleteNotToday];
        
        // keyId是否存在
        if([CallRealPhoneLimitUtil isExistWithPropKeyId:self.propKeyId])
        {
            NSString *mobileNum = @"";
           
            TrustorShenZhenEntity *trustorSZ = _propTrustorsForSZ.trustors[_selectIndex];
            if(trustorSZ.mobile){
                mobileNum = trustorSZ.mobile;
            }else{
                mobileNum = trustorSZ.tel;
            }
            
            NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",mobileNum];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
            
            return;
        }
        
        if(curCount >= limit){
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


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == CallRealPhoneAlertTag){
        switch (buttonIndex) {
            case 1:
            {
                NSString *mobileNum = @"";
          
                TrustorShenZhenEntity *trustorSZ = _propTrustorsForSZ.trustors[_selectIndex];
                if(trustorSZ.mobile){
                    mobileNum = trustorSZ.mobile;
                }else{
                    mobileNum = trustorSZ.tel;
                }
                
                [CallRealPhoneLimitUtil addCallRealPhoneRecordWithPropKeyId:self.propKeyId];
                
                NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",mobileNum];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
            }
                break;
                
            default:
                break;
        }
    }
    else if(alertView.tag == CallZeroAlertTag){
        
        NSString *isAddZero = @"";
        
        switch (buttonIndex) {
            case 0:
                isAddZero = @"1";
                break;
            case 1:
                _mobile = [NSString stringWithFormat:@"0%@",_mobile];
                break;
                
            default:
                
                break;
        }
        
        NSString *userMobile =  [CommonMethod getUserdefaultWithKey:APlusUserMobile];
        
        _virtualCallPhoneApi.tel1 = userMobile;
        _virtualCallPhoneApi.tel2 = _mobile;
        _virtualCallPhoneApi.staffNo = [CommonMethod getUserdefaultWithKey:UserStaffNumber];
        _virtualCallPhoneApi.keyId = _propKeyId;
        
        [_manager sendRequest:_virtualCallPhoneApi];
        
    }else if (alertView.tag == CheckHouseNoActionTag) {
        
        _dataBaseOperation = [DataBaseOperation sharedataBaseOperation];
        
        NSString *staffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
        
        // 保存到本地查看过的房号
        [_dataBaseOperation insertKeyIdOfCheckedRoomNum:_propKeyId
                                             andStaffNo:staffNo
                                                andDate:[NSDate stringWithSimpleDate:[NSDate date]]];
        // 查看房号
        [CheckRoomNumUtil useCheckRoomNumLimit];
        
        _isCheckedHouseNum = YES;
        _propTitleStr = _propHouseNo;
        
        self.title = _propTitleStr;
        
        [_mainTableView reloadData];
        
    }
    
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addCallPhoneView:(UIView *)callView
{
    [self.view addSubview:callView];
}


#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass
{
    [self hiddenLoadingView];
    
    if ([modelClass isEqual:[PropPageDetailEntity class]]) {
        //房源详情
        
        _propDetailEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        if([self isSaleAndOrder]){
            _isCollected = _propDetailEntity.isFavorite;
            _propertyStatus = [NSString stringWithFormat:@"%@",_propDetailEntity.propertyStatusCategory];
            [_mainTableView reloadData];
            
            // 图片路径
            _propImgUrl = _propImgUrl ? _propImgUrl :_propDetailEntity.photoPath;
            // type
            _propTrustType = _propTrustType ? _propTrustType :_propDetailEntity.trustType;
            _propTrustType = [NSString stringWithFormat:@"%@",_propTrustType];
            // 房号
            if (_isCheckedHouseNum) {
                _propTitleStr =  _propDetailEntity.allHouseInfo;
                self.title = _propTitleStr;
                
            }else{
                _propHouseNo = _propDetailEntity.allHouseInfo;
            }
            
            // 是否为澳盘
            _isMacau = _propDetailEntity.isMacau;
            
            // 获取房源跟进第一条记录
            [self getFollowRecord];
            
            
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"您无权限查看该售预定房源"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确认", nil];
            [alertView show];
        }
        
    }else if([modelClass isEqual:[CheckRealProtectedEntity class]])
    {
        // 验证实勘保护期
        CheckRealProtectedEntity *checkRealProtectedEntity = [DataConvert convertDic:data toEntity:modelClass];
        BOOL isAble = [AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_ADD_ALL];
        
        BOOL hasPermisstion = YES;
        
        if (![NSString isNilOrEmpty:_propDetailEntity.departmentPermissions]) {
            hasPermisstion =   [_propDetailEntity.departmentPermissions contains:DEPARTMENT_PROPERTY_REALSURVEY_ADD_ALL];
        }
        
        
        if(isAble && hasPermisstion){
            
            UploadRealSurveyViewController *uploadRealSurveyVC = [[UploadRealSurveyViewController alloc]initWithNibName:@"UploadRealSurveyViewController"
                                                                                                                 bundle:nil];
            uploadRealSurveyVC.propKeyId = _propKeyId;
            uploadRealSurveyVC.widthScale = [checkRealProtectedEntity.width integerValue];
            uploadRealSurveyVC.hightScale = [checkRealProtectedEntity.high integerValue];
            uploadRealSurveyVC.imgUploadCount = [checkRealProtectedEntity.imgUploadCount integerValue];
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.imgRoomMaxCount]) {
                uploadRealSurveyVC.imgRoomMaxCount = [checkRealProtectedEntity.imgRoomMaxCount integerValue];
            }
            
            if (![NSString isNilOrEmpty:checkRealProtectedEntity.imgAreaMaxCount]) {
                uploadRealSurveyVC.imgAreaMaxCount = [checkRealProtectedEntity.imgAreaMaxCount integerValue];
            }
            [self.navigationController pushViewController:uploadRealSurveyVC
                                                 animated:YES];
        }else{
            showMsg(@(NotHavePermissionTip));
        }
        
    }if ([modelClass isEqual:[FollowRecordEntity class]]){
        
        /**
         *  最新的跟进列表（第一条）
         */
        FollowRecordEntity *followRecordEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        if (followRecordEntity.propFollows.count > 0) {
            
            _followRecordEntity = [followRecordEntity.propFollows objectAtIndex:0];
            
            [_mainTableView reloadData];
        }
    }
    
    else if ([modelClass isEqual:[PropTrustorsInfoEntity class]]){
        
        //
        _propTrustorsInfoEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        [self showTrustors];
        
    }
    else if([modelClass isEqual:[PropTrustorsInfoForShenZhenEntity class]]){
        
        _propTrustorsForSZ = [DataConvert convertDic:data toEntity:modelClass];
        
        NSInteger trustorsCount = _propTrustorsForSZ.trustors.count;
        
        for (int i = 0; i < trustorsCount; i++) {
            TrustorShenZhenEntity *item = _propTrustorsForSZ.trustors[i];
            NSLog(@"手机短号＝＝%@，座机短号＝＝%@",item.shortCallMobile,item.shortCallTel);
        }
        
        [self showTrustorsForShenZhen];
    }
    else if ([modelClass isEqual:[HQCallNumberEntity class]]){
        // 横琴澳门拨打电话

    }
    else if ([modelClass isEqual:[AgencyBaseEntity class]]){
        
        // 收藏、取消收藏
        AgencyBaseEntity *collectResultEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        if (collectResultEntity.flag) {
            
            if (_isCollected) {
                
                [CustomAlertMessage showAlertMessage:@"取消收藏成功\n\n"
                                     andButtomHeight:APP_SCREEN_HEIGHT/2];
            }else{
                
                [CustomAlertMessage showAlertMessage:@"收藏成功\n\n"
                                     andButtomHeight:APP_SCREEN_HEIGHT/2];
            }
            
            _isCollected = !_isCollected;
        }
    }
    
}


- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
//    [self.navigationController popViewControllerAnimated:YES];
}



@end
