//
//  DiscoverViewController.m
//  APlus
//
//  Created by sujp on 2017/9/18.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "NewHomePageVC.h"
#import "NewSearchVC.h"
#import "MoreModuleVC.h"
#import "EstateListVC.h"
#import "PropertyDetailVC.h"
#import "BaseViewController+Handle.h"

#import "HeadView.h"
#import "EventScrollView.h"
#import "ModuleCollectionView.h"
#import "RankingFirstCell.h"
#import "RankingCell.h"
#import "NewPropertyCell.h"

#import "PhoneListUtil.h"
#import "CheckHttpErrorUtil.h"

#import "GetPropListApi.h"
#import "CityConfigApi.h"
#import "APPConfigApi.h"
#import "GetSystemParamApi.h"
#import "MyPerformanceApi.h"
#import "TopPerformanceApi.h"
#import "PropListEntity.h"
#import "DealDetailController.h"
#import "JDStatusBarNotification.h"

#import "UITabBar+badge.h"
#import "JMScanController.h"
#define MAX_COUNT                   11
#define ModuleViewTag               100
#define SecondViewBtnBaseTag        1000

@interface NewHomePageVC () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,
ResponseDelegate,ClickNewPropDelegate,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
{
    
    ModuleCollectionView *_moduleView;
    EventScrollView *_eventScrollView;
    HeadView *_headView;
    UIView *_titleView;
    
    APPConfigApi *_appConfig;

    NSArray *_newPropDataArr;
   
    NSArray *_homeEventArr;
    PerformanceItemEntity *_myPerformance;
    NSArray *_topPermanceArr;
    float _TopOnePerformance; // 第一名业绩
    BOOL _hasRequest;
}

@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) HudViewUtil *myHubViewUtil;
@property (nonatomic,strong) NSArray *homeModuleArr;
@end

@implementation NewHomePageVC

- (void)viewDidLoad {
    _isNewVC = YES;
    [super viewDidLoad];

    [self navBarNeedHidden:YES
              andAnimation:YES];
    

    // 登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:LoginSuccessNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getHomeModule:)
                                                 name:Home_Default
                                               object:nil];

    [self initData];

    [self initView];

    [self requestData];
    _hasRequest = YES;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 设置电池条为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

    _mainTableView.contentOffset = CGPointZero;

    NSArray *data = [CommonMethod getUserdefaultWithKey:Home_Default];

    _homeModuleArr = [MTLJSONAdapter modelsOfClass:[APPLocationEntity class]
                                     fromJSONArray:data
                                             error:nil];
    [_eventScrollView setContentOffset:CGPointZero];

    [self requestAllModuleData];
    
    //测试消息的小标位置
//    [self.tabBarController.tabBar showBadgeOnItemIndex:1];
    

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _hasRequest = NO;
}

#pragma mark - *****init*****

- (void)initData {
     
    _myHubViewUtil = [[HudViewUtil alloc] init];
    _appConfig = [[APPConfigApi alloc] init];

        [CommonMethod CheckAddressBookAuthorization:^(bool isAuthorized){

            if(isAuthorized)
            {
                NSString *phoneName = [NSString stringWithFormat:@"%@虚拟号",SettingProjectName];
                NSString *phoneNumber = [[BaseApiDomainUtil getApiDomain] getDascomNumber];

                // 通讯录无此联系人 且 虚拟号接入码为空时不做添加号码操作
                BOOL ishave = [PhoneListUtil filterContentForSearchText:phoneName andNumber:phoneNumber];
                if(!ishave && ![NSString isNilOrEmpty:phoneNumber])
                {
                    [PhoneListUtil addContacter];
                }
            }
            else
            {
                showMsg(@"请到设置>隐私>通讯录打开本应用的权限设置");
            }
        }];
    
    
}

- (void)initView {
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - APP_TAR_HEIGHT) style:UITableViewStylePlain];
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = [UIColor whiteColor];
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [self.view addSubview:_mainTableView];

    
    //头视图
    _headView = [[HeadView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 220*NewRatio)];
    [_headView.searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [_headView.scanBtn addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    _mainTableView.tableHeaderView = _headView;

    // 导航栏
    CGFloat height = APP_NAV_HEIGHT;
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, height)];
    _titleView.backgroundColor = [UIColor whiteColor];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(30*NewRatio, height - 44, APP_SCREEN_WIDTH - 60*NewRatio, 30*NewRatio);
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:15*NewRatio];
    [searchBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    searchBtn.backgroundColor = UICOLOR_RGB_Alpha(0xF9FaFF,1.0);
    [searchBtn setLayerCornerRadius:15*NewRatio];
    [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchBtn setTitle:@"  请输入城区、片区、楼盘名" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [_titleView addSubview:searchBtn];
    _titleView.alpha = 0;
    _titleView.hidden = YES;
    [self.view addSubview:_titleView];
    

    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    
    
}

#pragma mark - 下拉刷新

- (void)headerRefresh {
    [self requestData];

    [self requestAllModuleData];
}

- (void)requestData {
    
    // 重新获取系统参数
    NSString *sysParamNewUpdTime = [AgencySysParamUtil getSysParamNewUpdTime];
    GetSystemParamApi *systemParamApi = [GetSystemParamApi new];
    systemParamApi.updateTime = sysParamNewUpdTime;
    [_manager sendRequest:systemParamApi];

    
    // 新上房源(5分钟内不能重复刷新)
    BOOL isHave = [AgencyUserPermisstionUtil hasMenuPermisstion:MENU_PROPERTY_WAR_ZONE];

    if (isHave)
    {
        AppDelegate *appDelegate = (AppDelegate *)[self sharedAppDelegate];
        NSDate *lastDate = appDelegate.lastRequestNewPropTime;
        NSDate *nowDate = [NSDate date];
        NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:lastDate];

        if (timeInterval > 5 * 60 || lastDate == nil)
        {
            // 时间间隔大于5分钟
            GetPropListApi *propListApi = [[GetPropListApi alloc] init];
            propListApi.propListTyp = WARZONE;
            propListApi.isNewProInThreeDay = @"true";
            propListApi.ascending = @"true";
            propListApi.pageSize = @"5";
            propListApi.pageIndex = @"1";
            propListApi.estateSelectType = [NSString stringWithFormat:@"%d",EstateSelectTypeEnum_ALLNAME];
            propListApi.buildTypes = @[];
            propListApi.houseDirection = @[];
            propListApi.propertyTypes = @[];
            propListApi.propertyboolTag = @[];
            propListApi.popStatus = @[];
            [_manager sendRequest:propListApi];
            appDelegate.lastRequestNewPropTime = [NSDate date];
        }
    }else{
        _newPropDataArr = nil;
    }



    // 首页事件模块配置
    _appConfig.location = Home_Event;
    [_manager sendRequest:_appConfig];

    
#warning 加盟版没有这两个接口 LJS 2018.03.19
// api/customer/employeearea-top-performance
// api/customer/employee-performance
//    // 获取个人业绩
//    NSString *userNo = [AgencyUserPermisstionUtil getIdentify].userNo;
//    MyPerformanceApi *myPerformanceApi = [[MyPerformanceApi alloc] init];
//    myPerformanceApi.employeeNo = userNo;
//    [_manager sendRequest:myPerformanceApi];
//
//    // 获取前十业绩
//    TopPerformanceApi *topApi = [[TopPerformanceApi alloc] init];
//    topApi.employeeNo = userNo;
//    topApi.empTopCount = @(10);
//    [_manager sendRequest:topApi];
//    [_myHubViewUtil showLoadingView:nil];
    
    
    
}

- (void)requestAllModuleData {
   
    _appConfig.location = Home_More;
    
    [_manager sendRequest:_appConfig sucBlock:^(id result) {

         [self.mainTableView.mj_header endRefreshing];
         [self.myHubViewUtil  hiddenLoadingView];

         APPConfigEntity *entity = [DataConvert convertDic:result
                                                  toEntity:[APPConfigEntity class]];

         NSArray *dataArr = entity.result;
        
         NSMutableArray *configArr = [NSMutableArray array];
        
        for (APPLocationEntity *entity1 in dataArr) {
            
             NSInteger configId1 = entity1.configId;
             [configArr addObject:@(configId1)];
         }

         NSMutableArray *mArr = [NSMutableArray arrayWithArray:self.homeModuleArr];
         NSMutableArray *addMarray = [NSMutableArray array];

         for (APPLocationEntity *entity1 in dataArr) {
             
             NSInteger configId1 = entity1.configId;

             BOOL ishave1 = NO;

             for (APPLocationEntity *entity2 in self.homeModuleArr) {
                
                 NSInteger configId2 = entity2.configId;

                 if (![configArr containsObject:@(configId2)]) {
                     // 该模块已下架,从本地存储中移除
                     [mArr removeObject:entity2];
                 }

                 if (configId1 == configId2) {
                     // 如果有替换
                     NSInteger index = [mArr indexOfObject:entity2];
                     [mArr replaceObjectAtIndex:index withObject:entity1];
                     ishave1 = YES;

                     break;
                 }
             }

             if (!ishave1 && entity1.iconFrame.length > 0)
             {
                 // 新增加模块
                 [addMarray addObject:entity1];
             }
         }

         // 新增加模块插入到最前面
         if (mArr.count + addMarray.count > MAX_COUNT) {
             // 需要移除的个数
             NSInteger cha = mArr.count + addMarray.count  - MAX_COUNT;
             [mArr removeObjectsInRange:NSMakeRange(mArr.count - cha,cha)];
         }
         [mArr insertObjects:addMarray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, addMarray.count)]];

         self.homeModuleArr = mArr;
         mArr = nil;
         addMarray = nil;
         configArr = nil;

         // 存储到本地
         NSArray *data = [MTLJSONAdapter JSONArrayFromModels:self.homeModuleArr];
         [CommonMethod setUserdefaultWithValue:data forKey:Home_Default];

         [self.mainTableView reloadData];

     } failBlock:^(NSError *error) {
         
         [self hiddenLoadingView];
         [self.myHubViewUtil  hiddenLoadingView];
     }];
}



#pragma mark - Notification

// 获取道首页配置
- (void)getHomeModule:(NSNotificationCenter *)notifi {
    NSArray *data = [CommonMethod getUserdefaultWithKey:Home_Default];

    _homeModuleArr = [MTLJSONAdapter modelsOfClass:[APPLocationEntity class]
                                     fromJSONArray:data
                                             error:nil];
    
}

// 登录成功
- (void)loginSuccess:(NSNotification *)notiftcation
{
    if (![CommonMethod isLoadNewView]) {
        return;
    }
    
    if (_hasRequest == NO)
    {
        [self requestData];
    }
}


#pragma mark - 搜索


- (void)searchAction:(UIButton *)btn {
    
    if ([AgencyUserPermisstionUtil hasMenuPermisstion:MENU_PROPERTY_WAR_ZONE]) {
        
        NewSearchVC *searchVC = [[NewSearchVC alloc] init];
        searchVC.moduleSearchType = HomePageSearch;
        [self.navigationController pushViewController:searchVC animated:YES];
   
        
    }else{
        
         showMsg(@(NotHavePermissionTip));
    }
    
   
}

#pragma mark -  扫一扫
- (void)scanAction:(UIButton *)btn
{

    
//    DealDetailController *scanVC = [DealDetailController new];
//     [self.navigationController pushViewController:vc animated:YES];

    
    
        [JMScanController scanController:^(bool isInstance, UIViewController *vc) {

        if (isInstance) {

            [self.navigationController pushViewController:vc animated:YES];
        }else{

            [self presentViewController:vc animated:YES completion:nil];

        }
    }];

    
//        JMScanJumpYCuiController *scanVC = [JMScanJumpYCuiController new];
//         [self.navigationController pushViewController:scanVC animated:YES];

}

// 更多（新上房源）
- (void)newPropAction:(UIButton *)btn
{
    if (![AgencyUserPermisstionUtil hasMenuPermisstion:MENU_PROPERTY_WAR_ZONE])
    {
        showMsg(@(NotHavePermissionTip));
        return;
    }

    if (_newPropDataArr.count > 0)
    {
        EstateListVC *vc = [[EstateListVC alloc] init];
        vc.isPropList = NO;
        vc.propType = WARZONE;
        vc.isNewProInThreeDay = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        showMsg(@"暂无新上房源!");
    }
}

#pragma mark - <ClickNewPropDelegate>

/// 点击某一套新上房源
- (void)clickNewPropWithIndex:(NSInteger)index
{
    if (_newPropDataArr.count > 0)
    {
        NSLog(@"%ld",(long)index);
        PropertysModelEntty *propertyEntity =  _newPropDataArr[index];
        PropertyDetailVC *vc = [[PropertyDetailVC alloc] init];
        vc.propModelEntity = propertyEntity;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - <ScrollViewDelagete>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGFloat yOfSet = scrollView.contentOffset.y;
        CGFloat contentOffset = 140*NewRatio;

        if (yOfSet >= 0)
        {
            // 隐藏／显示导航栏
            float alpha = 1 - ((contentOffset - yOfSet) / contentOffset);
            if (alpha > 0.5)
            {
                _headView.searchBtn.hidden = YES;
                _titleView.hidden = NO;
                // 设置电池条为黑色
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
            }
            else
            {
                _headView.searchBtn.hidden = NO;
                _titleView.hidden = YES;
                // 设置电池条为白色
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
            }
            _titleView.hidden = NO;
            _titleView.alpha = alpha;
        }
    }
}

#pragma mark - *******tableview*******

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 3)
    {
        // 业绩排行
        return _topPermanceArr.count + 1;
    }
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        NSInteger rowCount = [CommonMethod getRowNumWithSunCount:_homeModuleArr.count + 1
                                                   andEachRowNum:4];
        CGFloat height = rowCount * 90*NewRatio+5*NewRatio;

        return height;

    }else if (indexPath.section == 1) {
        
        return 100*NewRatio;
        
    }else{
        
        CGFloat width = (APP_SCREEN_WIDTH - YCAppMargin * 3) / 2;
        
        return width * 100/170;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    if (indexPath.section == 0){ //功能图标
        
        _moduleView = [cell.contentView viewWithTag:100];
        if (_moduleView == nil) {
            
            _moduleView = [[ModuleCollectionView alloc] initWithFrame:CGRectMake(Module_space, 0, APP_SCREEN_WIDTH - Module_space * 2, 0)];
            _moduleView.tag = 100;
            _moduleView.delegate = self;
            [cell.contentView addSubview:_moduleView];
        }

        if (_homeModuleArr.count > 0)
        {
            _moduleView.dataArr = _homeModuleArr;
        }
   
    }else if (indexPath.section == 1){
        
        NSString *identifier = @"NewPropertyCell";
        NewPropertyCell *firstCell = (NewPropertyCell *)[tableView cellFromXib:identifier];
        firstCell.marqueeView.delegate = self;
        [firstCell.moreBtn addTarget:self action:@selector(newPropAction:) forControlEvents:UIControlEventTouchUpInside];

        if (_newPropDataArr.count > 0)
        {
            firstCell.dataArr = _newPropDataArr;
        }
        return firstCell;
        
    }else if (indexPath.section == 2){
        
        _eventScrollView = [cell.contentView viewWithTag:200];
        if (_eventScrollView == nil)
        {
            
            CGFloat width = (APP_SCREEN_WIDTH - YCAppMargin * 3) / 2;
            
            CGFloat height = width * 100 / 170;
            
            _eventScrollView = [[EventScrollView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, height)];
            
            _eventScrollView.tag = 200;
            
            [cell.contentView addSubview:_eventScrollView];
        }

        if (_homeEventArr.count > 0)
        {
            _eventScrollView.eventArr = _homeEventArr;
        }
    
    }else if (indexPath.section == 3){
        
        if (indexPath.row == 0)
        {
            RankingFirstCell *firstCell = (RankingFirstCell *)[tableView cellFromXib:@"RankingFirstCell"];
            NSString *userPhotoPath = [CommonMethod getUserdefaultWithKey:APlusUserPhotoPath];
            [firstCell.employeeImg sd_setImageWithURL:[NSURL URLWithString:userPhotoPath] placeholderImage:[UIImage imageNamed:@"默认头像"]];

            if (_myPerformance != nil)
            {
                firstCell.myPerformance = _myPerformance;
            }
            if (_topPermanceArr.count > 0)
            {
                firstCell.topPerformance = _TopOnePerformance;
            }
            return firstCell;
       
        }else{
            
            RankingCell *rankingCell = (RankingCell *)[tableView cellFromXib:@"RankingCell"];

            if (_topPermanceArr.count > 0)
            {
                SubPerformanceEntity *entity = _topPermanceArr[indexPath.row - 1];

                float rate = [entity.performance floatValue] / _TopOnePerformance;

                [rankingCell fillData:entity
                             withRate:rate
                     withRankingIndex:indexPath.row];
            }
            return rankingCell;
        }
    }

    return cell;
}



#pragma mark - 代理方法

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.item == _homeModuleArr.count)
    {
        // 跳转到更多应用界面
        MoreModuleVC *moreModuleVC = [[MoreModuleVC alloc] init];
        [self.navigationController pushViewController:moreModuleVC animated:YES];
    }
    else
    {
        APPLocationEntity *entity = _homeModuleArr[indexPath.item];
        [self popWithAPPConfigEntity:entity];
    }
}


#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass {
    
      [_mainTableView.mj_header endRefreshing];

    // 系统配置
    if ([modelClass isEqual:[SystemParamEntity class]])
    {
        SystemParamEntity *systemParamEntity = [DataConvert convertDic:data toEntity:modelClass];

        if(systemParamEntity.needUpdate)
        {
            [AgencySysParamUtil setSystemParam:systemParamEntity];
        }
        else
        {
            NSLog(@"系统参数不需要更新");
        }
    }

    // 新上房源
    if ([modelClass isEqual:[PropListEntity class]])
    {
        PropListEntity *entity = [DataConvert convertDic:data toEntity:modelClass];

        if (entity.propertysModel.count > 5)
        {
            // 取最新5条
            _newPropDataArr = [entity.propertysModel subarrayWithRange:NSMakeRange(0, 5)];
        }
        else
        {
            _newPropDataArr = entity.propertysModel;
        }

        if (_newPropDataArr.count > 0)
        {
            [_mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]]
                                  withRowAnimation:UITableViewRowAnimationNone];
        }

    }

    // 模块配置
    if ([modelClass isEqual:[APPConfigEntity class]]) {
        
        [_myHubViewUtil hiddenLoadingView];

        APPConfigEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        _homeEventArr = entity.result;

        [_mainTableView reloadData];
    }

    // 个人业绩
    if ([modelClass isEqual:[MyPerformanceEntity class]])
    {
        MyPerformanceEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        _myPerformance = entity.result;

        [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:3]
                      withRowAnimation:UITableViewRowAnimationNone];
    }

    // Top 10业绩
    if ([modelClass isEqual:[TopPerformanceEntity class]])
    {
        [_myHubViewUtil hiddenLoadingView];

        TopPerformanceEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        _topPermanceArr = entity.result;

        SubPerformanceEntity *entity1 = _topPermanceArr[0];
        _TopOnePerformance = [entity1.performance floatValue];


        [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:3]
                      withRowAnimation:UITableViewRowAnimationNone];
    }

}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{

    if ([cls isEqual:[MyPerformanceEntity class]])
    {
        NSString *errorMsg = @"";

        if ([error isKindOfClass:[Error class]])
        {
            Error *failError = (Error *)error;
            errorMsg = [CheckHttpErrorUtil handleError:failError];
        }
        else
        {
            Error *failError = [[Error alloc]init];

            failError.rDescription = error.localizedDescription;
            failError.httpCode = error.code;

            errorMsg = [CheckHttpErrorUtil handleError:failError];
        }

        // 弹提示
        NSNumber *isHave = [CommonMethod getUserdefaultWithKey:Have_Alert_Msg];
        if ([isHave boolValue] == NO || isHave == nil)
        {
            showJDStatusStyleErrorMsg(errorMsg);
            [CommonMethod setUserdefaultWithValue:[NSNumber numberWithBool:YES] forKey:Have_Alert_Msg];
        }
    }
    else
    {
        [super respFail:error andRespClass:cls];
    }
}


@end
