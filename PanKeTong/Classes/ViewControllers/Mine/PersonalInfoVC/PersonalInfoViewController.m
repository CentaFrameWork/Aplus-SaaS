//
//  PersonalInfoViewController.m
//  PanKeTong
//
//  Created by zhwang on 16/3/30.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "MyHeadImageCell.h"
#import "PersonalInfoCell.h"
#import "WeChatQRCodeCell.h"
#import "PersonalInfoEntity.h"
//#import "UserTokenService.h"
#import "WeChatQRCodeView.h"
#import "GetPersonalApi.h"

@interface PersonalInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    __weak IBOutlet UITableView *_mainTableView;
    
//    UserTokenService *_userTokenService;
    GetPersonalApi *_getPersonalApi;
    PersonalInfoEntity *_resultEntity;
}

@end

@implementation PersonalInfoViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    [self initData];
}

#pragma mark - init

- (void)initView
{
    [self setNavTitle:@"个人资料"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    _mainTableView.tableFooterView=[[UIView alloc]init];
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
    
//    _userTokenService = [UserTokenService shareService];
//    _userTokenService.delegate = self;
//    
//    [_userTokenService getPersonalWithStaffNo:staffNo
//                                      andCityCode:userCityCode];
}

#pragma mark - <TableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0)
    {
        return 64;
    }
    else if (indexPath.section == 2 && indexPath.row == 2)
    {
        return 60;
    }
    else
    {
        return 45;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    else if (section == 1)
    {
        return 2;
    }
    
    return 3;
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
    static NSString *myHeadImageIdentifier = @"myHeadImage";
    static NSString *personalInfoIdentifier = @"personalInfo";
    static NSString *weChatQRCodeIdentifier = @"weChatQRCode";
    
    MyHeadImageCell *myHeadImageCell = [tableView dequeueReusableCellWithIdentifier:myHeadImageIdentifier];
    
    if (!myHeadImageCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"MyHeadImageCell" bundle:nil]
        forCellReuseIdentifier:myHeadImageIdentifier];
        
        myHeadImageCell =[tableView dequeueReusableCellWithIdentifier:myHeadImageIdentifier];
    }
    
    PersonalInfoCell *personalInfo = [tableView dequeueReusableCellWithIdentifier:personalInfoIdentifier];
    if (!personalInfo)
    {
        [tableView registerNib:[UINib nibWithNibName:@"PersonalInfoCell" bundle:nil]
        forCellReuseIdentifier:personalInfoIdentifier];
        personalInfo =[tableView dequeueReusableCellWithIdentifier:personalInfoIdentifier];
    }
    
    WeChatQRCodeCell *weChatQRCodeCell = [tableView dequeueReusableCellWithIdentifier:weChatQRCodeIdentifier];
    if (!weChatQRCodeCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"WeChatQRCodeCell" bundle:nil]
        forCellReuseIdentifier:weChatQRCodeIdentifier];
        weChatQRCodeCell =[tableView dequeueReusableCellWithIdentifier:weChatQRCodeIdentifier];
        
    }
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        // 员工编号
//        NSString *staff = [CommonMethod getUserdefaultWithKey:UserStaffNumber];
//        NSString *photoPath = [[BaseApiDomainUtil getApiDomain] getStaffPhotoUrlWithStaffNo:staff];

        NSString *userPhotoPath = [CommonMethod getUserdefaultWithKey:APlusUserPhotoPath];
        // 头像
        [myHeadImageCell.headImageView sd_setImageWithURL:[NSURL URLWithString:userPhotoPath]
                                         placeholderImage:[UIImage imageNamed:@"staffHead_icon"]];
        return myHeadImageCell;
    }
    else if (indexPath.section == 2 && indexPath.row == 2)
    {
        // 微信二维码
        [CommonMethod setImageWithImageView:weChatQRCodeCell.weChatImage
                                andImageUrl:_resultEntity.weiXinQRCodeUrl
                    andPlaceholderImageName:@""];
        weChatQRCodeCell.qRCodeNoLabel.text = _resultEntity.wxNo;
        
        return weChatQRCodeCell;
    }
    else
    {
        // 个人资料Cell
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row == 1)
                {
                    personalInfo.leftTitleLabel.text = @"姓名";
                    personalInfo.rightDetailLabel.text = _resultEntity.employeeName;
                }
                else
                {
                    personalInfo.leftTitleLabel.text = @"账号";
                    personalInfo.rightDetailLabel.text = _resultEntity.employeeNo;
                }
            }
                break;
                
            case 1:
            {
                if (indexPath.row == 0)
                {
                    personalInfo.leftTitleLabel.text = @"角色";
                    personalInfo.rightDetailLabel.text = _resultEntity.position;
                }
                else
                {
                    personalInfo.leftTitleLabel.text = @"部门";
                    personalInfo.rightDetailLabel.text = _resultEntity.departmentName;
                }
            }
                break;
                
            case 2:
            {
                if (indexPath.row == 0)
                {
                    personalInfo.leftTitleLabel.text = @"手机";
                    personalInfo.rightDetailLabel.text = _resultEntity.mobile;
                    // 存储手机号
                    [CommonMethod setUserdefaultWithValue:_resultEntity.mobile forKey:APlusUserMobile];

                }
                if (indexPath.row ==1)
                {
                    personalInfo.leftTitleLabel.text = @"签名";
                    personalInfo.rightDetailLabel.text = _resultEntity.signature;
                }
            }
                break;
                
            default:
                break;
        }
        
        return personalInfo;
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2 && indexPath.row == 2)
    {
        // 微信二维码
        WeChatQRCodeView *view = [[WeChatQRCodeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        NSString *imageUrl = _resultEntity.weiXinQRCodeUrl;
        
        if (imageUrl.length > 0 || ![imageUrl isEqualToString:@""])
        {
            [view showWeChatQRCode:imageUrl];
        }
        else
        {
            showMsg(@"您还未设置微信二维码");
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

#pragma mark - <ResponseDelegate>

#pragma mark - <ResponseDelegate>
- (void)dealData:(id)data andClass:(id)modelClass
{
    [self hiddenLoadingView];
    
    if ([modelClass isEqual:[PersonalInfoEntity class]])
    {
        PersonalInfoEntity *staffInfoEntity = [DataConvert convertDic:data toEntity:modelClass];
        _resultEntity = staffInfoEntity;

        NSString *userDeptName = [[NSUserDefaults standardUserDefaults]objectForKey:APlusUserDepartName];
        NSString *userTitle = [[NSUserDefaults standardUserDefaults]objectForKey:APlusUserRoleName];

        if (![userDeptName isEqualToString:staffInfoEntity.departmentName]
            || ![userTitle isEqualToString:staffInfoEntity.position])
        {
            [self.delegate requestPersonalInfo];
        }
        
        [CommonMethod setUserdefaultWithValue:_resultEntity.mobile forKey:APlusUserMobile];
        [CommonMethod setUserdefaultWithValue:staffInfoEntity.departmentName forKey:APlusUserDepartName];
        [CommonMethod setUserdefaultWithValue:staffInfoEntity.position forKey:APlusUserRoleName];
        [CommonMethod setUserdefaultWithValue:staffInfoEntity.photoPath forKey:APlusUserPhotoPath];
        [CommonMethod setUserdefaultWithValue:staffInfoEntity.extendTel forKey:APlusUserExtendMobile];

    }
    
    [_mainTableView reloadData];
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
