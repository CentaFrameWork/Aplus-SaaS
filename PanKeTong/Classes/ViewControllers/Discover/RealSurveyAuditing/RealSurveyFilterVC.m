//
//  RealSurveyFilterVC.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/7/15.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "RealSurveyFilterVC.h"
#import "RealSurveyFilterCell.h"
#import "RealSurveyAuditingSearchVC.h"
#import "TCPickView.h"
#import "NSDate+Format.h"
#import "RealSurveyAuditingEntity.h"



@interface RealSurveyFilterVC ()<UITableViewDelegate,UITableViewDataSource,RealSurveySearchDelegate,SearchRemindPersonDelegate,TCPickViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (assign, nonatomic)BOOL  isUpdatePage;         //是否修改了该页面
@property (assign, nonatomic)SearchRealSurveyType selectRemindType;
@property (copy, nonatomic)NSString *departmentID;
@property (copy, nonatomic)NSString *oldEstateBuildingName;
@property (assign, nonatomic)BOOL hasPickView;         //是否页面上存在时间选择器
@property (strong, nonatomic)RealSurveyAuditingEntity *realSurveyAuditingEntity;



@end


@implementation RealSurveyFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _realSurveyAuditingEntity = [DataConvert convertDic:_dataDic toEntity:[RealSurveyAuditingEntity class]];

    
    [self initNavigation];
    [self initData];
}


- (void)initData
{
    _hasPickView = NO;
}


- (void)initNavigation
{
    [self setNavTitle:@"更多筛选"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];

    UIButton *commitBtn = [self customBarItemButton:@"确定"
                                    backgroundImage:nil
                                         foreground:nil
                                                sel:@selector(commitClick)];
    
    UIBarButtonItem *commitBtnItem = [[UIBarButtonItem alloc]initWithCustomView:commitBtn];
    UIButton *againSetting = [self customBarItemButton:@"重置"
                                       backgroundImage:nil
                                            foreground:nil
                                                   sel:@selector(againSetClick)];
    
    UIBarButtonItem *againSettingItem = [[UIBarButtonItem alloc]initWithCustomView:againSetting];
    self.navigationItem.rightBarButtonItems = @[commitBtnItem,againSettingItem];
    
}

/**
 *  确定
 */
- (void)commitClick
{
    if (!_isUpdatePage) {
        //没有修改页面直接返回
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    _realSurveyAuditingEntity.createTimeFrom = _realSurveyAuditingEntity.createTimeFrom ? _realSurveyAuditingEntity.createTimeFrom:_startTime;
    _realSurveyAuditingEntity.createTimeTo = _realSurveyAuditingEntity.createTimeTo ? _realSurveyAuditingEntity.createTimeTo:_endTime;
    
    
    //计算时间差
    NSString *startTime = [_realSurveyAuditingEntity.createTimeFrom stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *endTime = [_realSurveyAuditingEntity.createTimeTo stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if ([startTime integerValue]>[endTime integerValue]) {
        showMsg(@"开始时间不能大于结束时间");
        return;
    }
    //    if ([endTime integerValue]-[startTime integerValue]>101) {
    //        showMsg(@"为了更快的查询，仅支持30天内的查询");
    //        return;
    //
    //    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(RealSurveyFilterWithRealSurveyAuditingEntity:)])
    {
        [self.delegate RealSurveyFilterWithRealSurveyAuditingEntity:_realSurveyAuditingEntity];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 *  重置
 */
- (void)againSetClick
{
    // 初始化开始时间和结束时间
    NSDate *lastMouthDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 30];
    _startTime = [CommonMethod formatDateStrFromDate:lastMouthDate];
    _endTime = [CommonMethod formatDateStrFromDate:[NSDate date]];
    
    
    //楼盘
    _realSurveyAuditingEntity.estateNames = nil;
    _realSurveyAuditingEntity.estateKeyId = nil;
    //栋
    _realSurveyAuditingEntity.buildingNames = nil;
    _realSurveyAuditingEntity.buildingKeyId = nil;
    //时间
    _realSurveyAuditingEntity.createTimeFrom = _startTime;
    _realSurveyAuditingEntity.createTimeTo = _endTime;
    //实勘部门/实勘人
    _realSurveyAuditingEntity.realSurveyPersonKeyId =  nil;
    _realSurveyAuditingEntity.realSurveyPersonKeyName = nil;
    _realSurveyAuditingEntity.realSurveyPersonDeptKeyId = nil;
    _realSurveyAuditingEntity.realSurveyPersonDeptName = nil;
    _departmentID = nil;
    //审核人
    _realSurveyAuditingEntity.auditPersonKeyName = nil;
    _realSurveyAuditingEntity.auditPersonKeyId = nil;
    
    _isUpdatePage = YES;
    
    [_mainTableView reloadData];
}


#pragma mark - <RealSurveySearchDelegate>
- (void)realSurveySearchWithKey:(NSString *)key andValue:(NSString *)value andSearchType:(NSInteger)searchType
{
    if (searchType == EstateSelectTypeEnum_ESTATENAME) {
        //楼盘
        _realSurveyAuditingEntity.estateNames = key;
        _realSurveyAuditingEntity.estateKeyId = value;
        
        if (![_oldEstateBuildingName isEqualToString:key]) {
            //栋
            _realSurveyAuditingEntity.buildingNames = nil;
            _realSurveyAuditingEntity.buildingKeyId = nil;
        }
        
    }
    
    if (searchType == EstateSelectTypeEnum_BUILDINGBELONG){
        //栋
        _realSurveyAuditingEntity.buildingNames = key;
        _realSurveyAuditingEntity.buildingKeyId = value;
    }
    
    _isUpdatePage = YES;
    
    
    [_mainTableView reloadData];
}


#pragma mark - <SearchRemindPersonDelegate>
- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem
{
    if (_selectRemindType == RealSurveyPerson) {
        //实勘人
        _realSurveyAuditingEntity.realSurveyPersonKeyId =  selectRemindItem.resultKeyId;
        _realSurveyAuditingEntity.realSurveyPersonKeyName = selectRemindItem.resultName;
        _realSurveyAuditingEntity.realSurveyPersonDeptKeyId = selectRemindItem.departmentKeyId;
        _realSurveyAuditingEntity.realSurveyPersonDeptName = selectRemindItem.departmentName;
    }else if (_selectRemindType == RealSurveyDeparment){
        //实勘部门
        _realSurveyAuditingEntity.realSurveyPersonDeptName = selectRemindItem.departmentName;
        _realSurveyAuditingEntity.realSurveyPersonDeptKeyId = selectRemindItem.departmentKeyId;
        _departmentID = selectRemindItem.departmentKeyId;
        _realSurveyAuditingEntity.realSurveyPersonKeyId = nil;
        _realSurveyAuditingEntity.realSurveyPersonKeyName = nil;
    }else if (_selectRemindType == ExaminePerson){
        //审核人
        _realSurveyAuditingEntity.auditPersonKeyName = selectRemindItem.resultName;
        _realSurveyAuditingEntity.auditPersonKeyId = selectRemindItem.resultKeyId;
        _realSurveyAuditingEntity.auditPersonDeptKeyId = selectRemindItem.departmentKeyId;
        
    }
    
    _isUpdatePage = YES;
    _hasPickView = NO;
    
    
    [_mainTableView reloadData];
    
}



#pragma mark - <UITableViewDelegate/UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"realSurveyFilterCell";
    
    RealSurveyFilterCell *realSurveyAuditingListCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!realSurveyAuditingListCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"RealSurveyFilterCell"
                                              bundle:nil]
        forCellReuseIdentifier:CellIdentifier];
        
        realSurveyAuditingListCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    NSString *estateBuildingName = _realSurveyAuditingEntity.estateNames?_realSurveyAuditingEntity.estateNames:@"请点击搜索";
    NSString *buildingNames = _realSurveyAuditingEntity.buildingNames?_realSurveyAuditingEntity.buildingNames:@"请点击搜索";
    NSString *realSurveyPersonKeyName = _realSurveyAuditingEntity.realSurveyPersonKeyName?_realSurveyAuditingEntity.realSurveyPersonKeyName:@"请点击搜索";
    NSString *realSurveyPersonDeptName = _realSurveyAuditingEntity.realSurveyPersonDeptName?_realSurveyAuditingEntity.realSurveyPersonDeptName:@"请点击搜索";
    NSString *auditPersonKeyName = _realSurveyAuditingEntity.auditPersonKeyName?_realSurveyAuditingEntity.auditPersonKeyName:@"请点击搜索";
    NSString *startTime =  _realSurveyAuditingEntity.createTimeFrom?_realSurveyAuditingEntity.createTimeFrom:_startTime;
    NSString *endTime =  _realSurveyAuditingEntity.createTimeTo?_realSurveyAuditingEntity.createTimeTo:_endTime;
    
    
    switch (indexPath.row) {
        case 0:
            realSurveyAuditingListCell.filterLabel.text = @"楼盘名称";
            realSurveyAuditingListCell.valueLabel.text = estateBuildingName;
            _oldEstateBuildingName = estateBuildingName;
            break;
        case 1:
            realSurveyAuditingListCell.filterLabel.text = @"栋座单元";
            realSurveyAuditingListCell.valueLabel.text = buildingNames;
            
            break;
        case 2:
            realSurveyAuditingListCell.filterLabel.text = @"开始时间";
            realSurveyAuditingListCell.valueLabel.text = startTime;
            break;
        case 3:
            realSurveyAuditingListCell.filterLabel.text = @"结束时间";
            realSurveyAuditingListCell.valueLabel.text = endTime;
            break;
        case 4:
            realSurveyAuditingListCell.filterLabel.text = @"实勘部门";
            realSurveyAuditingListCell.valueLabel.text = realSurveyPersonDeptName;
            break;
        case 5:
            realSurveyAuditingListCell.filterLabel.text = @"实勘人";
            realSurveyAuditingListCell.valueLabel.text = realSurveyPersonKeyName;
            
            break;
        case 6:
            realSurveyAuditingListCell.filterLabel.text = @"审核人";
            realSurveyAuditingListCell.valueLabel.text = auditPersonKeyName;
        default:
            break;
    }
    
    return realSurveyAuditingListCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"_hasPickView = %d",_hasPickView);
    
    if (_hasPickView) {
        return;
    }
    
    
    if (indexPath.row == 2) {
        
        _hasPickView = YES;
        
        NSString *date = _realSurveyAuditingEntity.createTimeFrom ? _realSurveyAuditingEntity.createTimeFrom : _startTime;
        
        NSDate *aDate = [NSDate dateFromString:date];
        
        TCPickView *pickView = [[TCPickView alloc] initDatePickViewWithDate:aDate mode:UIDatePickerModeDate];
        pickView.myDelegate = self;
        [pickView showPickViewWithResultBlock:^(id result) {
            
            NSString *time = [CommonMethod subTime:result];
            NSString *oldtime = [NSDate stringWithSimpleDate:aDate];
            if(![time isEqualToString:oldtime])
            {
                //如果时间改变
                _isUpdatePage = YES;
            }
            
            _realSurveyAuditingEntity.createTimeFrom = time;
            
            _hasPickView = NO;
            
            [_mainTableView reloadData];
        }];
        return;
        
    }else if (indexPath.row == 3){
        
        _hasPickView = YES;
        
        NSString *date = _realSurveyAuditingEntity.createTimeTo ? _realSurveyAuditingEntity.createTimeTo : _endTime;
        
        NSDate *aDate = [NSDate dateFromString:date];
        TCPickView *pickView = [[TCPickView alloc] initDatePickViewWithDate:aDate mode:UIDatePickerModeDate];
        pickView.myDelegate = self;
        [pickView showPickViewWithResultBlock:^(id result) {
            
            NSString *time = [CommonMethod subTime:result];
            NSString *oldtime = [NSDate stringWithSimpleDate:aDate];
            if(![time isEqualToString:oldtime])
            {
                //如果时间改变
                _isUpdatePage = YES;
            }
            
            _hasPickView = NO;
            
            _realSurveyAuditingEntity.createTimeTo = time;
            
            [_mainTableView reloadData];
        }];
        return;
    }
    
    
    //楼盘名称
    RealSurveyAuditingSearchVC *search = [[RealSurveyAuditingSearchVC alloc]initWithNibName:@"RealSurveyAuditingSearchVC"   bundle:nil];
    search.delegate = self;
    search.searchType = TopTextSearchType;
    
    //实勘人
    SearchRemindType selectRemindType;
    NSString *selectRemindTypeStr;
    
    
    SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc]
                                                              initWithNibName:@"SearchRemindPersonViewController"
                                                              bundle:nil];
    searchRemindPersonVC.isExceptMe = NO;
    searchRemindPersonVC.delegate = self;
    
    switch (indexPath.row) {
        case 0:
            //楼盘
            search.searchBuildingType = EstateSelectTypeEnum_ESTATENAME;
            [self.navigationController pushViewController:search animated:YES];
            return;
            
            break;
        case 1:
            //栋座单元
            if (!_realSurveyAuditingEntity.estateNames) {
                showMsg(@"请先搜索楼盘名称");
                return;
            }
            search.searchBuildingType = EstateSelectTypeEnum_BUILDINGBELONG;
            search.estateBuildingName = _realSurveyAuditingEntity.estateNames;
            [self.navigationController pushViewController:search animated:YES];
            
            return;
            break;
        case 4:
            //实勘部门
            
            selectRemindType = DeparmentType;
            selectRemindTypeStr = RealSurveyDeparmentType;
            _selectRemindType = RealSurveyDeparment;
            
            break;
        case 5:
            //实勘人
            
            selectRemindType = PersonType;
            selectRemindTypeStr = RealSurveyPersonType;
            searchRemindPersonVC.departmentKeyId = _departmentID?_departmentID:@"";
            _selectRemindType = RealSurveyPerson;
            
            break;
        case 6:
            //审核人
            selectRemindType = PersonType;
            selectRemindTypeStr = RealSurveyAuditor;
            _selectRemindType = ExaminePerson;
            break;
        default:
            break;
    }
    
    
    //实勘部门
    searchRemindPersonVC.selectRemindType = selectRemindType;
    searchRemindPersonVC.selectRemindTypeStr = selectRemindTypeStr;
    [self.navigationController pushViewController:searchRemindPersonVC
                                         animated:YES];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
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
    if (MODEL_VERSION >= 7.0) {
        
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        
        if (MODEL_VERSION >= 8.0) {
            
            // Prevent the cell from inheriting the Table View's margin settings
            if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
                [cell setPreservesSuperviewLayoutMargins:NO];
            }
            
            // Explictly set your cell's layout margins
            if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
        }
    }
    
}

#pragma mark  - TCPickView
- (void)pickViewRemove
{
    _hasPickView = NO;
}


@end
