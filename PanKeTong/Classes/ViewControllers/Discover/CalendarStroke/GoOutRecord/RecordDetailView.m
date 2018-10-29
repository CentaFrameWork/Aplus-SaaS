//
//  RecordDetailView.m
//  PanKeTong
//
//  Created by 张旺 on 16/11/23.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "RecordDetailView.h"
#import "RecordDetailCell.h"

#define tableViewHeight   225
#define headViewHeight    25
@implementation RecordDetailView
{
    //阴影view
    UIView *_bgShadowView;
    
    
    NSMutableArray *_dataSource;
    
    UITableView *_mainTableView;
    
    UIView *_headView; //顶部视图
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

-(void)createGoOutRecordViewWithRecordDetail:(NSArray *)recordDetail
{
    _dataSource = [[NSMutableArray alloc] initWithArray:recordDetail];
    if (recordDetail.count == 0) {
        showMsg(@"暂无签到记录");
        return;
    }
    
    UITapGestureRecognizer *tapHideGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideRecordView)];
    tapHideGesture.numberOfTapsRequired = 1;
    tapHideGesture.numberOfTouchesRequired = 1;
    
    _bgShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    _bgShadowView.backgroundColor = ShadowBackgroundColor;
    _bgShadowView.alpha = 0;
    [_bgShadowView addGestureRecognizer:tapHideGesture];
    
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_SCREEN_HEIGHT, APP_SCREEN_WIDTH, headViewHeight)];
    [_headView setBackgroundColor:[UIColor whiteColor]];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH-headViewHeight, 5, 20, 20)];
    [button setImage:[UIImage imageNamed:@"goOut_btn_close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(hideRecordView) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:button];
    
    CGRect recordListRect;
    
    recordListRect = CGRectMake(0,
                                APP_SCREEN_HEIGHT,
                                APP_SCREEN_WIDTH,
                                100);
    
    _mainTableView = [[UITableView alloc]initWithFrame:recordListRect
                                                          style:UITableViewStylePlain];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self addSubview:_bgShadowView];
    [self addSubview:_mainTableView];
    [self addSubview:_headView];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        _bgShadowView.alpha = 1;
        [_mainTableView setFrame:CGRectMake(0, APP_SCREEN_HEIGHT-tableViewHeight, APP_SCREEN_WIDTH, tableViewHeight)];
        [_headView setFrame:CGRectMake(0, APP_SCREEN_HEIGHT-tableViewHeight-headViewHeight, APP_SCREEN_WIDTH, headViewHeight)];
    }];
}

-(void)hideRecordView
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         
                         _bgShadowView.alpha = 0;
                         [_mainTableView setFrame:CGRectMake(0,
                                                                      APP_SCREEN_HEIGHT,
                                                                      APP_SCREEN_WIDTH,
                                                                      _mainTableView.bounds.size.height)];
                         [_headView setFrame:CGRectMake(0, APP_SCREEN_HEIGHT, APP_SCREEN_WIDTH, headViewHeight)];
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         
                     }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordDetailCell *cell = [RecordDetailCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell goOutRecordCheckListDetailWithEntity:_dataSource andIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}
@end
