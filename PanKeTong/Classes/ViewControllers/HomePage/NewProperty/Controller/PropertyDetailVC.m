//
//  PropertyDetailVC.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/21.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "PropertyDetailVC.h"
#import "RealListViewController.h"
#import "OnlyTrustViewController.h"
#import "MoreFollowListViewController.h"
#import "UploadRealSurveyViewController.h"
#import "AddEntrustFilingVC.h"
#import "EditEntrustFilingVC.h"
#import "VoiceRecordViewController.h"
#import "PropAroundMapViewController.h"
#import "AppendInfoViewController.h"
#import "PropSumTakeSeeVC.h"
#import "PDHeaderView.h"
#import "PDPropNameCell.h"
#import "PDHeaderCell.h"
#import "PDFooterCell.h"
#import "PDOneCell.h"
#import "PropertyInfoView.h"
#import "PDFourCell.h"
#import "PDTakeSeeCell.h"
#import "PDPropFollowCell.h"
#import "EventView.h"
#import "CentaShadowView.h"


#import "PropertyStatusCategoryEnum.h"
#import "CallRealPhoneLimitUtil.h"

#import "GetPropDetailApi.h"
#import "PropPageDetailEntity.h"
#import "CollectPropApi.h"
#import "GetFollowRecordApi.h"
#import "FollowRecordEntity.h"
#import "CheckRealProtectedDurationApi.h"
#import "CheckRealProtectedEntity.h"
#import "GetTrustorsApi.h"
#import "PropTrustorsInfoEntity.h"
#import "AllRoundDetailPresenter.h"

#import "StateChangesViewController.h"
#import "WJContactViewController.h"
#import "AdjustThePriceVC.h"
#import "WJDealListController.h"
#import "JMDealCell.h"
//#import "PropKeyViewController.h"
#import "LookKeyViewController.h"
#import "WJDealListModel.h"
#import "DealDetailController.h"
#import "JMDetailPresentView.h"
#import "GetAllRealSurveyPhotoApi.h"
#import "JMPhotoBrowser.h"
#import <SDWebImage/SDImageCache.h>

@interface PropertyDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate
,EventDelegate,FreshFollowListDelegate,ApplyTransferEstDelegate,TapDelegate,UITextFieldDelegate,DetailPresentDelegate>
{
    PDHeaderView *_headerView;
    IBOutlet UIView *_bottomView;
    
    CentaShadowView *_shadowView;                       // 阴影
    IBOutlet UIView *_shareView;                        // 分享
    __weak IBOutlet UIButton *_collectBtn;              // 收藏/取消收藏按钮
    EventView *_eventView;
    BOOL _isCheckedHouseNo;                             // 是否已经查看过房号
    
    PropPageDetailEntity *_propDetailEntity;
    PropFollowRecordDetailEntity *_lastFollowEntity;    // 最新一条跟进
    AllRoundDetailPresenter *_propDetailPresenter;
    
    NSString *_propTitleStr;  // 房源名称
    NSInteger _selectIndex;   // 选择的联系人索引
    NSString *_mobile;        // 要拨打的联系方式
   
    
    NSArray *wjdealArr;
}

@property (nonatomic, strong)NSMutableArray *muArray;
@property (nonatomic, strong)UIView *stateBarView;
@property (nonatomic, strong)UITableView *mainTableView;
@property (nonatomic, strong)WJDealListModel * wjdealModel;
@property (nonatomic, strong) UIView *maskView;         // 影子
@property (nonatomic, strong) UIView *viewdibu;         // 调价View

@end

@implementation PropertyDetailVC

- (void)viewDidLoad {
    _isNewVC = YES;
    [super viewDidLoad];
    
    // 监听键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘落下的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];


    
    [self initData];
    [self initNav];
    [self initView];
    
    //***加载一次***
    [self headerRefresh];
}

//把输入框给顶上去了
- (void)keyboardWillShow:(NSNotification *)aNotification {
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    if ((APP_SCREEN_HEIGHT-CGRectGetMaxY(_viewdibu.frame)) < height) {
        CGRect frame = _viewdibu.frame;
        frame.origin.y = APP_SCREEN_HEIGHT-(height+frame.size.height);
        _viewdibu.frame = frame;
    }
}
//把输入框给降下来的
- (void)keyboardWillHide:(NSNotification *)aNotification {
    CGRect frame = _viewdibu.frame;
    frame.origin.y = (APP_SCREEN_HEIGHT-frame.size.height)/2;
    _viewdibu.frame = frame;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.stateBarView.backgroundColor = _mainTableView.contentOffset.y > 200 ?[UIColor whiteColor]:[UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"nav_line_clear"]];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self hiddenView];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)hiddenView {
    _eventView.hidden = YES;
    _shadowView.hidden = YES;
     [self.stateBarView removeFromSuperview];
     self.stateBarView = nil;
}

- (void)initData{
    _muArray = [[NSMutableArray alloc] initWithObjects:@"上传实勘",@"录音",@"周边",@"调价",@"状态修改",@"新增备案",@"维护联系人", nil];

    // 状态修改 权限判断
    if(![AgencyUserPermisstionUtil hasRight:PROPERTY_PROPERTYSTATUS_MODIFY_ALL]) {
        [_muArray removeObject:@"状态修改"];
    }
    // 查看联系人 权限判断
    if(![AgencyUserPermisstionUtil hasRight:PROPERTY_CONTACTINFORMATION_SEARCH_ALL]) {
        [_muArray removeObject:@"维护联系人"];
    }
    // 调价 权限判断
    if(![AgencyUserPermisstionUtil hasRight:PROPERTY_PROPERTY_MODIFY_ALL]) {
        [_muArray removeObject:@"调价"];
    }
    

    if (_propModelEntity != nil)
    {
        _propKeyId = _propModelEntity.keyId;
        _propTrustType = [NSString stringWithFormat:@"%ld",[_propModelEntity.trustType integerValue]?:0];
        _propertyStatus = [NSString stringWithFormat:@"%ld",[_propModelEntity.propertyStatusCategory integerValue]];
        _propEstateName = _propModelEntity.estateName;
        _propBuildingName = _propModelEntity.buildingName;
        _propHouseNo = _propModelEntity.houseNo;
        _propImgUrl = _propModelEntity.photoPath;
        
    }
    
    
        // 从数据库中查看是否已经查看过房号
        DataBaseOperation *propertyNumManager = [DataBaseOperation sharedataBaseOperation];
        NSString *curStaffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
        NSMutableArray *checkedHouseNumList = [propertyNumManager selectAllKeyIdOfCheckedRoomNumWithStaffNo:curStaffNo andDate:[NSDate stringWithSimpleDate:[NSDate date]]];
        
        if ([checkedHouseNumList containsObject:_propKeyId])
        {
            // 当前房源已查看过房号
            _isCheckedHouseNo = YES;
            _propTitleStr = [NSString stringWithFormat:@"%@%@%@",_propEstateName,_propBuildingName,_propHouseNo];
        }
        else
        {
            _isCheckedHouseNo = NO;
            _propTitleStr = [NSString stringWithFormat:@"%@%@",_propEstateName?:@"",_propBuildingName?:@""];
            
        }
    
    
    [self add];
}
- (void)add{
    
    NSDictionary *paramDic = @{@"PropertyKeyId":_propKeyId,
                               @"StartCreateTime":@"",
                               @"EndCreateTime":@"",
                               @"TransactionType":@"",
                               @"PageIndex":@"1",
                               @"PageSize":@"10",
                               @"SortField":@"",
                               @"Ascending":@"",
                               @"IsMobileRequest":@(true)};
    
    
    
    
    __weak typeof (self) weakSelf = self;
    
    [AFUtils GET:WJDealListAPI parameters:paramDic controller:self successfulDict:^(NSDictionary *successfuldict) {
        NSLog(@"successfuldict===%@",successfuldict);
        [weakSelf endRefreshWithTableView:weakSelf.mainTableView];
        wjdealArr = successfuldict[@"Transactions"];
        
        if (wjdealArr.count>0) {
            weakSelf.wjdealModel = [[WJDealListModel alloc] initDic:successfuldict[@"Transactions"][0]];
        }
        
        [weakSelf.mainTableView reloadData];
    } failureDict:^(NSDictionary *failuredict) {
         NSLog(@"failuredict===%@",failuredict);
    } failureError:^(NSError *failureerror) {
        NSLog(@"failureerror===%@",failureerror);
    }];
    

}

- (void)initNav {
    [self setNavTitle:@""
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"房源详情返回icon"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"房源详情更多icon"
                                            sel:@selector(moreAction:)]];
    
    
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self setBackgroundImageWithAlpha:0];
    
    
     _propDetailPresenter = [[AllRoundDetailPresenter alloc] initWithDelegate:self];
    
}

#pragma mark -  初始化视图
- (void)initView {
    // 表视图
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - APP_TAR_HEIGHT) style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = YCThemeColorBackground;
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    
    [self.view addSubview:_mainTableView];
    
    // 头视图
    _headerView = [[PDHeaderView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 270*WIDTH_SCALE2)];
    NSString *newImagePath = [NSString stringWithFormat:@"%@%@",_propImgUrl, PhotoDownWidth];
    [_headerView.bgImgView sd_setImageWithURL:[NSURL URLWithString:newImagePath] placeholderImage:[UIImage imageNamed:@"estateCheapDefaultDetailImg"]];
    
    _headerView.propDetailLabel.text = [_propModelEntity.estateName stringByAppendingString: _propModelEntity.buildingName?:@""];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapAction:)];
    [_headerView.bgImgView addGestureRecognizer:tap];
    _mainTableView.tableHeaderView = _headerView;
    
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 12)];
    footV.backgroundColor = UICOLOR_RGB_Alpha(0xF4F4F4,1.0);
    
    _mainTableView.tableFooterView = footV;
    
    // 底部视图
    _bottomView.frame = CGRectMake(0, _mainTableView.bottom, APP_SCREEN_WIDTH, 50);
    _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    _bottomView.layer.shadowOpacity = 0.2;
    _bottomView.layer.shadowRadius = 2;
    [self.view addSubview:_bottomView];
    
    // 阴影视图
    _shadowView = [[CentaShadowView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    _shadowView.delegate = self;
    [self.view addSubview:_shadowView];
    
    // 右上角
    NSArray *titleArr = _muArray;
    _eventView = [[EventView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH - RowWidth - 15,
                                                             APP_TAR_HEIGHT,RowWidth,
                                                             RowHeight * titleArr.count + ArrowHeight)
                                   andIsHaveImage:YES];
    _eventView.hidden = YES;
    _eventView.eventDelegate = self;
    [self.view addSubview:_eventView];
    
    // 分享视图默认隐藏
    _shareView.frame = CGRectMake(0,APP_SCREEN_HEIGHT - 190 , APP_SCREEN_WIDTH, 190);
    [self.view addSubview:_shareView];
    _shareView.hidden = YES;
    
    
    if (@available(iOS 11.0, *)) {
        _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    
    // 调价弹窗
    [self initPricingView];
}

#pragma mark - Request

- (void)headerRefresh {
    
    [self showLoadingView:@""];
    // 获取房源详情
    GetPropDetailApi *proDetailApi = [[GetPropDetailApi alloc] init];
    proDetailApi.propKeyId = _propKeyId;
    [_manager sendRequest:proDetailApi];
    
    
    // 获取跟进 AipPropertyFollows
    BOOL isAble = [_propDetailPresenter canViewFollowList:_propDetailEntity.departmentPermissions];
 
    if (isAble){
        
        GetFollowRecordApi *getFollowApi = [[GetFollowRecordApi alloc] init];
        getFollowApi.pageIndex = @"1";
        getFollowApi.pageSize =  @"10";
        getFollowApi.isDetails = @"true";
        getFollowApi.propKeyId = _propKeyId;
        getFollowApi.followTypeKeyId = @"";
        [_manager sendRequest:getFollowApi];
    
    }else{
        
        _lastFollowEntity = [[PropFollowRecordDetailEntity alloc] init];
        _lastFollowEntity.followContent = @"您没有相关查看权限～";
    }
    
}

#pragma mark -  跳转到房源实勘
- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    
    if([AgencyUserPermisstionUtil hasRight:DEPARTMENT_PROPERTY_REALSURVEY_SEARCH_ALL]) {
    
        if ([_propDetailEntity.realSurveyCount integerValue] > 0) {
            
         
            [AFUtils GET:ApiGetPhotos parameters:@{@"KeyId":_propKeyId} controller:self successfulDict:^(NSDictionary *successfuldict) {
                
                
                NSLog(@"图片:%@",successfuldict);
                
                NSArray *arr = successfuldict[@"Photos"];
                
                NSMutableArray *mutArrUrl = [NSMutableArray array];
                for (NSDictionary *dict in arr) {
                    
                NSString *newImagePath = [NSString stringWithFormat:@"%@%@",dict[@"ImgPath"], PhotoDownWidth];
//                      NSString *newImagePath = [NSString stringWithFormat:@"%@",dict[@"ImgPath"]];
                    
                    NSURL *url = [NSURL URLWithString:newImagePath];
                    
                    [mutArrUrl addObject:url];
                }
                
              [JMPhotoBrowser showPhotoBrowserWithImages:mutArrUrl currentImageIndex:0];
          
                
            } failureDict:^(NSDictionary *failuredict) {
                
            } failureError:^(NSError *failureerror) {
                
            }];
      
        }
        
    }else{


         showMsg(@"您没有相关权限");
    }
    
    
    
    
}


/// 更多
- (void)moreAction:(UIButton *)btn {

    _eventView.top = STATUS_BAR_HEIGHT + 45;

    _shadowView.hidden = NO;
    _eventView.hidden = NO;
}

/// 实勘、钥匙、委托
- (void)operaAction:(UIButton *)btn
{
    if (btn.tag == 100)
    {
        // 实勘
        BOOL isAble = [_propDetailPresenter canViewUploadrealSurvey:_propDetailEntity.departmentPermissions];
        if (isAble)
        {
            // 实堪
            RealListViewController *realListViewController = [[RealListViewController alloc]initWithNibName:@"RealListViewController"
                                                                                                     bundle:nil];
            realListViewController.keyId = _propKeyId;
            
            [self.navigationController pushViewController:realListViewController animated:YES];
        }
        else
        {
            showMsg(@(NotHavePermissionTip));
        }
        
    }
    else if (btn.tag == 101)
    {
        
        
        // 查看不需要权限 编辑有权限
        // 钥匙
//        PropKeyViewController *keyBoxVC = [[PropKeyViewController alloc] init];
//        keyBoxVC.keyId = _propKeyId;
//        [self.navigationController pushViewController:keyBoxVC animated:YES];
        
        LookKeyViewController *lookKeyVC = [[LookKeyViewController alloc] init];
        lookKeyVC.keyId = _propKeyId;
        [self.navigationController pushViewController:lookKeyVC animated:YES];
        
     
    }
    else if (btn.tag == 102)
    {
        // 委托
        OnlyTrustViewController *onlyTrustViewController = [[OnlyTrustViewController alloc]initWithNibName:@"OnlyTrustViewController" bundle:nil];
        onlyTrustViewController.keyId = _propKeyId;
        onlyTrustViewController.titleName = @"独家";
        
        [self.navigationController pushViewController:onlyTrustViewController animated:YES];
        
    }
}

/// 分享视图出现
- (IBAction)shareClick:(UIButton *)sender
{
    [self sendSharePropDetailWithKeyId:_propKeyId
                             andImgUrl:_propImgUrl
                            andEstName:_propEstateName];
}

/// 分享到微信好友或者朋友圈
- (IBAction)shareAction:(UIButton *)sender
{
    if (sender.tag == 1111)
    {
        // 分享给微信好友
        [self sendSharePropDetailWithKeyId:_propKeyId
                                 andImgUrl:_propImgUrl
                                andEstName:_propTitleStr];
        
    }
    else if (sender.tag == 2222)
    {
        // 分享到朋友圈
        
    }
    
}

/// 取消分享
- (IBAction)cancelShareAction:(UIButton *)sender
{
    _shadowView.hidden = YES;
    _shareView.hidden = YES;
}


#pragma mark -  收藏／取消收藏
- (IBAction)collectClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    CollectPropApi *collectPropApi = [[CollectPropApi alloc] init];
    collectPropApi.isCollect = sender.selected;
    collectPropApi.propKeyId = _propKeyId;
    if (_block) _block(collectPropApi.isCollect);
    [_manager sendRequest:collectPropApi];
    
    [self showLoadingView:nil];
}


/// 添加跟进
- (IBAction)addFollowClick:(UIButton *)sender
{
    
    BOOL isCanAdd = [AgencyUserPermisstionUtil hasRight:DEPARTMENT_PROPERTY_FOLLOW_SEARCH_ALL];
    if(isCanAdd)
    {
        // 信息补全 或 洗盘
        AppendInfoViewController *appendMsgVC = [[AppendInfoViewController alloc]initWithNibName:@"AppendInfoViewController" bundle:nil];
        appendMsgVC.appendMessageType = PropertyFollowTypeInfoAdd;
        appendMsgVC.propertyKeyId = _propKeyId;
        appendMsgVC.delegate = self;
        
        [self.navigationController pushViewController:appendMsgVC
                                             animated:YES];
    }
    else
    {
        showMsg(@(NotHavePermissionTip));
    }
    
    
}

#pragma mark -  ******开始打电话******

- (IBAction)callClick:(UIButton *)sender
{
    // 查看联系人权限
    BOOL hasPermisstion = [_propDetailPresenter canViewTrustors:_propDetailEntity.departmentPermissions];
  
    if (hasPermisstion) {
        NSString *phoneNum = [[NSUserDefaults standardUserDefaults] stringForKey:APlusUserMobile];

        phoneNum = phoneNum?: @"";

        NSString *userKeyId = [AgencyUserPermisstionUtil getIdentify].uId;
        NSString *departId = [AgencyUserPermisstionUtil getIdentify].departId;
        
        GetTrustorsApi *getTrustorsApi = [[GetTrustorsApi alloc] init];
        getTrustorsApi.userKeyId = userKeyId;
        getTrustorsApi.departmentKeyId = departId;
        getTrustorsApi.userPhone = phoneNum;
        getTrustorsApi.keyId = _propKeyId;
        [_manager sendRequest:getTrustorsApi];
        
        //  重置selectIndex
        _selectIndex = 0;
        [self showLoadingView:@"正在获取联系人信息..."];
   
    }else{
        
        showMsg(@(NotHavePermissionTip));
        
    }
    
    
}

- (void)showPresentView {
    
     NSArray *nameArr = [_propDetailPresenter getTrustorsName];
    
    JMDetailPresentView *presentV = [[JMDetailPresentView alloc] initPresentViewWithArray:nameArr];
    presentV.delegate = self;
    [self.view addSubview:presentV];
    
}


#pragma mark - <TapDelegate>

- (void)tapAction
{
    _eventView.hidden = !_eventView.hidden;
}


#pragma mark - 右上角

- (void)eventClickWithBtnTitle:(NSString *)title
{
    
    // 隐藏两个弹窗：影子和事件view
    [self hiddenView];
    
    __weak typeof(self) weakSelf = self;
    
    if ([title contains:@"上传实勘"]) {
        
        BOOL isAble = [_propDetailPresenter canAddUploadrealSurvey:_propDetailEntity.departmentPermissions];
        
        if (isAble) {
            
            [self showLoadingView:nil];
        
            // 验证实堪保护期
            CheckRealProtectedDurationApi *checkRealProtectedApi = [[CheckRealProtectedDurationApi alloc] init];
            checkRealProtectedApi.keyId = _propKeyId;
            [_manager sendRequest:checkRealProtectedApi];
            

        }else{
            
            showMsg(@(NotHavePermissionTip));
        }
    }else if ([title contains:@"新增备案"] || [title contains:@"编辑备案"])
    {//陈行解决44bug _propDetailEntity.hasRegisterTrusts
        if (!(_propDetailEntity.entrustKeepOnRecord == nil)) {
            
            if ([_propTrustType integerValue] < 1)
            {
                showMsg(FINAL_ESTATE_HAS_NO_TRUST_TYPE)
                return;
            }
            
            EditEntrustFilingVC *editEntrustFilingVC = [[EditEntrustFilingVC alloc] initWithNibName:@"EditEntrustFilingVC"
                                                                                             bundle:nil];
            editEntrustFilingVC.signType = _propDetailEntity.trustType;
            editEntrustFilingVC.propertyKeyId = _propKeyId;
//            editEntrustFilingVC.trustAuditState = _propDetailEntity.trustAuditState;
            editEntrustFilingVC.view.backgroundColor = [UIColor whiteColor];
            
            [editEntrustFilingVC setRefreshPropertyDetailDataBlock:^{
                
                [weakSelf headerRefresh];
                
            }];
            
            [self.navigationController pushViewController:editEntrustFilingVC animated:YES];
        }else {
            if ([_propTrustType integerValue] < 1)
            {
                showMsg(FINAL_ESTATE_HAS_NO_TRUST_TYPE)
                return;
            }
            
            AddEntrustFilingVC * addEntrustFilingVC = [[AddEntrustFilingVC alloc] initWithNibName:@"AddEntrustFilingVC"
                                                                                           bundle:nil];
            addEntrustFilingVC.signType = _propTrustType;
            addEntrustFilingVC.propertyKeyId = _propKeyId;
            addEntrustFilingVC.view.backgroundColor = [UIColor whiteColor];
            
            [addEntrustFilingVC setAddEntrustfilingSuccBlock:^{
                
                [weakSelf headerRefresh];
                
            }];
            
            [self.navigationController pushViewController:addEntrustFilingVC animated:YES];
        }
        
    }
    
    else if ([title contains:@"录音"])
    {
        VoiceRecordViewController *voiceRecordVC = [[VoiceRecordViewController alloc]initWithNibName:@"VoiceRecordViewController"
                                                                                              bundle:nil];
        voiceRecordVC.propId = _propKeyId;
        
        [self.navigationController pushViewController:voiceRecordVC animated:YES];
    }
    else if ([title contains:@"周边"])
    {
        PropAroundMapViewController *propMapVC = [[PropAroundMapViewController alloc]
                                                  initWithNibName:@"PropAroundMapViewController"
                                                  bundle:nil];
        propMapVC.latitude = _propDetailEntity.latitude.doubleValue;
        propMapVC.longitude = _propDetailEntity.longitude.doubleValue;
        propMapVC.propTitleString = _propTitleStr;
        
        [self.navigationController pushViewController:propMapVC animated:YES];
    }
    
    if ([title contains:@"状态修改"])
    {
        if ([_propTrustType integerValue] < 1)
        {
            showMsg(FINAL_ESTATE_HAS_NO_TRUST_TYPE)
            return;
        }
        StateChangesViewController *stateChangesVC = [[StateChangesViewController alloc] init];
        stateChangesVC.propKeyId = _propKeyId;
        stateChangesVC.refreshData = ^{
            [self headerRefresh];
        };
        if ([_propertyStatus isEqualToString:@"1"]) {
            stateChangesVC.propertyStatus = 0;
        }else {
            stateChangesVC.propertyStatus = 1;
        }
        [self.navigationController pushViewController:stateChangesVC animated:YES];
        
        return;
    }
    
    if ([title contains:@"维护联系人"]) {
        
        if ([_propTrustType integerValue] < 1){
            [self hiddenView];
            showMsg(FINAL_ESTATE_HAS_NO_TRUST_TYPE)
            return;
        }
        if (_propDetailEntity.noCallMessage != nil) {
            [self hiddenView];
            showMsg(_propDetailEntity.noCallMessage)
            return;
        }

        WJContactViewController *contantVC = [WJContactViewController new];
        contantVC.propertyKeyId = self.propKeyId;
        [self.navigationController pushViewController:contantVC animated:YES];
        return;
        
    }
    if ([title contains:@"调价"]) {
        
        if ([_propTrustType integerValue] < 1)
        {
            // 隐藏两个弹窗：影子和事件view
            [self hiddenView];
            showMsg(FINAL_ESTATE_HAS_NO_TRUST_TYPE)
            return;
        }
        
        // 隐藏两个弹窗：影子和事件view
        [self hiddenView];
        _maskView.hidden = NO;
        return;
        
    }
    
}


// 调价弹窗
- (void)initPricingView {
    
    __weak typeof(self) weakSelf = self;
    
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    _maskView.hidden = YES;
    _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [[[UIApplication sharedApplication] delegate].window addSubview:_maskView];
    
    // 底部view
    _viewdibu = [[UIView alloc] initWithFrame:CGRectMake(12*NewRatio, 230*NewRatio, APP_SCREEN_WIDTH-12*2*NewRatio, 300*NewRatio)];
    _viewdibu.userInteractionEnabled = YES;
    _viewdibu.layer.cornerRadius = 5*NewRatio;
    _viewdibu.clipsToBounds = YES;
    _viewdibu.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *dateTapgg = [[UITapGestureRecognizer alloc] init];
    [[dateTapgg rac_gestureSignal]subscribeNext:^(id x) {
        
    }];
    [_viewdibu addGestureRecognizer:dateTapgg];
    [_maskView addSubview:_viewdibu];
    
    // 说明
    UILabel *labelstr = [[UILabel alloc] initWithFrame:CGRectMake(24*NewRatio, 24*NewRatio, 60*NewRatio, 23*NewRatio)];
    labelstr.textColor = YCTextColorBlack;
    labelstr.font = [UIFont systemFontOfSize:23*NewRatio];
    labelstr.text = @"调价";
    [_viewdibu addSubview:labelstr];
    
    // 交易类型
    UILabel *jylx = [[UILabel alloc] initWithFrame:CGRectMake(24*NewRatio, CGRectGetMaxY(labelstr.frame)+12*NewRatio, 200*NewRatio, 17*NewRatio)];
    jylx.font = [UIFont systemFontOfSize:17*NewRatio];
    jylx.textColor = YCTextColorGray;
    jylx.text = @"交易类型：租售";
    [_viewdibu addSubview:jylx];
    
    // 横线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(24*NewRatio, CGRectGetMaxY(jylx.frame)+13*NewRatio, CGRectGetWidth(_viewdibu.frame)-24*2*NewRatio, 1*NewRatio)];
    lineView.backgroundColor = UICOLOR_RGB_Alpha(0xf6f6f6, 1.0);
    [_viewdibu addSubview:lineView];
    
    // 总价底部view
    UIView *zongjiadbView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame)+24*NewRatio, CGRectGetWidth(_viewdibu.frame), 48*NewRatio)];
    [_viewdibu addSubview:zongjiadbView];
    // 售价
    UILabel *labelzongjia = [[UILabel alloc] initWithFrame:CGRectMake(24*NewRatio, 0, 44*NewRatio, 35*NewRatio)];
    labelzongjia.font = [UIFont systemFontOfSize:17*NewRatio weight:UIFontWeightLight];
    labelzongjia.textColor = YCTextColorBlack;
    labelzongjia.text = @"售价";
    [zongjiadbView addSubview:labelzongjia];
    // 售价TextField
    UITextField *textFieldPrice = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelzongjia.frame), 0, 210*NewRatio, 35*NewRatio)];
    textFieldPrice.backgroundColor = UICOLOR_RGB_Alpha(0xf9faff, 1.0);
    textFieldPrice.font = [UIFont systemFontOfSize:17*NewRatio weight:UIFontWeightLight];
    textFieldPrice.textColor = YCTextColorBlack;
    textFieldPrice.tag = 678;
    textFieldPrice.layer.cornerRadius = 5*NewRatio;
    textFieldPrice.clipsToBounds = YES;
    textFieldPrice.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    textFieldPrice.delegate = self;
    textFieldPrice.leftViewMode = UITextFieldViewModeAlways;
    textFieldPrice.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12*NewRatio, 10)];
    [zongjiadbView addSubview:textFieldPrice];
    [[textFieldPrice rac_signalForControlEvents:UIControlEventAllEvents] subscribeNext:^(id x) {
//        NSString *string = ((UITextField *)x).text;
//        if (!isItANumber(((UITextField *)x).text) && string.length != 0) {
//            textFieldPrice.text = [string substringWithRange:(NSRange){0,string.length-1}];
//        }
//        if (string.intValue >= 100000000) {
//            textFieldPrice.text = [string substringWithRange:(NSRange){0,string.length-1}];
//        }
    }];
    // 单位
    UILabel *zongjaidanwei = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textFieldPrice.frame)+10*NewRatio, 0, 45*NewRatio, 35*NewRatio)];
    zongjaidanwei.font = [UIFont systemFontOfSize:17*NewRatio weight:UIFontWeightLight];
    zongjaidanwei.textColor = YCTextColorBlack;
    zongjaidanwei.text = @"万元";
    [zongjiadbView addSubview:zongjaidanwei];
    
    // 租价底部view
    UIView *zujiadbView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(zongjiadbView.frame), CGRectGetWidth(_viewdibu.frame), 48*NewRatio)];
    [_viewdibu addSubview:zujiadbView];
    // 租价
    UILabel *labelzujia = [[UILabel alloc] initWithFrame:CGRectMake(24*NewRatio, 0, 44*NewRatio, 35*NewRatio)];
    labelzujia.font = [UIFont systemFontOfSize:17*NewRatio weight:UIFontWeightLight];
    labelzujia.textColor = YCTextColorBlack;
    labelzujia.text = @"租价";
    
    [zujiadbView addSubview:labelzujia];
    // 租价TextField
    UITextField *textFieldPrice2 = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelzujia.frame), 0, 210*NewRatio, 35*NewRatio)];
    textFieldPrice2.backgroundColor = UICOLOR_RGB_Alpha(0xf9faff, 1.0);
    textFieldPrice2.font = [UIFont systemFontOfSize:17*NewRatio weight:UIFontWeightLight];
    textFieldPrice2.textColor = YCTextColorBlack;
    textFieldPrice2.tag = 789;
    textFieldPrice2.layer.cornerRadius = 5*NewRatio;
    textFieldPrice2.clipsToBounds = YES;
    textFieldPrice2.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    textFieldPrice2.delegate = self;
    textFieldPrice2.leftViewMode = UITextFieldViewModeAlways;
    textFieldPrice2.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12*NewRatio, 10)];
    [zujiadbView addSubview:textFieldPrice2];
    [[textFieldPrice2 rac_signalForControlEvents:UIControlEventAllEvents] subscribeNext:^(id x) {
//        NSString *string = ((UITextField *)x).text;
//        if (!isItANumber(((UITextField *)x).text) && string.length != 0) {
//            textFieldPrice2.text = [string substringWithRange:(NSRange){0,string.length-1}];
//        }
//        if (string.intValue >= 100000) {
//            textFieldPrice2.text = [string substringWithRange:(NSRange){0,string.length-1}];
//        }
    }];
    // 单位
    UILabel *zujiadanwei = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textFieldPrice2.frame)+10*NewRatio, 0, 45*NewRatio, 35*NewRatio)];
    zujiadanwei.font = [UIFont systemFontOfSize:17*NewRatio weight:UIFontWeightLight];
    zujiadanwei.textColor = YCTextColorBlack;
    zujiadanwei.text = @"元/月";
    [zujiadbView addSubview:zujiadanwei];
    
    // 按钮底部view
    UIView *bottomButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(zujiadbView.frame), CGRectGetWidth(_viewdibu.frame), 86*NewRatio)];
    [_viewdibu addSubview:bottomButtonView];
    
    // 取消按钮
    UIButton * buttonCancel = [[UIButton alloc]initWithFrame:CGRectMake(24*NewRatio, 12*NewRatio, 140*NewRatio, 50*NewRatio)];
    buttonCancel.layer.cornerRadius = 5*NewRatio;
    buttonCancel.clipsToBounds = YES;
    buttonCancel.backgroundColor = YCTextColorRentOrange;
    [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
    [buttonCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonCancel.titleLabel.font = [UIFont systemFontOfSize:17*NewRatio];
    [bottomButtonView addSubview:buttonCancel];
    [[buttonCancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        textFieldPrice.text = @"";
        textFieldPrice2.text = @"";
        weakSelf.maskView.hidden = YES; // 影子点击事件
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }];
    
    UIButton * buttonDetermine = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(buttonCancel.frame)+24*NewRatio, 12*NewRatio, 140*NewRatio, 50*NewRatio)];
    buttonDetermine.layer.cornerRadius = 5*NewRatio;
    buttonDetermine.clipsToBounds = YES;
    buttonDetermine.backgroundColor = YCThemeColorGreen;
    [buttonDetermine setTitle:@"确定" forState:UIControlStateNormal];
    [buttonDetermine setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonDetermine.titleLabel.font = [UIFont systemFontOfSize:17*NewRatio];
    [bottomButtonView addSubview:buttonDetermine];
    
    [[buttonDetermine rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        // 隐藏键盘
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        showLoading(nil);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            hiddenLoading();
            if (weakSelf.propTrustType.intValue == 1) {
                if (textFieldPrice.text.length == 0) {
                    showMsg(@"请输入价格！");
                    return ;
                }
                if (textFieldPrice.text.floatValue<5) {
                    showMsg(@"售价须大于或等于5万！");
                    return ;
                }
            }
            else if (weakSelf.propTrustType.intValue == 2) {
                if (textFieldPrice2.text.length == 0) {
                    showMsg(@"请输入价格！");
                    return ;
                }
                if (textFieldPrice2.text.floatValue<120) {
                    showMsg(@"租价必须大于或等于120元/月！");
                    return ;
                }
            }
            else if (weakSelf.propTrustType.intValue == 3) {
                if (textFieldPrice.text.length == 0 && textFieldPrice2.text.length == 0) {
                    showMsg(@"请输入价格！");
                    return ;
                }
                if (textFieldPrice.text.length != 0 && textFieldPrice.text.floatValue<5) {
                    showMsg(@"售价须大于或等于5万！");
                    return ;
                }
                if (textFieldPrice2.text.length != 0 && textFieldPrice2.text.floatValue<120) {
                    showMsg(@"租价必须大于或等于120元/月！");
                    return ;
                }
            }
            
            NSDictionary *sict = @{
                                   @"SalePrice":textFieldPrice.text == nil?@"":textFieldPrice.text,
                                   @"RentPrice":textFieldPrice2.text == nil?@"":textFieldPrice2.text,
                                   @"KeyId":weakSelf.propKeyId,
                                   @"TrustType":@(weakSelf.propTrustType.intValue),
                                   @"IsMobileRequest":@(1)
                                   };
            
            
            [AFUtils PUT:AipPropertyPriceModify parameters:sict controller:weakSelf successfulDict:^(NSDictionary *successfuldict) {
                weakSelf.maskView.hidden = YES; // 影子点击事件
                textFieldPrice.text = @"";
                textFieldPrice2.text = @"";
                [weakSelf headerRefresh];
            } failureDict:^(NSDictionary *failuredict) {
            } failureError:^(NSError *failureerror) {
            }];
        });
        
    }];
    
    // 底部视图的点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal]subscribeNext:^(id x) {
        textFieldPrice.text = @"";
        textFieldPrice2.text = @"";
        weakSelf.maskView.hidden = YES; // 影子点击事件
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }];
    [_maskView addGestureRecognizer:tap];
    
   
    
    
    if (_propTrustType.intValue == 1) {
        zujiadbView.hidden = YES;
        _viewdibu.frame = CGRectMake(12*NewRatio, 230*NewRatio, APP_SCREEN_WIDTH-12*2*NewRatio, (300-48)*NewRatio);
        bottomButtonView.frame = CGRectMake(0, CGRectGetMaxY(zongjiadbView.frame), CGRectGetWidth(_viewdibu.frame), 86*NewRatio);
        jylx.text = @"交易类型：出售";
    }else if (_propTrustType.intValue == 2) {
        zongjiadbView.hidden = YES;
        _viewdibu.frame = CGRectMake(12*NewRatio, 230*NewRatio, APP_SCREEN_WIDTH-12*2*NewRatio, (300-48)*NewRatio);
        zujiadbView.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame)+24*NewRatio, CGRectGetWidth(_viewdibu.frame), 48*NewRatio);
        bottomButtonView.frame = CGRectMake(0, CGRectGetMaxY(zujiadbView.frame), CGRectGetWidth(_viewdibu.frame), 86*NewRatio);
        jylx.text = @"交易类型：出租";
    }
}


// 实时获得textField.text的改变
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // 售价
    if (textField.tag == 678) {
        if (!isItDecimal(string, textField.text, 6)) {
            return NO;
        }
    }
    // 租价
    if (textField.tag == 789) {
        if (!isItInteger(string, textField.text, 8)) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - ************  代理 ************

- (void)didSelectCell:(NSInteger)index {

    _selectIndex = index;
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
    
    // 使用虚拟号
    if (isVirtualCall) {
        
        [_propDetailPresenter callVirtualPhoneSelectIndex:_selectIndex
                                                 andMobil:_mobile
                                             andPropKeyId:_propKeyId
                                            andPropertyNo:_propDetailEntity.propertyNo];
    }else{ // 不使用虚拟号
        
        // 删除当日拨打记录
        [CallRealPhoneLimitUtil deleteNotToday];
        
        // keyId是否存在
        if ([CallRealPhoneLimitUtil isExistWithPropKeyId:_propKeyId]) {
            
            NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",tel];
            
            NSArray *arr = [phone componentsSeparatedByString:@"-"];
            
            if (arr.count >2) {
                
                phone = [arr[0] stringByAppendingString:arr[1]].mutableCopy;
            }
          
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
                NSLog(@"%@",[NSThread currentThread]);
                
            });
            
        }else{
            
            
            NSInteger limit = [_propDetailPresenter getCallLimit];
            NSInteger curCount = [CallRealPhoneLimitUtil getCountForToday];
            
            if (curCount >= limit) {
                showMsg(@"您今日拨打电话次数已用完！");
                
            }else{
                
                JMDetailPresentView *presentV = [[JMDetailPresentView alloc] initPresentViewWithNumber:@(limit - curCount).description withTpe:SeeTel];
                presentV.delegate = self;
                [self.view addSubview:presentV];
            }
            
        }
        
    }
    
    
}
- (void)didClickSureBtn:(UIButton *)btn withType:(SeeType)type{
    
    
    if (type == SeeHouse) {
        
        DataBaseOperation *propertyNumManager = [DataBaseOperation sharedataBaseOperation];
        
        NSString *staffNo = [[NSUserDefaults standardUserDefaults]stringForKey:UserStaffNumber];
        // 保存到本地查看过的房号
        [propertyNumManager insertKeyIdOfCheckedRoomNum:_propKeyId
                                             andStaffNo:staffNo
                                                andDate:[NSDate stringWithSimpleDate:[NSDate date]]];
        // 查看房号
        [CheckRoomNumUtil useCheckRoomNumLimit];
        
        _isCheckedHouseNo = YES;
        _propTitleStr = [NSString stringWithFormat:@"%@%@%@",_propEstateName,_propBuildingName,_propHouseNo];
        self.title = _mainTableView.contentOffset.y > 200 ?_propTitleStr:@"";
        _headerView.propDetailLabel.text = _propTitleStr;
        [_mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        
    }else{
        
        [CallRealPhoneLimitUtil addCallRealPhoneRecordWithPropKeyId:_propKeyId];
        
        
        
        NSMutableString *phone = [[NSMutableString alloc] initWithFormat:@"tel:%@",_mobile];
        
        NSArray *arr = [phone componentsSeparatedByString:@"-"];
        
        if (arr.count >2) {
            
            phone = [arr[0] stringByAppendingString:arr[1]].mutableCopy;
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
            NSLog(@"%@",[NSThread currentThread]);
            
        });
        
        
    }
    
    
    
}

#pragma mark - <FreshFollowListDelegate>

/// 刷新跟进列表
- (void)freshFollowListMethod
{
    GetFollowRecordApi *getFollowApi = [[GetFollowRecordApi alloc] init];
    getFollowApi.pageIndex = @"1";
    getFollowApi.pageSize = @"10";
    getFollowApi.isDetails = @"true";
    getFollowApi.propKeyId = _propKeyId;
    getFollowApi.followTypeKeyId = @"";
    [_manager sendRequest:getFollowApi];
}

#pragma mark - <ApplyTransferEstDelegate>

- (void)transferEstSuccess
{
    [self freshFollowListMethod];
}

#pragma mark - *******tableview******

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 3)
    {
        return 1;
    }else if (section == 2) {
        
        return 2;
        
    }else if (section == 4|| section == 5)
    {
        // 房源跟进、房源带看量
        return 3;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.section == 0) {
        // 租价、售价、户型
        return 90;
    }else if (indexPath.section == 1 ) {
       
        if (indexPath.row) {
            
            return 80;
        }else{
        
            // 房源详细信息
            NSArray *titleArr = [_propDetailPresenter getDetailLeftArrayWithTrustType:[_propTrustType integerValue]];
            NSInteger rowCount = [CommonMethod getRowNumWithSunCount:titleArr.count
                                                       andEachRowNum:2];
            
            return 35 * rowCount;
        }
     
        
    }else if ((indexPath.section == 2 && indexPath.row == 1)) {
        // 房源跟进->动态获取
        
        NSString *testStr = @" ";
        if (_lastFollowEntity != nil)
        {
            testStr = _lastFollowEntity.followContent;
        }
        
        CGFloat height1 = [testStr heightWithLabelFont:[UIFont systemFontOfSize:15.0]
                                        withLabelWidth:APP_SCREEN_WIDTH - 30];
        
        CGFloat height2 = _lastFollowEntity.follower.length > 0?20:0;
        
        return height1 + height2 + 30;
    }
    else if (indexPath.section == 4 && indexPath.row == 1)
    {
        // 房源带看量
        return 150;
    }else if (indexPath.section == 3) {
        // 实勘、钥匙、委托
        return 110;
    }else {
        
        
        return 44;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    
    PDHeaderCell *headerCell = (PDHeaderCell *)[tableView cellFromXib:@"PDHeaderCell"];
    PDFooterCell *footerCell = (PDFooterCell *)[tableView cellFromXib:@"PDFooterCell"];
    
    if (indexPath.section == 0) {
        
        /*****租售价、房型*****/
        NSString *identifier = @"PDFitstCell";
        PDOneCell *oneCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!oneCell) {
            
            oneCell = [[PDOneCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:identifier];
            oneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        oneCell.trustType =[_propTrustType integerValue];
        
        if (_propDetailEntity) {
            
            oneCell.dataArr = @[[NSString nilToEmptyWithStr:_propDetailEntity.salePrice],[NSString nilToEmptyWithStr:_propDetailEntity.rentPrice],[NSString nilToEmptyWithStr:_propDetailEntity.roomType]];
       
        }else{
            
            if (_propModelEntity) {
                oneCell.dataArr = @[[NSString nilToEmptyWithStr:_propModelEntity.salePrice],[NSString nilToEmptyWithStr:_propModelEntity.rentPrice],[NSString nilToEmptyWithStr:_propModelEntity.houseType]];
            }
        }
        
        return oneCell;
        
    } else if (indexPath.section == 1) {
      
        /*****房源明细*****/
        if (indexPath.row == 0) {
            
            UITableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
            
            if (!commonCell) {
                commonCell =   [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:@"DetailCell"];
                
                PropertyInfoView *propertyInfoView =   propertyInfoView = [[PropertyInfoView alloc] initWithFrame:CGRectMake(10, 1, APP_SCREEN_HEIGHT - 20, 130)];
                
//                propertyInfoView.leftArr = [_propDetailPresenter getDetailLeftArrayWithTrustType:[_propTrustType integerValue]];
                
                propertyInfoView.tag = 1993;
                [commonCell.contentView addSubview:propertyInfoView];
                
            }
            
            PropertyInfoView *propertyInfoView = [commonCell.contentView viewWithTag:1993];
        
            propertyInfoView.height = commonCell.height;
            
            
            _propTrustType = _propDetailEntity.trustType;
            
            propertyInfoView.leftArr = [_propDetailPresenter getDetailLeftArrayWithTrustType:_propTrustType.integerValue];
            
            propertyInfoView.rightArr = [_propDetailPresenter getDetailRightArrayWithEntity:_propDetailEntity];

            
            return commonCell;
       
        }else{ //查看房号
            
            PDPropNameCell *propNameCell = (PDPropNameCell *)[tableView cellFromXib:@"PDPropNameCell"];
            
            // 是否显示查看房号

                if (_isCheckedHouseNo) {
                    propNameCell.viewBtn.hidden = YES;
                    propNameCell.propInfoLabel.text = _propTitleStr;
                    _headerView.propDetailLabel.text = _propTitleStr;
                    propNameCell.accessoryType = UITableViewCellAccessoryNone;

                }else{

                    propNameCell.viewBtn.hidden = NO;
                   
                }

        
            return propNameCell;
        }
    }else if (indexPath.section == 2) {//房源跟进
       
        //头视图
        if (indexPath.row == 0){
            
            headerCell.titleStr = @"房源跟进";
            headerCell.lastState.hidden = YES;
            return headerCell;
            
        }else if (indexPath.row == 1) {
            
            PDPropFollowCell *propFollowCell = (PDPropFollowCell *)[tableView cellFromXib:@"PDPropFollowCell"];
            if (_lastFollowEntity != nil)
            {
                propFollowCell.followDetailEntity = _lastFollowEntity;
                
                
                
            }
            
            
            
            return propFollowCell;
        }
    
        
    }else if (indexPath.section == 3) {//实勘、钥匙、委托
        
        PDFourCell *fourCell = (PDFourCell *)[tableView cellFromXib:@"PDFourCell"];
        
        for (int i = 0; i < 3; i++)
        {
            UIButton *btn = [fourCell.contentView viewWithTag:100 + i];
            [btn addTarget:self action:@selector(operaAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return fourCell;
    }else if (indexPath.section == 4) {//房源带看量
        
        if (indexPath.row == 0) {
            headerCell.titleStr = @"带看数量";
            headerCell.lastState.hidden = NO;
            return headerCell;
            
        }else if (indexPath.row == 1){
            
            PDTakeSeeCell *takeSeeCell = (PDTakeSeeCell *)[tableView cellFromXib:@"PDTakeSeeCell"];
            
            if (_propDetailEntity != nil)
            {
                takeSeeCell.sumLabel.text = [NSString stringWithFormat:@"%ld", (long)[_propDetailEntity.takeSeeCount integerValue]];
                takeSeeCell.oneWeekLabel.text = [NSString stringWithFormat:@"%ld",(long)[_propDetailEntity.latelyTakeSeeDay7Count integerValue]];
            }
            
            return takeSeeCell;
       
        }else{
            
            
            if (_propDetailEntity.latelyTakeSeeTime.length > 0) {
                
                NSString *timeStr = [_propDetailEntity.latelyTakeSeeTime substringToIndex:10];
                footerCell.content = [NSString stringWithFormat:@"最近带看: %@",timeStr];
                
                
            }else{
                
               footerCell.content = @"最近带看: ";
            }
            
            
            return footerCell;
            
        }
        
       
    }else if (indexPath.section == 5)
    {
        /*****房源成交记录*****/
        if (indexPath.row == 0)
        {
            headerCell.titleStr = @"成交记录";
            headerCell.lastState.hidden = YES;
            return headerCell;
            
        }else if (indexPath.row == 1){
            
            if (wjdealArr.count>0) {
                JMDealCell* cell = [[JMDealCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DealListCell"];
                cell.customerLabel.text = _wjdealModel.CustomerName;
                cell.timeLabel.text = _wjdealModel.CreateTime;
//                cell.selectionStyle = 0;
                cell.typeLabel.text = _wjdealModel.TransactionType;
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            }else {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:14.0];
                cell.textLabel.textColor = [UIColor blackColor];
                cell.accessoryType = 0;
                cell.textLabel.text = @"此房源没有成交记录～";
                return cell;
            }
            
            
        }else{
            
            footerCell.content = @"查看全部成交记录";
            return footerCell;
        }
        
    }
    
    return headerCell;
 
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        // 查看房号
        if (!_isCheckedHouseNo)
        {
            NSInteger checkHouseNoTimes = [CheckRoomNumUtil timesOfCheckNum];
           
            if (checkHouseNoTimes == 0){
                showMsg(@"您今天浏览房号次数已用完！");
            
            } else {
                
              JMDetailPresentView *pView =  [[JMDetailPresentView alloc] initPresentViewWithNumber:[NSString stringWithFormat:@"%ld",checkHouseNoTimes] withTpe:SeeHouse];
                pView.delegate = self;
                [self.view addSubview:pView];
                
              
            }
        }
        
    }else if (indexPath.section == 2 && indexPath.row == 1) {
//        // 查看更多跟进
        BOOL isAble = [_propDetailPresenter canViewFollowList:_propDetailEntity.departmentPermissions];
        if (isAble) {
            // 跟进列表
            MoreFollowListViewController *moreFollowListVC = [[MoreFollowListViewController alloc]initWithNibName:@"MoreFollowListViewController"
                                                                                                           bundle:nil];
            moreFollowListVC.freshFollowListDelegate = self;
            moreFollowListVC.propKeyId = _propKeyId;
            moreFollowListVC.propertyStatusCategory = _propDetailEntity.propertyStatusCategory;
            moreFollowListVC.propDetailEntity = _propDetailEntity;
            moreFollowListVC.propModelEntity = _propModelEntity;
            moreFollowListVC.departmentPermisstion = _propDetailEntity.departmentPermissions;
            moreFollowListVC.propTrustType = _propDetailEntity.trustType;
            moreFollowListVC.propertyStatus = _propDetailEntity.propertyStatus;
            
            [self.navigationController pushViewController:moreFollowListVC animated:YES];
        }else{
//            showMsg(@(NotHavePermissionTip));
        }
    
    }else if (indexPath.section == 4 && indexPath.row == 2) {
        // 查看更多带看记录
        PropSumTakeSeeVC *vc = [[PropSumTakeSeeVC alloc] init];
        vc.propKeyId = _propKeyId;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (indexPath.section == 5 && indexPath.row == 1) {
        
        // 房源成交记录
        if (wjdealArr.count>0) {
            
            DealDetailController *vc = [[DealDetailController alloc] init];
            vc.model = _wjdealModel;
            vc.titleString = @"成交详情";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    
    }else if (indexPath.section == 5 && indexPath.row == 2) {
        
        // 房源成交记录
        WJDealListController *vc = [[WJDealListController alloc] init];
        vc.propKeyId = _propKeyId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
        CGFloat yOffSet = scrollView.contentOffset.y;
    
        if (yOffSet >= 200) {
            
            self.title = _propTitleStr;
            [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
            self.stateBarView.backgroundColor = [UIColor whiteColor];
            
        }else{
            
            [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
            self.stateBarView.backgroundColor = [UIColor clearColor];
            self.title = @"";
           
        }
        
        
        [self setBackgroundImageWithAlpha:yOffSet/200];
    
    
    
    
    
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass {
    
    [_mainTableView.mj_header endRefreshing];
    
    if ([modelClass isEqual:[PropPageDetailEntity class]]) {/// 房源详情
         [self hiddenLoadingView];
        _propDetailEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        if (self.isFollowRecord) {
            
            _propTitleStr = _propDetailEntity.allHouseInfo;
            _headerView.propDetailLabel.text = _propTitleStr;
            self.title = _mainTableView.contentOffset.y > 200 ?_propTitleStr:@"";
            
        }
        
        //刷新列表的图片
        self.propModelEntity.photoPath = _propDetailEntity.photoPath;
        NSString *newImagePath = [NSString stringWithFormat:@"%@%@",_propDetailEntity.photoPath, PhotoDownWidth];
       
        [_headerView.bgImgView sd_setImageWithURL:[NSURL URLWithString:newImagePath] placeholderImage:[UIImage imageNamed:@"estateCheapDefaultDetailImg"]];
        
        [self reloadData];
        
    }else if ([modelClass isEqual:[FollowRecordEntity class]]) {/// 房源跟进
      

        FollowRecordEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        if (entity.propFollows.count > 0)
        {
            _lastFollowEntity = entity.propFollows[0];
        }
        else
        {
            // 没有跟进记录
            _lastFollowEntity = [PropFollowRecordDetailEntity new];
            _lastFollowEntity.followContent = @"此房源没有跟进记录～";
        }
       
        // 刷新
        [_mainTableView reloadData];

        
    }else if ([modelClass isEqual:[AgencyBaseEntity class]]) {/// 收藏/取消收藏
       

        AgencyBaseEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        if (entity.flag == YES)
        {
            // 收藏/取消收藏成功
            if (_collectBtn.selected)
            {
                [CustomAlertMessage showAlertMessage:@"收藏成功\n\n" andButtomHeight:APP_SCREEN_HEIGHT/2];
            }
            else
            {
                [CustomAlertMessage showAlertMessage:@"取消收藏成功\n\n" andButtomHeight:APP_SCREEN_HEIGHT/2];
            }
        }
   
    } else if ([modelClass isEqual:[CheckRealProtectedEntity class]]){/// 验证实勘保护期
        //取消loadingView
        [self hiddenLoadingView];

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
            
            __block typeof(self) weakSelf = self;
            
            [uploadRealSurveyVC setUploadRealSurveySuccessBlock:^{
                
                [weakSelf headerRefresh];
                
            }];
            
            [self.navigationController pushViewController:uploadRealSurveyVC animated:YES];
        }
        else
        {
            showMsg(@(NotHavePermissionTip));
        }

    } else if ([modelClass isEqual:[PropTrustorsInfoEntity class]]) { /// 获取联系人
     

        [_propDetailPresenter getDataSource:data];
        [self showTrustors];
    
    }else if ([modelClass isEqual:[PropTrustorsInfoForShenZhenEntity class]]) {
     
        [_propDetailPresenter getDataSource:data];
        // 显示联系人
        [self showTrustors];
    }
    
}
#pragma mark -  显示联系人
- (void)showTrustors {
    
    
    NSString *errorMsg = [_propDetailPresenter showTrustorsErrorMsg];
    if (errorMsg.length || ![_propDetailPresenter getTrustorsName].count) {
        showMsg(errorMsg?:@"暂无联系人信息!");

    }else{

        [self showPresentView];
    }


}

- (void)respFail:(NSError *)error andRespClass:(id)cls {
 
    [super respFail:error andRespClass:cls];
    
    [self hiddenLoadingView];

    [_mainTableView.mj_header endRefreshing];

    /// 收藏/取消收藏
    if ([cls isEqual:[AgencyBaseEntity class]])
    {
        _collectBtn.selected = !_collectBtn.selected;
    }
    
}


- (void)reloadData
{
    
    //陈行解决44bug
    NSString * str = !(_propDetailEntity.entrustKeepOnRecord == nil) ? @"编辑备案" : @"新增备案";
    
    for (int i = 0; i < _muArray.count; i++) {
        
        NSString * tmp = _muArray[i];
        
        if ([tmp isEqualToString:@"新增备案"] || [tmp isEqualToString:@"编辑备案"]) {
            
            _muArray[i] = str;
            break;
        }
        
    }
    
    _propDetailPresenter.propDetailEntity = _propDetailEntity;
    _eventView.titleArr = _muArray;
    [_eventView setNeedsLayout];
    
    _headerView.label.text = _propDetailEntity.propertyTags;
    _headerView.photoSumlLabel.text = [NSString stringWithFormat:@"%ld",[_propDetailEntity.realSurveyCount integerValue]];
    _collectBtn.selected = _propDetailEntity.isFavorite;
    _propTrustType = _propDetailEntity.trustType ? : _propTrustType;
    _propertyStatus = [NSString stringWithFormat:@"%ld",[_propDetailEntity.propertyStatusCategory integerValue]];
    
    [_mainTableView reloadData];
    
}

- (void)setBackgroundImageWithAlpha:(CGFloat)alpha {
    

    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor: [[UIColor whiteColor] colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
    

  
}

- (UIView *)stateBarView {
    
    if (!_stateBarView) {
        
        _stateBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -STATUS_BAR_HEIGHT, APP_SCREEN_WIDTH, STATUS_BAR_HEIGHT)];
        
        [self.navigationController.navigationBar addSubview:_stateBarView];
        
    }
    return _stateBarView;
}


- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *imgae = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgae;
}
- (void)dealloc {
    
    [[SDImageCache sharedImageCache] clearMemory];
    
}


@end
