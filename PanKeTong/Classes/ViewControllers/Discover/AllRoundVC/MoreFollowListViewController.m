
//
//  MoreFollowListViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/4.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MoreFollowListViewController.h"
#import "ApplyTransferPubEstViewController.h"
#import "AppendMessageViewController.h"
#import "AddContactsViewController.h"
#import "NewOpeningViewController.h"
#import "AppendInfoViewController.h"
#import "MoreFollowListCell.h"
#import "CustomActionSheet.h"
#import "FollowRecordEntity.h"

#import "GetFollowRecordApi.h"
#import "PropFollowOprateApi.h"
#import "FollowMarkTopApi.h"
#import "FollowMarkTopCancelApi.h"

#import "PropertyStatusCategoryEnum.h"

#import "JMMoreFollowListCell.h"

#import "UITableView+Category.h"

#define     TagActionSheet          201

typedef NS_ENUM(NSInteger, CityPermissionType)
{
    CityPermissionTypeShenzheng = 0,
    CityPermissionTypeOther
};

@interface MoreFollowListViewController ()<UITableViewDataSource,UITableViewDelegate,
ApplyTransferEstDelegate,UIPickerViewDataSource,UIPickerViewDelegate,doneSelect,NewOpeningDelegate>
{
    __weak IBOutlet UITableView *_mainTableView;
    UIPickerView *_selectItemPickerView;
    //    UIButton *filtPropBtn;
    
    GetFollowRecordApi *_getFollowRecordApi;        // 请求跟进列表
    PropFollowOprateApi *_propFollowOprateApi;      // 确认或删除跟进
    SelectItemDtoEntity *_selectFiltItem;       //当前选择的筛选项
    
    NSMutableArray *_followListArray;               // 跟进列表
    NSMutableArray *_filterItemArray;           //跟进列表筛选项
    NSMutableArray *_itemMenuLabels;
    NSInteger _selectResultIndex;               // 当前选择的筛选项索引
    NSInteger followClickIndex;                 // 点击的跟进索引
    NSString *_trustType;                       // 当前交易类型
    NSString *_menu1;
    NSString *_menu2;
}



@end

@implementation MoreFollowListViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
    [self initData];
    
    //默认筛选全部类型的跟进列表
    _selectResultIndex = 0;
    
    _getFollowRecordApi = [[GetFollowRecordApi alloc] init];
    _propFollowOprateApi = [[PropFollowOprateApi alloc] init];
    
    
    
    _mainTableView.separatorStyle = NO; // 隐藏cell分割线
    _mainTableView.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - init

- (void)initView
{
    [self setNavTitle:@"更多跟进"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    UIButton *addNewBtn = [self customBarItemButton:@"新增"
                                    backgroundImage:nil
                                         foreground:nil
                                                sel:@selector(addMoreMethod:)];
    
    //    filtPropBtn = [self customBarItemButton:@"筛选"
    //                                      backgroundImage:nil
    //                                           foreground:nil
    //                                                  sel:@selector(filtFollowMethod:)];
    //    filtPropBtn.selected = NO;
    
    UIBarButtonItem *rightNegativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
    rightNegativeSpacer.width = -10;
    
    UIBarButtonItem *addNewBarItem = [[UIBarButtonItem alloc]initWithCustomView:addNewBtn];
    //    UIBarButtonItem *filtPropBarItem = [[UIBarButtonItem alloc]initWithCustomView:filtPropBtn];
    
    self.navigationItem.rightBarButtonItems = @[rightNegativeSpacer, addNewBarItem];
    
    //    [_mainTableView addHeaderWithTarget:self
    //                                 action:@selector(headerRefreshMethod)];
    //    [_mainTableView addFooterWithTarget:self
    //                                 action:@selector(footerRefreshMethod)];
    
    _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshMethod)];
    
    _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshMethod)];
    
}

- (void)initData
{
    _menu1 = @"经理确认";
    _menu2 = @"删除";
    NSNumber * num = _propModelEntity.trustType ? _propModelEntity.trustType : _propTrustType;
    _trustType = [NSString stringWithFormat:@"%@", num];
    
    // 跟进数据源
    if (!_followListArray)
    {
        _followListArray = [[NSMutableArray alloc] init];
    }
    
    // 筛选条件（自动添加“全部”筛选项）
    if (!_filterItemArray)
    {
        _filterItemArray = [[NSMutableArray alloc] init];
        
        SysParamItemEntity *estStatuSysParamItemEntity = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_PROP_FOLLOW_TYPE];
        SelectItemDtoEntity *filtDefaultItem = [[SelectItemDtoEntity alloc] init];
        filtDefaultItem.itemValue = [NSString stringWithFormat:@""];
        filtDefaultItem.itemText = [NSString stringWithFormat:@"全部"];
        
        [_filterItemArray addObject:filtDefaultItem];
        [_filterItemArray addObjectsFromArray:estStatuSysParamItemEntity.itemList];
    }
    
    //    [_mainTableView headerBeginRefreshing];
    [_mainTableView.mj_header beginRefreshing];
}

#pragma mark - ClickEvents

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
    //返回房源详情师刷新跟进列表
    [self.freshFollowListDelegate freshFollowListMethod];
}

/// 筛选跟进
- (void)filtFollowMethod:(UIButton *)btn
{
    if (btn.selected == YES)
    {
        return;
    }
    
    btn.selected = !btn.selected;
    [self createPickerMethod];
}

//  新增
- (void)addMoreMethod:(UIButton *)addBtn {
    
    // 信息补全 或 洗盘
    AppendInfoViewController *appendMsgVC = [[AppendInfoViewController alloc]initWithNibName:@"AppendInfoViewController"
                                                                                      bundle:nil];
    
    appendMsgVC.appendMessageType = PropertyFollowTypeInfoAdd;
    appendMsgVC.propertyKeyId = _propKeyId;
    appendMsgVC.delegate = self;
    [self.navigationController pushViewController:appendMsgVC
                                         animated:YES];
    
}

#pragma mark - CustomMethod

// 是否可以删除跟进
- (BOOL)canDeleteFollowByFollow:(PropFollowRecordDetailEntity *)propFollowRecordDetailEntity
{
    // 没有删除权限
    if([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_DELETE_NONE])
    {
        return NO;
    }
    // 可以删除全部
    if([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_DELETE_ALL])
    {
        return YES;
    }
    
    //天津：房源归属人／房源归属部门
    //深圳：跟进归属人／跟进归属部门
    
    // 归属人keyId
    NSString *userKeyId = propFollowRecordDetailEntity.followerKeyId;
    // 我的keyid
    NSString *myKeyId = [AgencyUserPermisstionUtil getIdentify].uId;
    
    if([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_DELETE_MYSELF])
    {
        BOOL isEqual = [myKeyId isEqualToString:userKeyId];
        return isEqual;
    }
    
    if([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_DELETE_MYDEPARTMENT])
    {
        // 我的可视部门范围
        NSString *departmentKeyIds = [AgencyUserPermisstionUtil getAgencyPermisstion].departmentKeyIds;
        // 归属部门keyId
        NSString *departmentKeyId = propFollowRecordDetailEntity.departmentKeyId;
        
        BOOL isContainsDepartment = [AgencyUserPermisstionUtil Content:departmentKeyIds ContainsWith:departmentKeyId];
        return isContainsDepartment;
    }
    
    return NO;
}

// 是否可以进行经理确认
- (BOOL)canConfirmFollowByFollow:(PropFollowRecordDetailEntity *)propFollowRecordDetailEntity
{
    // 没有确定权限
    if([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_CONFIRM_NONE])
    {
        return NO;
    }
    // 可以确定全部
    if([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_CONFIRM_ALL])
    {
        return YES;
    }
    
    // 天津：房源归属人／房源归属部门
    // 深圳：跟进归属人／跟进归属部门
    // 归属人keyId
    NSString *userKeyId = propFollowRecordDetailEntity.followerKeyId;
    // 我的keyid
    NSString *myKeyId = [AgencyUserPermisstionUtil getIdentify].uId;
    
    if([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_CONFIRM_MYSELF])
    {
        BOOL isEqual = [myKeyId isEqualToString:userKeyId];
        return isEqual;
    }
    
    if([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_CONFIRM_MYDEPARTMENT])
    {
        // 我的可视部门范围
        NSString *departmentKeyIds = [AgencyUserPermisstionUtil getAgencyPermisstion].departmentKeyIds;
        // 归属部门keyId
        NSString *departmentKeyId = propFollowRecordDetailEntity.departmentKeyId;
        
        BOOL isContainsDepartment = [AgencyUserPermisstionUtil Content:departmentKeyIds
                                                          ContainsWith:departmentKeyId];
        return isContainsDepartment;
    }
    
    return NO;
}

/// 是否可以跟进置顶 (暂时只有南京有此功能)
- (BOOL)canMarkTopFollowByFollow:(PropFollowRecordDetailEntity *)propFollowRecordDetailEntity
{
    // 无"跟进置顶"权限
    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_TOP_NONE])
    {
        return NO;
    }
    
    // 可以"置顶"全部
    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_TOP_ALL])
    {
        return YES;
    }
    
    // "置顶"本人
    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_TOP_MYSELF])
    {
        // 归属人keyId
        NSString *userKeyId = propFollowRecordDetailEntity.followerKeyId;
        // 我的keyid
        NSString *myKeyId = [AgencyUserPermisstionUtil getIdentify].uId;
        
        BOOL isEqual = [myKeyId isEqualToString:userKeyId];
        return isEqual;
    }
    
    // "置顶"本部门
    if ([AgencyUserPermisstionUtil hasRight:PROPERTY_FOLLOW_TOP_MYDEPARTMENT])
    {
        // 我的可视部门范围
        NSString *departmentKeyIds = [AgencyUserPermisstionUtil getAgencyPermisstion].departmentKeyIds;
        // 归属部门keyId
        NSString *departmentKeyId = propFollowRecordDetailEntity.departmentKeyId;
        
        BOOL isContainsDepartment = [AgencyUserPermisstionUtil Content:departmentKeyIds
                                                          ContainsWith:departmentKeyId];
        return isContainsDepartment;
    }
    
    return NO;
}

- (void)createPickerMethod
{
    _selectItemPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, APP_SCREEN_WIDTH, 180)];
    _selectItemPickerView.dataSource = self;
    _selectItemPickerView.delegate = self;
    [_selectItemPickerView selectRow:_selectResultIndex
                         inComponent:0
                            animated:YES];
    
    CustomActionSheet *sheet = [[CustomActionSheet alloc] initWithView:_selectItemPickerView
                                                             AndHeight:284];
    sheet.doneDelegate = self;
    [sheet showInView:self.view];
}

- (void)headerRefreshMethod
{
    _getFollowRecordApi.pageIndex = @"1";
    _getFollowRecordApi.pageSize = @"10";
    _getFollowRecordApi.isDetails = @"true";
    _getFollowRecordApi.propKeyId = _propKeyId;
    _getFollowRecordApi.followTypeKeyId = _selectFiltItem.itemValue?_selectFiltItem.itemValue:@"";
    [_manager sendRequest:_getFollowRecordApi];
}

- (void)footerRefreshMethod
{
    [self showLoadingView:nil];
    
    NSInteger pageIndex = [_getFollowRecordApi.pageIndex integerValue] + 1;
    _getFollowRecordApi.pageIndex = [NSString stringWithFormat:@"%ld", pageIndex];
    _getFollowRecordApi.pageSize = @"10";
    _getFollowRecordApi.isDetails = @"true";
    _getFollowRecordApi.propKeyId = _propKeyId;
    _getFollowRecordApi.followTypeKeyId = _selectFiltItem.itemValue?_selectFiltItem.itemValue:@"";
    [_manager sendRequest:_getFollowRecordApi];
}

#pragma mark - PickerViewDelegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _filterItemArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    
    UILabel *cusPicLabel = view ? (UILabel *) view : [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                                                               0.0f,
                                                                                               self.view.frame.size.width,
                                                                                               20.0f)];
    
    SelectItemDtoEntity *selectItemDtoEntity = [_filterItemArray objectAtIndex:row];
    cusPicLabel.text = selectItemDtoEntity.itemText;
    [cusPicLabel setFont:[UIFont fontWithName:FontName size:18.0]];
    [cusPicLabel setTextAlignment:NSTextAlignmentCenter];
    cusPicLabel.backgroundColor = [UIColor clearColor];
    
    return cusPicLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectResultIndex = row;
}

#pragma mark - DoneSelectDelegate

- (void)doneSelectItemMethod
{
    if (![self respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)])
    {
        [self performSelector:@selector(pickerView:didSelectRow:inComponent:) withObject:nil ];
    }
    _selectFiltItem = [_filterItemArray objectAtIndex:_selectResultIndex];
    
    [self initData];
}

#pragma mark - ***************UITableViewDelegate************

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _followListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * identifier = @"JMMoreFollowListCell";
    
    JMMoreFollowListCell * cell = [tableView tableViewCellByNibWithIdentifier:identifier];
    
    cell.entity = _followListArray[indexPath.row];
    
    //    static NSString *reuseID = @"cell";
    //    NewMoreFollowListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    //    if (!cell) {
    //        cell = [[NewMoreFollowListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    }
    //
    //    cell.propFollowRecordDetailEntity = _followListArray[indexPath.row];
    cell.buttonPlacedTop.tag = indexPath.row;
    [cell.buttonPlacedTop addTarget:self action:@selector(placedAtTheTopEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PropFollowRecordDetailEntity *followDetailEntity = [_followListArray objectAtIndex:indexPath.row];
    
    return [JMMoreFollowListCell getHeight:followDetailEntity.followContent]+16+26;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    followClickIndex = indexPath.row;
    _itemMenuLabels = [[NSMutableArray alloc]init];
    BOOL isHaveConfirm = NO;
    
    // 是否含有删除功能
    
    BOOL isCanDelete = [self canDeleteFollowByFollow:_followListArray[indexPath.row]];
    
    
    if (isCanDelete)
    {
        [_itemMenuLabels addObject:_menu2];
    }
    
    PropFollowRecordDetailEntity *followDetailEntity = [_followListArray objectAtIndex:indexPath.row];
    if (followDetailEntity.confirmUserName && isCanDelete)
    {
        [_itemMenuLabels removeObject:_menu1];
        
        // 若是确认过就不可继续进行确认
        [self showDeleteTextView];
        
        //         BYActionSheetView *byActionSheet = [[BYActionSheetView alloc]initWithTitle:nil
        //                                                                           delegate:self
        //                                                                  cancelButtonTitle:@"取消"
        //                                                                  otherButtonTitles:@"删除",
        //                                                                                    nil];
        //         byActionSheet.tag = TagActionSheet;
        //         [byActionSheet show];
        
        return;
    }
    
    if (followDetailEntity.confirmUserName && !isCanDelete)
    {
        // 若是确认过就不可继续进行经理确认(且没有删除权限)
        return;
    }
    
    if (isHaveConfirm && isCanDelete)
    {
        
        [self showManagerConfirmedDeleteTextView];
        
        //        BYActionSheetView *byActionSheet = [[BYActionSheetView alloc]initWithTitle:nil
        //                                                                          delegate:self
        //                                                                 cancelButtonTitle:@"取消"
        //                                                                 otherButtonTitles:@"经理确认",@"删除",
        //                                                                                    nil];
        //        byActionSheet.tag = TagActionSheet;
        //        [byActionSheet show];
        
        return;
    }
    
    if (isHaveConfirm && !isCanDelete)
    {
        
        [self showManagerConfirmedTextView];
        
        //        BYActionSheetView *byActionSheet = [[BYActionSheetView alloc]initWithTitle:nil
        //                                                                          delegate:self
        //                                                                 cancelButtonTitle:@"取消"
        //                                                                 otherButtonTitles:@"经理确认",
        //                                                                                    nil];
        //        byActionSheet.tag = TagActionSheet;
        //        [byActionSheet show];
        
        return;
    }
    
    if (!isHaveConfirm && isCanDelete)
    {
        
        [self showDeleteTextView];
        
        //        BYActionSheetView *byActionSheet = [[BYActionSheetView alloc]initWithTitle:nil
        //                                                                          delegate:self
        //                                                                 cancelButtonTitle:@"取消"
        //                                                                 otherButtonTitles:@"删除",
        //                                                                                    nil];
        //        byActionSheet.tag = TagActionSheet;
        //        [byActionSheet show];
        
        return;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    PropFollowRecordDetailEntity *followDetailEntity = [_followListArray objectAtIndex:indexPath.row];
    BOOL hasFunction = NO;
    BOOL hasRight = [self canMarkTopFollowByFollow:followDetailEntity];
    
    return hasFunction && hasRight;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView
                  editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PropFollowRecordDetailEntity *followDetailEntity = [_followListArray objectAtIndex:indexPath.row];
    NSString *actionTitle = @"置顶";
    UIColor *actionBgColor = RGBColor(231, 39, 11);
    BOOL topFlag = followDetailEntity.topFlag;
    
    if (topFlag)
    {
        actionTitle = @"取消置顶";
        actionBgColor = RGBColor(175, 174, 181);
    }
    
    WS(weakSelf);
    UITableViewRowAction *stickFollowAction = [UITableViewRowAction
                                               rowActionWithStyle:UITableViewRowActionStyleDefault
                                               title:actionTitle
                                               handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                   [weakSelf showLoadingView:nil];
                                                   [_mainTableView setEditing:NO];
                                                   
                                                   if (topFlag)
                                                   {
                                                       // 取消置顶
                                                       FollowMarkTopCancelApi *cancelApi = [[FollowMarkTopCancelApi alloc] init];
                                                       cancelApi.propertyFollowKeyId = followDetailEntity.keyId;
                                                       cancelApi.propertyKeyId = weakSelf.propKeyId;
                                                       [_manager sendRequest:cancelApi];
                                                   }
                                                   else
                                                   {
                                                       // 置顶
                                                       FollowMarkTopApi *markTopApi = [[FollowMarkTopApi alloc] init];
                                                       markTopApi.propertyFollowKeyIds = @[followDetailEntity.keyId];
                                                       markTopApi.propertyKeyId = weakSelf.propKeyId;
                                                       [_manager sendRequest:markTopApi];
                                                   }
                                               }];
    stickFollowAction.backgroundColor = actionBgColor;
    
    return @[stickFollowAction];
}

#pragma mark - <ApplyTransferDelegate>

/// 申请转盘、信息补充成功后返回跟进列表需要刷新列表    PROP_FOLLOW_TYPE
- (void)transferEstSuccess
{
    [self initData];
}

#pragma mark - NewOpeningDelegate

- (void)newOpenSuccess:(NSInteger)tradingState
{
    
    
    [self initData];
}

#pragma mark - private
//展示删除选择框
- (void)showDeleteTextView{
    
    NSArray * listArr = @[@"删除"];
    
    __block typeof(self) weakSelf = self;
    
    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
        
        [weakSelf selectButtonIndex:optionValue];
        
    }];
    
}

//展示经理确认选择框
- (void)showManagerConfirmedTextView{
    
    NSArray * listArr = @[@"经理确认"];
    
    __block typeof(self) weakSelf = self;
    
    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
        
        [weakSelf selectButtonIndex:optionValue];
        
    }];
    
}

//展示经理确认+删除选择框
- (void)showManagerConfirmedDeleteTextView{
    
    NSArray * listArr = @[@"经理确认",@"删除"];
    
    __block typeof(self) weakSelf = self;
    
    [NewUtils popoverSelectorTitle:nil listArray:listArr theOption:^(NSInteger optionValue) {
        
        [weakSelf selectButtonIndex:optionValue];
        
    }];
    
}

- (void)selectButtonIndex:(NSInteger)index{
    
    if(_itemMenuLabels.count == index)
    {
        return;
    }
    
    [self showLoadingView:nil];
    
    // 经理确认
    if([_itemMenuLabels[index] isEqualToString:_menu1])
    {
        PropFollowRecordDetailEntity *followDetailEntity = [_followListArray objectAtIndex:followClickIndex];
        _propFollowOprateApi.keyids = followDetailEntity.keyId;
        _propFollowOprateApi.PropertyKeyId = _propKeyId;
        _propFollowOprateApi.PropFollowOprateType = ConfirmPropFollow;
        
        [_manager sendRequest:_propFollowOprateApi sucBlock:^(id result) {
            // 请求成功
            [self hiddenLoadingView];
            
            // 休眠一秒（为保证服务端真实将确认标识插入到数据库中，不休眠会导致数据更新不及时，导致查询的结果不真实）
            [NSThread sleepForTimeInterval:1];
            
            //                [_mainTableView headerBeginRefreshing];
            [_mainTableView.mj_header beginRefreshing];
            [CustomAlertMessage showAlertMessage:@"确认成功！\n\n"
                                 andButtomHeight:APP_SCREEN_HEIGHT/2];
            return;
            
        } failBlock:^(NSError *error) {
            // 请求失败
            [self endRefreshWithTableView:_mainTableView];
        }];
        
        return;
    }
    
    // 删除
    if([_itemMenuLabels[index] isEqualToString:_menu2])
    {
        PropFollowRecordDetailEntity *followDetailEntity = [_followListArray objectAtIndex:followClickIndex];
        _propFollowOprateApi.keyids = followDetailEntity.keyId;
        _propFollowOprateApi.PropertyKeyId = _propKeyId;
        _propFollowOprateApi.PropFollowOprateType = DeletePropFollow;
        
        [_manager sendRequest:_propFollowOprateApi sucBlock:^(id result) {
            // 请求成功
            [self hiddenLoadingView];
            
            // 休眠一秒（为保证服务端真实将删除动作更新到数据库中，不休眠会导致数据更新不及时，导致查询的结果不真实）
            [NSThread sleepForTimeInterval:1];
            
            //                [_mainTableView headerBeginRefreshing];
            [_mainTableView.mj_header beginRefreshing];
            [CustomAlertMessage showAlertMessage:@"删除成功！\n\n"
                                 andButtomHeight:APP_SCREEN_HEIGHT/2];
            return;
            
        } failBlock:^(NSError *error) {
            // 请求失败
            [self endRefreshWithTableView:_mainTableView];
            
        }];
    }
    
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    if ([modelClass isEqual:[FollowRecordEntity class]])
    {
        [self hiddenLoadingView];
        [self endRefreshWithTableView:_mainTableView];
        
        [_mainTableView reloadData];
        
        FollowRecordEntity *followRecordEntity = [DataConvert convertDic:data toEntity:modelClass];
        
        //        if (_mainTableView.isHeaderRefreshing)
        if (_mainTableView.mj_header.isRefreshing)
        {
            [_followListArray removeAllObjects];
        }
        
        if (followRecordEntity.propFollows.count < 10 || !followRecordEntity.propFollows)
        {
            //            _mainTableView.footerHidden = YES;
            _mainTableView.mj_footer.hidden = YES;
        }
        else
        {
            //            _mainTableView.footerHidden = NO;
            _mainTableView.mj_footer.hidden = NO;
        }
        
        [_followListArray addObjectsFromArray:followRecordEntity.propFollows];
        [_mainTableView reloadData];
        
        return;
    }
    
    // 置顶或取消置顶
    if ([modelClass isEqual:[AgencyBaseEntity class]])
    {
        [self hiddenLoadingView];
        
        AgencyBaseEntity *receiveEntity = [DataConvert convertDic:data toEntity:modelClass];
        if (receiveEntity.flag == YES)
        {
            // 操作成功，刷新数据
            //            [_mainTableView headerBeginRefreshing];
            [_mainTableView.mj_header beginRefreshing];
        }
        else
        {
            showMsg(receiveEntity.errorMsg);
        }
    }
}

// 置顶
- (void)placedAtTheTopEvent:(UIButton *)button {
    if (_followListArray.count == 0) {
        return;
    }
    PropFollowRecordDetailEntity *followDetailEntity = [_followListArray objectAtIndex:button.tag];
    if (followDetailEntity.topFlag) {
        // 取消置顶
        NSDictionary *dict = @{
                               @"PropertyKeyId":_propKeyId,
                               @"PropertyFollowKeyId":followDetailEntity.keyId
                               };
        
        
        [AFUtils PUT:AipPropertyFollowMarktopCancel parameters:dict controller:self successfulDict:^(NSDictionary *successfuldict) {
            
            [_followListArray removeAllObjects];
            [self headerRefreshMethod];
            
        } failureDict:^(NSDictionary *failuredict) {
            
        } failureError:^(NSError *failureerror) {
            
            
        }];
        
        //        [AFUtils POST:AipPropertyFollowMarktopCancel parameters:dict controller:self successfulDict:^(NSDictionary *successfuldict) {
        //            [_followListArray removeAllObjects];
        //            [self headerRefreshMethod];
        //        } failureDict:^(NSDictionary *failuredict) {
        //
        //        } failureError:^(NSError *failureerror) {
        //
        //        }];
    }
    else {
        // 置顶
        NSDictionary *dict = @{
                               @"PropertyKeyId":_propKeyId,
                               @"PropertyFollowKeyIds":@[followDetailEntity.keyId]
                               };
        
        
        
        [AFUtils PUT:AipPropertyFollowMarktop parameters:dict controller:self successfulDict:^(NSDictionary *successfuldict) {
            
            [_followListArray removeAllObjects];
            [self headerRefreshMethod];
            
        } failureDict:^(NSDictionary *failuredict) {
            
        } failureError:^(NSError *failureerror) {
            
            
        }];
        
        
        //        [AFUtils POST:AipPropertyFollowMarktop parameters:dict controller:self successfulDict:^(NSDictionary *successfuldict) {
        //
        //        } failureDict:^(NSDictionary *failuredict) {
        //
        //        } failureError:^(NSError *failureerror) {
        //
        //        }];
    }
    
}


- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
    [self hiddenLoadingView];
    [self endRefreshWithTableView:_mainTableView];
}

@end
