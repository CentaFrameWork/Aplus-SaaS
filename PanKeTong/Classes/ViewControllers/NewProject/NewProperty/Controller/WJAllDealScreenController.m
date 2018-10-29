//
//  WJAllDealScreenController.m
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/22.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "WJAllDealScreenController.h"
#import "WJMyDealScreenCell.h"
#import "TCPickView.h"
#import "CustomActionSheet.h"
#import "RealSurveyAuditingSearchVC.h"
#import "SearchRemindPersonViewController.h"
#import "WJDealProgressController.h"

//判断字段时候为空的情况
#define IfNullToString(x)  ([(x) isEqual:[NSNull null]]||(x)==nil||[(x) isEqualToString:@"(null)"])?@"":TEXTString(x)
#define TEXTString(x) [NSString stringWithFormat:@"%@",x]  //转换为字符串
@interface WJAllDealScreenController ()<UITableViewDelegate,UITableViewDataSource,doneSelect,RealSurveySearchDelegate,SearchRemindPersonDelegate,WJDealProgressDelegate,SearchRemindPersonDelegate,TCPickViewDelegate>
{
    UITableView *_mainTableView;        //表视图
    NSMutableArray * _dataSource;       //数据源
    
    NSInteger _selectType;              //选中类型标示

    NSString *_startTime;               //开始时间
    NSString *_endTime;                 //结束时间
    NSString *_type;                    //交易类型
    NSString *_typeID;                    //交易类型

    
    NSString *_progressCode;                //成交进度
    NSString *_progressName;                //成交进度
    
    NSString *_dealPeople;              //成交人
    NSString *_dealPeopleId;              //成交人ID

    NSString *_resultsPeople;           //业绩分配人
    NSString *_resultsPeopleId;           //业绩分配人ID
    
    NSString *_buildingNameKey;         //楼盘名称
    NSString *_buildingNameValue;       //楼盘名称id
    
    NSString *_unitNameKey;             //栋座单元名称
    NSString *_unitNamevalue;           //栋座单元id
    
    BOOL _isSelectLookWithPeopleId;                 //点击选择成交人还是业绩分配人

}
@property (nonatomic, strong) NSMutableDictionary *parameterDic;//参数字典

@property (nonatomic, strong) NSArray * transactionTypeArr;

@end

@implementation WJAllDealScreenController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}


#pragma mark -- 初始化视图
-(void)initView
{
    [self setNavTitle:@"筛选"
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
    
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - APP_NAV_HEIGHT)
                                                  style:UITableViewStyleGrouped];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;

    [self.view addSubview:_mainTableView];
}

#pragma mark -- 初始化数据
- (void)inittitle{
    _type = @"不限";
    _typeID = @"";
    
    _startTime = @"请选择";
    
    _endTime = @"请选择";
    
    _buildingNameKey = @"请点击搜索";
    _buildingNameValue = @"";
    
    _unitNameKey = @"请点击搜索";
    _unitNamevalue = @"";
    
    _progressName = @"请选择";
    _progressCode = @"";
    
    _dealPeople = @"请选择";
    _dealPeopleId = @"";
    
    _resultsPeople = @"请选择";
    _resultsPeopleId = @"";
}

#pragma mark -- 重置事件
- (void)againSetClick {
    [self inittitle];
    [_mainTableView reloadData];
}

#pragma mark -- 确定提交按钮
- (void)commitClick {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (_isMyDeal) {
        [dic setValue:@"13" forKey:@"PropertyCategory"];
    }else {
        [dic setValue:@"14" forKey:@"PropertyCategory"];
    }
    
    [dic setValue:IfNullToString(_buildingNameValue) forKey:@"EstateNames"];
    [dic setValue:IfNullToString(_unitNamevalue) forKey:@"BuildingNames"];
    [dic setValue:IfNullToString(_startTime) forKey:@"StartTime"];
    [dic setValue:IfNullToString(_endTime) forKey:@"EndTime"];
    [dic setValue:IfNullToString(_typeID) forKey:@"TransactionType"];
    [dic setValue:IfNullToString(_dealPeople) forKey:@"TransactionUserName"];
    [dic setValue:IfNullToString(_progressCode) forKey:@"ContractType"];
    [dic setValue:IfNullToString(_resultsPeople) forKey:@"PerformanceUserName"];
    
    ZYDealScreen * dealScreen = [[ZYDealScreen alloc] init];
    
    ZYCodeName * progress = [[ZYCodeName alloc] init];
    progress.code = _progressCode;
    progress.name = _progressName;
    
    dealScreen.selectType = _selectType;
    dealScreen.startTime = _startTime;
    dealScreen.endTime = _endTime;
    dealScreen.type = _type;
    dealScreen.typeID = _typeID;
    dealScreen.progress = progress;
    dealScreen.dealPeople = _dealPeople;
    dealScreen.dealPeopleId = _dealPeopleId;
    dealScreen.resultsPeople = _resultsPeople;
    dealScreen.resultsPeopleId = _resultsPeopleId;
    dealScreen.buildingNameKey = _buildingNameKey;
    dealScreen.buildingNameValue = _buildingNameValue;
    dealScreen.unitNameKey = _unitNameKey;
    dealScreen.unitNamevalue = _unitNamevalue;
    
    self.ensureDealScreenBlock ? self.ensureDealScreenBlock(dic, dealScreen) : nil;
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -- 下拉刷新
- (void)headerRefreshMethod
{
    [_dataSource removeAllObjects];
    [_mainTableView reloadData];
    [self showLoadingView:nil];
}



#pragma mark - tableView代理事件
/**
 * tableView的分区数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


/**
 * tableView分区里的行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_isMyDeal){
        return 6;

    }else {
        return 8;

    }
    
}

/**
 * tableViewCell的相关属性
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"WJContactCell";
    
    //出列可重用的cell
    WJMyDealScreenCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[WJMyDealScreenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    //修改cell属性，使其在选中时无色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *leftTitle = @[@"楼盘名称",@"栋座单元",@"开始时间", @"结束时间",@"交易类型",@"成交进度",@"成交人",@"业绩分配人"];
    NSArray *rightTitle = @[_buildingNameKey,_unitNameKey,_startTime,_endTime,_type,_progressName,_dealPeople,_resultsPeople];
    cell.leftLabel.text = leftTitle[indexPath.row];
    cell.rightLabel.text = rightTitle[indexPath.row];
    cell.rightImg.image = [UIImage imageNamed:@"icon_jm_right_arrow"];
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
    
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 10)];
    return label;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 0)];
    
    return label;
}
/**
 * tableViewCell的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

/**
 * 分区头的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    return 10;
}

/**
 * 分区脚的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}
/**
 * tableViewCell的点击事件
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    __block typeof(self) weakSelf = self;
    //楼盘名称
    RealSurveyAuditingSearchVC *search = [[RealSurveyAuditingSearchVC alloc]initWithNibName:@"RealSurveyAuditingSearchVC"   bundle:nil];
    search.delegate = self;
    search.searchType = TopTextSearchType;
    
    
    switch (indexPath.row) {
            case 0:
            //楼盘
            search.searchBuildingType = EstateSelectTypeEnum_ESTATENAME;
            [self.navigationController pushViewController:search animated:YES];
            return;
            
            break;
            case 1:
            //陈行修改105bug进行添加判断
            if (_buildingNameValue.length == 0) {
                showMsg(@"请先搜索楼盘名称");
                return;
            }
            search.isNoShowHistoryRecord = YES;
            search.estateBuildingName = _buildingNameKey;
            search.searchBuildingType = EstateSelectTypeEnum_BUILDINGBELONG;
            [self.navigationController pushViewController:search animated:YES];
            
            return;
            break;
    }
    if (indexPath.row == 2){
        TCPickView *pickView;
        NSDate *defaultDate;
        if (pickView == nil)
        {
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:OnlyDateFormat];
            defaultDate = [df dateFromString:_startTime];
            
            pickView = [[TCPickView alloc] initDatePickViewWithDate:defaultDate mode:UIDatePickerModeDate];
            pickView.myDelegate = self;
            [self.view addSubview:pickView];
        }
        
        [pickView showPickViewWithResultBlock:^(id result)
         {
             NSString *str1 = [result substringToIndex:10];
             
             if ([weakSelf isGreaterThanWithEndTime:_endTime andStartTime:str1]) {
                 
                 _startTime = [NSString stringWithFormat:@"%@",str1];
                 [_mainTableView reloadData];
                 
             }else{
                 
                 showMsg(@"结束时间必须大于开始时间");
                 
             }
             
         }];
    }
    if(indexPath.row == 3){
        TCPickView *pickView;
        NSDate *defaultDate;
        if (pickView == nil)
        {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:OnlyDateFormat];
            defaultDate = [df dateFromString:_endTime];
            
            pickView = [[TCPickView alloc] initDatePickViewWithDate:defaultDate mode:UIDatePickerModeDate];
            pickView.myDelegate = self;
            [self.view addSubview:pickView];
        }
        
        [pickView showPickViewWithResultBlock:^(id result)
         {
             
             NSString *str1 = [result substringToIndex:10];
             
             if ([weakSelf isGreaterThanWithEndTime:str1 andStartTime:_startTime]) {
                 
                 _endTime = [NSString stringWithFormat:@"%@",str1];
                 [_mainTableView reloadData];
                 
             }else{
                 
                 showMsg(@"结束时间必须大于开始时间");
                 
             }
             
         }];
    }
    if (indexPath.row == 4){
        
        __block typeof(self) weakSelf = self;
        
        [NewUtils popoverSelectorTitle:@"交易类型" listArray:self.transactionTypeArr theOption:^(NSInteger optionValue) {
            
            [weakSelf selectTransactionTypeWithIndex:optionValue];
            
        }];
        
    }
    if (indexPath.row == 5){
        WJDealProgressController *progressVC = [[WJDealProgressController alloc] init];
        progressVC.delegate  =self;
        [self.navigationController pushViewController:progressVC animated:YES];
    }
    if (indexPath.row == 6) {
        _isSelectLookWithPeopleId  = YES;
        SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc] init];
        
        //人员
//        searchRemindPersonVC.isExceptMe = YES;
        searchRemindPersonVC.isFromOtherModule = YES;
        searchRemindPersonVC.selectRemindType = PersonType;
        searchRemindPersonVC.delegate = self;
        [self.navigationController pushViewController:searchRemindPersonVC animated:YES];
    }
    if (indexPath.row == 7) {
        _isSelectLookWithPeopleId  = NO;
        SearchRemindPersonViewController *searchRemindPersonVC = [[SearchRemindPersonViewController alloc] init];
        
        //人员
//        searchRemindPersonVC.isExceptMe = YES;
        searchRemindPersonVC.isFromOtherModule = YES;
        searchRemindPersonVC.selectRemindType = PersonType;
        searchRemindPersonVC.delegate = self;
        [self.navigationController pushViewController:searchRemindPersonVC animated:YES];
    }
}

#pragma mark - <SearchRemindPersonDelegate>
- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem
{
    if (_isSelectLookWithPeopleId) {
    
        NSIndexPath *indexPth = [NSIndexPath indexPathForRow:6 inSection:0];
        _dealPeopleId = selectRemindItem.resultKeyId;
        _dealPeople = selectRemindItem.resultName;
        [_mainTableView reloadRowsAtIndexPaths:@[indexPth] withRowAnimation:UITableViewRowAnimationNone];
    }else{
       
        NSIndexPath *indexPth = [NSIndexPath indexPathForRow:7 inSection:0];
        _resultsPeopleId = selectRemindItem.resultKeyId;
        _resultsPeople = selectRemindItem.resultName;
        [_mainTableView reloadRowsAtIndexPaths:@[indexPth] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)returnText:(NSString *)text{
    
    if (_isSelectLookWithPeopleId) {
        NSIndexPath *indexPth = [NSIndexPath indexPathForRow:6 inSection:0];
        _dealPeople = text;
        [_mainTableView reloadRowsAtIndexPaths:@[indexPth] withRowAnimation:UITableViewRowAnimationNone];
    }else{
        NSIndexPath *indexPth = [NSIndexPath indexPathForRow:7 inSection:0];
        _resultsPeople = text;
        [_mainTableView reloadRowsAtIndexPaths:@[indexPth] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

#pragma mark - WJDealProgressDelegate
- (void)selectProgressSuccss:(ZYCodeName *)progress{
    
    _progressCode = progress.code;
    _progressName = progress.name;
    
    [_mainTableView reloadData];
    
}


#pragma mark - <RealSurveySearchDelegate>
- (void)realSurveySearchWithKey:(NSString *)key andValue:(NSString *)value andSearchType:(NSInteger)searchType
{
    if (searchType == EstateSelectTypeEnum_ESTATENAME) {
        _buildingNameKey = key;
        _buildingNameValue = key;
//        _buildingNameValue = value;
    }
    
    if (searchType == EstateSelectTypeEnum_BUILDINGBELONG){
        _unitNameKey = key;
        _unitNamevalue = key;
//        _unitNamevalue = value;

    }
    
    [_mainTableView reloadData];
}




#pragma mark - private
- (BOOL)isGreaterThanWithEndTime:(NSString *)endTime andStartTime:(NSString *)startTime{
    
    if (endTime.length == 0 || startTime.length == 0 || [endTime isEqualToString:@"请选择"] || [startTime isEqualToString:@"请选择"]) {
        
        return YES;
        
    }
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate * startTimeDate = [dateFormatter dateFromString:startTime];
    
    NSDate * endTimeDate = [dateFormatter dateFromString:endTime];
    
    NSTimeInterval timeInterval = [endTimeDate timeIntervalSinceDate:startTimeDate];
    
    return timeInterval >= 0;
    
}

#pragma mark-<doneSelect>
- (void)selectTransactionTypeWithIndex:(NSInteger)index{
    
    _type = self.transactionTypeArr[index];
    
    _typeID = [NSString stringWithFormat:@"%@", index == 0 ? @"" : @(index)];
    
    [_mainTableView reloadData];
    
}

#pragma mark - setter
- (void)setDealScreen:(ZYDealScreen *)dealScreen{
    _selectType = dealScreen.selectType;
    _startTime = dealScreen.startTime ? : @"请选择";
    _endTime = dealScreen.endTime ? : @"请选择";
    _type = dealScreen.type ? : @"不限";
    _typeID = dealScreen.typeID;
    _progressName = dealScreen.progress.name ? : @"请选择";
    _progressCode = dealScreen.progress.code;
    _dealPeople = dealScreen.dealPeople ? : @"请选择";
    _dealPeopleId = dealScreen.dealPeopleId;
    _resultsPeople = dealScreen.resultsPeople ? : @"请选择";
    _resultsPeopleId = dealScreen.resultsPeopleId;
    _buildingNameKey = dealScreen.buildingNameKey ? : @"请点击搜索";
    _buildingNameValue = dealScreen.buildingNameValue;
    _unitNameKey = dealScreen.unitNameKey ? : @"请点击搜索";
    _unitNamevalue = dealScreen.unitNamevalue;
    
}

#pragma mark - getter
- (NSArray *)transactionTypeArr{
    
    if (!_transactionTypeArr) {
        
        _transactionTypeArr = @[@"不限", @"售", @"租"];
        
    }
    
    return _transactionTypeArr;
    
}

#pragma mark - 系统协议
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
