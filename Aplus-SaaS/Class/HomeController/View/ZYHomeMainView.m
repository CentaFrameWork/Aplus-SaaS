//
//  ZYHomeMainView.m
//  Aplus-SaaS
//
//  Created by 陈行 on 2018/8/27.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYHomeMainView.h"
#import "ZYHousePageFunc.h"

@interface ZYHomeMainView()

@property (nonatomic, strong) NSArray * dataArray;

@end

@implementation ZYHomeMainView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        
        self.delegate = self;
        
    }
    
    return self;
}


- (void)setViewData:(NSObject *)data {
    
    ZYHousePageFunc * pageFunc = (ZYHousePageFunc*)data;
    
    self.dataArray = pageFunc.domains;
    
    [self reloadData];
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
    
    self.itemDidSelctedBlock ? self.itemDidSelctedBlock(indexPath) : nil;
    
}

@end
