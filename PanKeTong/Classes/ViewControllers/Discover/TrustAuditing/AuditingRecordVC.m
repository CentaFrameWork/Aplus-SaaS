//
//  AuditingRecordVC.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/5/23.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AuditingRecordVC.h"
#import "ApprovalRefuseReasonCell.h"

#define ROW_Height 44

@interface AuditingRecordVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
}

@end

@implementation AuditingRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"审核记录"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -30, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 34)
                                              style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}



#pragma mark - <UITableViewDelegate>

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MyCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"审核状态";
        cell.detailTextLabel.textColor = [UIColor redColor];
        if (_regTrustsAuditStatus == AuditAdopt)
        {
            cell.detailTextLabel.text = @"审核通过";
            cell.detailTextLabel.textColor = [UIColor greenColor];
        }else
        {
            cell.detailTextLabel.text = @"审核拒绝";
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
    }

    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"审核人";
        cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = _trustAuditPersonName;
    }else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"审核时间";
        cell.detailTextLabel.textColor = [UIColor blackColor];
        _trustAuditDate = [_trustAuditDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        _trustAuditDate = [_trustAuditDate substringToIndex:10];
        cell.detailTextLabel.text = _trustAuditDate;
    }
    

    return cell;
}

- (NSString *)getTrustStatusWithNum:(int)num
{
    if (num == 1)
    {
        return @"审核通过";
    }
    return @"审核拒绝";
}

@end
