//
//  CalendarStrokeVC.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/11/22.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "CalendarStrokeVC.h"
#import "JMDateDetailView.h"
#import "WeekTextView.h"
#import "CalendarStrokeCell.h"
#import "SectionFooterBtn.h"
#import "AddEventView.h"
#import "TakingSeeVC.h"
#import "TakeLookViewController.h"
#import "ReminRecordViewController.h"
#import "AllRoundDetailViewController.h"
#import "PropertyDetailVC.h"
#import "NSDate+Format.h"
#import "AllRoundDetailViewController.h"
#import "TCLocationHelper.h"


#import "JMCalendarStrokeHeaderView.h"
#import "JMCalendarStrokeTakeLookCell.h"
#import "JMCalendarStrokeTakingSeeCell.h"

#import "GetAllListApi.h"
#import "AllListEntity.h"
#import "SignedApi.h"
#import "AddGoOutApi.h" // 新增外出/编辑外出
#import "AddAlertApi.h"
#import "SignedRecordApi.h"
#import "SignedRecordEntity.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>         // base相关所有头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>   // 检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>     // 引入计算工具所有的头文件
#import "UITableView+Category.h"


#define SINGN_ALERTTAG 1993     //签到提醒框tag
enum EventTypeEnum{
    ASkLook = 0,
    daiLook = 1,
    
    
};
@interface CalendarStrokeVC ()<LBCalendarDataSource,UIScrollViewDelegate,UITableViewDataSource,
UITableViewDelegate,AddEventDelegate,TurnOtherMonthDelegate,UIAlertViewDelegate>{
    JMDateDetailView *_dateDetailView;            // 日历头部详情视图
    WeekTextView *_weekTextView;                // 一周星期
    LBCalendarContentView *_calendarContentView;// 日历中间内容视图
    UITableView *_infoTableView;                // 行程表
    AddEventView *_addEventView;                // 新增事件视图
    UIView *_shadowView;

    GetAllListApi *_getAllListApi;              // 获取所有列表数据
    SignedApi *_signedApi;

    NSMutableArray *_selectSectionArr;          // 记录所有点击被展开的数组
    NSMutableArray *_hasComplentArr;            // 已完成列表
    NSMutableArray *_allListDataMarray;
    NSSet *_allMonthPointDateSet;               // 整月需要打点的日期
    NSInteger _sectionNum;                      // 总组数
    NSDate *_lastSelectDate;                    // 上次选择的数组
    NSDate *_selectDate;                        // 请求某天时的选择日期

    BOOL _isNeedRequestAllData;                 // 是否是请求整月数据
    BOOL _isReloadData;                         // 是否需要更新表视图数据

}

@end

@implementation CalendarStrokeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //陈行修改185bug，
    if ([AgencyUserPermisstionUtil hasMenuPermisstion:MENU_CUSTOMER]) {
        
        UIButton * rbtn = [self customBarItemButton:nil backgroundImage:nil foreground:@"加号2" sel:@selector(addEvent)];
        
        [self setNavTitle:@"日历行程"
           leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:rbtn];
        
    }else{
        
        [self setNavTitle:@"日历行程"
           leftButtonItem:[self customBarItemButton:nil backgroundImage:nil foreground:@"backBtnImg" sel:@selector(back)] rightButtonItem:nil];
        
    }

    _selectSectionArr = [NSMutableArray array];
    _hasComplentArr = [NSMutableArray array];
    _allListDataMarray = [NSMutableArray array];
    _sectionNum = 0;

    

    // 创建UI
    [self initView];

    // 设置默认数据
    [self setDefaultData];

}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    // 刷新数据
    [self.calendar reloadData];
    [self clearConfigure];
    [self requestData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    _addEventView.hidden = YES;
    _shadowView.hidden = YES;
    [_infoTableView setEditing:NO];
}

#pragma mark - init


- (void)initView{
    
    // 顶部日历今日详情
    UIView * headerConView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 50)];
    _dateDetailView = [JMDateDetailView viewFromXib];
    _dateDetailView.backgroundColor = YCThemeColorBackground;
    _dateDetailView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 50);
    _dateDetailView.currentDate = [NSDate date];
    [_dateDetailView.todayBtn addTarget:self action:@selector(jinAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerConView addSubview:_dateDetailView];
    [self.view addSubview:headerConView];

    // 日历头部星期数
    _weekTextView = [[WeekTextView alloc] initWithFrame:CGRectMake(0, headerConView.bottom, APP_SCREEN_WIDTH, 36)];
    _weekTextView.weekArr = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    _weekTextView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_weekTextView];

    // 日历
    _calendarContentView = [[LBCalendarContentView alloc] initWithFrame:CGRectMake(0, _weekTextView.bottom, APP_SCREEN_WIDTH, 310)];
    _calendarContentView.backgroundColor = [UIColor whiteColor];
    self.calendar = [LBCalendar new];
    self.calendar.calendarAppearance.calendar.firstWeekday = 1; // Sunday == 1, Saturday == 7
    self.calendar.calendarAppearance.dayRectangularRatio = 9. / 10.;
    [self.calendar setContentView:_calendarContentView];
    [self.calendar setDataSource:self];
    _calendar.myDelegate = self;
    [self.view addSubview:_calendarContentView];
    
    //设置颜色
    LBCalendarAppearance * calendarSet = self.calendar.calendarAppearance;
    
    calendarSet.dayRectangularColorSelected = YCThemeColorGreen;
    calendarSet.dayRectangularColorSelectedOtherMonth = YCThemeColorGreen;
//    calendarSet.dayRectangularColorTodayOtherMonth = YCThemeColorGreen;

    calendarSet.dayTextFont = [UIFont systemFontOfSize:14];
    
    [_calendarContentView reloadData];
    [_calendarContentView reloadAppearance];
    
    // 行程表
    _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   _calendarContentView.bottom,
                                                                   APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 80 - 64 - 310)
                                                  style:UITableViewStyleGrouped];
    _infoTableView.showsVerticalScrollIndicator = NO;
    _infoTableView.pagingEnabled = NO;
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    _infoTableView.backgroundColor = RGBColor(245, 245, 245);
    [self.view addSubview:_infoTableView];

    // 新增事件按钮
    _shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64)];
    _shadowView.hidden = YES;
    _shadowView.backgroundColor = [UIColor blackColor];
    _shadowView.alpha = 0.2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_shadowView addGestureRecognizer:tap];
    [self.view addSubview:_shadowView];

    NSArray *titltArr = @[@"约看记录",@"带看记录"];
    CGFloat width = 110;
    CGFloat height = titltArr.count * RowHeight + ArrowHeight;
    _addEventView = [[AddEventView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH - width - 16, 5, width, height)];
    _addEventView.backgroundColor = [UIColor clearColor];
    _addEventView.titleArr = titltArr;
    _addEventView.imageArr = @[@"icon_jm_calendar_more_take_look", @"icon_jm_calendar_more_taking_see"];
    _addEventView.isHaveImage = YES;
    _addEventView.hidden = YES;
    _addEventView.addEventDelegate = self;
    [self.view addSubview:_addEventView];
}

#pragma mark - 默认数据

- (void)setDefaultData{
    _isNeedRequestAllData = NO;
    _isReloadData = YES;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSDate *event24Date = [endDate dateByAddingTimeInterval:8 * 60 * 60];
    NSDate *nowDate = [event24Date dateByAddingTimeInterval:-24 * 60 * 60];
    _lastSelectDate = nowDate;

    self.calendar.currentDate = [NSDate date];
    self.calendar.currentDateSelected = [NSDate date];

    // 请求当月数据
    _selectDate = [NSDate date];
}

#pragma mark - 清空配置信息

- (void)clearConfigure{
    _addEventView.hidden = YES;
    _sectionNum = 0;
    [_hasComplentArr removeAllObjects];
    [_allListDataMarray removeAllObjects];
    [_selectSectionArr removeAllObjects];
}

#pragma mark - 新增事件

- (void)addEvent{
    [CommonMethod addLogEventWithEventId:@"C stroke_added_Click" andEventDesc:@"日历行程-新增事件点击量"];
    
    //更换为此处
//    // 右上角
//    NSArray *titleArr = _muArray;
//    _eventView = [[EventView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH - RowWidth - 15, APP_TAR_HEIGHT,RowWidth, RowHeight * titleArr.count + ArrowHeight) andIsHaveImage:YES];
//    _eventView.hidden = YES;
//    _eventView.eventDelegate = self;
//    [self.view addSubview:_eventView];

    _addEventView.hidden = !_addEventView.hidden;
    _shadowView.hidden = !_shadowView.hidden;
} 

#pragma mark - 背景视图点击手势

- (void)tapAction:(UITapGestureRecognizer *)tap{
    _shadowView.hidden = YES;
    _addEventView.hidden = YES;
}

#pragma mark - 点击今

- (void)jinAction:(UIButton *)btn{
    // 加载当前月数据
    _dateDetailView.currentDate = [NSDate date];

    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGE_SELECT_DATE object:[NSDate date]];

    [self setDefaultData];
    [self clearConfigure];
     [_infoTableView reloadData];
    [self requestData];
}

#pragma mark - <AddEventDelegate>

- (void)addEventClickWithBtnTitle:(NSString *)title{
    // 新增视图隐藏
    _addEventView.hidden = YES;
    _shadowView.hidden = YES;

    if ([title contains:@"约看"])
    {
        // 约看
        [self takingSee];
    }
    else if ([title contains:@"带看"])
    {
        // 带看
        [self takedSee];
    }
}

#pragma mark - 约看/带看／外出／提醒
// 约看
- (void)takingSee{
    [CommonMethod addLogEventWithEventId:@"Added_appointment_Click" andEventDesc:@"新增事件-约看点击量"];

    TakingSeeVC *takingSeeVc = [[TakingSeeVC alloc] init];
    [self.navigationController pushViewController:takingSeeVc animated:YES];
}

// 带看
- (void)takedSee{
    [CommonMethod addLogEventWithEventId:@"Added_look with_Click" andEventDesc:@"新增事件-带看点击量"];

    TakeLookViewController *takingSeeVc = [[TakeLookViewController alloc] init];
    [self.navigationController pushViewController:takingSeeVc animated:YES];
}

// 提醒
- (void)alert{
    [CommonMethod addLogEventWithEventId:@"Added_remind_Click" andEventDesc:@"新增事件-提醒点击量"];

    ReminRecordViewController *reminRecordVC = [[ReminRecordViewController alloc] init];
    [self.navigationController pushViewController:reminRecordVC animated:YES];
}

#pragma mark - <LBCalendarDataSource>

/// 设置在某个位置是否打点
- (BOOL)calendarHaveEvent:(LBCalendar *)calendar date:(NSDate *)date{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    [dateFormatter setDateFormat:OnlyDateFormat];
//    NSString *dateTest = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
//
//    if (_allMonthPointDateSet.count > 0)
//    {
//        for (NSString *timeStr in _allMonthPointDateSet)
//        {
//            if ([dateTest isEqualToString:timeStr])
//            {
//                return YES;
//            }
//        }
//    }
    return NO;
}

#pragma mark -   点击某一天

- (void)calendarDidDateSelected:(LBCalendar *)calendar date:(NSDate *)date{
   
    if (_lastSelectDate == date){
        // 取消选择---显示当前某月全部数据
        _dateDetailView.currentDate = date;
        [self.calendar setCurrentDateSelected:nil];
        
        // 请求数据
        [_infoTableView setEditing:NO];
        _isNeedRequestAllData = YES;
        _isReloadData = YES;
        [self clearConfigure];
        [_infoTableView reloadData];
//        [self requestData];
        _lastSelectDate = nil;
        _selectDate = nil;
    
    }else{
        
        // 设置头部详细日期
        _dateDetailView.currentDate = date;
        [self.calendar setCurrentDateSelected:date];

        // 请求数据
        _selectDate = date;
        [_infoTableView setEditing:NO];
        _isNeedRequestAllData = NO;
        _isReloadData = YES;
        [self clearConfigure];
        [_infoTableView reloadData];
//        [self requestData];
        _lastSelectDate = date;
    }
    
    __block typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf requestData];
        
    });
    
}

#pragma mark - <TurnOtherMonthDelegate>

/// 切换月份
- (void)getEventDataWithDate:(NSDate *)date{
    _selectDate = nil;
    _allMonthPointDateSet = nil;
    _dateDetailView.currentDate = date;
    _selectDate = date;

    // 请求网络数据
    _isNeedRequestAllData = YES;
    _isReloadData = NO;
    
    [self requestData];
}


#pragma mark - 请求日历行程首页所有纪录数据

- (void)requestData{
    [self requestDataWithStartDate];
}

- (void)requestDataWithStartDate{
    [self showLoadingView:nil];

    // 请求约看／带看／外出／提醒记录
    IdentifyEntity *identifyEntity = [AgencyUserPermisstionUtil getIdentify];
    _getAllListApi = [[GetAllListApi alloc] init];
    _getAllListApi.scopeType = MYSELF;// 首页约看带看数据查看范围固定本人
    _getAllListApi.outScopeType = MYSELF;// 首页外出权限数据查看范围固定本人
    _getAllListApi.employeeKeyId = identifyEntity.uId;
    _getAllListApi.employeeDeptKeyId = identifyEntity.departId;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *requestDate = (_selectDate == nil)?[NSDate date]:_selectDate;
    NSDateComponents *comps = [calendar components: NSCalendarUnitYear | NSCalendarUnitMonth fromDate:requestDate];
    NSInteger days = [NSDate getCurrentMonthDaysWithYear:comps.year andMonth:comps.month];
    NSString *startDate = [NSString stringWithFormat:@"%ld-%ld-1",comps.year,comps.month];
    NSString *endDate = [NSString stringWithFormat:@"%ld-%ld-%ld",comps.year,comps.month,days];
    _getAllListApi.startTime = startDate;
    _getAllListApi.endTime = endDate;
    _getAllListApi.pageIndex = @"1";
    _getAllListApi.pageSize = @"200";
    _getAllListApi.sortField = @"";
    _getAllListApi.ascending = @"false";
    [_manager sendRequest:_getAllListApi];
    
    
    
}

#pragma mark - 获取权限

// 约看带看权限
- (int)getPermission{
    
    
    if ([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_ADD_ALL])
    {
        // 全部
        return  ALL;
    }
    else if ([AgencyUserPermisstionUtil hasRight:CUSTOMER_INQUIRY_SEARCH_MYDEPARTMENT])
    {
        // 本部
        return MYDEPARTMENT;

    }
    // 本人
    return MYSELF;
}

// 外出权限
- (int)getOutPermission{
    if ([AgencyUserPermisstionUtil hasRight:CENTER_CHENCKIN_SEARCH_ALL])
    {
        // 全部
        return ALL;
    }
    else if ([AgencyUserPermisstionUtil hasRight:CENTER_CHENCKIN_SEARCH_MYDEPT])
    {
        // 本部
        return MYDEPARTMENT;

    }
    // 本人
    return MYSELF;
}

#pragma mark - <UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // 约看／带看／外出／提醒／已完成
    return _sectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // 有已完成的
    if (_hasComplentArr.count > 0)
    {
        if (section == _sectionNum - 1)
        {
            return _hasComplentArr.count;
        }
    }

    // 没有已完成的
    if (_allListDataMarray.count > section) {
        
        NSDictionary *dic = _allListDataMarray[section];
        NSArray *array = [dic allValues][0];
        
        if ([_selectSectionArr containsObject:@(section)])
        {
            // 分组被展开
            return array.count;
        }
        
    }

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SubTakingSeeEntity * entity = nil;
    
    BOOL isFinished = YES;

    if (_hasComplentArr.count > 0) {

        if (indexPath.section == _sectionNum - 1) {

            NSDictionary * dict = _hasComplentArr[indexPath.row];

            NSString *keyStr = [dict allKeys][0];

            entity = [dict objectForKey:keyStr];
            
            isFinished = YES;

        }

    }
    
    if (entity == nil && _allListDataMarray.count > indexPath.section) {
        
        NSDictionary * dic = _allListDataMarray[indexPath.section];
        
        NSArray * dataArr = [dic allValues][0];
        
        entity = dataArr[indexPath.row];
        
        isFinished = NO;
        
    }

    if (entity.takeSeeKeyId.length > 0) {//带看

        static NSString * identifier = @"JMCalendarStrokeTakeLookCell";

        JMCalendarStrokeTakeLookCell * cell = [tableView tableViewCellByNibWithIdentifier:identifier];

        cell.entity = entity;

        cell.typeLabel.backgroundColor = isFinished ? YCThemeColorBackground : rgba(239, 247, 243, 1);

        cell.typeLabel.textColor = isFinished ? YCTextColorAuxiliary : YCThemeColorGreen;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }else{//约看

        static NSString * identifier = @"JMCalendarStrokeTakingSeeCell";

        JMCalendarStrokeTakingSeeCell * cell = [tableView tableViewCellByNibWithIdentifier:identifier];

        cell.entity = entity;

        cell.typeLabel.backgroundColor = isFinished ? YCThemeColorBackground : rgba(239, 247, 243, 1);

        cell.typeLabel.textColor = isFinished ? YCTextColorAuxiliary : YCThemeColorGreen;

        cell.customerNameLabel.textColor = isFinished ? YCTextColorAuxiliary : YCTextColorBlack;

        cell.customerPhoneNumLabel.textColor = isFinished ? YCTextColorAuxiliary : rgba(74, 144, 226, 1);

        cell.callPhoneNumBtn.hidden = isFinished;
        
        [cell.callPhoneNumBtn addTarget:self action:@selector(callPhoneNum:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    
//    NSString *identifier = @"CalendarStrokeCell";
//    CalendarStrokeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil)
//    {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"CalendarStrokeCell" owner:nil options:nil] lastObject];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    if (_hasComplentArr.count > 0)
//    {
//        //有已完成
//        if (indexPath.section == _sectionNum - 1)
//        {
//            cell.eventType = HasComplentEvent;
//            cell.dataEntity = _hasComplentArr[indexPath.row];
//            return cell;
//        }
//    }
//    if (_allListDataMarray.count > 0)
//    {
//        NSDictionary *dic = _allListDataMarray[indexPath.section];
//        cell.eventType = [dic allKeys][0];
//        NSArray *dataArr = [dic allValues][0];
//        cell.dataEntity = dataArr[indexPath.row];
//    }
//    return cell;
}

#pragma mark - tableView height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 46;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_hasComplentArr.count > 0)
    {
        if (section == _sectionNum - 1)
        {
            // 已完成
            return 0.1;
        }
    }
    if (_allListDataMarray.count > section)
    {
        NSDictionary *dic = _allListDataMarray[section];
        NSArray *array = [dic allValues][0];
        if (array.count > 1)
        {
            return 36;
        }
    }
    return 0.1;
}

#pragma mark - tableView header or footer View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    JMCalendarStrokeHeaderView * headerView = [JMCalendarStrokeHeaderView viewFromXib];
    
    headerView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 46);
    
    headerView.backgroundColor = YCThemeColorBackground;
    
    headerView.typeView.backgroundColor = YCThemeColorGreen;
    
    headerView.titleLabel.text = @"未完成行程";
    
    if (_hasComplentArr.count > 0){
        
        if (section == _sectionNum - 1){
            
            headerView.typeView.backgroundColor = YCHeaderViewBGColor;
            
            headerView.titleLabel.text = @"已完成行程";
            
        }
        
    }
    
    return headerView;
    
//    
//    if (_hasComplentArr.count > 0)
//    {
//        if (section == _sectionNum - 1)
//        {
//            // 已完成
//            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 50)];
//            UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, APP_SCREEN_WIDTH, 40)];
//            headLabel.textColor = [UIColor blackColor];
//            headLabel.backgroundColor = [UIColor whiteColor];
//            headLabel.text = @"   已完成行程";
//            headLabel.font = [UIFont systemFontOfSize:15];
//            [headView addSubview:headLabel];
//            return headView;
//        }
//    }
//    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (_hasComplentArr.count > 0)
    {// 有已完成
        if (section == _sectionNum - 1)
        {
            return nil;
        }
        else
        {
            // 尾视图
            if (_allListDataMarray.count > 0)
            {
                NSDictionary *dic = _allListDataMarray[section];
                NSArray *array = [dic allValues][0];
                if (array.count > 1)
                {
                    SectionFooterBtn *footBtnView = [SectionFooterBtn buttonWithType:UIButtonTypeCustom];
                    footBtnView = [SectionFooterBtn buttonWithType:UIButtonTypeCustom];
                    footBtnView.tag = 1000 + section;
                    footBtnView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 36);
                    [footBtnView addTarget:self action:@selector(openOrCloseClick:) forControlEvents:UIControlEventTouchUpInside];
                    if ([_selectSectionArr containsObject:@(section)])
                    {
                        footBtnView.selected = YES;
                    }
                    return  footBtnView;
                }
            }
        }
    }

    //尾视图－没有已完成
    if (_allListDataMarray.count > 0)
    {
        NSDictionary *dic = _allListDataMarray[section];
        NSArray *array = [dic allValues][0];
        if (array.count > 1)
        {
            SectionFooterBtn *footBtnView = [SectionFooterBtn buttonWithType:UIButtonTypeCustom];
            footBtnView = [SectionFooterBtn buttonWithType:UIButtonTypeCustom];
            footBtnView.tag = 1000 + section;
            footBtnView.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, 40);
            [footBtnView addTarget:self action:@selector(openOrCloseClick:) forControlEvents:UIControlEventTouchUpInside];

            if ([_selectSectionArr containsObject:@(section)])
            {
                footBtnView.selected = YES;
            }
            return  footBtnView;
        }
    }
    return nil;
}

#pragma mark - 跳转房源详情

- (void)turnToPropertyDetailWith:(SubTakingSeeEntity *)entity{
    [CommonMethod addLogEventWithEventId:@"C stroke_details_Click"  andEventDesc:@"日历行程列表操作-跳转房源详情"];

//    AllRoundDetailViewController *vc = [[AllRoundDetailViewController alloc] init];
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

- (void)takingToTakeWithEntity:(SubTakingSeeEntity *)entity{
    [CommonMethod addLogEventWithEventId:@"C stroke_turn to look_Click"  andEventDesc:@"日历行程列表操作-转带看"];
}

#pragma mark - 签到

- (void)signInWithModel:(SubGoOutListEntity *)entity{
    [CommonMethod addLogEventWithEventId:@"Out r_check the record_Click" andEventDesc:@"外出记录列表页操作-签到详情"];

    // 不能操作不属于自己的外出
    IdentifyEntity *identifyEntity = [AgencyUserPermisstionUtil getIdentify];
    if (![entity.employeeKeyId isEqualToString:identifyEntity.uId])
    {
        showMsg(@"不能操作不属于自己的外出!");
        return;
    }

    // 请求最新的签到记录
    [self showLoadingView:nil];
    SignedRecordApi *signedRecordApi = [[SignedRecordApi alloc] init];
    signedRecordApi.goOutMsgKeyId = entity.keyId;
    signedRecordApi.scope = [NSString stringWithFormat:@"%d",[self getOutPermission]];

    // 往前推两分钟
    NSTimeInterval min2 = 60 * 2;
    NSDate *date2Min = [[NSDate alloc] initWithTimeIntervalSinceNow:-min2];
    NSString *dateStr = [NSDate stringWithDate:date2Min];
    signedRecordApi.timeFrom = dateStr;
    signedRecordApi.timeTo = @"";
    signedRecordApi.employeeKeyId = identifyEntity.uId;
    signedRecordApi.employeeDeptKeyId = identifyEntity.departId;
    signedRecordApi.pageIndex = @"0";
    signedRecordApi.pageSize = @"500";
    signedRecordApi.sortField = @"CheckInTime";
    signedRecordApi.ascending = @"";

    WS(weakSelf);
    [_manager sendRequest:signedRecordApi sucBlock:^(id result)
    {

        SignedRecordEntity *signedRecordEntity = [DataConvert convertDic:result toEntity:[SignedRecordEntity class]];
        if (signedRecordEntity.checkIns.count > 0)
        {
            [weakSelf hiddenLoadingView];
            showMsg(@"请于2分钟后再尝试签到");
            [_infoTableView setEditing:NO];
            return;

        }
        [self getUserLocationWithEntity:entity];

    } failBlock:^(NSError *error)
    {
        [super respFail:error andRespClass:nil];
        [weakSelf hiddenLoadingView];
    }];
}

#pragma mark - 获取用户位置

- (void)getUserLocationWithEntity:(SubGoOutListEntity *)entity
{
   TCLocationHelper *locationHelper =  [TCLocationHelper shareInstance];

    // 获取当前位置信息
    [locationHelper getLocationSuccess:^(TCLocationHelper *mananger)
    {

        if (mananger.addressDetail == nil)
        {
            [self hiddenLoadingView];
            showMsg(@"无法获取当前位置！");
            return;
        }
        [self hiddenLoadingView];

        // 定位成功
        NSString *addressDetail = [NSString stringWithFormat:@"%@%@%@",mananger.cityName,mananger.subLocality,mananger.addressDetail];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"签到位置:"
                                                            message:addressDetail
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        alertView.tag = SINGN_ALERTTAG;
        [alertView show];

        _signedApi = [[SignedApi alloc] init];
        _signedApi.goOutMsgKeyId = entity.keyId;
        _signedApi.employeeKeyId = entity.employeeKeyId;
        _signedApi.employeeName = entity.employeeName;
        _signedApi.employeeDeptKeyId = entity.employeeDeptKeyid;
        _signedApi.employeeDeptName = entity.employeeDeptName;
        _signedApi.checkInAddress = addressDetail;
        _signedApi.longitude = [NSString stringWithFormat:@"%f",mananger.location.coordinate.longitude];
        _signedApi.latitude = [NSString stringWithFormat:@"%f",mananger.location.coordinate.latitude];
        _signedApi.height = [NSString stringWithFormat:@"%f",mananger.location.altitude];
    } locationFailBlock:^(NSError *error) {
        // 获取定位信息失败
        [self hiddenLoadingView];
        showMsg(@"无法获取当前位置!");
    }];
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == SINGN_ALERTTAG)
    {
        if (buttonIndex == 1)
        {
            // 确定签到
            [self ConfirmSign];
        }
    }
}

#pragma mark - 确认签到

- (void)ConfirmSign{
    [CommonMethod addLogEventWithEventId:@"C stroke_check_Click"  andEventDesc:@"日历行程列表操作-签到"];

    NSString *nowDate = [NSDate stringWithDate:[NSDate date]];
    _signedApi.checkInTime = nowDate;
    [self showLoadingView:@"正在签到"];
    [_manager sendRequest:_signedApi];
}

#pragma mark - 日历行程详情分组展开或者收起

- (void)openOrCloseClick:(SectionFooterBtn *)btn{
    if (_sectionNum <= 0)
    {
        return;
    }
    _addEventView.hidden = YES;
    btn.selected = !btn.selected;
    NSInteger section = btn.tag - 1000;
    if (btn.selected == YES)
    {
        // 展开
        [_selectSectionArr addObject:@(section)];
    }
    else
    {
        // 收起
        if ([_selectSectionArr containsObject:@(section)])
        {
            [_selectSectionArr removeObject:@(section)];
        }
    }

    [_infoTableView reloadData];
//    // 刷新被选中的组
//    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
//    [_infoTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
//    [_infoTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
//                          atScrollPosition:UITableViewScrollPositionNone
//                                  animated:NO];
//    [_infoTableView reloadData];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _addEventView.hidden = YES;
    if(!self.calendar.calendarAppearance.isWeekMode)
    {
        // 当前日历展开时
        if (_infoTableView.contentOffset.y >= 25)
        {
            self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
            [self transitionExample];
        }

    }
    else
    {
        // 当前日历收起时
        if (_infoTableView.contentOffset.y <= -25)
        {
            self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
            [self transitionExample];
        }
    }
}

#pragma mark - 展开/收起日历

- (void)transitionExample{
    if (_sectionNum > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_infoTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }

    CGFloat newHeight = 300;
    if(self.calendar.calendarAppearance.isWeekMode)
    {
        newHeight = 60.0;
    }

    [UIView animateWithDuration:.25
                     animations:^{
                         _calendarContentView.frame = CGRectMake(0, _weekTextView.bottom,APP_SCREEN_WIDTH, newHeight);
                         _infoTableView.frame = CGRectMake(0, _calendarContentView.bottom, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64 - 80 - newHeight);
                         [self.view layoutIfNeeded];
                     }];

    [UIView animateWithDuration:.25
                     animations:^{

                         _calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.calendar reloadAppearance];

                         [UIView animateWithDuration:.25
                                          animations:^{
                                              _calendarContentView.layer.opacity = 1;
                                          }];
                     }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _shadowView.hidden = YES;
    _addEventView.hidden = YES;
}

#pragma mark - 拨打电话
- (void)callPhoneNum:(UIButton *)callBtn{
    
    JMCalendarStrokeTakingSeeCell * cell = (JMCalendarStrokeTakingSeeCell *)callBtn.superview.superview;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cell.entity.mobile]]];
    
}

#pragma mark -  代理方法

- (void)dealData:(id)data andClass:(id)modelClass{
    
    
    if ([modelClass isEqual:[AllListEntity class]]) {
        // 事件列表
        AllListEntity *entity = [DataConvert convertDic:data toEntity:modelClass];

        [self dealDataWithEntity:entity];
    
    }else if ([modelClass isEqual:[AgencyBaseEntity class]]) {
        // 签到完成
        [CustomAlertMessage showAlertMessage:@"签到完成\n\n"
                             andButtomHeight:APP_SCREEN_HEIGHT / 2-64];
        [_infoTableView setEditing:NO];
    }
}

#pragma mark -   处理日历显示数据
- (void)dealDataWithEntity:(AllListEntity *)entity{
   
    // 临时存储打点集合
    NSMutableSet *mSet = [NSMutableSet set];

    //***************************约看行程*******************************//
    if (entity.takingSees.count > 0) {
        
        NSArray *array = entity.takingSees;
        NSMutableArray *mArr = [NSMutableArray array];
       
        for (SubTakingSeeEntity *entity in array) {
            
            //约看时间
            
            entity.reserveTime = [entity.reserveTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            
            NSString *timeStr = [entity.reserveTime substringToIndex:10];
            
            BOOL isEarly = [NSDate islaterDate24WithDate:entity.reserveTime];
           
            if (!isEarly && entity.takeSeeKeyId.length == 0){
                [mSet addObject:[entity.reserveTime substringToIndex:10]];
            }

            // 请求整月数据
            if (_isNeedRequestAllData){
                
               if (_isReloadData){
                    
                    if (isEarly || entity.takeSeeKeyId.length > 0){
                        // 已完成
                        NSDictionary *dic = @{
                                              TakingSeeEvent:entity
                                              };

                        [_hasComplentArr addObject:dic];
                    
                    }else{
                        
                        // 未完成
                        [mArr addObject:entity];
                    }

                }else{
                    
                    // 切换月份时显示当前月数据，不根据月份进行更新
                }
            
            }else{
                
                // 请求某天数据－按日期筛选  选择日期
                NSString *selectStr = [NSDate stringWithDate:_selectDate];
                NSString *newStr = [selectStr substringToIndex:10];

                if ([newStr isEqualToString:timeStr]){
                    
                    if (isEarly || entity.takeSeeKeyId.length > 0){
                        // 已完成
                        NSDictionary *dic = @{
                                              TakingSeeEvent:entity
                                              };
                        [_hasComplentArr addObject:dic];
                   
                    }else{
                        // 未完成
                        [mArr addObject:entity];
                    }
                }
            }
        }
        
        

        if (_isNeedRequestAllData) {
            // 请求整月数据
            if (_isReloadData)
            {
                // 请求当月整月数据
                if (mArr.count > 0)
                {
                    NSDictionary *dic = @{
                                          TakingSeeEvent:mArr
                                          };
                    [_allListDataMarray addObject:dic];
                    _sectionNum += 1;
                }
                mArr = nil;
            }
            else{
                //切换月份时

            }
        }else{
            // 请求某天数据
            if (mArr.count > 0)
            {
                NSDictionary *dic = @{
                                      TakingSeeEvent:mArr
                                      };
                [_allListDataMarray addObject:dic];
                _sectionNum += 1;
            }
            mArr = nil;
        }
        
        
    }

    //***************************带看行程*******************************//
    if (entity.takeSees.count > 0 && [AgencyUserPermisstionUtil hasMenuPermisstion:CUSTOMER_TAKE]) {
        // 所有带看都是已完成
        NSArray *array = entity.takeSees;
        for (SubTakingSeeEntity *entity in array) {
            
            entity.takeSeeTime = [entity.takeSeeTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            
            NSString *timeStr = [entity.takeSeeTime substringToIndex:10];
          
            if (_isNeedRequestAllData) {
                // 请求整月数据
                if (_isReloadData) {
                    // 请求当月整月数据
                    NSDictionary *dic = @{
                                          TakeSeeEvent:entity
                                          };
                    [_hasComplentArr addObject:dic];
                
                }else{// 切换月份时

                }
            
            }else{
                
                // 请求某天数据--筛选出某天的已完成数据
                NSString *selectStr = [NSDate stringWithDate:_selectDate];
                NSString *newStr = [selectStr substringToIndex:10];
                if ([newStr isEqualToString:timeStr])
                {
                    NSDictionary *dic = @{
                                          TakeSeeEvent:entity
                                          };
                    [_hasComplentArr addObject:dic];

                }
            }
        }

    }

    
    //***************************展示数据*******************************//
    if (_isNeedRequestAllData)
    {
        //请求整月数据
        if (_isReloadData)
        {
            //请求当月整月数据
            if (_hasComplentArr.count > 0)
            {
                _sectionNum += 1;
            }
            [_infoTableView reloadData];

        }
        else
        {
            // 切换月份
            NSLog(@"%ld",_sectionNum);
        }

    }
    else
    {
        // 请求某天数据
        if (_hasComplentArr.count > 0)
        {
            _sectionNum += 1;
        }
        [_infoTableView reloadData];
    }

    _allMonthPointDateSet = mSet;
    [_infoTableView reloadData];
    [_calendar reloadData];
    mSet = nil;

}

- (void)respFail:(NSError *)error andRespClass:(id)cls{
    [super respFail:error andRespClass:cls];
    [_infoTableView setEditing:NO];
}

@end
