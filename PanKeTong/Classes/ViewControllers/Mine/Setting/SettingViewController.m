//
//  SettingViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/30.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SettingViewController.h"
#import "ArrowSignLeftTextCell.h"
#import "ArrowSignTextCell.h"
#import "SettingImgViewController.h"
#import "SettingMsgRemindViewController.h"
#import "CommonWebView.h"
#import "MindFeedBackViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "CheckVersonEntity.h"
#import "SettingChatSwitchCell.h"
#import "AgencyBaseEntity.h"
#import "ChangePhoneNumberApi.h"
#import "CheckAppVersonApi.h"
#import "CheckVersonUtils.h"

#import "NSFileManager+FileCategory.h"

#define UpdateAlertTag          1000    //更新提示框tag
#define ChangePhoneAlertTag     2000    //修改报备手机号tag
#define ChatSwitchTag           3000    //聊天开关tag
#define NotifySwitchTag         4000    //消息提醒tag
#define ClearCacheAlertTag      5000    //清除缓存二次确认
#define ClearChatAlertTag       6000    //清空聊天记录二次确认


@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,DascomCallProtocol,CheckVersonDelegate>
{
    
    __weak IBOutlet UITableView *_mainTableView;
    
    NSString *_cacheSizeStr;        //缓存大小
    NSString *_serverAppVerson;     //服务端appversion
    NSString *_phoneNumber;         //手机号
    
    BOOL _isShowUpdateAlert;        //是否点击了版本更新，如果点击了，有新版本就提示alert
    //
    //    CheckVersonUtils *_checkVersonUtils;
    //
    
}

@end

@implementation SettingViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavTitle:@"系统设置"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 后台执行：计算图片缓存
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *cache = [NSString stringWithFormat:@"%@",@([[SDImageCache sharedImageCache]
                                                              getSize])];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf calculateCacheSuccess:cache];
        });
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    _checkVersonUtils.delegate = nil;
}



- (void)initData
{
    _mainTableView.rowHeight=44;
    _isShowUpdateAlert = NO;
    _isShowErrorAlert = NO;
    
    //  获取服务端版本号
    [self getUpdateVerson];
    [self getMsisdnMethod];
}

/**
 *  获取服务端版本号
 */
- (void)getUpdateVerson
{
    // 检查版本更新
    //    _checkVersonUtils = [CheckVersonUtils shareCheckVersonUtils];
    //    _checkVersonUtils.delegate = self;
    //    [_checkVersonUtils checkAppVerson];
}

#pragma mark - SDWebImageCache
/**
 *  计算缓存完成
 */
- (void)calculateCacheSuccess:(NSString *)cache
{
    _cacheSizeStr = [NSString stringWithFormat:@"%@",cache];
    
    [_mainTableView reloadData];
}

- (void)clearCache
{
    [self showLoadingView:@"清除缓存中..."];
    
    __weak typeof (self) weakSelf = self;
    
    //清除WKWebView产生的缓存
    [NSFileManager removeWKWebCache];
    
    //清除图片缓存
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        
        [[SDImageCache sharedImageCache] clearMemory];
        
        [weakSelf hiddenLoadingView];
        
        NSString *cache = [NSString stringWithFormat:@"%@", @([[SDImageCache sharedImageCache] getSize])];
        
        [weakSelf calculateCacheSuccess:cache];
    }];
    
//    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
//    [[SDImageCache sharedImageCache] calculateSizeWithCompletionBlock:^(NSUInteger fileCount, NSUInteger totalSize) {
//
//        NSString *cache = [NSString stringWithFormat:@"%@",@([[SDImageCache sharedImageCache]
//                                                              getSize])];
//        [weakSelf hiddenLoadingView];
//        [weakSelf calculateCacheSuccess:cache];
//    }];
//
//    NSString *faceUrl = [CommonMethod getUserdefaultWithKey:FaceCollectUrl];
//
//    if ([faceUrl contains:@"http"])
//    {
//        // 清除缓存
//        [[SDImageCache sharedImageCache] removeImageForKey:faceUrl withCompletion:nil];
//
//    }
}

#pragma mark-<UITextFieldDelegate>

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([[[UITextInputMode currentInputMode ]primaryLanguage] isEqualToString:@"emoji"])
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - <UITableViewDelegate/UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
        {
            return 3;
        }
            break;
        case 1:
        {
            return 2;
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 是否可以修改报备手机号
    
        if (indexPath.section == 0 && indexPath.row == 2)
        {
            return 0.01;
        }
    
    
    return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *arrowSignTextCellId = @"arrowSignTextCell";
    static NSString *arrowSignLeftTextCellId = @"arrowSignLeftTextCell";
    
    ArrowSignTextCell *arrowSignTextCell = [tableView dequeueReusableCellWithIdentifier:arrowSignTextCellId];
    ArrowSignLeftTextCell *arrowSignLeftTextCell = [tableView dequeueReusableCellWithIdentifier:arrowSignLeftTextCellId];
    
    if (indexPath.section == 0)
    {
        if (!arrowSignLeftTextCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"ArrowSignLeftTextCell"
                                                  bundle:nil]
            forCellReuseIdentifier:arrowSignLeftTextCellId];
            arrowSignLeftTextCell = [tableView dequeueReusableCellWithIdentifier:arrowSignLeftTextCellId];
        }
        
        arrowSignLeftTextCell.hidden = NO;
        
        switch (indexPath.row) {
            case 0:
            {
                
                arrowSignLeftTextCell.leftTextLabel.text = @"图片设置";
            }
                break;
                
            case 1:
            {
                arrowSignLeftTextCell.leftTextLabel.text = @"手势密码管理";
                
            }
                break;
                
            case 2:
            {
                
                
               
                    arrowSignLeftTextCell.hidden = YES;
                
                
                   arrowSignLeftTextCell.leftTextLabel.text = [NSString stringWithFormat:@"%@%@", @"报备手机号：",@""];
            }
                break;
                
                //            case 3:
                //            {
                //                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                //                NSString *app_Build = [infoDictionary objectForKey:@"CFBundleVersion"];
                //                NSString *app_Version = [NSString stringWithFormat:@"%@",
                //                                         [infoDictionary objectForKey:@"CFBundleShortVersionString"]];
                //
                //                if (!arrowSignTextCell)
                //                {
                //                    [tableView registerNib:[UINib nibWithNibName:@"ArrowSignTextCell"
                //                                                          bundle:nil]
                //                    forCellReuseIdentifier:arrowSignTextCellId];
                //                    arrowSignTextCell = [tableView dequeueReusableCellWithIdentifier:arrowSignTextCellId];
                //                }
                //
                //                arrowSignTextCell.leftTextLabel.text = [NSString stringWithFormat:@"版本更新（当前版本v%@）",app_Version];
                //
                //                if (_serverAppVerson
                //                    && [_serverAppVerson integerValue] > [app_Build integerValue])
                //                {
                //                    arrowSignTextCell.rightTextLabel.text = @"有可用更新";
                //
                //                }
                //                else
                //                {
                //                    arrowSignTextCell.rightTextLabel.text = @"";
                //                }
                //
                //                return arrowSignTextCell;
                //            }
                //                break;
                
            default:
                break;
        }
        
        return arrowSignLeftTextCell;
        
    }
    else if (indexPath.section == 1)
    {
        if (!arrowSignTextCell)
        {
            [tableView registerNib:[UINib nibWithNibName:@"ArrowSignTextCell"
                                                  bundle:nil]
            forCellReuseIdentifier:arrowSignTextCellId];
            arrowSignTextCell = [tableView dequeueReusableCellWithIdentifier:arrowSignTextCellId];
        }
        
        switch (indexPath.row) {
            case 0:
            {
                arrowSignTextCell.leftTextLabel.text = @"意见反馈";
                arrowSignTextCell.rightTextLabel.text = @"让我们更好";
            }
                break;
                
            case 1:
            {
                arrowSignTextCell.leftTextLabel.text = @"清除缓存";
                if (![_cacheSizeStr isEqualToString:@"0"])
                {
                    arrowSignTextCell.rightTextLabel.text = [NSString stringWithFormat:@"%.1f M",
                                                             _cacheSizeStr.floatValue/1024.0/1024.0] ;
                }
                else
                {
                    arrowSignTextCell.rightTextLabel.text = @"0.0 M";
                }
            }
                break;
                
            case 2:
            {
                arrowSignTextCell.leftTextLabel.text = @"清空聊天记录";
                arrowSignTextCell.rightTextLabel.text = @"0.0 M";
            }
                
                break;
                
            default:
                break;
        }
        
        return arrowSignTextCell;
    }
    else if (indexPath.section == 2)
    {
        switch (indexPath.row) {
            case 0:
            {
                //                if (!arrowSignLeftTextCell)
                //                {
                //                    [tableView registerNib:[UINib nibWithNibName:@"ArrowSignLeftTextCell"
                //                                                          bundle:nil]
                //                    forCellReuseIdentifier:arrowSignLeftTextCellId];
                //                    arrowSignLeftTextCell = [tableView dequeueReusableCellWithIdentifier:arrowSignLeftTextCellId];
                //                }
                //
                //                arrowSignLeftTextCell.leftTextLabel.text = [NSString stringWithFormat:@"分享%@给好友",SettingProjectName];;
                //
                //                return arrowSignLeftTextCell;
            }
                break;
                
            default:
                break;
        }
    }
    
    return [[UITableViewCell alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row) {
            case 0:
            {
                // 图片设置
                SettingImgViewController *settingImgVC = [[SettingImgViewController alloc] initWithNibName:@"SettingImgViewController"
                                                                                                    bundle:nil];
                [self.navigationController pushViewController:settingImgVC animated:YES];
            }
                break;
                
            case 1:
            {
                // 手机密码管理
                NSLog(@"===＝手势密码管理＝＝＝＝");
                GesturePwdManageViewController *gesturePwdManageView = [[GesturePwdManageViewController alloc] initWithNibName:@"GesturePwdManageViewController"
                                                                                                                        bundle:nil];
                [self.navigationController pushViewController:gesturePwdManageView animated:YES];
            }
                break;
                
            case 2:
            {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"修改报备手机号"
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确认", nil];
                alert.tag = ChangePhoneAlertTag;
                // 基本输入框，显示实际输入的内容
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                // 设置输入框的键盘类型
                UITextField *nameText = [alert textFieldAtIndex:0];
                nameText.keyboardType = UIKeyboardTypeNumberPad;
                nameText.clearButtonMode=UITextFieldViewModeAlways;
                
                [alert show];
            }
                break;
                
            case 3:
            {
                // 检查版本号
                //                _isShowUpdateAlert = YES;
                //                [self showLoadingView:@"检查中..."];
                //                _checkVersonUtils.isShowErrorAlert = YES;
                //                [self getUpdateVerson];
            }
                break;
                
            default:
                break;
        }
    }
    else if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                // 意见反馈
                MindFeedBackViewController * feedBackVC = [[MindFeedBackViewController alloc]initWithNibName:@"MindFeedBackViewController"   bundle:nil];
                [self.navigationController pushViewController:feedBackVC  animated:YES];
            }
                break;
                
            case 1:
            {
                // 清除缓存
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认清除缓存?"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确认", nil];
                alert.tag = ClearCacheAlertTag;
                [alert show];
            }
                break;
                
            default:
                break;
        }
    }
    else if(indexPath.section == 2)
    {
        // 分享移动A+
        [self shareAppMethod];
    }
}

/**
 *  聊天开关、消息提醒开关
 */
#pragma mark - ChangeShowChatState

- (void)changeShowChatState:(UISwitch *)switchItem
{
    if (switchItem.tag == ChatSwitchTag)
    {
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:switchItem.isOn]
                                       forKey:ShowChatIcon];
    }
    else if (switchItem.tag == NotifySwitchTag)
    {
        [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:switchItem.isOn]
                                       forKey:EnableNotify];
        [CommonMethod registPushWithState:switchItem.on];
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

#pragma mark - <AlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case UpdateAlertTag:
        {
            if (buttonIndex == 1)
            {
                // 点击更新按钮
                NSString *updateUrl = [[NSUserDefaults standardUserDefaults]stringForKey:UpdateVersionUrl];
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
            }
        }
            break;
            
        case ChangePhoneAlertTag:
        {
            // 修改报备手机号
            UITextField * nameText=[alertView textFieldAtIndex:0];
            _phoneNumber = nameText.text;
            
            if (buttonIndex == 1)
            {
                if([CommonMethod isMobile:nameText.text])
                {
                    [self showLoadingView:@"正在修改报备号码..."];
//                    if([_settingPresenter isUseDascom])
//                    {
//                        DascomUtil *dascomUtil = [DascomUtil shareDascomUtil];
//                        dascomUtil.delegate = self;
//                        [dascomUtil requestChangePhoneNumber:nameText.text];
//                    }
//                    else
//                    {
                        NSString *userKeyId = [AgencyUserPermisstionUtil getIdentify].uId;
                        
                        ChangePhoneNumberApi *changePhoneNumberApi = [[ChangePhoneNumberApi alloc] init];
                        changePhoneNumberApi.employeeKeyId = userKeyId;
                        changePhoneNumberApi.mobile = nameText.text;
                        [_manager sendRequest:changePhoneNumberApi];
//                    }
                }else{
                    showMsg(@"请输入正确的手机号码！");
                    return;
                }
            }
            
            [_mainTableView reloadData];
        }
            break;
            
        case ClearCacheAlertTag:
        {
            if (buttonIndex == 1)
            {
                // 清除缓存
                [self clearCache];
            }
        }
            break;
            
        case ClearChatAlertTag:
        {
            // 清空聊天记录
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - <DascomCallProtocol>

- (void)addCallPhoneView:(UIView *)callView
{
    
}

- (void)changedPhoneNumber:(NSString *)newPhoneNumber
{
    [self hiddenLoadingView];
    [_mainTableView reloadData];
    showMsg(@"修改成功！");
}

- (void)resultFail
{
    [self hiddenLoadingView];
    //    showMsg(@"网络请求失败！");
}

/**
 *  获取虚拟号配置
 */
- (void)getMsisdnMethod
{
//    if([_settingPresenter isUseDascom])
//    {
//        // 聊天数据获取成功后请求手机号
//        [DascomUtil shareDascomUtil].fromeVC = @"setting";
//        [[DascomUtil shareDascomUtil]requestMsisdn:^{
//            
//            [_mainTableView reloadData];
//            
//        }];
//    }
}

#pragma mark -<CheckVersonDelegate>

- (void)requestSuccess
{
    [self hiddenLoadingView];
}

- (void)requestFeild:(NSString *)errorMsg
{
    [self hiddenLoadingView];
    //    showMsg(errorMsg);
}

#pragma mark-<ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[CheckVersonEntity class]])
    {
        [self hiddenLoadingView];
        
        CheckVersonEntity *checkVersionEntity = [DataConvert convertDic:data toEntity:modelClass];
        CheckVersonResultEntity *versionDetailEntity = checkVersionEntity.result;
        
        // 保存更新地址、更新内容
        [CommonMethod setUserdefaultWithValue:versionDetailEntity.updateUrl
                                       forKey:UpdateVersionUrl];
        
        _serverAppVerson = versionDetailEntity.clientVer;
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleVersion"];
        
        if (_isShowUpdateAlert)
        {
            if ([versionDetailEntity.clientVer integerValue] > [app_Version integerValue])
            {
                UIAlertView *updateAlert = [[UIAlertView alloc]initWithTitle:@"有版本更新"
                                                                     message:versionDetailEntity.updateContent
                                                                    delegate:self
                                                           cancelButtonTitle:@"取消"
                                                           otherButtonTitles:@"更新", nil];
                updateAlert.tag = UpdateAlertTag;
                [updateAlert show];
                
            }
            else
            {
                [CustomAlertMessage showAlertMessage:@"当前已是最新版本\n\n"
                                     andButtomHeight:APP_SCREEN_HEIGHT/2];
            }
        }
        
        if ([modelClass isEqual:[AgencyBaseEntity class]])
        {
            [self hiddenLoadingView];
            
            // 存储A+系统手机号
            [CommonMethod setUserdefaultWithValue:_phoneNumber forKey:APlusUserMobile];
            
            showMsg(@"已成功修改");
            
            [_mainTableView reloadData];
        }
    }
}

- (void)didFailedReceiveResponseWithError:(Error *)error
{
    if (error.rCode == Tag_AppVersion)
    {
        [self hiddenLoadingView];
    }
}

@end
