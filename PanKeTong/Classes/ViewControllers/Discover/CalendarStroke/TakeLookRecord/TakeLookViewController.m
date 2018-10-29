//
//  TakeLookViewController.m
//  PanKeTong
//
//  Created by 张旺 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "TakeLookViewController.h"
#import "NewTakeLookRecordViewController.h"
#import "TakeLookScreeningViewController.h"
#import "SeeEstatePhotoViewController.h"


#import "TakeSeeApi.h"
#import "TakingSeeEntity.h"
#import "SubTakingSeeEntity.h"
#import "TakeLookScreeningVO.h"
#import "WJTaskSeeModel.h"

#import "JMTakeLookPropertyDetailCell.h"
#import "TakeLookRecordCell.h"

#import "UITableView+Category.h"
#import "NSDate+Format.h"

#import <objc/runtime.h>


char* const runtimeKey = "Key";

@interface TakeLookViewController ()<UITableViewDelegate,UITableViewDataSource,AddTakeSeeDelegate>
{
    __weak IBOutlet UIView *_firstUseView;          // 初次使用的view
    
    __weak IBOutlet UITableView *_mainTableView;
    
    TakeSeeApi * _getTakeSeeApi;
    //    TakingSeeEntity * _takingSeeEntity;
    NSMutableArray * _dataSource;                   // 数据实体
    
    
    TakeSeeApi * _takeSeeScreening;                 // 筛选实体

    BOOL _isFilterSearch;   // 筛选查询
    BOOL _hasClicked;                               // 是否已经点击
    NSMutableArray *openArr;
    
}

@property (weak, nonatomic) IBOutlet UIButton *addTakeLookBtn;


@end

@implementation TakeLookViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    [self initData];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    _hasClicked = NO;
}

- (void)back
{
    if (self.isPopToRoot)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - init

- (void)initView
{
    _mainTableView.separatorColor = YCOtherColorDivider;
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    
    _firstUseView.hidden = YES;
    [self setNavTitle:@"带看记录"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    if ([AgencyUserPermisstionUtil hasMenuPermisstion:CUSTOMER_TAKE]) {
        
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
        
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];
        
    }
    
    UIButton *addNewBtn = [self customBarItemButton:@"新增" backgroundImage:nil foreground:nil sel:@selector(addMoreMethod:)];
    
    UIButton *screenningButton = [self customBarItemButton:@"筛选" backgroundImage:nil foreground:nil sel:@selector(filtFollowMethod:)];
    
    UIBarButtonItem *addNewBarItem = [[UIBarButtonItem alloc]initWithCustomView:addNewBtn];
    UIBarButtonItem *filtPropBarItem = [[UIBarButtonItem alloc]initWithCustomView:screenningButton];
    
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    
    //陈行修改185bug
    if ([AgencyUserPermisstionUtil hasMenuPermisstion:MENU_CUSTOMER_ALL_CUSTOMER]) {
        
        self.navigationItem.rightBarButtonItems = @[addNewBarItem, filtPropBarItem];
        
        [dataArray addObject:addNewBarItem];
        
    }
    
    if ([AgencyUserPermisstionUtil hasMenuPermisstion:CUSTOMER_TAKE]) {
        
        [dataArray addObject:filtPropBarItem];
        
    }
    
    self.navigationItem.rightBarButtonItems = dataArray;
    
    [self.addTakeLookBtn setLayerCornerRadius:YCLayerCornerRadius];
}

-(void)initData
{
    _dataSource = [[NSMutableArray alloc] init];
    _getTakeSeeApi = [[TakeSeeApi alloc] init];
    _takeSeeScreening = [TakeSeeApi new];
    openArr = [NSMutableArray array];
    
    [self headerRefreshMethod];
}



- (void)headerRefreshMethod
{
    if (![AgencyUserPermisstionUtil hasMenuPermisstion:CUSTOMER_TAKE]) {
        
        return;
        
    }
    [_dataSource removeAllObjects];
    [_mainTableView reloadData];
    [self requestData];
    [self showLoadingView:nil];
}

- (void)footerRefreshMethod
{
    if (![AgencyUserPermisstionUtil hasMenuPermisstion:CUSTOMER_TAKE]) {
        
        return;
        
    }
    [self requestData];
}

-(void)requestData
{
    if ([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_MYSELF] )
    {
        // 本人
        _getTakeSeeApi.scopeType = MYSELF;
        
    }
    else if ([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_MYDEPARTMENT])
    {
        // 本部
        _getTakeSeeApi.scopeType = MYDEPARTMENT;
        
    }
    else if ([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_ALL])
    {
        // 全部
        _getTakeSeeApi.scopeType = ALL;
    }
    
    NSString *seePropertyType = @"";    // SeePropertyType - 看房类型（全部=null、看租=10、看售=20、看租售=30）
    if ([_takeSeeScreening.seePropertyType isEqualToString:@"看租"])
    {
        seePropertyType = @"10";
    }
    else if ([_takeSeeScreening.seePropertyType isEqualToString:@"看售"])
    {
        seePropertyType = @"20";
    }
    else if ([_takeSeeScreening.seePropertyType isEqualToString:@"看租售"])
    {
        seePropertyType = @"30";
    }
    else
    {
        seePropertyType = @"";
    }
    
    _getTakeSeeApi.departmentName = _takeSeeScreening.departmentName?_takeSeeScreening.departmentName:@"";
    _getTakeSeeApi.employeeName = _takeSeeScreening.employeeName?_takeSeeScreening.employeeName:@"";
    _getTakeSeeApi.dateTimeStart = _takeSeeScreening.dateTimeStart?_takeSeeScreening.dateTimeStart:[NSDate stringWithSimpleDate:[NSDate dateWithTimeInterval:-24*60*60*30 sinceDate:[NSDate date]]];
    _getTakeSeeApi.dateTimeEnd = _takeSeeScreening.dateTimeEnd?_takeSeeScreening.dateTimeEnd:[CommonMethod formatDateStrFromDate:[NSDate date]];
    _getTakeSeeApi.seePropertyType = seePropertyType;
    _getTakeSeeApi.pageIndex = [NSString stringWithFormat:@"%@",@(_dataSource.count/10+1)];
    _getTakeSeeApi.pageSize = @"10";
    _getTakeSeeApi.sortField = @"";
    _getTakeSeeApi.ascending = @"true";
    _getTakeSeeApi.inquiryFollowSearchType = @(0);
    [_manager sendRequest:_getTakeSeeApi];
}

#pragma mark - 导航栏新增方法

-(void)addMoreMethod:(UIButton *)addBtn
{
    [CommonMethod addLogEventWithEventId:@"Look r_added_Click" andEventDesc:@"带看记录-新增点击量"];
    
    if (_hasClicked)
    {
        return;
    }
    _hasClicked = YES;
    NewTakeLookRecordViewController *newGoOutRecordVC = [[NewTakeLookRecordViewController alloc]
                                                         initWithNibName:@"NewTakeLookRecordViewController"
                                                         bundle:nil];
    newGoOutRecordVC.delegate = self;
    [self.navigationController pushViewController:newGoOutRecordVC animated:YES];
    
}

#pragma mark - 新增带看事件

- (IBAction)addTakeLookClick:(id)sender
{
    [CommonMethod addLogEventWithEventId:@"Look r_added_Click" andEventDesc:@"带看记录-新增点击量"];
    
    if (_hasClicked)
    {
        return;
    }
    _hasClicked = YES;
    NewTakeLookRecordViewController *newGoOutRecordVC = [[NewTakeLookRecordViewController alloc]
                                                         initWithNibName:@"NewTakeLookRecordViewController"
                                                         bundle:nil];
    newGoOutRecordVC.delegate = self;
    [self.navigationController pushViewController:newGoOutRecordVC animated:YES];
}

#pragma mark - 新增成功后返回代理方法，刷新列表

-(void)addTakeSeeSuccess
{
    [CommonMethod addLogEventWithEventId:@"New look_success_Click" andEventDesc:@"新增带看-成功新增带看数量"];
    [CommonMethod addLogEventWithEventId:@"New look_success_Function" andEventDesc:@"新增带看-成功新增带看数量"];
    [self headerRefreshMethod];
}

#pragma mark - 导航栏筛选方法

-(void)filtFollowMethod:(UIButton *)btn
{
    [CommonMethod addLogEventWithEventId:@"Look r_screen_Click" andEventDesc:@"带看记录-筛选点击量"];
    if (_hasClicked)
    {
        return;
    }
    _hasClicked = YES;
    _isFilterSearch = YES;
    
    TakeLookScreeningVO *takeLookVO = [[TakeLookScreeningVO alloc] init];
    takeLookVO.dateTimeStart = _takeSeeScreening.dateTimeStart;
    takeLookVO.dateTimeEnd = _takeSeeScreening.dateTimeEnd;
    takeLookVO.employeeName = _takeSeeScreening.employeeName;
    takeLookVO.departmentKeyId = _takeSeeScreening.departmentKeyId;
    takeLookVO.departmentName = _takeSeeScreening.departmentName;
    takeLookVO.seePropertyType = _takeSeeScreening.seePropertyType;
    
    WS(weakSelf);
    TakeLookScreeningViewController * takeLookScreeningVC = [[TakeLookScreeningViewController alloc] init];
    takeLookScreeningVC.takeLookVO = takeLookVO;
    takeLookScreeningVC.block = ^(TakeLookScreeningVO * takeSee){
        // 筛选点击确定进行筛选
        _takeSeeScreening.dateTimeEnd = takeSee.dateTimeEnd;
        _takeSeeScreening.dateTimeStart = takeSee.dateTimeStart;
        _takeSeeScreening.employeeName = takeSee.employeeName;
        _takeSeeScreening.departmentKeyId = takeSee.departmentKeyId;
        _takeSeeScreening.departmentName = takeSee.departmentName;
        _takeSeeScreening.seePropertyType = takeSee.seePropertyType;
        
        [_dataSource removeAllObjects];
        [weakSelf showLoadingView:nil];
        [_mainTableView reloadData];
        [weakSelf requestData];
    };
    
    [self.navigationController pushViewController:takeLookScreeningVC animated:YES];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    WJTaskSeeModel *group = _dataSource[section];
    
    if ([openArr[section] isEqualToString:@"1"]) {
        
        return group.PropertyList.count + 1;
        
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        static NSString * identifier = @"TakeLookRecordCell";
        
        TakeLookRecordCell *cell = [tableView tableViewCellByNibWithIdentifier:identifier];
        
        cell.arrowBtn.selected = ![openArr[indexPath.section] isEqualToString:@"0"];
        
        [cell.seeLinkBtn addTarget:self action:@selector(seeImgLinkClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.arrowBtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell setTakeLookRecordListDetailWithListEntity:_dataSource andIndexPath:indexPath andIsHiddenNextStep:NO];
        
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        return cell;
        
    } else {
        
        static NSString * identifier = @"JMTakeLookPropertyDetailCell";
        
        JMTakeLookPropertyDetailCell * cell = [tableView tableViewCellByNibWithIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WJTaskSeeModel *group = _dataSource[indexPath.section];
        
        cell.property = group.PropertyList[indexPath.row - 1];
        
        cell.separatorInset = UIEdgeInsetsMake(0, APP_SCREEN_WIDTH, 0, 0);
        
        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return 160;
        
    }else {
        WJTaskSeeModel *group = _dataSource[indexPath.section];
        
        PropertyList *model = group.PropertyList[indexPath.row - 1];
        
        CGFloat height = [model.Content getStringHeight:[UIFont systemFontOfSize:14 weight:UIFontWeightLight] width:(APP_SCREEN_WIDTH - 96) size:14] + (50 - 17);
        
        return group.PropertyList.count == indexPath.row ? (height + 12) : height;
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    
}

#pragma mark - 自定义方法
/**
 * header Button点击事件（分区展开闭合）
 */
- (void)buttonPress:(UIButton *)sender{
    
    UITableViewCell * cell = (UITableViewCell *) sender.superview.superview;
    
    NSIndexPath * indexPath = [_mainTableView indexPathForCell:cell];
    
    openArr[indexPath.section] = [openArr[indexPath.section] isEqualToString:@"1"] ? @"0" : @"1";
    
    [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
}

/**
 *  查看上传看房单
 */
-(void)seeImgLinkClick:(UIButton *)button
{
    
    UITableViewCell * cell = (UITableViewCell *)button.superview.superview;
    
    NSIndexPath * indexPath = [_mainTableView indexPathForCell:cell];
    
    WJTaskSeeModel *subTakeSeeEntity = [_dataSource objectAtIndex:indexPath.section];
    NSString *imgUrl =  subTakeSeeEntity.attachmentPath;
    
    if (imgUrl.length < 1)
    {
        return;
    }
    SeeEstatePhotoViewController *seePhotoImageVC = [[SeeEstatePhotoViewController alloc]init];
    
    // 附近路径地址
    NSString * pathUrl = @"";
    NSRange range = [[[BaseApiDomainUtil getApiDomain] getImageServerUrl] rangeOfString:@"/image"];
    pathUrl = [[[BaseApiDomainUtil getApiDomain] getImageServerUrl] substringToIndex:range.location];
    NSString *lookUrl = [NSString stringWithFormat:@"%@%@",pathUrl,imgUrl];
    seePhotoImageVC.seeImageUrl = lookUrl;// @"http://10.7.19.23:8080//images/20170213/011853_f24bad96-03c7-42e7-9ed2-3a13e4b4f701.png";
    [self.navigationController pushViewController:seePhotoImageVC animated:YES];
}

- (void)subViewIsHidden:(BOOL)isHidden {
    UILabel *label = [self.view viewWithTag:101];
    UIImageView *imgView = [self.view viewWithTag:102];
    UIButton *btn = [self.view viewWithTag:103];
    
    label.hidden = isHidden;
    
    if (!_isFilterSearch)
    {
        // 默认带看记录没有结果
        label.text = @"一个月内还没有带看记录，快去新增一条吧～";
        imgView.hidden = NO;
        btn.hidden = isHidden;
    }
    else
    {
        // 筛选时没有结果
        label.text = @"当前搜索条件下没有结果，换个试试～";
        imgView.hidden = YES;
        btn.hidden = !isHidden;
    }
    _mainTableView.hidden = !isHidden;
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass {
    
    [self endRefreshWithTableView:_mainTableView];
    
    NSDictionary *dic = (NSDictionary *)data;
    NSInteger count = [[dic objectForKey:@"RecordCount"] integerValue];
    
    for (NSDictionary *miniDic in dic[@"TakeSees"]) {
        WJTaskSeeModel * model = [[WJTaskSeeModel alloc] initDic:miniDic];
        [_dataSource addObject:model];
        
    }
    
    for (int i = 0; i<_dataSource.count; i++) {
        [openArr addObject:@"0"];
    }
    
    if (count > 0 && _takeSeeScreening) {
        
        [CommonMethod addLogEventWithEventId:@"Look record_screen success_Function" andEventDesc:@"带看记录筛选条件-筛选成功数量"];
        [CommonMethod addLogEventWithEventId:@"Look r_screen success_Click" andEventDesc:@"带看记录筛选条件-筛选成功数量"];
        
    }
    
    _firstUseView.hidden = count > 0;
    
    [self subViewIsHidden:count > 0];
    
    _mainTableView.mj_footer.hidden = count == _dataSource.count;
    
    [_mainTableView reloadData];
    
}

-(void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    [self hiddenLoadingView];
}

@end
