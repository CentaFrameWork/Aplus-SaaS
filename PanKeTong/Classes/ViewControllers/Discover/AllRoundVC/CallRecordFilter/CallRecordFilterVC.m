//
//  CallRecordFilterVC.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/19.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "CallRecordFilterVC.h"

#import "SearchRemindPersonViewController.h"
#import "TCPickView.h"
#import "NSDate+Format.h"

@interface CallRecordFilterVC ()<UITableViewDataSource,UITableViewDelegate,TCPickViewDelegate,SearchRemindPersonDelegate>{
    UITableView *_tableView;
    NSArray *_titleArr;
    
    SearchRemindType selectRemindType;
    RemindPersonDetailEntity *_remindPersonDetailEntity1;//部门
    RemindPersonDetailEntity *_remindPersonDetailEntity2;//人员
    BOOL _isTouchSureBtn;//是否点击了确定操作
    BOOL _hasShowDataPicker;//是否已显示
}

@end

@implementation CallRecordFilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavTitle:@"筛选"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    
    UIButton *sureBtn = [self customBarItemButton:@"   确定"
                                  backgroundImage:nil
                                       foreground:nil
                                              sel:@selector(sureAction:)];
    
    UIButton *resetBtn = [self customBarItemButton:@"重置  "
                                   backgroundImage:nil
                                        foreground:nil
                                               sel:@selector(resetAction:)];
    UIBarButtonItem *resetItem = [[UIBarButtonItem alloc]initWithCustomView:resetBtn];
    UIBarButtonItem *sureItem = [[UIBarButtonItem alloc]initWithCustomView:sureBtn];
    self.navigationItem.rightBarButtonItems = @[sureItem,resetItem];
    
    _titleArr = @[@[@"部门",@"人员"],@[@"开始时间",@"结束时间"]];
    
    if (_startTimeShow == nil && _endTimeShow == nil) {
        NSDate *nowDate = [NSDate date];
        NSDate *startDay = [NSDate dateWithTimeInterval:-24*60*60*30 sinceDate:nowDate];//前30天
        
        if ([NSString isNilOrEmpty:_startTimeShow]) {
            _startTimeShow = [NSDate stringWithSimpleDate:startDay];
        }
        if ([NSString isNilOrEmpty:_endTimeShow]) {
            _endTimeShow = [NSDate stringWithSimpleDate:nowDate];
        }
    }
    
    [self initView];
}

#pragma mark-<确定>
- (void)sureAction:(UIButton *)btn
{
    _isTouchSureBtn = YES;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:OnlyDateFormat];
    NSDate *startDate = [df dateFromString:_startTimeShow];
    NSDate *endDate = [df dateFromString:_endTimeShow];
    NSTimeInterval time30Days = 30 * 24 * 60 * 60;
    NSTimeInterval starTime = startDate.timeIntervalSince1970;
    NSTimeInterval endTime = endDate.timeIntervalSince1970;
    CGFloat days = endTime - starTime;
    
    //判断开始时间是否晚于结束时间
    if (days < 0) {
        showMsg(@"开始时间不能晚于结束时间!");
        return;
    }
    
    //判断开始时间和结束时间是否大于一个月
    if (days > time30Days) {
        showMsg(@"为了保证查询速度，请查询少于30天的数据!");
        return;
    }

    if ([self.delegate respondsToSelector:@selector(commitDataWithDepartment:withEmployee:withStartTime:withEndTime:)])
    {
        [self.delegate commitDataWithDepartment:_remindPersonDetailEntity1 withEmployee:_remindPersonDetailEntity2 withStartTime:_startTimeShow withEndTime:_endTimeShow];
    }
    
    [self back];
}

- (void)back
{
    if (!_isTouchSureBtn)
    {
        //没做任何操作的返回
        [self.delegate commitDataWithDepartment:nil withEmployee:nil withStartTime:_startTimeShow withEndTime:_endTimeShow];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark-<重置>
- (void)resetAction:(UIButton *)btn{
    _remindPersonDetailEntity1 = nil;
    _remindPersonDetailEntity2 = nil;
    NSDate *nowDate = [NSDate date];
    NSDate *startDay = [NSDate dateWithTimeInterval:-24*60*60*30 sinceDate:nowDate];//前30天
    _startTimeShow = [NSDate stringWithSimpleDate:startDay];
    _endTimeShow = [NSDate stringWithSimpleDate:nowDate];

    [_tableView reloadData];
    
}


#pragma mark-<设置UI>
- (void)initView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    [self.view addSubview:_tableView];
}

#pragma mark-<TCPickViewDelegate>
//点击取消按钮之后
- (void)pickViewRemove{
    _hasShowDataPicker = NO;
}


#pragma mark-<UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *iden = @"Mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Mycell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    NSArray *arr = _titleArr[indexPath.section];
    cell.textLabel.text = arr[indexPath.row];
    
    
    UILabel *detailLabel = [cell.contentView viewWithTag:100];
    if (detailLabel == nil) {
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH - 250, 7, 200, 30)];
        detailLabel.textColor = [UIColor blackColor];
        detailLabel.tag = 100;
        detailLabel.font = [UIFont systemFontOfSize:14.0];
        detailLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:detailLabel];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            detailLabel.text = _remindPersonDetailEntity1.departmentName;
        }else{
            detailLabel.text = _remindPersonDetailEntity2.resultName;
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            detailLabel.text = _startTimeShow ?_startTimeShow :@"";
        }else{
            detailLabel.text = _endTimeShow ? _endTimeShow : @"";
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        SearchRemindPersonViewController *vc = [[SearchRemindPersonViewController alloc] init];
        if (indexPath.row == 0) {
            //部门
            selectRemindType = DeparmentType;
            vc.selectRemindTypeStr = CallRecordDeparmentType;
        }else{
            //人员
            if (_remindPersonDetailEntity1.departmentKeyId.length > 0) {
                vc.departmentKeyId = _remindPersonDetailEntity1.departmentKeyId;
            }
            selectRemindType = PersonType;
            vc.selectRemindTypeStr = CallRecordPersonType;
        }
        
        vc.selectRemindType = selectRemindType;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        if (indexPath.row == 0) {
            //开始时间
            if (_hasShowDataPicker == YES) {
                return;
            }
            TCPickView *datePicker;
            if (datePicker == nil) {
                datePicker = [[TCPickView alloc] initDatePickViewWithDate:[NSDate dateFromString:_startTimeShow] mode:UIDatePickerModeDate];
                datePicker.myDelegate = self;
                [self.view addSubview:datePicker];
            }
            
            [datePicker showPickViewWithResultBlock:^(id result) {
                NSLog(@"%@",result);
                _startTimeShow = result;
                _startTimeShow = [_startTimeShow substringToIndex:_startTimeShow.length - 6];
                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            _hasShowDataPicker = YES;
            
        }else{
            //结束时间
            if (_hasShowDataPicker == YES) {
                return;
            }
            
            TCPickView *datePicker;
            if (datePicker == nil) {
                datePicker = [[TCPickView alloc] initDatePickViewWithDate:[NSDate dateFromString:_endTimeShow] mode:UIDatePickerModeDate];
                datePicker.myDelegate = self;
                [self.view addSubview:datePicker];
            }
            
            [datePicker showPickViewWithResultBlock:^(id result) {
                NSLog(@"%@",result);
                _endTimeShow = result;
                _endTimeShow = [_endTimeShow substringToIndex:_endTimeShow.length - 6];
                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            _hasShowDataPicker = YES;
            
        }
    }
}



#pragma mark-<SearchRemindPersonDelegate>
- (void)selectRemindPersonOrDepWithItem:(RemindPersonDetailEntity *)selectRemindItem{
    
    NSIndexPath *indexPth;
    if (selectRemindType == DeparmentType) {
        //部门改变，人员置空
        indexPth = [NSIndexPath indexPathForRow:0 inSection:0];
        _remindPersonDetailEntity1 = selectRemindItem;
        _remindPersonDetailEntity2 = nil;
    }else{
        //人员改变，部门联动
        indexPth = [NSIndexPath indexPathForRow:1 inSection:0];
        _remindPersonDetailEntity2 = selectRemindItem;
        _remindPersonDetailEntity1 = selectRemindItem;
    }
    [_tableView reloadData];
}


@end
