//
//  MineViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/22.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MineViewController.h"


#import "UserMessageTableViewCell.h"
#import "OtherChooseTableViewCell.h"
#import "FaceImageCell.h"
#import "FaceSwitchCell.h"
#import "IdentifyEntity.h"
#import "AgencyUserPermisstionUtil.h"
#import "AllRoundVC.h"
#import "ExitTableViewCell.h"
#import "PersonalInfoViewController.h"
#import "SettingViewController.h"
#import "MyCollectVC.h"
#import "NewOpeningViewController.h"
#import "AppendInfoViewController.h"
#import "ConfirmSuccessEntity.h"
#import "CustomHelpVC.h"
#import "PersonalInfoEntity.h"
#import "LogOffUtil.h"
#import "ApiDomainUtil.h"
#import "DeviceLockApi.h"
#import "GetPersonalApi.h"
#import "NotificationNameDefine.h"
#import "EstateListVC.h"

#import "ShowStaffImageView.h"
#import "SDImageCache.h"

#define NotifySwitchTag         4000    // 消息提醒tag

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    DeviceLockApi *_deviceLockApi;
    GetPersonalApi *_getPersonalApi;

    __weak IBOutlet UITableView *_mainTableView;
    PersonalInfoEntity *_resultEntity;
    
}

@end

@implementation MineViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    [self initView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    

    [self.navigationController.navigationBar setBarTintColor:YCThemeColorGreen];
    [_mainTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
}

#pragma mark - init

- (void)initView
{
    
    self.view.backgroundColor = [UIColor colorWithRed:144.0/255.0 green:195.0/255.0 blue:30.0/255.0 alpha:0.0];
    
    
//    [self setNavTitle:nil
//       leftButtonItem:[self customBarItemButton:nil
//                                backgroundImage:nil
//                                     foreground:nil
//                                            sel:@selector(back)]
//      rightButtonItem:nil];
   
    self.navigationItem.title = @"";
    
    _mainTableView.tableFooterView=[[UIView alloc]init];
    _mainTableView.separatorStyle = NO;
    _mainTableView.bounces = NO;
}



- (void)initData
{

    [self showLoadingView:nil];
    NSString *userCityCode = [[NSUserDefaults standardUserDefaults]stringForKey:CityCode];
    NSString *staffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
    
    _getPersonalApi = [[GetPersonalApi alloc] init];
    _getPersonalApi.staffNo = staffNo;
    _getPersonalApi.cityCode = userCityCode;
    [_manager sendRequest:_getPersonalApi];

}



#pragma mark - <PersonalInfoDelegate>

- (void)requestPersonalInfo
{
    NSString *userCityCode = [[NSUserDefaults standardUserDefaults]stringForKey:CityCode];
    NSString *staffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
    
    _getPersonalApi = [[GetPersonalApi alloc] init];
    _getPersonalApi.staffNo = staffNo;
    _getPersonalApi.cityCode = userCityCode;
    [_manager sendRequest:_getPersonalApi];
}

#pragma mark - <TableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0)
    {
        return 140*NewRatio;
    }
    else
    {
        return 51*NewRatio;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
//        return [_minePresenter getRowsInSection0];
        return 4;
    }
//    else if (section == 1)
//    {
//        return 1;
//    }
//    else if (section == 2)
//    {
//        return 1;
//    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 0.1;
        }
            break;
            
        default:
            break;
    }
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"UserMesCell";
    static NSString *otherChooseIdentifier = @"otherChooseCell";
    static NSString *exitCellIdentifier = @"exitCell";
    static NSString *imageCell = @"faceImageCell";
    static NSString *switchCell = @"faceSwitchCell";

    
    UserMessageTableViewCell *messageCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!messageCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"UserMessageTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:cellIdentifier];
        messageCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    OtherChooseTableViewCell *otherChooseCell = [tableView dequeueReusableCellWithIdentifier:otherChooseIdentifier];
    if (!otherChooseCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"OtherChooseTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:otherChooseIdentifier];
        
        otherChooseCell = [tableView dequeueReusableCellWithIdentifier:otherChooseIdentifier];
    }
    
    ExitTableViewCell *exitCell = [tableView dequeueReusableCellWithIdentifier:exitCellIdentifier];
    if (!exitCell) {
        [tableView registerNib:[UINib nibWithNibName:@"ExitTableViewCell" bundle:nil ] forCellReuseIdentifier:exitCellIdentifier];
        exitCell = [tableView dequeueReusableCellWithIdentifier:exitCellIdentifier];
    }
    
    FaceImageCell *staffImageCell = [tableView dequeueReusableCellWithIdentifier:imageCell];
    
    if (!staffImageCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"FaceImageCell"
                                              bundle:nil]
        forCellReuseIdentifier:imageCell];
        staffImageCell = [tableView dequeueReusableCellWithIdentifier:imageCell];
    }
    
    FaceSwitchCell *faceSwitchCell = [tableView dequeueReusableCellWithIdentifier:switchCell];
    
    if (!faceSwitchCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"FaceSwitchCell"
                                              bundle:nil]
        forCellReuseIdentifier:switchCell];
        faceSwitchCell = [tableView dequeueReusableCellWithIdentifier:switchCell];
    }

    
    if (indexPath.section == 0)
    {
        // 获取用户信息
        NSString *userName=[[NSUserDefaults standardUserDefaults]objectForKey:APlusUserName];
        NSString *userDeptName = [[NSUserDefaults standardUserDefaults]objectForKey:APlusUserDepartName];
        NSString *userTitle = [[NSUserDefaults standardUserDefaults]objectForKey:APlusUserRoleName];
        // 员工编号
//        NSString *staff = [CommonMethod getUserdefaultWithKey:UserStaffNumber];
//        NSString *photoPath = [[BaseApiDomainUtil getApiDomain] getStaffPhotoUrlWithStaffNo:staff];
        NSString *userPhotoPath = [CommonMethod getUserdefaultWithKey:APlusUserPhotoPath];
        otherChooseCell.rightLabel.text = @"";
        switch (indexPath.row) {
            case 0:
            {
                messageCell.headerImg.layer.borderWidth = 3*NewRatio;
                messageCell.headerImg.layer.borderColor = UICOLOR_RGB_Alpha(0x1b9556,1.0).CGColor;
                messageCell.headerImg.layer.cornerRadius = 44*NewRatio;
                messageCell.whiteView.layer.cornerRadius = 8*NewRatio;
                messageCell.grayView.layer.cornerRadius = 12*NewRatio;
                [messageCell.headerImg sd_setImageWithURL:[NSURL URLWithString:userPhotoPath]
                                         placeholderImage:[UIImage imageNamed:@"个人中心默认头像"]];
                
                messageCell.userNameLabel.text = userName;
                messageCell.userGroupLabel.text = userDeptName;
                messageCell.userTitleLabel.text = userTitle;
                return messageCell;
            }
                break;
                
            case 1:
            {
                [otherChooseCell.typeButton setImage:[UIImage imageNamed:@"我的-收藏"] forState:UIControlStateNormal];
                otherChooseCell.typeNameLabel.text = @"我的收藏";
                return otherChooseCell;
                
            }
                break;
                
            case 2:
            {
                [otherChooseCell.typeButton setImage:[UIImage imageNamed:@"我的-密码修改"] forState:UIControlStateNormal];
                otherChooseCell.typeNameLabel.text = @"修改密码";
                
                return otherChooseCell;
            }
                break;
                
            case 3:
            {
                [otherChooseCell.typeButton setImage:[UIImage imageNamed:@"我的-设置"] forState:UIControlStateNormal];
                otherChooseCell.typeNameLabel.text = @"系统设置";
                return otherChooseCell;
            }
                break;
                
//            case 3:
//            {
//                if ([_minePresenter hasFaceRecog])
//                {
//                    NSString *faceUrl = [CommonMethod getUserdefaultWithKey:FaceCollectUrl];
//                    if (![faceUrl isEqualToString:@"0"]) {
//
//                        // 已采集
//                        [staffImageCell.typeButton setImage:[UIImage imageNamed:@"set_face_collection_"] forState:UIControlStateNormal];
//                        staffImageCell.typeNameLabel.text = @"人脸采集";
//                        [staffImageCell.staffImage sd_setImageWithURL:[NSURL URLWithString:faceUrl]];
//                        staffImageCell.staffImage.layer.cornerRadius = staffImageCell.staffImage.frame.size.width/2;
//                        staffImageCell.staffImage.layer.masksToBounds = YES;
//                        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showStaffImage)];
//                        [staffImageCell.staffImage addGestureRecognizer:tapGesture];
//                        staffImageCell.staffImage.userInteractionEnabled = YES;
//
//                        return staffImageCell;
//                    }else{
//                        // 未采集
//                        otherChooseCell.rightLabel.text = @"未采集";
//                        [otherChooseCell.typeButton setImage:[UIImage imageNamed:@"set_face_collection_"] forState:UIControlStateNormal];
//                        otherChooseCell.typeNameLabel.text = @"人脸采集";
//                    }
//
//                }else{
//                    [otherChooseCell.typeButton setImage:[UIImage imageNamed:@"my_btn_store"] forState:UIControlStateNormal];
//                    otherChooseCell.typeNameLabel.text = @"我的店铺";
//                }
//                return otherChooseCell;
//            }
//                break;
//            case 4:
//            {
//                faceSwitchCell.typeNameLabel.text = @"人脸识别";
//                [faceSwitchCell.typeButton setImage:[UIImage imageNamed:@"set_face_discern"] forState:UIControlStateNormal];
//                BOOL isOn = [[CommonMethod getUserdefaultWithKey:FaceRecogSwitch] boolValue];
//                faceSwitchCell.faceSwitch.on = isOn;
//                [faceSwitchCell.faceSwitch addTarget:self action:@selector(faceRecogSwitch:) forControlEvents:UIControlEventValueChanged];
//                float faceTime = [[CommonMethod getUserdefaultWithKey:@"FaceOption"] floatValue];
//                faceSwitchCell.faceSwitch.enabled = faceTime>0;
//                faceSwitchCell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//                return faceSwitchCell;
//            }
//                break;
                
            default:
                return [[UITableViewCell alloc]init];
                break;
        }
    }
//    else if (indexPath.section == 1)
//    {
//        [otherChooseCell.typeButton setImage:[UIImage imageNamed:@"my_btn_news"] forState:UIControlStateNormal];
//        otherChooseCell.typeNameLabel.text = @"客服帮助";
//        return otherChooseCell;
//
//    }
    else if (indexPath.section == 1)
    {
        exitCell.exitLabel.text = @"退出";
        return exitCell;
//        [otherChooseCell.typeButton setImage:[UIImage imageNamed:@"my_btn_set-up"] forState:UIControlStateNormal];
//        otherChooseCell.typeNameLabel.text = @"设置";
//        return otherChooseCell;
    }
//    else
//    {
//        exitCell.exitLabel.text = @"退出";
//        return exitCell;
//    }
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
		// 个人资料
		PersonalInfoViewController *personalInfoVC = [[PersonalInfoViewController alloc] initWithNibName:@"PersonalInfoViewController"
                                                                                                  bundle:nil];
        personalInfoVC.delegate = self;
        [self.navigationController pushViewController:personalInfoVC animated:YES];
    }
    else if (indexPath.section == 0 &&indexPath.row == 1)
    {
        // 我的收藏
        EstateListVC * myCollectVC = [[EstateListVC alloc] initWithNibName:@"EstateListVC" bundle:nil];
        myCollectVC.isPropList = NO;
        myCollectVC.propType = FAVORITE;
        [self.navigationController pushViewController:myCollectVC animated:YES];
        
//       // 修改密码
//        ModifyPwdViewController *modifyPwdView = [[ModifyPwdViewController alloc]initWithNibName:@"ModifyPwdViewController"
//                                                                                          bundle:nil];
//        [self.navigationController pushViewController:modifyPwdView animated:YES];
        
    }
    else if (indexPath.section == 0 &&indexPath.row == 2)
    {
        // 修改密码
        ModifyPwdViewController *modifyPwdView = [[ModifyPwdViewController alloc]initWithNibName:@"ModifyPwdViewController" bundle:nil];
        [self.navigationController pushViewController:modifyPwdView animated:YES];
        
//        // 我的收藏
//        if ([CommonMethod isLoadNewView])
//        {
//            EstateListVC * myCollectVC = [[EstateListVC alloc] initWithNibName:@"EstateListVC" bundle:nil];
//            myCollectVC.isPropList = NO;
//            myCollectVC.propType = FAVORITE;
//            [self.navigationController pushViewController:myCollectVC animated:YES];
//        }
//        else
//        {
//            MyCollectVC *myCollectVC= [[MyCollectVC alloc] initWithNibName:@"MyCollectVC" bundle:nil];
//            [self.navigationController pushViewController:myCollectVC animated:YES];
//        }
    }
    else if (indexPath.section == 0 && indexPath.row == 3)
    {
        // 设置
        SettingViewController *settingVC = [[SettingViewController alloc]
                                            initWithNibName:@"SettingViewController"
                                            bundle:nil];
        [self.navigationController pushViewController:settingVC animated:YES];
        
//        if ([_minePresenter hasFaceRecog])
//        {
//            NSString *faceUrl = [CommonMethod getUserdefaultWithKey:FaceCollectUrl];
//
//            if (![faceUrl contains:@"http"]) {
//                // 未采集
//                // 人脸采集
//                FaceRecogVC *faceVC = [[FaceRecogVC alloc] initWithDefauleSetting:YES];
//
//                [self.navigationController pushViewController:faceVC animated:YES];
//            }
//            else
//            {
//                [self showStaffImage];
//            }
//        }
//        else
//        {
//            // 我的店铺
//            NSLog(@"我的店铺");
//            MyStoreVC *infoVC = [[MyStoreVC alloc] init];
//            infoVC.navTitle = @"我的店铺";
//            NSString *infoUrl = [NSString stringWithFormat:@"http://m.gz.centanet.com/jingjiren/esf-%@",
//                                 [AgencyUserPermisstionUtil getIdentify].userNo];
//            infoVC.inforUrl = infoUrl;
//            [self.navigationController pushViewController:infoVC animated:YES];
//        }
    }
    else if (indexPath.section == 0 && indexPath.row == 4)
    {
        // 人脸识别开关
        
    }

//    else if (indexPath.section == 1 &&indexPath.row == 0)
//    {
//        // 客服帮助
//        CustomHelpVC *customHelpVC = [[CustomHelpVC alloc] initWithNibName:@"CustomHelpVC" bundle:nil];
//
//        customHelpVC.helpURL = [[BaseApiDomainUtil getApiDomain] getHelpUrl];
//        [self.navigationController pushViewController:customHelpVC animated:YES];
//    }
    else if (indexPath.section == 1 &&indexPath.row == 0)
    {
        
        WS(weakSelf);
        // 退出登录
        
        NSArray *otherButtonTitleArray = @[@"退出",@"退出并解绑设备"];
        
        [NewUtils popoverSelectorTitle:@"退出登录" listArray:otherButtonTitleArray theOption:^(NSInteger optionValue) {
            
            [weakSelf actionSheetViewClickedButtonAtIndex:optionValue];
            
        }];
        
//        ALActionSheetView *actionSheetView = [ALActionSheetView showActionSheetWithTitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号。" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:otherButtonTitleArray handler:^(ALActionSheetView *actionSheetView, NSInteger buttonIndex) {
//
//            [weakSelf actionSheetViewClickedButtonAtIndex:buttonIndex];
//        }];
//        [actionSheetView show];
        return;
        
//        // 设置
//        SettingViewController *settingVC = [[SettingViewController alloc]
//                                            initWithNibName:@"SettingViewController"
//                                            bundle:nil];
//        [self.navigationController pushViewController:settingVC animated:YES];
    }
    else if (indexPath.section == 2 &&indexPath.row == 0)
    {
//        WS(weakSelf);
//        // 退出登录
//
//        NSArray *otherButtonTitleArray = [[NSArray alloc] init];
//
//        // 退出登录/退出登录+解绑
//       otherButtonTitleArray = [_minePresenter getLogoutButtonTitles];
//
//        ALActionSheetView *actionSheetView = [ALActionSheetView showActionSheetWithTitle:@"退出后不会删除任何历史数据，下次登录依然可以使用本账号。"
//                                                                       cancelButtonTitle:@"取消"
//                                                                  destructiveButtonTitle:nil
//                                                                       otherButtonTitles:otherButtonTitleArray
//                                                                                 handler:^(ALActionSheetView *actionSheetView, NSInteger buttonIndex) {
//
//                                                                                     [weakSelf actionSheetViewClickedButtonAtIndex:buttonIndex];
//                                                                                 }];
//        [actionSheetView show];
//        return;
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

- (void)showStaffImage
{
    ShowStaffImageView *showView = [[ShowStaffImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [showView showStaffImage:[CommonMethod getUserdefaultWithKey:FaceCollectUrl]];
}

- (void)faceRecogSwitch:(UISwitch *)sender
{
    [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:sender.isOn] forKey:FaceRecogSwitch];
}

#pragma mark - ALActionSheetBlock

- (void)actionSheetViewClickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
            // 退出登录
        case 0:
            [self logoutMethod];
            break;
        case 1:
            // 退出登录并解绑设备
            [self deviceLock];
            break;
        case 2:
            
            break;
            
        default:
            break;
    }
}

/**
 *  登出
 */
- (void)logoutMethod
{
    // 用户退出登录后清除用户信息
    [LogOffUtil clearUserInfoFromLocal];
    
    //  [_recommendPropList removeAllObjects];
    [_mainTableView reloadData];
    
    [[self sharedAppDelegate] changeDiscoverRootVCIsLogin:YES];
}

#pragma mark - Request
- (void)deviceLock
{
    // 解绑
    [self showLoadingView:@"解绑中..."];
    
    [CommonMethod registPushWithState:NO];

    
    _deviceLockApi = [DeviceLockApi new];
    
    [_manager sendRequest:_deviceLockApi];
    
    // 用户退出登录后清除用户信息
    [LogOffUtil clearUserInfoFromLocal];
}

/**
 *  聊天开关、消息提醒开关
 */
#pragma mark - ChangeShowChatState

- (void)changeShowChatState:(UISwitch *)switchItem
{
    if (switchItem.tag == NotifySwitchTag)
    {
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:switchItem.isOn]
                                       forKey:EnableNotify];
        
        [CommonMethod registPushWithState:switchItem.on];
    }
}

#pragma mark-<ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    [self hiddenLoadingView];


    if([modelClass isEqual:ConfirmSuccessEntity.class])
    {
        // 解绑成功
        [self hiddenLoadingView];
        
        ConfirmSuccessEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        
        if ([entity.result integerValue] == 0)
        {
            [self logoutMethod];
        }
    }

    if ([modelClass isEqual:[PersonalInfoEntity class]])
    {
        PersonalInfoEntity *staffInfoEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        _resultEntity = staffInfoEntity;

        [CommonMethod setUserdefaultWithValue:staffInfoEntity.employeeName forKey:APlusUserName];
        [CommonMethod setUserdefaultWithValue:_resultEntity.mobile forKey:APlusUserMobile];
        [CommonMethod setUserdefaultWithValue:staffInfoEntity.departmentName forKey:APlusUserDepartName];
        [CommonMethod setUserdefaultWithValue:staffInfoEntity.position forKey:APlusUserRoleName];
        [CommonMethod setUserdefaultWithValue:staffInfoEntity.photoPath forKey:APlusUserPhotoPath];
        
        [_mainTableView reloadData];
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [self hiddenLoadingView];
    if([cls isEqual:ConfirmSuccessEntity.class])
    {
        // 解绑失败
        [super respFail:error andRespClass:cls];
        
        if ([error isKindOfClass:[Error class]])
        {
            Error *failError = (Error *)error;
            if ([failError.rDescription isEqualToString:@"用户未登录"])
            {
                // 登出
                [self logoutMethod];
            }
        }
    }
}

@end
