//
//  TakingSeeVC.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "TakingSeeVC.h"
#import "AddTakingSeeVC.h"
#import "TakingSeeCell.h"
#import "FilterTakingSeeVC.h"
#import "PropertyDetailVC.h"

#import "AccessModelScopeEnum.h"            // 约看记录查看范围


#import "TakingSeeApi.h"
#import "TakingSeeEntity.h"
#import "SubTakingSeeEntity.h"
#import "PropertysModelEntty.h"

#import "UIView+Extension.h"

///看房类型
enum SeePropertyTypeEnum {
    SeeRent = 10,// 看租
    SeeSale = 20,// 看售
    SeeRentAndSale = 30,// 看租售
};
@interface TakingSeeVC ()<UITableViewDelegate,UITableViewDataSource,FilterDelegate> {
    UITableView *_mytableView;

    TakingSeeApi *_takingSeeApi;
    TakingSeeEntity *_takingSeeEntity;

    NSInteger _currentPage;
    NSMutableArray *_dataArr;

    BOOL _isFilterSearch;   // 筛选查询
    BOOL _hasClicked;       //是否已经点击
}

@property (weak, nonatomic) IBOutlet UIButton *addTakingSeeBtn;


@end

@implementation TakingSeeVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:@"约看记录"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];


    UIButton *addBtn = [self customBarItemButton:@"新增"
                                       backgroundImage:nil
                                            foreground:nil
                                             sel:@selector(addAction:)];

    UIButton *filterBtn = [self customBarItemButton:@"筛选"
                                    backgroundImage:nil
                                         foreground:nil
                                                sel:@selector(filterClick:)];

    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc]initWithCustomView:filterBtn];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithCustomView:addBtn];
    
    NSMutableArray * dataArray = [[NSMutableArray alloc] init];
    
    //陈行修改185bug
    if ([AgencyUserPermisstionUtil hasMenuPermisstion:MENU_CUSTOMER] &&  [AgencyUserPermisstionUtil hasMenuPermisstion:MENU_CUSTOMER_ALL_CUSTOMER]) {
        
        [dataArray addObject:addItem];
        
    }
    
    if ([AgencyUserPermisstionUtil hasMenuPermisstion:CUSTOMER_TAKE]) {
        
        [dataArray addObject:filterItem];
        
    }
    
    self.navigationItem.rightBarButtonItems = dataArray;
    
    
    // 加载数据
    [self initData];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self headRefresh];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mytableView setEditing:NO];
//    _isFilterSearch = NO;
    if (_dataArr.count > 0)
    {
        [_mytableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    _hasClicked = NO;
}

- (void)back {
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

- (void)initData {
    _takingSeeApi = [[TakingSeeApi alloc] init];
    _dataArr = [NSMutableArray array];
    NSDate *nowDate = [NSDate date];
    NSDate *startDay = [NSDate dateWithTimeInterval:-24*60*60*30 sinceDate:nowDate]; // 前30天
    _dateTimeStart = [NSDate stringWithSimpleDate:startDay];
    _dateTimeEnd = [NSDate stringWithSimpleDate:nowDate];
    
}

- (void)initView {
    _mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREENSafeAreaHeight-APP_NAV_HEIGHT) style:UITableViewStylePlain];
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    _mytableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_mytableView];
    
    if ([AgencyUserPermisstionUtil hasMenuPermisstion:CUSTOMER_TAKE]) {
        
        _mytableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
        _mytableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footrefresh)];
        
    }
    
    _mytableView.hidden = YES;
    
    self.addTakingSeeBtn.hidden = YES;
    [self.addTakingSeeBtn setLayerCornerRadius:YCLayerCornerRadius];
}

#pragma mark - 筛选

- (void)filterClick:(UIButton *)btn {
    [CommonMethod addLogEventWithEventId:@"A record_screen_Click" andEventDesc:@"约看记录-筛选点击量"];

    if (_hasClicked)
    {
        return;
    }
    _hasClicked = YES;
    FilterTakingSeeVC *vc = [[FilterTakingSeeVC alloc] init];
    vc.myDelegate = self;
    vc.remindPersonDetailEntity1 = _departmentEntity;
    vc.remindPersonDetailEntity2 = _employeeEntity;
    vc.startTime = _dateTimeStart;
    vc.endTime = _dateTimeEnd;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 新增

- (IBAction)addAction:(UIButton *)sender {
    [CommonMethod addLogEventWithEventId:@"A record_added_Click" andEventDesc:@"约看记录-新增点击量"];

    if (_hasClicked)
    {
        return;
    }
    _hasClicked = YES;
    AddTakingSeeVC *addTakingSeeVC = [[AddTakingSeeVC alloc] init];

    [self.navigationController pushViewController:addTakingSeeVC animated:YES];
}

- (void)subViewIsHidden:(BOOL)isHidden {
    UILabel *label = [self.view viewWithTag:101];
    UIImageView *imgView = [self.view viewWithTag:102];
    UIButton *btn = [self.view viewWithTag:103];

   label.hidden = isHidden;

    if (!_isFilterSearch)
    {
        // 默认约看记录没有结果
        label.text = @"一个月内还没有约看记录，快去新增一条吧～";
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
    _mytableView.hidden = !isHidden;
}

#pragma mark - <FilterDelegate>

- (void)commitDataWithDepartment:(RemindPersonDetailEntity *)departEntity // 部门
                    withEmployee:(RemindPersonDetailEntity *)employeeEntity // 人员
                   withStartTime:(NSString *)startTime
                     withEndTime:(NSString *)endTime {
    [CommonMethod addLogEventWithEventId:@"A record_screen success_Click" andEventDesc:@"约看记录筛选条件-筛选成功数量"];
    _isFilterSearch = YES;
    _departmentEntity = departEntity;
    _employeeEntity = employeeEntity;
    NSDate *nowDate = [NSDate date];
    NSDate *startDay = [NSDate dateWithTimeInterval:-24*60*60*30 sinceDate:nowDate]; // 前30天
    _dateTimeStart = (startTime.length > 0)?startTime:[NSDate stringWithSimpleDate:startDay];
    _dateTimeEnd = (endTime.length > 0)?endTime:[NSDate stringWithSimpleDate:nowDate];
}

#pragma mark - 头/尾视图刷新

- (void)headRefresh {
    
    [_dataArr removeAllObjects];

    _currentPage = 1;
    _takingSeeApi.departmentName = [NSString nilToEmptyWithStr:_departmentEntity.departmentName];
    _takingSeeApi.employeeName = [NSString nilToEmptyWithStr:_employeeEntity.resultName];
    _takingSeeApi.dateTimeStart = _dateTimeStart;
    _takingSeeApi.dateTimeEnd = _dateTimeEnd;
    _takingSeeApi.seePropertyType = @"";
    _takingSeeApi.inquiryFollowSearchType = @"0";
    _takingSeeApi.scopeType = [self getPermission];
    _takingSeeApi.pageIndex = [NSString stringWithFormat:@"%ld",_currentPage];
    _takingSeeApi.pageSize = @"15";
    _takingSeeApi.sortField = @"";
    _takingSeeApi.ascending = @"true";
    [_manager sendRequest:_takingSeeApi];
    [self showLoadingView:nil];
}

- (void)footrefresh {
    
    _currentPage += 1;
    _takingSeeApi.departmentName = (_departmentEntity == nil)?@"":_departmentEntity.departmentName;
    _takingSeeApi.employeeName = (_employeeEntity == nil)?@"":_employeeEntity.resultName;
    _takingSeeApi.dateTimeStart = _dateTimeStart;
    _takingSeeApi.dateTimeEnd = _dateTimeEnd;
    _takingSeeApi.seePropertyType = @"";
    _takingSeeApi.inquiryFollowSearchType = @"0";
    _takingSeeApi.scopeType = [self getPermission];
    _takingSeeApi.pageIndex = [NSString stringWithFormat:@"%ld",_currentPage];
    _takingSeeApi.pageSize = @"15";
    _takingSeeApi.sortField = @"";
    _takingSeeApi.ascending = @"true";
    [_manager sendRequest:_takingSeeApi];
    [self showLoadingView:nil];
}

- (int)getPermission {
    if ([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_ALL] )
    {
        // 全部
        return  ALL;
    }
    else if ([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_MYDEPARTMENT])
    {
        // 本部
        return MYDEPARTMENT;
    }
    return MYSELF;
}

#pragma mark - <UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64*NewRatio;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseID = @"cell";
    TakingSeeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[TakingSeeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (_dataArr.count > 0)
    {
        cell.subTakingSeeEntity = _dataArr[indexPath.row];
    }
    return cell;
}



#pragma mark - 跳转房源详情

- (void)turnToPropertyDetailWith:(SubTakingSeeEntity *)entity {
    [CommonMethod addLogEventWithEventId:@"A record_details_Click"  andEventDesc:@"约看记录页列表操作-跳转房源详情"];

    PropertyDetailVC *vc = [[PropertyDetailVC alloc] init];
    vc.propKeyId = entity.propertyKeyId;
    vc.propTrustType = entity.trustType;
    if ([entity.trustType isEqualToString:@"出售"])
    {
        vc.propTrustType = [NSString stringWithFormat:@"%d",SALE];
    }
    else if ([entity.trustType isEqualToString:@"出租"])
    {
        vc.propTrustType = [NSString stringWithFormat:@"%d",RENT];
    }
    else if ([entity.trustType isEqualToString:@"租售"])
    {
        vc.propTrustType = [NSString stringWithFormat:@"%d",BOTH];
    }

    vc.propEstateName = entity.estateName;
    vc.propBuildingName = entity.buildingName;
    vc.propHouseNo = entity.houseNo;

    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 转带看

- (void)takingToTakeWithEntity:(SubTakingSeeEntity *)entity {
    [CommonMethod addLogEventWithEventId:@"A record_turn to look_Click"  andEventDesc:@"约看记录页列表操作-转带看"];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass {
    if ([modelClass isEqual:[TakingSeeEntity class]])
    {
        _takingSeeEntity = [DataConvert convertDic:data toEntity:modelClass];
        if ([_takingSeeEntity.recordCount integerValue] > 0)
        {
            // 有约看记录
            [self subViewIsHidden:YES];

            NSInteger countNum = [_takingSeeEntity.recordCount intValue];
            if (_dataArr.count == countNum)
            {
                // 没有更多数据了
//                _mytableView.footerHidden = YES;
                _mytableView.mj_footer.hidden = YES;
            }
            else if(_dataArr.count < countNum)
            {
//                _mytableView.footerHidden = NO;
                 _mytableView.mj_footer.hidden = NO;
                [_dataArr addObjectsFromArray:_takingSeeEntity.takingSees];
            }

            [self hiddenLoadingView];
            [self endRefreshWithTableView:_mytableView];
            [_mytableView reloadData];
        }
        else
        {
            // 没有约看记录
            [self subViewIsHidden:NO];
        }
    }
}

@end
