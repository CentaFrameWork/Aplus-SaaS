//
//  TimeScreenViewController.m
//  PanKeTong
//
//  Created by zhwang on 16/4/22.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "TimeScreenViewController.h"
#import "NewOpeningCell.h"
#import "TCPickView.h"
#import "CheckScopeCell.h"
#import "DepartmentInfoResultEntity.h"
#import "NSDate+Format.h"

#define selfDepartmentBtnBaseTag    1000        //选中本部的tag
#define selectAllBtnBaseTag         1001        //选中全部的tag

static NSString * const TimeScreenViewController_ReferScope = @"ReferScope";
static NSString * const TimeScreenViewController_ReferScope_Native = @"Native";
static NSString * const TimeScreenViewController_ReferScope_All = @"All";

static NSString * const TimeScreenViewController_Time_BeginTime = @"beginTime";
static NSString * const TimeScreenViewController_Time_EndTime = @"endTime";



@interface TimeScreenViewController ()<UITableViewDataSource,UITableViewDelegate,TCPickViewDelegate>
{
    __weak IBOutlet UITableView *_mainTableView;
    DataBaseOperation * _dataBase;
    DepartmentInfoResultEntity *_departmentInfoEntity;
    NSString *_followDeptKeyId; //部门Id
	
	CheckScopeCell *checkScopeCell;
    
    BOOL _isUpdatePage;         //是否修改了该页面
    BOOL _hasPickView;         //是否页面上存在时间选择器

}

@end

@implementation TimeScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}
-(void)initView
{
    [self setNavTitle:@"时间筛选"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"确认"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(commitClick)]];
}

-(void)initData
{
    _isUpdatePage = NO;
    _hasPickView = NO;
    
    _dataBase = [DataBaseOperation sharedataBaseOperation];
    _departmentInfoEntity = [_dataBase selectAgencyUserInfo];
    
    //默认为本部
    _followDeptKeyId = _departmentInfoEntity.identify.departId;
    //初始化开始时间和结束时间
	NSDate *lastMouthDate = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*30];
	if (_startTime.length == 0) {
		 _startTime = [CommonMethod formatDateStrFromDate:lastMouthDate];
	}
	if (_endTime.length == 0) {
		_endTime = [CommonMethod formatDateStrFromDate:[NSDate date]];
	}
	
}

-(void)commitClick {
    if (!_isUpdatePage) {
        //没有修改页面直接返回
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
//    //选择的是全部
//    if (_isNative == NO) {
        _followDeptKeyId = @"";
//    }

    NSDate *startDate = [NSDate dateFromString:_startTime];
    NSDate *endDate = [NSDate dateFromString:_endTime];
    NSTimeInterval time30Days = 30 * 24 * 60 * 60;
    NSTimeInterval starTime = startDate.timeIntervalSince1970;
    NSTimeInterval endTime = endDate.timeIntervalSince1970;
    CGFloat days = endTime - starTime;

    if (days < 0)
    {
        showMsg(@"开始时间不能大于结束时间");
        return;
    }

    if (days > time30Days)
    {
        showMsg(@"为了保证查询速度，请查询少于30天的数据！");
        return;
    }

    if (_block)
    {
        _block(_startTime,_endTime,_followDeptKeyId,_isNative);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  两个按钮的点击事件
 *
 */
-(void)selectButtonClick:(UIButton*)button
{
	NSString *value = @"";
    if (button.tag == selfDepartmentBtnBaseTag) {
        _followDeptKeyId = _departmentInfoEntity.identify.departId;
        [button setBackgroundImage:[UIImage imageNamed:@"button_select_Img"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIButton*button =[self.view viewWithTag:selectAllBtnBaseTag];
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:LITTLE_GRAY_COLOR forState:UIControlStateNormal];
		
		//插入选择条件到数据库
		value = TimeScreenViewController_ReferScope_Native;
		_isNative = YES;
        
    }else if(button.tag == selectAllBtnBaseTag){
        _followDeptKeyId = @"";
        [button setBackgroundImage:[UIImage imageNamed:@"button_select_Img"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIButton*button =[self.view viewWithTag:selfDepartmentBtnBaseTag];
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button setTitleColor:LITTLE_GRAY_COLOR forState:UIControlStateNormal];
		
		//插入选择条件到数据库
		value = TimeScreenViewController_ReferScope_All;
		_isNative = NO;
    }
    _isUpdatePage = YES;
}

#pragma mark UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *newOpeningCellIdentifier = @"newOpeningCell";
    NSString *checkScopeCellIdentifier = @"checkScopeCell";
    NewOpeningCell *newOpeningCell = [tableView dequeueReusableCellWithIdentifier:newOpeningCellIdentifier];
	checkScopeCell = [tableView dequeueReusableCellWithIdentifier:checkScopeCellIdentifier];
    if (!newOpeningCell) {
        [tableView registerNib:[UINib nibWithNibName:@"NewOpeningCell" bundle:nil] forCellReuseIdentifier:newOpeningCellIdentifier];
        newOpeningCell = [tableView dequeueReusableCellWithIdentifier:newOpeningCellIdentifier];
    }
    if (!checkScopeCell) {
        [tableView registerNib:[UINib nibWithNibName:@"CheckScopeCell" bundle:nil] forCellReuseIdentifier:checkScopeCellIdentifier];
        checkScopeCell = [tableView dequeueReusableCellWithIdentifier:checkScopeCellIdentifier];
    }
    switch (indexPath.section) {
        //时间部分
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
					newOpeningCell.leftTitleLabel.text = @"开始时间";
					
					if (_startTime.length == 0) {
						newOpeningCell.rightValueLabel.text = @"请选择开始时间";
					}else{
						newOpeningCell.rightValueLabel.text = _startTime;
					}
					
                    return newOpeningCell;
                }
                    break;
                case 1:
                {
					newOpeningCell.leftTitleLabel.text = @"结束时间";
					
					if (_endTime.length == 0) {
						newOpeningCell.rightValueLabel.text = @"请选择结束时间";
					}else{
						newOpeningCell.rightValueLabel.text = _endTime;
					}
					
                    return newOpeningCell;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        //查看房源范围部分
        case 1:
        {
			[checkScopeCell.selectAllBtn addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
			[checkScopeCell.selfDepartmentBtn addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
			
			if (_isNative) {
				//本部
				_followDeptKeyId = _departmentInfoEntity.identify.departId;
				[checkScopeCell.selfDepartmentBtn setBackgroundImage:[UIImage imageNamed:@"button_select_Img"] forState:UIControlStateNormal];
				[checkScopeCell.selfDepartmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
				
				[checkScopeCell.selectAllBtn setBackgroundImage:nil forState:UIControlStateNormal];
				[checkScopeCell.selectAllBtn setTitleColor:LITTLE_GRAY_COLOR forState:UIControlStateNormal];
				
			}else{
				//全部
				_followDeptKeyId = _departmentInfoEntity.identify.departId;
				[checkScopeCell.selectAllBtn setBackgroundImage:[UIImage imageNamed:@"button_select_Img"] forState:UIControlStateNormal];
				[checkScopeCell.selectAllBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
				
				[checkScopeCell.selfDepartmentBtn setBackgroundImage:nil forState:UIControlStateNormal];
				[checkScopeCell.selfDepartmentBtn setTitleColor:LITTLE_GRAY_COLOR forState:UIControlStateNormal];
			}

            return checkScopeCell;
        }
            break;
        default:
            break;
    }
    
    return [UITableViewCell new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 60;
    }
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UILabel * label=[[UILabel alloc]init];
        label.text=@"参考房源范围";
        label.textColor=LITTLE_BLACK_COLOR;
        label.font=[UIFont fontWithName:FontName size:14.0];
        label.textAlignment=NSTextAlignmentCenter;
        return label;
    }else{
        return nil;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }else{
        return 50;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_hasPickView) {
        return;
    }
    
    if (indexPath.section == 1) {
        return;
    }
	
	if (indexPath.row == 0) {
        
        _hasPickView = YES;
        
		NSDate *aDate = [NSDate dateFromString:_startTime];
        TCPickView *pickView = [[TCPickView alloc] initDatePickViewWithDate:aDate mode:UIDatePickerModeDate];
        pickView.myDelegate = self;
        [pickView showPickViewWithResultBlock:^(id result) {
			
			NSString *time = [CommonMethod subTime:result];
            NSString *oldtime = [NSDate stringWithSimpleDate:aDate];
            if(![time isEqualToString:oldtime])
            {
                _isUpdatePage = YES;
            }
            
            _hasPickView = NO;
            
			_startTime = time;
			[_mainTableView reloadData];
		}];
	}else if (indexPath.row == 1){
        _hasPickView = YES;
        
		NSDate *aDate = [NSDate dateFromString:_endTime];
		TCPickView *pickView = [[TCPickView alloc] initDatePickViewWithDate:aDate mode:UIDatePickerModeDate];
        pickView.myDelegate = self;
        [pickView showPickViewWithResultBlock:^(id result) {
            
            NSString *time = [CommonMethod subTime:result];
            NSString *oldtime = [NSDate stringWithSimpleDate:aDate];
            if(![time isEqualToString:oldtime])
            {
                _isUpdatePage = YES;
            }
            
            _hasPickView = NO;
			_endTime = time;
            
			[_mainTableView reloadData];
		}];
	}
	
	
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MODEL_VERSION >= 7.0) {
        
        // Remove seperator inset
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
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

#pragma mark - TCPickViewDelegate
- (void)pickViewRemove
{
     _hasPickView = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
