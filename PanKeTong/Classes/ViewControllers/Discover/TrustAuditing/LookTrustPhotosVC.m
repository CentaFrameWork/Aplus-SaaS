//
//  LookTrustPhotosVC.m
//  PanKeTong
//
//  Created by 李慧娟 on 17/6/5.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "LookTrustPhotosVC.h"
#import "SubScrollView.h"
#import "SubCheckTrustEntity.h"

@interface LookTrustPhotosVC (){
    UIScrollView *_superScrollView;
    UILabel *_imgTypeLabel;
}

@end

@implementation LookTrustPhotosVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

    [self setNavTitle:[NSString stringWithFormat:@"%@(%ld/%ld)",_navTitleStr,_lastIndex + 1,_dataArr.count]
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
    
    [self initUI];
}

#pragma mark - 设置UI

- (void)initUI {
    // 创建一个总的滑动视图，里面装的是n个小的滑动视图
    _superScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    // 设置分页显示
    _superScrollView.pagingEnabled = YES;
    // 隐藏水平导航栏
    _superScrollView.showsHorizontalScrollIndicator = NO;

    // 循环创建n个小的滑动视图装入总的滑动视图中
    for (int i = 0; i < _dataArr.count; i++)
    {
        // 调用SubScrollView的初始化方法
        SubScrollView *subScrollView = [[SubScrollView alloc] initWithFrame:CGRectMake(APP_SCREEN_WIDTH * i, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - 64)];
        // 调用SubScrollView的image的set方法
        SubCheckTrustEntity *entity = _dataArr[i];
        NSString *imgStr = [NSString stringWithFormat:@"%@%@%@",entity.attachmentPath, EntrustPhotoDownWidth, TrustWaterMark];

        subScrollView.imageUrlStr = imgStr;

        [_superScrollView addSubview:subScrollView];
    }

    // 设置滑动视图的内容尺寸
    _superScrollView.contentSize = CGSizeMake(_dataArr.count * APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT);

    // 设置总的滑动视图的代理
    _superScrollView.delegate = self;

    // 设置滚动未开始的偏移量
    _superScrollView.contentOffset = CGPointMake(_lastIndex * APP_SCREEN_WIDTH, 0);
    [self.view addSubview:_superScrollView];
    
    if (self.isHaveImgType)
    {
        SubCheckTrustEntity *entity = _dataArr[_lastIndex];

        _imgTypeLabel = [[UILabel alloc] init];
        _imgTypeLabel.frame = CGRectMake(0, 5, APP_SCREEN_WIDTH, 30);
        _imgTypeLabel.backgroundColor = [UIColor clearColor];
        _imgTypeLabel.textAlignment = NSTextAlignmentCenter;
        _imgTypeLabel.textColor = [UIColor whiteColor];
        _imgTypeLabel.text = entity.attachmenSysTypeName?entity.attachmenSysTypeName:@"";
        _imgTypeLabel.font = [UIFont systemFontOfSize:14];
        
        [self.view addSubview:_imgTypeLabel];
    }
}

#pragma mark - 停止加速时调用的方法

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 取到总滑动视图中的所有小滑动视图的数组
    NSArray *allScrollViews = [_superScrollView subviews];
    // 根据当前的偏移量获取当前的小滑动视图的下标
    NSInteger nowIndex = (NSInteger)scrollView.contentOffset.x/APP_SCREEN_WIDTH;
    // 判断
    if (_lastIndex != nowIndex)
    {
        // 还原上一个下标的滑动视图的缩放
        SubScrollView *subSV =  allScrollViews[_lastIndex];
        subSV.zoomScale = 1;
        self.navigationItem.title = [NSString stringWithFormat:@"%@(%ld/%ld)",_navTitleStr,nowIndex + 1,_dataArr.count];
        if (self.isHaveImgType)
        {
            SubCheckTrustEntity *entity = _dataArr[nowIndex];
            _imgTypeLabel.text = entity.attachmenSysTypeName?entity.attachmenSysTypeName:@"";
        }
    }
    _lastIndex = nowIndex;
}

@end
