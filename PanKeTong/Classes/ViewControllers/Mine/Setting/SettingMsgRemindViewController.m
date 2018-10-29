//
//  SettingMsgRemindViewController.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SettingMsgRemindViewController.h"
#import "SettingMsgSwitchCell.h"


@interface SettingMsgRemindViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *_mainTableView;
}

@end

@implementation SettingMsgRemindViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavTitle:@"消息提醒"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
}

#pragma mark - <UITableViewDelegate/UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellString = @"settingMsgSwitchCell";
    
    SettingMsgSwitchCell *settingMsgCell = [tableView dequeueReusableCellWithIdentifier:CellString];
    
    if (!settingMsgCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"SettingMsgSwitchCell"
                                              bundle:nil]
        forCellReuseIdentifier:CellString];
        
        settingMsgCell = [tableView dequeueReusableCellWithIdentifier:CellString];
    }
    
    switch (indexPath.row) {
        case 0:
        {
            settingMsgCell.leftTitleLabel.text = @"房源消息";
            settingMsgCell.leftDetailLabel.text = @"agency房源相关提醒";
        }
            break;
            
        case 1:
        {
            settingMsgCell.leftTitleLabel.text = @"客源消息";
            settingMsgCell.leftDetailLabel.text = @"agency客源相关提醒";
        }
            break;
            
        case 2:
        {
            settingMsgCell.leftTitleLabel.text = @"成交消息";
            settingMsgCell.leftDetailLabel.text = @"agency客户成交相关提醒";
        }
            break;
            
        case 3:
        {
            settingMsgCell.leftTitleLabel.text = @"私信";
            settingMsgCell.leftDetailLabel.text = @"agency私信提醒";
        }
            break;
            
        default:
            break;
    }
    
    return settingMsgCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

@end
