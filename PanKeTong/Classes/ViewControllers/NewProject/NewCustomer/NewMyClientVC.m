//
//  NewMyClientVC.m
//  PanKeTong
//
//  Created by 李慧娟 on 2018/2/2.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "NewMyClientVC.h"
#import "EventView.h"
#import "AddMyClientVC.h"
#import "CentaShadowView.h"

@interface NewMyClientVC () <TapDelegate,EventDelegate>
{
    CentaShadowView *_shadowView;
    EventView *_eventView;
    UIButton *_voiceSearchBtn;
}

@end

@implementation NewMyClientVC

- (void)viewDidLoad
{
    _isNewVC = YES;
    [super viewDidLoad];

    [self setNavTitle:nil
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"back"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"更多_black"
                                            sel:@selector(moreAction:)]];
    [self initNavTitleView];
    [self initView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    _shadowView.hidden = YES;
    _eventView.hidden = YES;
}

#pragma mark - init

- (void)initNavTitleView
{
    // 创建右部语音搜索按钮
    // 创建文字搜索按钮
    UIButton *searchTextBtn = [self createTextSearchBtnWithSelector:@selector(clickTextSearch)];

    _voiceSearchBtn = [self createVoiceSearchBtnWithSelector:@selector(clickVoiceSearch)];

    // 创建搜索框
    [self createTopSearchBarViewWithTextSearchBtn:searchTextBtn
                                      andRightBtn:_voiceSearchBtn
                                   andPlaceholder:@"请输入城区、片区、楼盘名"];

}

- (void)initView
{
    _shadowView = [[CentaShadowView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT)];
    _shadowView.delegate = self;
    [self.view addSubview:_shadowView];
    
    NSArray *titleArr = @[@"新增客户",@"筛选",@"首页",@"消息",@"工作"];
    _eventView = [[EventView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH - RowWidth - 15,0,
                                                             RowWidth,
                                                             RowHeight * titleArr.count + ArrowHeight)
                                   andIsHaveImage:YES];
    _eventView.hidden = YES;
    _eventView.eventDelegate = self;
    _eventView.titleArr = titleArr;
    [self.view addSubview:_eventView];

}

#pragma mark - BtnClick

// 导航栏更多
- (void)moreAction:(UIButton *)btn
{
    _shadowView.hidden = NO;
    _eventView.hidden = NO;
}

#pragma mark - <TapDelegate>

- (void)tapAction
{
    _eventView.hidden = !_eventView.hidden;
}

#pragma mark - <EventDelegate>

- (void)eventClickWithBtnTitle:(NSString *)title
{
    if ([title contains:@"新增客户"])
    {
        AddMyClientVC *addClientVC = [[AddMyClientVC alloc] init];
        [self.navigationController pushViewController:addClientVC animated:YES];
    }
    else if ([title contains:@"筛选"])
    {

    }
}

@end
