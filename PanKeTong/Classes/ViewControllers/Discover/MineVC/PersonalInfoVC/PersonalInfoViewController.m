//
//  PersonalInfoViewController.m
//  PanKeTong
//
//  Created by zhwang on 16/3/30.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "MyHeadImageCell.h"
#import "PersonalInfoCell.h"
#import "WeChatQRCodeCell.h"

@interface PersonalInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *_mainTableView;
    
}

@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavTitle:@"个人资料"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
//    self.tabBarController.tabBar.hidden = YES;
    _mainTableView.tableFooterView=[[UIView alloc]init];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0)
    {
        return 64;
    }else if (indexPath.section == 2 && indexPath.row == 2)
    {
        return 60;
    }
    else
    {
        return 45;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    else if (section == 1)
    {
        return 2;
    }else{
        return 3;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            
            return 0.1;
        }
            break;
            
        default:
            break;
    }
    
    return 10;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * myHeadImageIdentifier = @"myHeadImage";
    static NSString * personalInfoIdentifier = @"personalInfo";
    static NSString * weChatQRCodeIdentifier = @"weChatQRCode";
    
    MyHeadImageCell * myHeadImageCell = [tableView dequeueReusableCellWithIdentifier:myHeadImageIdentifier];
    
    if (!myHeadImageCell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"MyHeadImageCell" bundle:nil]
        forCellReuseIdentifier:myHeadImageIdentifier];
        
        myHeadImageCell =[tableView dequeueReusableCellWithIdentifier:myHeadImageIdentifier];
        
    }
    
    PersonalInfoCell * personalInfo = [tableView dequeueReusableCellWithIdentifier:personalInfoIdentifier];
    if (!personalInfo) {
        
        [tableView registerNib:[UINib nibWithNibName:@"PersonalInfoCell" bundle:nil]
        forCellReuseIdentifier:personalInfoIdentifier];
        personalInfo =[tableView dequeueReusableCellWithIdentifier:personalInfoIdentifier];
        
    }
    
    WeChatQRCodeCell * weChatQRCodeCell = [tableView dequeueReusableCellWithIdentifier:weChatQRCodeIdentifier];
    if (!weChatQRCodeCell) {
        [tableView registerNib:[UINib nibWithNibName:@"WeChatQRCodeCell" bundle:nil]
        forCellReuseIdentifier:weChatQRCodeIdentifier];
        weChatQRCodeCell =[tableView dequeueReusableCellWithIdentifier:weChatQRCodeIdentifier];
        
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        //头像
        return myHeadImageCell;
    }else if (indexPath.section == 2 && indexPath.row == 2){
        //微信二维码
        return weChatQRCodeCell;
    }else{
        //个人资料Cell
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 1) {
                    personalInfo.leftTitleLabel.text = @"姓名";
                    personalInfo.rightDetailLabel.text = @"张晓明";
                }else{
                    personalInfo.leftTitleLabel.text = @"账号";
                    personalInfo.rightDetailLabel.text = @"2016018046";
                }
                break;
            case 1:
                if (indexPath.row == 0) {
                    personalInfo.leftTitleLabel.text = @"角色";
                    personalInfo.rightDetailLabel.text = @"置业顾问";
                }else{
                    personalInfo.leftTitleLabel.text = @"部门";
                    personalInfo.rightDetailLabel.text = @"和平区1组";
                }
                break;
            case 2:
                if (indexPath.row == 0) {
                    personalInfo.leftTitleLabel.text = @"手机";
                    personalInfo.rightDetailLabel.text = @"13041136816";
                }
                if (indexPath.row ==1) {
                    personalInfo.leftTitleLabel.text = @"签名";
                    personalInfo.rightDetailLabel.text = @"坚持就是胜利";
                }
                break;
            default:
                break;
        }
        return personalInfo;
    }
    
    
    return [[UITableViewCell alloc] init];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];

    
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


@end
