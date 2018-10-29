//
//  APSortView.m
//  APlus
//
//  Created by 张旺 on 2017/11/10.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "APSortView.h"
#import "APSortTableViewCell.h"

#define Cell_HEIGHT 41.f

@interface APSortView ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_mainTableView;
    NSArray *_dataArr;
    NSString *_selectData;
}

@end

@implementation APSortView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [JMWindow addSubview:self];
        UIControl *backgroundControl = [[UIControl alloc]initWithFrame:self.bounds];
        backgroundControl.backgroundColor = [UIColor clearColor];
        [backgroundControl addTarget:self action:@selector(hideSortView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgroundControl];
        
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, APP_SCREEN_HEIGHT, APP_SCREEN_WIDTH, 0) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.scrollEnabled = NO;
        _mainTableView.rowHeight = Cell_HEIGHT;
        [self addSubview:_mainTableView];
    }
    return self;
}

- (void)showSortViewWithSortDataArr:(NSArray *)sortDataArr
                      andSelectData:(NSString *)selectData
                   andCompleteBlock:(SelectSortCompleteBlock)completeBlock
{
    self.block = completeBlock;
    _mainTableView.height = Cell_HEIGHT * sortDataArr.count;
    _dataArr = sortDataArr;
    _selectData = selectData;
    [_mainTableView reloadData];
    
    WS(weakSelf);
    [UIView animateWithDuration:0.25 animations:^{
        
        //CGFloat bottomHeight = 0;
        //_mainTableView.frame = CGRectMake(0, APP_SCREEN_HEIGHT - Cell_HEIGHT * _dataArr.count - BOTTOM_SAFE_HEIGHT, APP_SCREEN_WIDTH, Cell_HEIGHT * _dataArr.count + BOTTOM_SAFE_HEIGHT);
        
        //慧娟提醒修改为此代码，修复筛选按钮iPhoneX的显示问题
        CGFloat height = Cell_HEIGHT * _dataArr.count + BOTTOM_SAFE_HEIGHT;
        
        _mainTableView.frame = CGRectMake(0, APP_SCREEN_HEIGHT - height, APP_SCREEN_WIDTH, height);
        
        
        _mainTableView.alpha = 1;
        weakSelf.backgroundColor = UICOLOR_RGB_Alpha(0x000000, 0.4);
    }];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    APSortTableViewCell *cell = [APSortTableViewCell cellWithTableView:tableView];
    
    cell.titleLabel.text = _dataArr[indexPath.row];
    
    if ([_dataArr[indexPath.row] isEqualToString:_selectData])
    {
        cell.titleLabel.textColor = YCThemeColorGreen;
    }else
    {
        cell.titleLabel.textColor = LITTLE_BLACK_COLOR;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self hideSortView];
    
    if (self.block) {
        self.block(_dataArr[indexPath.row]);
    }
}

#pragma mark hideSortView  隐藏筛选

- (void)hideSortView
{
    WS(weakSelf);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGFloat bottomHeight = 0;
        _mainTableView.frame = CGRectMake(0, APP_SCREEN_HEIGHT, APP_SCREEN_WIDTH, Cell_HEIGHT * _dataArr.count + bottomHeight);
        _mainTableView.alpha = 0;
        weakSelf.backgroundColor = [UIColor clearColor];
        
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

@end
