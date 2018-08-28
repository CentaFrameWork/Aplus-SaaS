//
//  ZYHomeMainView.m
//  Aplus-SaaS
//
//  Created by 陈行 on 2018/8/27.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYHomeMainView.h"

@interface ZYHomeMainView()

@property (nonatomic, strong) ZYHomeControllerPresent * present;

@property (nonatomic, strong) NSArray * dataArray;

@end

@implementation ZYHomeMainView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        
        self.present = [[ZYHomeControllerPresent alloc] initWithView:self];
        
        [self.present sendRequest];
        
    }
    
    return self;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.didSelectItemBlock ? self.didSelectItemBlock(indexPath) : nil;
    
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

#pragma mark - ZYHomeMainViewDelegate
- (void)getServerData:(ZYHousePageFunc *)data{
    
    self.dataArray = data.domains;
    
    [self reloadData];
    
}


@end
