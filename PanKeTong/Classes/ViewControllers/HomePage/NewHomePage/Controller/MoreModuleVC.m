//
//  MoreModuleVC.m
//  APlus
//
//  Created by 李慧娟 on 2017/10/16.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "MoreModuleVC.h"
#import "WorkSectionHeaderView.h"
#import "JMModuleCell.h"
#import "MoreTopView.h"
#import "EditModuleVC.h"
#import "APPConfigApi.h"
#import "BaseViewController+Handle.h"

#define HeaderView @"WorkSectionHeaderView"
#define FooterView @"FooterView"


@interface MoreModuleVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_mainCollectionView;

    MoreTopView *_TopView;
    __weak IBOutlet UIButton *_moreBtn;

    APPConfigApi *_appConfig;

    NSArray *_homeModuleArr;
    NSArray *_allModuleArr;     // 所有模块数组
    
}

@end

@implementation MoreModuleVC

- (void)viewDidLoad
{
    _isNewVC = YES;
    [super viewDidLoad];

    [self setNavTitle:@"更多应用"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"back"
                                            sel:@selector(back)]
      rightButtonItem:nil];

    _appConfig = [[APPConfigApi alloc] init];

    [self initView];

    [self requestHomeAllData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    _mainCollectionView.contentOffset = CGPointZero;

    // 取本地存储数据
    NSArray *data = [CommonMethod getUserdefaultWithKey:Home_Default];

    _homeModuleArr = [MTLJSONAdapter modelsOfClass:[APPLocationEntity class]
                                     fromJSONArray:data
                                             error:nil];
    _TopView.homeArr = _homeModuleArr;
    _TopView.moreBtn.hidden = _homeModuleArr.count > 7 ? NO:YES;
}

- (void)initView
{
    self.view.backgroundColor = APP_BACKGROUND_COLOR;
    
    _TopView = [[MoreTopView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 60*NewRatio)];
    _TopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_TopView];

    UICollectionViewFlowLayout *mainFlowLayOut = [[UICollectionViewFlowLayout alloc] init];
    mainFlowLayOut.minimumInteritemSpacing = 0;
    mainFlowLayOut.minimumLineSpacing = 0;
    mainFlowLayOut.itemSize = CGSizeMake(APP_SCREEN_WIDTH/4, 90*NewRatio);
    mainFlowLayOut.headerReferenceSize = CGSizeMake(APP_SCREEN_WIDTH, 40*NewRatio);
    mainFlowLayOut.footerReferenceSize = CGSizeMake(APP_SCREEN_WIDTH, 120*NewRatio);

    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 70*NewRatio, APP_SCREEN_WIDTH, 0)
                                             collectionViewLayout:mainFlowLayOut];
    _mainCollectionView.backgroundColor = [UIColor whiteColor];
    _mainCollectionView.bounces = NO;
    _mainCollectionView.delegate = self;
    _mainCollectionView.dataSource = self;
    _mainCollectionView.showsVerticalScrollIndicator = NO;

    // 组头视图
    [_mainCollectionView registerNib:[UINib nibWithNibName:HeaderView bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:HeaderView];

    // 组尾视图
    [_mainCollectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:FooterView];
    [self.view addSubview:_mainCollectionView];

}

#pragma mark - Request

// 请求首页默认显示模块
- (void)requestHomeData
{
    _appConfig.location = Home_More;// 首页所有应用
    [_manager sendRequest:_appConfig
                 sucBlock:^(id result) {
                     APPConfigEntity *entity = [DataConvert convertDic:result toEntity:[APPConfigEntity class]];
                     _homeModuleArr = entity.result;
                 }
                failBlock:^(NSError *error) {

                }];

    [self showLoadingView:nil];
}

// 请求全部应用模块
- (void)requestHomeAllData
{
    _appConfig.location = Home_More;// 首页所有应用
    [_manager sendRequest:_appConfig];

    [self showLoadingView:nil];
}

#pragma mark - editClick

- (void)editClick:(UIButton *)btn
{
    EditModuleVC *editModuleVC = [[EditModuleVC alloc] init];
    editModuleVC.homeModuleArr = _homeModuleArr;
    editModuleVC.allModuleArr = _allModuleArr;
    [self.navigationController pushViewController:editModuleVC animated:YES];
}

#pragma mark - <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return _allModuleArr.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        // 头视图
        WorkSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                               withReuseIdentifier:HeaderView
                                                                                      forIndexPath:indexPath];
        headerView.titleLabel.text = @"所有应用";
        headerView.lineView.hidden = YES;
        return headerView;
    }

    // 尾视图
    UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                              withReuseIdentifier:FooterView
                                                                                     forIndexPath:indexPath];
    footerView.backgroundColor = APP_BACKGROUND_COLOR;
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake((APP_SCREEN_WIDTH - 80*NewRatio)/2, 5*NewRatio, 80*NewRatio, 92*NewRatio);
    [footerView addSubview:editBtn];
    [editBtn setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    return footerView;

}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *identifier = @"JMModuleCell";
    UINib *nib = [UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];

     JMModuleCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                   forIndexPath:indexPath];
    item.itemWidth.constant = 50*NewRatio;

    if (_allModuleArr.count > 0)
    {
        APPLocationEntity *entity = _allModuleArr[indexPath.item];
        item.entity = entity;
    }
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    APPLocationEntity *entity = _allModuleArr[indexPath.item];

    [self popWithAPPConfigEntity:entity];
}

#pragma mark - <ResponseDelegate>

- (void)dealData:(id)data andClass:(id)modelClass
{
    // 获取所有应用
    if ([modelClass isEqual:[APPConfigEntity class]])
    {
        APPConfigEntity *entity = [DataConvert convertDic:data toEntity:modelClass];
        _allModuleArr = entity.result;

        NSInteger row = [CommonMethod getRowNumWithSunCount:_allModuleArr.count
                                              andEachRowNum:4];
        CGFloat realHeight = row * 90*NewRatio + 160*NewRatio;
        CGFloat maxHeight = APP_SCREEN_HEIGHT - APP_NAV_HEIGHT - 70*NewRatio;
        _mainCollectionView.height = realHeight > maxHeight ? maxHeight : realHeight;
        [_mainCollectionView reloadData];
    }
}

- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    [super respFail:error andRespClass:cls];
}

@end
