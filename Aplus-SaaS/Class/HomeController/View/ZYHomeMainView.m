//
//  ZYShareCell.m
//  PanKeTong
//
//  Created by Admin on 2018/9/11.
//  Copyright © 2018年 中原集团. All rights reserved.
//
#import "ZYHomeMainView.h"
#import "ZYHousePageFunc.h"

@interface ZYHomeMainView()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong,nonnull) UITableView *myTableView;


@end

@implementation ZYHomeMainView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _myTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        [_myTableView registerNib:[UINib nibWithNibName:@"ZYShareCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Share"];
        _myTableView.estimatedRowHeight = 44;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.tableFooterView = [UIView new];
        [self addSubview:_myTableView];
        
    }
    return self;
}

- (void)setVmodel:(ZYHomeControllerPresent *)vmodel {
    
    _vmodel = vmodel;
    [self.myTableView reloadData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _vmodel.array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"UITableViewCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(cell == nil){
        
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    
    
    cell.textLabel.text = @"1111";
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

@end
