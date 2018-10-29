//
//  ModifyPwdViewController.m
//  PanKeTong
//
//  Created by 燕文强 on 16/4/8.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "ModifyPwdViewController.h"
#import "ModifyPwdApi.h"
#import "SSOModifyApi.h"

@interface ModifyPwdViewController ()
{
    SSOModifyApi *_ssoModifyApi;
    NSString *_newPwd;
}

@property (nonatomic,strong)  UIButton *Submit,*ReversedBtn, *PositiveBtn;
@property (nonatomic,strong) UITextField *TextField01 ,*validTextField;



@end

@implementation ModifyPwdViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _ssoModifyApi = [SSOModifyApi new];
    
    [self setNavTitle:@"修改密码"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
     
      rightButtonItem:[self customBarItemButton:@"提交"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(submit)]];
    
    
//    UITextField *newTextField = [_mainTableView viewWithTag:23];
//    UITextField *validTextField = [_mainTableView viewWithTag:24];
//
//    [newTextField.rac_textSignal subscribeNext:^(id x) {
//
//        if (newTextField.text.length > 5) {
//            newTextField.text = [newTextField.text substringToIndex:5];
//        }
//
//    }];
//    [validTextField.rac_textSignal subscribeNext:^(id x) {
//
//        if (validTextField.text.length > 5) {
//            validTextField.text = [validTextField.text substringToIndex:5];
//        }
//    }];
    
    
}
// 解决tableView分割线不到头的问题
-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    if ([_mainTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_mainTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([_mainTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_mainTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];    }         if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
}


- (void)submit
{
    UITextField *oldTextField = [_mainTableView viewWithTag:22];
    UITextField *newTextField = [_mainTableView viewWithTag:23];
    UITextField *validTextField = [_mainTableView viewWithTag:24];

    NSString *oldPwd = oldTextField.text;
    _newPwd = newTextField.text;
    NSString *validPwd = validTextField.text;
    
    if ([NSString isEmptyWithLineSpace:_newPwd])
    {
        showMsg(@"密码不可为空格！");
        return;
    }
    
    if(![_newPwd isEqualToString:validPwd])
    {
        NSLog(@"%@",_newPwd);
        NSLog(@"%@",validPwd);
        showMsg(@"两次输入密码不一致！");
        return;
    }
    
    [self.view endEditing:YES];

    [self showLoadingView:@"正在修改中"];

    ModifyPwdApi *modifyPwdApi = [[ModifyPwdApi alloc] init];
    modifyPwdApi.oldPassword = oldPwd;
    modifyPwdApi.nowPassword = _newPwd;
    modifyPwdApi.nowPassword2 = validPwd;
    [_manager sendRequest:modifyPwdApi];
    NSLog(@"%@",oldPwd);
}

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *modifyPwdCell = @"modifyPwdCell";
    ModifyPwdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:modifyPwdCell];
    
    NSInteger row = indexPath.row;
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"ModifyPwdTableViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:modifyPwdCell];
        cell = [tableView dequeueReusableCellWithIdentifier:modifyPwdCell];
    }
    
    cell.labelForValue.tag = row+22;
    switch (row) {
        case 0:
        {
            cell.labelForKey.text = @"旧密码";
        }
            break;
            
        case 1:
        {
            cell.labelForKey.text = @"新密码";
        }
            break;
            
        case 2:
        {
            cell.labelForKey.text = @"确认密码";
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45.0;
}


#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - <UIAlertViewDelegate>

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.view endEditing:YES];
    [self back];
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    [self hiddenLoadingView];
    
    if ([modelClass isEqual:[AgencyBaseEntity class]])
    {
        NSString *account = [CommonMethod getUserdefaultWithKey:Account];
        
        _ssoModifyApi.empNo = account;
        _ssoModifyApi.passWord = _newPwd;
        [_manager sendRequest:_ssoModifyApi];
        
        //休息1秒等待sso发送完毕
        [NSThread sleepForTimeInterval:1];
        
        //        showMsg(@"重置成功");
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"重置成功！"
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

@end
