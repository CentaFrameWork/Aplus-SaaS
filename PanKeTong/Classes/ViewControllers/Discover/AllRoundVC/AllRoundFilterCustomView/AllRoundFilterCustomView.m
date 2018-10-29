//
//  AllRoundFilterCustomView.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/19.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "AllRoundFilterCustomView.h"
#import "BaseViewController.h"
#import "SaveSearchCell.h"

@implementation AllRoundFilterCustomView
{
    NSMutableArray * _filterInfoArray;     //筛选信息数组
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    // 保存搜索名的通知
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFiledChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:nil];
}

- (void)getTableViewArray:(NSArray *)array
{
    [_filterInfoArray addObjectsFromArray:array];
}

- (IBAction)TheDefaultButtonEvent:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)buttonClick:(UIButton *)sender
{
    [self endEditing:YES];
    [self.delegate getBtnTag:sender.tag FilterName:self.filterNameTextfield.text SettingSwitch:self.TheDefaultButton.selected andSearchName:_searchName];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)creatView
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTapGesture)];
    tapGesture.numberOfTapsRequired = 1; //点击次数
    tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [_backgroundView addGestureRecognizer:tapGesture];
    _mainTableView.delegate=self;
    _mainTableView.dataSource=self;
    _mainTableView.tableFooterView=[[UIView alloc]init];
    
    _filterInfoArray=[NSMutableArray arrayWithCapacity:0];
    self.filterNameTextfield.delegate=self;
    self.filterNameTextfield.returnKeyType=UIReturnKeyDone;
    
    
}

- (void)textFiledChanged:(NSNotification *)obj{
    
    UITextField *textField = (UITextField *)obj.object;
    NSString *resultStr = textField.text;
    
    if ([NSString stringContainsEmoji:resultStr]) {

        textField.text = [resultStr substringToIndex:resultStr.length - 2 ];
        return ;
    }
    
    if (textField.text.length > 15)
    {
        resultStr = [resultStr substringToIndex:15];
        textField.text = resultStr;
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender

{
    
    if ([UIMenuController sharedMenuController]) {
        
        [UIMenuController sharedMenuController].menuVisible = NO;
        
    }
    
    return NO;
    
}

- (void)clickTapGesture
{
    [self endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    NSLog(@"string = %@",string);
    //不支持系统表情的输入
    if ([[[UITextInputMode currentInputMode ]primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
//    
    
    if (range.length == 0 && range.location >= 14)
    {
        NSString *inputString = [NSString stringWithFormat:@"%@%@",
                                 textField.text,
                                 string];
        NSString *resultString = [inputString substringToIndex:15];
        
        textField.text = resultString;
        
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - <TableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filterInfoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseID = @"cell";
    SaveSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[SaveSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.string = _filterInfoArray[indexPath.row];
    return cell.Max;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SaveSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[SaveSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.string = _filterInfoArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
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
