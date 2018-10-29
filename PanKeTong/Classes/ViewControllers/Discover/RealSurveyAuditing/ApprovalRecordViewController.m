//
//  ApprovalRecordViewController.m
//  PanKeTong
//
//  Created by 李慧娟 on 16/7/14.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "ApprovalRecordViewController.h"
#import "ApprovalRecordTableViewCell.h"
#import "ApprovalRefuseReasonCell.h"
#import "RealSurveyStatusEnum.h"

#define ROW_Height 44
#define FIRST_Row 0
#define SECOND_Row 1
#define Third_Row  2

@interface ApprovalRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}

@end

@implementation ApprovalRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self initView];
}

#pragma mark-设置UI

- (void)initView
{
    //导航栏UI
    [self setNavTitle:@"审核记录"
       leftButtonItem:[self customBarItemButton:nil 
                                backgroundImage:nil 
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];

    
    //表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH,ROW_Height * 3) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }

    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}



- (void)back
{
    [self.navigationController popViewControllerAnimated:YES]; 
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ROW_Height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleArr = @[@"   审核状态:",@"   审  核 人:",@"   审核时间:"];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.font = [UIFont fontWithName:FontName size:16.0];
    cell.textLabel.text = titleArr[indexPath.row];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150, 2, 150,40 )];
    label.font = [UIFont fontWithName:FontName size:14.0];
    [cell.contentView addSubview:label];

    if (indexPath.row == FIRST_Row)
    {
        NSInteger status = [_approvalRecordEntity.approvalStatus integerValue];
        if (status == APPROVED)
        {
            label.text = @"审核通过";
            label.textColor = [UIColor greenColor];
        }
        else if (status == UNAPPROVED)
        {
            label.text = @"正在审核";
            label.textColor = [UIColor orangeColor];
        }
        else if (status == REJECT)
        {
            label.text = @"审核拒绝";
            label.textColor = [UIColor redColor];
        }
    }
    else if (indexPath.row == SECOND_Row)
    {
        label.text = _approvalRecordEntity.auditorName;
    }
    else if (indexPath.row == Third_Row)
    {
        label.text = _approvalRecordEntity.time;
    }
      

    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
