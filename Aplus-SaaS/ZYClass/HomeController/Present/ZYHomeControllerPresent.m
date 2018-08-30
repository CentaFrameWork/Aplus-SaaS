//
//  ZYHomeControllerPresent.m
//  Aplus-SaaS
//
//  Created by 陈行 on 2018/8/27.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYHomeControllerPresent.h"
#import "ZYHouseRequestApi.h"


@interface ZYHomeControllerPresent ()

@property (nonatomic, weak) UITableView * tableView;

@end

@implementation ZYHomeControllerPresent

- (void)sendRequest{
    
    ZYHouseRequestApi * api = [[ZYHouseRequestApi alloc] init];
    
    [self.manager request:api];
    
}
- (void)setPresentView:(UIView *)view {
    
    _tableView = (UITableView *)view;
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    self.delegate = self.view;
    
    
}
#pragma mark - Delegate
- (void)respSuc:(CentaResponse *)resData{
    
    if (resData.code != 200) {
        
        
        
    }else{
        
        NSDictionary * dict = resData.data;
        
        ZYHousePageFunc * pageFunc = [ZYHousePageFunc yy_modelWithJSON:dict];
        
        self.dataArray = pageFunc.domains;
        
        [_tableView reloadData];
        
    }
}

- (void)respFail:(CentaResponse *)error{
    
    NSLog(@"-------->%@", error);
    
    
}


#pragma mark - tableView协议代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"UITableViewCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    ZYHousePageFuncItem * item = self.dataArray[indexPath.row];
    
    cell.textLabel.text = item.domain_name;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}


@end
