//
//  TrustAuditingVC.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/19.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "TrustAuditingVC.h"
#import "TrustAuditingCell.h"
#import "TrustFilterVC.h"
#import "PropertyDetailVC.h"
#import "AuditingRecordVC.h"
#import "CheckTrustVC.h"
#import "RegisterTrustsApi.h"

#define SelectStatusBaseTag  100

@interface TrustAuditingVC ()<UITableViewDelegate,UITableViewDataSource,TrustFilterDelegate,RefreshTrustProtocol>
{
    IBOutlet UIView *_headView;// 顶部筛选视图
    UITableView *_tableView;
    
    // 筛选条件
    NSString *_estateName;// 楼盘名称
    NSString *_estateKeyId;// 楼盘keyId
    NSString *_buildingNames;// 栋座名称
    NSString *_buildingKeyId;// 栋座keyId
    NSString *_houseNo;// 房号
    RemindPersonDetailEntity *_employeeEntity;// 签署人
    RemindPersonDetailEntity *_deptEntity;// 签署部门
    NSString *_timeFrom;// 开始时间
    NSString *_timeTo;// 结束时间
    NSInteger _selectTag;// 选择的筛选按钮

    NSInteger _pageIndex;
    NSMutableArray *_dataArr;

    BOOL _isRefresh;// 是否需要刷新数据
    BOOL _isSelectTrustStatus;// 是否切换审核状态

    RegisterTrustsApi *_registerTrustsApi;
}

@end

@implementation TrustAuditingVC

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNav];
    [self initData];
    [self initView];
    [self headerRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isRefresh)
    {
        [self headerRefresh];
        _isRefresh = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_tableView setEditing:NO];
//    _tableView.footerHidden = NO;
    _tableView.mj_footer.hidden = NO;
}

#pragma mark - init 

/// 设置默认筛选条件
- (void)initData
{
    _estateName = @"";
    _estateKeyId = @"";
    _buildingNames = @"";
    _buildingKeyId = @"";
    _houseNo = @"";
    _employeeEntity = nil;
    _deptEntity = nil;
    _timeFrom = nil;
    _timeTo = nil;
    _registerTrustsApi = [[RegisterTrustsApi alloc] init];
    _dataArr = [NSMutableArray array];
    _pageIndex = 1;
}

- (void)initNav
{
    [self setNavTitle:@"委托审核"
    leftButtonItem:[self customBarItemButton:nil
                             backgroundImage:nil
                                  foreground:@"backBtnImg"
                                         sel:@selector(back)]
   rightButtonItem:[self customBarItemButton:@"筛选"
                             backgroundImage:nil
                                  foreground:nil
                                         sel:@selector(filterMethod)]];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - APP_NAV_HEIGHT)
                                              style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
//    [_tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
//    [_tableView addFooterWithTarget:self action:@selector(footerRefresh)];

    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];

    
    [self.view addSubview:_tableView];
    
    for (int i = 0;  i < 3; i ++) {
        UIButton *btn = [_headView viewWithTag:SelectStatusBaseTag + i];
        btn.layer.cornerRadius = 12.5;
        btn.layer.masksToBounds = YES;
        if (i == 0) {
            btn.backgroundColor = RGBColor(249, 45, 11);
            _selectTag = SelectStatusBaseTag + i;
        }
    }
}

#pragma mark - ClickEvents

- (void)back
{
    [_tableView setEditing:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

/// 获取审核权限
- (int)getRegisterTrustsPermission
{
    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_REGISTERTRUSTS_AUDIT_MYDEPARTMENT] )
    {
        // 本部
        return MYDEPARTMENT;
    }
    else if ([AgencyUserPermisstionUtil hasRight:PROPERTY_REGISTERTRUSTS_AUDIT_ALL])
    {
        // 全部
        return ALL;
    }
    // 无
    return NONE;
}

/// 筛选
- (void)filterMethod
{
    [CommonMethod addLogEventWithEventId:@"A power of a_screen_Function" andEventDesc:@"委托审核筛选点击量"];

    TrustFilterVC *vc = [[TrustFilterVC alloc] init];
    vc.trustFilterDelegate = self;
    vc.estateName = _estateName;
    vc.estateKeyId = _estateKeyId;
    vc.buildingName = _buildingNames;
    vc.buildingKeyId = _buildingKeyId;
    vc.searchPropertyNum = _houseNo;
    vc.departEntity = _deptEntity;
    vc.employeeEntity = _employeeEntity;
    vc.startTime = _timeFrom;
    vc.endTime = _timeTo;

    [self.navigationController pushViewController:vc animated:YES];
}

/// 选择委托审核状态
- (IBAction)selectTrustAuditingClick:(UIButton *)sender
{
    NSInteger tagNum = sender.tag;
    
    UIColor *noSelectColor = RGBColor(213, 213, 213);
    UIColor *selectColor = RGBColor(249, 45, 11);
    
    if (tagNum != _selectTag)
    {
        UIButton *lastBtn = [_headView viewWithTag:_selectTag];
        UIButton *currentBtn = [_headView viewWithTag:tagNum];
        lastBtn.backgroundColor = noSelectColor;
        currentBtn.backgroundColor = selectColor;
        _selectTag = tagNum;
        
        // 请求加载数据
        _isSelectTrustStatus = YES;
        
        [self headerRefresh];
    }
}

#pragma mark - RequestData

- (void)headerRefresh
{
    [_dataArr removeAllObjects];
//    _tableView.footerHidden = NO;
    _tableView.mj_footer.hidden = NO;
    _pageIndex = 1;

    _registerTrustsApi.estateNames = _estateName;// 输入的楼盘名称条件,多楼盘用"+"分隔
    _registerTrustsApi.estateKeyId = _estateKeyId;// 楼盘KeyId
    _registerTrustsApi.buildingNames = _buildingNames;// 选择的栋座单元名称条件,多栋座单元用","分隔
    _registerTrustsApi.buildingKeyId = _buildingKeyId;// 栋座单元KeyId
    _registerTrustsApi.houseNo = _houseNo;// 房号
    _registerTrustsApi.createTimeFrom = (_timeFrom == nil)?@"":_timeFrom;// 签署时间时间起始值
    _registerTrustsApi.createTimeTo = (_timeTo == nil)?@"":_timeTo;// 签署时间截止值
    _registerTrustsApi.regTrustsAuditStatus = (int)(_selectTag - SelectStatusBaseTag);// 业主审核状态类型
    _registerTrustsApi.creatorPersonKeyId = _employeeEntity.resultKeyId;// 签署人
    _registerTrustsApi.creatorPersonDeptKeyId = _deptEntity.departmentKeyId;// 签署人部门
    _registerTrustsApi.auditPerScope = [self getRegisterTrustsPermission];// 审核权限范围
    _registerTrustsApi.pageIndex = [NSString stringWithFormat:@"%ld",_pageIndex];// 当前页码
    _registerTrustsApi.pageSize= @"10";// 页容量
    _registerTrustsApi.sortField = @"";// 排序字段名称
    _registerTrustsApi.ascending = @"true";// 排序方向
    [_manager sendRequest:_registerTrustsApi];

    [self showLoadingView:nil];
}

- (void)footerRefresh
{
    _pageIndex += 1;

    _registerTrustsApi.estateNames = _estateName;// 输入的楼盘名称条件,多楼盘用"+"分隔
    _registerTrustsApi.estateKeyId = _estateKeyId;//楼盘KeyId
    _registerTrustsApi.buildingNames = _buildingNames;// 选择的栋座单元名称条件,多栋座单元用","分隔
    _registerTrustsApi.buildingKeyId = _buildingKeyId;// 栋座单元KeyId
    _registerTrustsApi.houseNo = _houseNo;// 房号
    _registerTrustsApi.createTimeFrom = (_timeFrom == nil)?@"":_timeFrom;// 签署时间时间起始值
    _registerTrustsApi.createTimeTo = (_timeTo == nil)?@"":_timeTo;// 签署时间截止值
    _registerTrustsApi.regTrustsAuditStatus = (int)(_selectTag - SelectStatusBaseTag);// 业主审核状态类型
    _registerTrustsApi.creatorPersonKeyId = _employeeEntity.resultKeyId;// 签署人
    _registerTrustsApi.creatorPersonDeptKeyId = _deptEntity.departmentKeyId;// 签署人部门
    _registerTrustsApi.auditPerScope = [self getRegisterTrustsPermission];// 审核权限范围
    _registerTrustsApi.pageIndex = [NSString stringWithFormat:@"%ld",_pageIndex];// 当前页码
    _registerTrustsApi.pageSize = @"10";// 页容量
    _registerTrustsApi.sortField = @"";// 排序字段名称
    _registerTrustsApi.ascending = @"true";// 排序方向
    [_manager sendRequest:_registerTrustsApi];

    [self showLoadingView:nil];
}

#pragma mark - <TrustFilterDelegate>

- (void)trustFilterWithEstateName:(NSString *)estateName
                   andEstateKeyId:(NSString *)estateKeyId
                 andBuildingNames:(NSString *)buildingNames
                 andBuildingKeyId:(NSString *)buildingKeyId
                       andHouseNo:(NSString *)houseNo
                andEmployeeEntity:(RemindPersonDetailEntity *)employeeEntity
                    andDeptEntity:(RemindPersonDetailEntity *)deptEntity
                      andTimeFrom:(NSString *)timeFrom
                        andTimeTo:(NSString *)timeTo
{
    _estateName = estateName;
    _estateKeyId = estateKeyId;
    _buildingNames = buildingNames;
    _buildingKeyId = buildingKeyId;
    _houseNo = houseNo;
    _employeeEntity = employeeEntity;
    _deptEntity = deptEntity;
    _timeFrom = timeFrom;
    _timeTo = timeTo;
    
    [self headerRefresh];
}

#pragma mark - <UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _headView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 50);
    return _headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 10)];
    return footView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"TrustAuditingCell";
    TrustAuditingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (_dataArr.count > 0)
    {
        cell.entity = _dataArr[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView setEditing:NO];

    CheckTrustVC *vc = [[CheckTrustVC alloc] init];
    if (_selectTag == SelectStatusBaseTag)
    {
        // 待审核－进入查看委托（带通过和拒绝）
        vc.pushType = UNAUDITING;
        vc.refreshDelegate = self;
    }
    else
    {
        // 审核通过或拒绝－进入查看委托，不带通过和拒绝按钮
        vc.pushType = HAVEAUDITING;
    }

    if (_dataArr.count > 0)
    {
        SubRegisterTrustsEntity *entity = _dataArr[indexPath.row];
        vc.propertyKeyId = entity.propertyKeyId;
        vc.trustkeyId = entity.keyId;
        vc.creatorPersonName = entity.creatorPersonName;
        vc.signDate = [entity.signDate substringToIndex:10];
        vc.signType = [self getTypeWithTrustRecordsTypeEnum:[entity.propertyTrustType integerValue]];

        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubRegisterTrustsEntity *entity = _dataArr[indexPath.row];

    UITableViewRowAction *propertyDetailAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"房源详情"
                                                                       handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                           // 房源详情
                                                                           PropertyDetailVC *vc = [[PropertyDetailVC alloc] init];
                                                                           vc.propKeyId = entity.propertyKeyId;
                                                                           vc.propEstateName = entity.estateName;
                                                                           vc.propBuildingName = entity.buildingName;
                                                                           vc.propHouseNo = entity.houseName;

                                                                           [self.navigationController pushViewController:vc animated:YES];

                                                                       }];
    propertyDetailAction.backgroundColor = RGBColor(176, 175, 182);

    UITableViewRowAction *auditingListAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                              title:@"审核记录"
                                                                            handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                                // 审核记录
                                                                                AuditingRecordVC *vc = [[AuditingRecordVC alloc] init];
                                                                                vc.regTrustsAuditStatus = [entity.regTrustsAuditStatus intValue];
                                                                                vc.trustAuditPersonName = entity.trustAuditPersonName;
                                                                                vc.trustAuditDate = entity.trustAuditDate;

                                                                                [self.navigationController pushViewController:vc animated:YES];

                                                                            }];
    auditingListAction.backgroundColor = RGBColor(15, 110, 236);

    if (_selectTag == SelectStatusBaseTag)
    {
        // 待审核
        return @[propertyDetailAction];

    }

    // 审核通过或拒绝
    return @[auditingListAction,propertyDetailAction];
}

- (NSString *)getTypeWithTrustRecordsTypeEnum:(NSInteger)trustRecordsTypeEnum
{
    if (trustRecordsTypeEnum == SALE)
    {
        return @"售房委托";
    }
    else if (trustRecordsTypeEnum == RENT)
    {
        return @"租房委托";
    }
    else if (trustRecordsTypeEnum == BOTH)
    {
        return @"租售委托";
    }

    return nil;
}

#pragma mark - <RefreshTrustProtocol>

- (void)isRefreshData:(BOOL)isRefresh
{
    _isRefresh = isRefresh;
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[RegisterTrustsEntity class]])
    {
//        [_tableView headerEndRefreshing];
//        [_tableView footerEndRefreshing];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        RegisterTrustsEntity *entity = [DataConvert convertDic:data toEntity:modelClass];

        if (entity.propertyRegisterTrusts.count > 0)
        {
            [_dataArr addObjectsFromArray:entity.propertyRegisterTrusts];
        }
        else
        {
            // 没有更多数据
//            _tableView.footerHidden = YES;
            _tableView.mj_footer.hidden = YES;
        }

        [_tableView reloadData];

        if (_isSelectTrustStatus && _dataArr.count > 0)
        {
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
        }
        _isSelectTrustStatus = NO;
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    
//    [_tableView headerEndRefreshing];
//    [_tableView footerEndRefreshing];

    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    
}

@end
