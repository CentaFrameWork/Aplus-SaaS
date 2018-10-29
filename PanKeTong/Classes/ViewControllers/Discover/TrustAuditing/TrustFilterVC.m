//
//  TrustFilterVC.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/19.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "TrustFilterVC.h"
#import "TrustFilterCell.h"
#import "TCPickView.h"
#import "SearchViewController.h"
#import "SearchBuildingVC.h"
#import "SearchRemindPersonViewController.h"

#define Start_Time @"startTime"
#define End_Time @"endTime"
#define searchPropertyNum 1993 // 搜索房号TF

@interface TrustFilterVC ()<UITableViewDelegate,UITableViewDataSource,TCPickViewDelegate,CustomTextFieldDelegate,SearchResultDelegate,SearchRemindPersonDelegate,searchBuildingNameDelagate>{
    UITableView *_tableView;

    BOOL _hasShowDataPicker;

    SearchRemindType _selectRemindType;
}

@end

@implementation TrustFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:@"筛选"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];

    UIButton *commentBtn = [self customBarItemButton:@"   确认"
                                 backgroundImage:nil
                                      foreground:nil
                                             sel:@selector(commentAction:)];

    UIButton *clearBtn = [self customBarItemButton:@"重置  "
                                    backgroundImage:nil
                                         foreground:nil
                                                sel:@selector(clearAtion:)];
    UIBarButtonItem *commentBtnItem = [[UIBarButtonItem alloc]initWithCustomView:commentBtn];
    UIBarButtonItem *clearBtnItem = [[UIBarButtonItem alloc]initWithCustomView:clearBtn];
    self.navigationItem.rightBarButtonItems = @[commentBtnItem,clearBtnItem];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self initSubViews];
}



#pragma mark - 重置

- (void)clearAtion:(UIButton *)btn{
    [CommonMethod resignFirstResponder];

    _estateName = nil;
    _estateKeyId = nil;
    _buildingName = nil;
    _buildingKeyId = nil;
    _startTime = nil;
    _endTime = nil;
    _searchPropertyNum = nil;
    _departEntity = nil;
    _employeeEntity = nil;
    [_tableView reloadData];
}

#pragma mark - 确认

- (void)commentAction:(UIButton *)btn{
    [CommonMethod addLogEventWithEventId:@"A power of a_s s_Function" andEventDesc:@"委托审核筛选成功数量"];
    [self back];
    [self.trustFilterDelegate trustFilterWithEstateName:_estateName
                                          andEstateKeyId:_estateKeyId
                                        andBuildingNames:_buildingName
                                        andBuildingKeyId:_buildingKeyId
                                              andHouseNo:_searchPropertyNum
                                       andEmployeeEntity:_employeeEntity
                                           andDeptEntity:_departEntity
                                             andTimeFrom:_startTime
                                               andTimeTo:_endTime];
}

#pragma mark - UI

- (void)initSubViews{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, - 30, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 34) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.sectionHeaderHeight = 0;
    [self.view addSubview:_tableView];
}

#pragma mark - <UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
    {
        return 3;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2)
    {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 20)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH - 220, 0, 200, 30)];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"注:请先搜索楼盘名称";
        label.textColor = [UIColor redColor];
        [footView addSubview:label];
        return footView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *leftTitleDic = @{
                                   @(0):@[@"楼盘名称",@"栋座单元",@"房号"],
                                   @(1):@[@"开始日期",@"结束日期"],
                                   @(2):@[@"签署部门",@"签署人"]
                                   };
    TrustFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrustFilterCell"];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TrustFilterCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSArray *titleArr = [leftTitleDic objectForKey:@(indexPath.section)];
    cell.leftLabel.text = titleArr[indexPath.row];

    //===================设置默认值======================
    if (indexPath.section == 0 || indexPath.section == 2)
    {
        if (indexPath.row != 2)
        {
            cell.rightTF.text = nil;
            cell.rightTF.placeholder = @"请点击搜索";
            cell.rightTF.enabled = NO;
        }else
        {
            cell.rightTF.text = nil;
            cell.rightTF.placeholder = @"请输入房号";
            cell.rightTF.enabled = YES;
            cell.rightTF.tag = searchPropertyNum;
            cell.rightTF.CustomDelegate = self;
//            cell.rightTF.limitCondition = NUMBERANDLETTER;
            cell.rightTF.limitLength = 10;
            cell.rightTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
    }

    else
    {
        cell.rightTF.enabled = NO;
        if (indexPath.row == 0) {

            if (_startTime.length > 0)
            {
                cell.rightTF.text = _startTime;
            }else
            {
                cell.rightTF.text = nil;
                cell.rightTF.placeholder = @"请选择开始日期";
            }
        }else
        {
            if (_endTime.length > 0)
            {
                cell.rightTF.text = _endTime;
            }else
            {
                cell.rightTF.text = nil;
                cell.rightTF.placeholder = @"请选择结束日期";
            }
        }
    }

    //===================拿到数据之后赋值======================
    if (indexPath.section == 0) // 第一组
    {
        if (indexPath.row == 0)
        {
            // 楼盘
            if (_estateName.length  > 0)
            {
                cell.rightTF.text = _estateName;
            }

        }else if (indexPath.row == 1)
        {
            // 栋座
            if (_buildingName != nil)
            {
                cell.rightTF.text = _buildingName;
            }

        }else{
            // 房号
            if (_searchPropertyNum.length > 0)
            {
                cell.rightTF.text = _searchPropertyNum;
            }
        }
    }

    else if(indexPath.section == 2) // 第三组
    {
        if (indexPath.row == 0) {
            // 签署部门
            if (_departEntity != nil)
            {
                cell.rightTF.text = _departEntity.departmentName;
            }
        }else
        {
            // 签署人
            if (_employeeEntity != nil)
            {
                cell.rightTF.text = _employeeEntity.resultName;
            }
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [CommonMethod resignFirstResponder];

    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            // 楼盘名称
            SearchViewController *vc = [[SearchViewController alloc] init];
            vc.searchType = TopTextSearchType;
            vc.isFromMainPage = NO;
            vc.delegate = self;
            vc.fromModuleStr = From_TrustAuditing;

            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 1)
        {
            // 栋座单元
            if (_estateName.length == 0)
            {
                showMsg(@"请先搜索楼盘名称");
                return;
            }

            SearchBuildingVC *vc = [[SearchBuildingVC alloc] init];
            vc.isFromTrustAuditing = YES;
            vc.searchBuildingNameDelagate = self;
            vc.estateName = _estateName;

            [self.navigationController pushViewController:vc animated:YES];
        }
    }

    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            // 开始日期
            [self showPickerViewWithDateStr:_startTime andType:Start_Time];
        }else
        {
            // 结束日期
            [self showPickerViewWithDateStr:_endTime andType:End_Time];
        }
    }

    else
    {
        SearchRemindPersonViewController *vc = [[SearchRemindPersonViewController alloc] init];
        if (indexPath.row == 0)
        {
            // 签署部门
            _selectRemindType = DeparmentType;
            vc.selectRemindTypeStr = TrustAuditingDeparmentType;

        }else
        {
            // 签署人
            _selectRemindType = PersonType;
            vc.selectRemindTypeStr = TrustAuditingPersonType;
            if (_departEntity.departmentKeyId.length > 0) {
                vc.departmentKeyId = _departEntity.departmentKeyId;
            }
        }
        vc.selectRemindType = _selectRemindType;
        vc.delegate = self;
        vc.isFromOtherModule = YES;

        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - <searchBuildingNameDelagate>

- (void)searchBuildingWithBuildingName:(NSString *)buidingName andBuidingKeyId:(NSString *)buidingKeyId{
    _buildingName = buidingName;
    _buildingKeyId = buidingKeyId;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - <SearchRemindPersonDelegate>

- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem{
    if (_selectRemindType == DeparmentType)
    {
        // 签署部门
        _departEntity = selectRemindItem;
        _employeeEntity = nil;
    }else
    {
        // 签署人
        _employeeEntity = selectRemindItem;
        _departEntity = selectRemindItem;
    }

    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:2];
    [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - <SearchResultDelegate>

- (void)searchResultWithKeyword:(NSString *)keyword andExtendAttr:(NSString *)extendAttr andItemValue:(NSString *)itemvalue andHouseNum:(NSString *)houseNum{
    _estateName = keyword;
    _estateKeyId = itemvalue;
    NSIndexPath *reloadRow = [NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[reloadRow] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)showPickerViewWithDateStr:(NSString *)dateStr andType:(NSString *)typeStr{
    if (_hasShowDataPicker == YES)
    {
        return;
    }

    TCPickView *datePicker;
    if (datePicker == nil)
    {
        NSString *defaultTime = ([typeStr isEqualToString:Start_Time])?_startTime:_endTime;
        NSDate *showDate = defaultTime.length > 0?[NSDate dateFromString:defaultTime]:[NSDate date];
        datePicker = [[TCPickView alloc] initDatePickViewWithDate:showDate mode:UIDatePickerModeDate];
        datePicker.myDelegate = self;
        [self.view addSubview:datePicker];
    }

    [datePicker showPickViewWithResultBlock:^(id result)
    {
        result = [result substringToIndex:10];
        NSDate *startDate;
        NSDate *endDate;
        if ([typeStr isEqualToString:Start_Time])
        {
            if (_endTime.length > 0)
            {
                startDate = [NSDate dateFromString:result];
                endDate = [NSDate dateFromString:_endTime];
            }
        }else
        {
            if (_startTime.length > 0)
            {
                startDate = [NSDate dateFromString:_startTime];
                endDate = [NSDate dateFromString:result];
            }
        }

        if (startDate != nil && endDate != nil)
        {
            NSTimeInterval starTime = startDate.timeIntervalSince1970;
            NSTimeInterval endTime = endDate.timeIntervalSince1970;
            CGFloat days = endTime - starTime;
            // 判断开始时间是否晚于结束时间
            if (days < 0)
            {
                showMsg(@"开始时间不能晚于结束时间!");
                return;
            }
        }

        if ([typeStr isEqualToString:Start_Time])
        {
            _startTime = result;
        }else
        {
            _endTime = result;
        }

        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }];

    _hasShowDataPicker = YES;
}

#pragma mark - <TCPickViewDelegate>

- (void)pickViewRemove{
    _hasShowDataPicker = NO;
    
}

#pragma mark - <CustomTextFieldDelegate>

- (BOOL)customTextFieldShouldBeginEditing:(UITextField *)textField{
    if (_estateName.length == 0)
    {
        showMsg(@"请先搜索楼盘名称");
        return NO;
    }

    if (_buildingName.length == 0)
    {
        showMsg(@"请先搜索栋座单元");
        return NO;
    }
    return YES;
}

- (void)customTextFieldDidChangeNotification{
    
    CustomTextField *tf = [_tableView viewWithTag:searchPropertyNum];
    _searchPropertyNum = tf.text;
}

- (void)customTextFieldDidEndEditing:(UITextField *)textField{
    _searchPropertyNum = textField.text;
}

@end
