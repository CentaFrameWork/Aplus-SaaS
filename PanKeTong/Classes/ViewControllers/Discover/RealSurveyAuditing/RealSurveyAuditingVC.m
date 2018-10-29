//
//  RealSurveyAuditingVC.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/7/14.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "RealSurveyAuditingVC.h"
#import "RealSurveyAuditingListCell.h"
#import "UIView+Extension.h"
#import "DropDownMeunView.h"
#import "RealSurveyFilterVC.h"
#import "RealSurveyEntity.h"
#import "RealSurveyAuditingEntity.h"
//#import "AccessModelScopeDefine.h"
#import "AccessModelScopeEnum.h"
#import "RealSurveyStatusEnum.h"
#import "CheckRealSurveyViewController.h"
#import "RealSurveyReviedListEntity.h"
#import "RealSurveyAuditingListEntity.h"
#import "ApprovalRecordViewController.h"
#import "ApprovalRecordEntity.h"
//#import "AllRoundDetailViewController.h"
#import "PropertyDetailVC.h"
#import "RealSurveyOperationEntity.h"
#import "RealSurveyAuditingListApi.h"
#import "RealSurveyOperationApi.h"

#import "RealSurveyAuditingBasePresenter.h"

#import "RealSurveyAuditingViewProtocol.h"

#define PERTYPE_APPROVED   @"1"
#define PERTYPE_REVIEWAPPROVED  @"2"

#define PassAlertView_Tag       111
#define RefusedAlertView_Tag    222
#define SubmitAlertView_Tag     333


@interface RealSurveyAuditingVC ()<UITableViewDelegate,UITableViewDataSource,
DropDownMeunDelegate,RealSurveyFilterDelegate,CheckRealSurveyOperDelegate,RealSurveyAuditingViewProtocol>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) DropDownMeunView *meun;;
@property (strong, nonatomic) RealSurveyAuditingEntity *realSurveyAuditingEntity;
@property (strong, nonatomic) RealSurveyAuditingBasePresenter *realSurveyAuditingPresenter;

@property (nonatomic, readwrite, strong) NSString *startTime;       // 开始时间
@property (nonatomic, readwrite, strong) NSString *endTime;         // 结束时间
@property (nonatomic, strong) NSArray *auditingArray;               // 审核状态
@property (nonatomic, strong) NSMutableArray *realSurveyListArray;
@property (nonatomic, copy) NSString *presentClickRealStatus;
@property (nonatomic, copy) NSString *presentClickPropKeyId;
@property (nonatomic, assign) NSInteger collectionHight;
@property (nonatomic, strong) NSIndexPath *presentClickIndexPath;
@property (nonatomic, assign) BOOL isSelect;                        // 是否点击下拉菜单

@end

@implementation RealSurveyAuditingVC

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self checkShowViewPermission:MENU_PROPERTY_REALSURVEYS andHavePermissionBlock:^(NSString *permission) {
        
        [self initPresenter];
        [self initArray];
        [self initView];
        [self initData];
        [self headerRefreshMethod];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 收起下拉菜单
    [_meun collectionViewDismiss];
    // 改变箭头方向
    [self meunImageViewChangeImage:YES];
}

#pragma mark - init

- (void)initView
{
    [self setNavTitle:_titleName
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"筛选"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(goFilterVC)]];
    
    _topView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]
                                    initWithTarget:self action:@selector(dropDownClick)];
    [_topView addGestureRecognizer:tap];
    
    CGFloat meunY = _topView.y + _topView.height;
    NSInteger itemWitch = (APP_SCREEN_WIDTH - 20 * 3) / 3;
    
    _meun = [[DropDownMeunView alloc] initCollectionFrame:CGRectMake(0, meunY, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - meunY)
                                              andItemSize:CGSizeMake(itemWitch, 40)
                                             andDataArray:self.auditingArray];
    _meun.delegate = self;
    [self.view addSubview:_meun];
    
//    [_mainTableView addHeaderWithTarget:self action:@selector(headerRefreshMethod)];
//    [_mainTableView addFooterWithTarget:self action:@selector(footerRefreshMethod)];
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];
    
    // 获得默认状态
    _auditStatusLabel.text = [_realSurveyAuditingPresenter getDefaultState];
}

- (void)initArray
{
    self.realSurveyListArray = [NSMutableArray array];
    self.auditingArray = [_realSurveyAuditingPresenter getDropDownMeunArray];

    _isSelect = NO;
}

- (void)initPresenter
{
    
        _realSurveyAuditingPresenter = [[RealSurveyAuditingBasePresenter alloc] initWithDelegate:self];
    
}

- (void)initData
{
    // 初始化开始时间和结束时间
    NSDate *lastMouthDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 30];
    
    if (_startTime.length == 0)
    {
        _startTime = [CommonMethod formatDateStrFromDate:lastMouthDate];
    }
    if (_endTime.length == 0)
    {
        _endTime = [CommonMethod formatDateStrFromDate:[NSDate date]];
    }
    
    _realSurveyAuditingEntity = [RealSurveyAuditingEntity new];
    
    if ([_auditStatusLabel.text isEqualToString:@"待审核"])
    {
        _realSurveyAuditingEntity.auditStatus = [NSString stringWithFormat:@"%d",UNAPPROVED];
    }
    if ([_auditStatusLabel.text isEqualToString:@"待提交"])
    {
        _realSurveyAuditingEntity.auditStatus = [NSString stringWithFormat:@"%d",UNSUBMIT];
    }
    _realSurveyAuditingEntity.createTimeFrom = _startTime;
    _realSurveyAuditingEntity.createTimeTo = _endTime;

    // 获取权限
    [self getPermission];
}

#pragma mark - ClickEvents

/// 跳筛选
- (void)goFilterVC
{
    NSDictionary *dic = [MTLJSONAdapter JSONDictionaryFromModel:_realSurveyAuditingEntity];
    
    RealSurveyFilterVC *filter = [[RealSurveyFilterVC alloc] initWithNibName:@"RealSurveyFilterVC" bundle:nil];
    filter.dataDic = dic;
    filter.startTime = self.realSurveyAuditingEntity.createTimeFrom;;
    filter.endTime = self.realSurveyAuditingEntity.createTimeTo;
    filter.delegate = self;
    
    [self.navigationController pushViewController:filter animated:YES];
}

/// 跳房源详情
- (void)goAllRoundDetailWithIndexPath:(NSIndexPath *)indexPath andEntity:(RealSurveyAuditingListEntity *)listEntity
{
    PropertyDetailVC *allRoundDetailVC = [[PropertyDetailVC alloc] init];
    allRoundDetailVC.propKeyId = listEntity.propertyKeyId;
    allRoundDetailVC.propEstateName = [NSString stringWithFormat:@"%@",listEntity.estateName];
    allRoundDetailVC.propBuildingName = [NSString stringWithFormat:@"%@",listEntity.buildinName];
    
    [self.navigationController pushViewController:allRoundDetailVC animated:YES];
}

/// 跳审核记录
- (void)goApprovalRecordWithIndexPath:(NSIndexPath *)indexPath andEntity:(RealSurveyAuditingListEntity *)listEntity
{
    double timeDouble = [CommonMethod tryTimeNumberWith:listEntity.auditTime];
    NSString *time = [CommonMethod dateConcretelyTime:timeDouble andYearNum:[[listEntity.auditTime substringToIndex:4] integerValue]];
    
    ApprovalRecordEntity *approvalRecordEntity = [ApprovalRecordEntity new];
    approvalRecordEntity.approvalStatus = [NSString stringWithFormat:@"%ld",listEntity.auditStatus];
    approvalRecordEntity.auditorName = listEntity.auditPersonName;
    approvalRecordEntity.time = time;
    
    ApprovalRecordViewController *approvalRecord = [ApprovalRecordViewController new];
    approvalRecord.approvalRecordEntity = approvalRecordEntity;
    
    [self.navigationController pushViewController:approvalRecord animated:YES];
}

/// 下拉实勘状态菜单
- (void)dropDownClick
{
    if (!_isSelect)
    {
        [self.view bringSubviewToFront:_meun];
        [_meun collectionViewAppear];
    }
    else
    {
        [_meun collectionViewDismiss];
    }
    
    // 改变箭头方向
    [self meunImageViewChangeImage:_isSelect];
    _isSelect = !_isSelect;
}

#pragma mark - RequestData

- (void)headerRefreshMethod
{
    [self showLoadingView:nil];
    
    [_realSurveyListArray removeAllObjects];
    [_mainTableView reloadData];
    RealSurveyAuditingListApi *realSurveyAuditingListApi = [[RealSurveyAuditingListApi alloc] init];
    realSurveyAuditingListApi.realSurveyAuditingEntity = _realSurveyAuditingEntity;
    realSurveyAuditingListApi.pageIndex = @"1";
    realSurveyAuditingListApi.pageSize = @"10";
    realSurveyAuditingListApi.sortField = @"";
    realSurveyAuditingListApi.ascending = @"true";
    [_manager sendRequest:realSurveyAuditingListApi];
}

- (void)footerRefreshMethod
{
    NSString *curPageNum = [NSString stringWithFormat:@"%@",@(_realSurveyListArray.count/10+1)];
    RealSurveyAuditingListApi *realSurveyAuditingListApi = [[RealSurveyAuditingListApi alloc] init];
    realSurveyAuditingListApi.realSurveyAuditingEntity = _realSurveyAuditingEntity;
    realSurveyAuditingListApi.pageIndex = curPageNum;
    realSurveyAuditingListApi.pageSize = @"10";
    realSurveyAuditingListApi.sortField = @"";
    realSurveyAuditingListApi.ascending = @"true";
    [_manager sendRequest:realSurveyAuditingListApi];
}

#pragma mark - PrivateMethod

- (NSMutableArray *)getRightSlideButton:(NSArray *)rightSlideArray
                   andPassButton:(UITableViewRowAction *)passButton
                 andRefuseButton:(UITableViewRowAction *)refuseButton
                   andDataButton:(UITableViewRowAction *)dataButton
                 andSubmitButton:(UITableViewRowAction *)submitButton
                 andRecordButton:(UITableViewRowAction *)recordButton
{
    NSMutableArray *newRightSlideArray = [NSMutableArray array];
    
    for (int i = 0; i < rightSlideArray.count; i++)
    {
        NSString *buttonTitle = rightSlideArray[i];
        
        if ([buttonTitle isEqualToString:PassStr])
        {
            [newRightSlideArray addObject:passButton];
        }
        else if ([buttonTitle isEqualToString:RefuseStr])
        {
            [newRightSlideArray addObject:refuseButton];
        }
        else if ([buttonTitle isEqualToString:HouseDataStr])
        {
            [newRightSlideArray addObject:dataButton];
        }
        else if ([buttonTitle isEqualToString:SubmitStr])
        {
            [newRightSlideArray addObject:submitButton];
        }
        else if ([buttonTitle isEqualToString:RecordStr])
        {
            [newRightSlideArray addObject:recordButton];
        }
    }
    
    return newRightSlideArray;
}

- (void)meunImageViewChangeImage:(BOOL)select
{
    if (!select)
    {
        _meunImageView.image = [UIImage imageNamed:@"check_up_icon"];
    }
    else
    {
        _meunImageView.image = [UIImage imageNamed:@"check_down_icon"];
    }
}

/// 获得权限
- (void)getPermission
{
    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_REVIEW])
    {
        // 复审权限
        _realSurveyAuditingEntity.realSurveysPerType = PERTYPE_REVIEWAPPROVED;
    }
    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_AUDIT])
    {
        // 初审权限
        _realSurveyAuditingEntity.realSurveysPerType = PERTYPE_APPROVED;
    }
    else
    {
        // 无审核权限
        _realSurveyAuditingEntity.realSurveysPerType = NONE;
    }
    
    // 审核权限范围
    if([AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_AUDIT_NONET])
    {
        // 无权限
        _realSurveyAuditingEntity.realSurveysAuditType = NONE;
    }
    else if([AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_AUDIT_MYDEPARTMENT])
    {
        // 本部
        _realSurveyAuditingEntity.realSurveysAuditType = MYDEPARTMENT;
    }
    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_REALSURVEY_AUDIT_ALL])
    {
        // 全部
        _realSurveyAuditingEntity.realSurveysAuditType = ALL;
    }

    // 获得"审核"/"查看权限"状态
    _realSurveyAuditingEntity.auditPerScope = [_realSurveyAuditingPresenter getAuditPerScope];
}

- (void)checkPermission:(HaveMenuPermissionBlock)block
{
    
}

/// 删除cell
- (void)deleteCellWithIndexPath:(NSIndexPath *)indexPath
{
    [_realSurveyListArray removeObjectAtIndex:indexPath.row];
    
    [_mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - <RealSurveyFilterDelegate>

- (void)RealSurveyFilterWithRealSurveyAuditingEntity:(RealSurveyAuditingEntity *)Entity
{
    _realSurveyAuditingEntity = Entity;
    [self headerRefreshMethod];
}

#pragma mark - <UITableViewDelegate/UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _realSurveyListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"realSurveyAuditingListCell";
    
    RealSurveyAuditingListCell *realSurveyAuditingListCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!realSurveyAuditingListCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"RealSurveyAuditingListCell"
                                              bundle:nil]
                                forCellReuseIdentifier:CellIdentifier];
        realSurveyAuditingListCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    RealSurveyAuditingListEntity *listEntity = _realSurveyListArray[indexPath.row];
    realSurveyAuditingListCell.realSurveyAuditingListEntity = listEntity;
    
    return realSurveyAuditingListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RealSurveyAuditingListEntity *listEntity = _realSurveyListArray[indexPath.row];
    
    CheckRealSurveyViewController *vc = [[CheckRealSurveyViewController alloc] init];
    vc.auditPerScope = _realSurveyAuditingEntity.auditPerScope;
    vc.keyId = listEntity.keyId;
    vc.realSurveyStatus = listEntity.auditStatus;
    vc.realSurveyPersonDeptKeyId = listEntity.realSurveyPersonDeptKeyId;
    vc.propertyChiefDeptKeyId = listEntity.propertyChiefDeptKeyId;
    vc.listEntity = listEntity;
    vc.realSurveyAuditingEntity = _realSurveyAuditingEntity;
    vc.operDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;// 删除cell
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
     RealSurveyAuditingListEntity *listEntity = _realSurveyListArray[indexPath.row];
    _presentClickPropKeyId = listEntity.keyId;
    _presentClickRealStatus = [NSString stringWithFormat:@"%ld",listEntity.auditStatus];
    _presentClickIndexPath = indexPath;
    
    UITableViewRowAction *pass = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:PassStr
                                                                       handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                           
                                                                        PermisstionsEntity *entity = [AgencyUserPermisstionUtil getAgencyPermisstion];
                                                                        NSString *errorMsg =[_realSurveyAuditingPresenter passRealSurveyAuditPerScope:_realSurveyAuditingEntity
                                                                                                                                        andListEntity:listEntity
                                                                                                                                  andDepartmentKeyIds:entity.departmentKeyIds];
                                                                           if (![NSString isNilOrEmpty:errorMsg])
                                                                           {
                                                                               showMsg(errorMsg);
                                                                           }
                                                                       }];
    pass.backgroundColor = RGBColor(255, 156, 1);
    
    UITableViewRowAction *refuse = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:RefuseStr
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              
                                                                              PermisstionsEntity *entity = [AgencyUserPermisstionUtil getAgencyPermisstion];
                                                                              NSString *errorMsg = [_realSurveyAuditingPresenter refusedRealSurveyAuditPerScope:_realSurveyAuditingEntity
                                                                                                                                              andListEntity:listEntity
                                                                                                                                        andDepartmentKeyIds:entity.departmentKeyIds];
                                                                              if (![NSString isNilOrEmpty:errorMsg])
                                                                              {
                                                                                  showMsg(errorMsg);
                                                                              }
                                                                          }];
    refuse.backgroundColor = RGBColor(255, 58, 49);
    
    UITableViewRowAction *data = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                              title:HouseDataStr
                                                                            handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                                
                                                                                [self goAllRoundDetailWithIndexPath:indexPath andEntity:listEntity];
                                                                                tableView.editing = NO;
                                                                            }];
    
    data.backgroundColor = RGBColor(200, 199, 205);
    
    UITableViewRowAction *record = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                    title:RecordStr
                                                                  handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                      
                                                                      [self goApprovalRecordWithIndexPath:indexPath andEntity:listEntity];
                                                                      tableView.editing = NO;
                                                                  }];
    
    record.backgroundColor = RGBColor(33, 151, 238);
    
    UITableViewRowAction *submit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                      title:SubmitStr
                                                                    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                        
                                                                        [self submitAction];
                                                                        tableView.editing = NO;
                                                                    }];
    submit.backgroundColor = RED_COLOR;
    
    NSMutableArray *array = [NSMutableArray array];
    
    if ([_realSurveyAuditingEntity.auditStatus integerValue] == UNSUBMIT)
    {
        // 未提交
        NSArray *unapprovedArray = [_realSurveyAuditingPresenter getUnsibmitArray:_realSurveyAuditingEntity
                                                                    andListEntity:listEntity];
        
        array = [self getRightSlideButton:unapprovedArray
                            andPassButton:pass
                          andRefuseButton:refuse
                            andDataButton:data
                          andSubmitButton:submit
                          andRecordButton:record];
    }
    else if ([_realSurveyAuditingEntity.auditStatus integerValue] == UNAPPROVED)
    {
        // 未审核
        NSArray *unapprovedArray = [_realSurveyAuditingPresenter getUnapprovedArray:_realSurveyAuditingEntity
                                                                      andListEntity:listEntity];
        
        array = [self getRightSlideButton:unapprovedArray
                            andPassButton:pass
                          andRefuseButton:refuse
                            andDataButton:data
                          andSubmitButton:submit
                          andRecordButton:record];
    }
    else
    {
        // 审核通过/审核拒绝
        array = [@[data,record] mutableCopy];
    }
  
    return (NSArray *)array;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MODEL_VERSION >= 7.0)
    {
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
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

#pragma mark - <CheckRealSurveyOperDelegate>

- (void)refreshData
{
    [self headerRefreshMethod];
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == PassAlertView_Tag)
    {
        if (buttonIndex == 1)
        {
            // 通过---确定
            RealSurveyOperationApi *realSurveyOperationApi = [[RealSurveyOperationApi alloc] init];
            realSurveyOperationApi.auditStatus = [NSString stringWithFormat:@"%d",APPROVED];
            realSurveyOperationApi.keyId = _presentClickPropKeyId;
            [_manager sendRequest:realSurveyOperationApi];
        }
    }
    else if (alertView.tag == RefusedAlertView_Tag)
    {
        if (buttonIndex == 1)
        {
            // 拒绝---确定
            RealSurveyOperationApi *realSurveyOperationApi = [[RealSurveyOperationApi alloc] init];
            realSurveyOperationApi.auditStatus = [NSString stringWithFormat:@"%d",REJECT];
            realSurveyOperationApi.keyId = _presentClickPropKeyId;
            [_manager sendRequest:realSurveyOperationApi];
        }
    }
    if (alertView.tag == SubmitAlertView_Tag)
    {
        if (buttonIndex == 1)
        {
            // 提交---确定
            RealSurveyOperationApi *realSurveyOperationApi = [[RealSurveyOperationApi alloc] init];
            realSurveyOperationApi.auditStatus = [NSString stringWithFormat:@"%d",UNAPPROVED];
            realSurveyOperationApi.keyId = _presentClickPropKeyId;
            [_manager sendRequest:realSurveyOperationApi];
        }
    }
}

#pragma mark - <DropDownMeunDelegate>

- (void)dropDownMeunLabelText:(NSString *)text andIndexPath:(NSIndexPath *)indexPath
{
    _auditStatusLabel.text = text;
    [_meun collectionViewDismiss];
    [self meunImageViewChangeImage:_isSelect];
    _isSelect = !_isSelect;
    
    if ([text isEqualToString:@"待提交"])
    {
        _realSurveyAuditingEntity.auditStatus = [NSString stringWithFormat:@"%d", UNSUBMIT];
    }
    if ([text isEqualToString:@"待审核"])
    {
        _realSurveyAuditingEntity.auditStatus = [NSString stringWithFormat:@"%d", UNAPPROVED];
    }
    else if ([text isEqualToString:@"审核通过"])
    {
        _realSurveyAuditingEntity.auditStatus = [NSString stringWithFormat:@"%d", APPROVED];
    }
    else if ([text isEqualToString:@"审核拒绝"])
    {
        _realSurveyAuditingEntity.auditStatus = [NSString stringWithFormat:@"%d", REJECT];
    }
    
    [self headerRefreshMethod];
}

- (void)chickBackgroud
{
    [self meunImageViewChangeImage:_isSelect];
     _isSelect = NO;
}

#pragma mark - RealSurveyAuditingViewProtocol

/// 通过审核
- (void)passAction
{
    UIAlertView *passAlertView = [[UIAlertView alloc] initWithTitle:@"您确定要进行该实勘操作吗？"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
    passAlertView.tag = PassAlertView_Tag;
    [passAlertView show];
}

/// 拒绝
- (void)refusedAction
{
    if ([_realSurveyAuditingPresenter needRefusedReason])
    {
        // 深圳----需要拒绝理由
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"拒绝理由"
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"拒绝理由";
        }];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 取出textFiled的值
            NSArray *testArr = [alertController textFields];
            UITextField *textField = [testArr lastObject];
            // 拒绝理由
            NSString *textFieldTextStr = textField.text;
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            // 取消
        }];
        
        [alertController addAction:sureAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    else
    {
        // 北京----不需要拒绝理由
        UIAlertView *refuseAlerView = [[UIAlertView alloc] initWithTitle:@"您确定要进行该实勘操作吗？"
                                                                 message:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                       otherButtonTitles:@"确定", nil];
        refuseAlerView.tag = RefusedAlertView_Tag;
        [refuseAlerView show];
    }
}

/// 提交按钮
- (void)submitAction
{
    UIAlertView *passAlertView = [[UIAlertView alloc] initWithTitle:@"您确定要进行该实勘操作吗？"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
    passAlertView.tag = SubmitAlertView_Tag;
    [passAlertView show];
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[RealSurveyReviedListEntity class]])
    {
        RealSurveyReviedListEntity *realSurveyReviedListEntity = [DataConvert convertDic:data toEntity:modelClass];
        if (_realSurveyListArray.count > 0)
        {
            [_realSurveyListArray addObjectsFromArray:realSurveyReviedListEntity.result];
        }
        else
        {
            _realSurveyListArray = [realSurveyReviedListEntity.result mutableCopy];
        }

        if (realSurveyReviedListEntity.result.count < 10 || !realSurveyReviedListEntity.result)
        {
//            _mainTableView.footerHidden = YES;
            _mainTableView.mj_footer.hidden = YES;
        }
        else
        {
//            _mainTableView.footerHidden = NO;
            _mainTableView.mj_footer.hidden = NO;
        }
    }

    if ([modelClass isEqual:[RealSurveyOperationEntity class]])
    {
        RealSurveyOperationEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        
        if (entity.flag)
        {
            [self deleteCellWithIndexPath:_presentClickIndexPath];
        }
    }

    [self hiddenLoadingView];
    [self endRefreshWithTableView:_mainTableView];
    [_mainTableView reloadData];
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    [self endRefreshWithTableView:_mainTableView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
