//
//  APFilterView.m
//  APlusFilterView
//
//  Created by 张旺 on 2017/10/23.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "APFilterView.h"
#import "ItemView.h"
#import "APFilterEntity.h"
#import "FilterEstateDetailView.h"
#import "FilterMoreDetailView.h"

@interface APFilterView()
{
    ItemView *_itemView;
    FilterEstateDetailView *_filterEstateDetailView;        // 筛选房源类型View
    FilterMoreDetailView *_filterMoreDetailView;            // 筛选更多View
    UIView *_shadowBackView;                                // 半透明阴影view
    
    //FilterCompleteBlock _filterCompleteBlock;               // 选择筛选项后回调的block
    
    FilterType _filterType;                                 // 筛选类型
    //APFilterEntity * _filterEntity;                         // 筛选实体
    FilterEntity *_filterEntity;                            // 筛选实体
    NSMutableArray *_itemTitleArray;                        // 标题数组
    NSMutableArray *_dataSourceArray;                       // 数据源
    CGRect _tempFilterViewRect;                             // 记录FilterView位置
    NSInteger _lastSelectIndex;                             // 上次选择的筛选项index
    BOOL _isShowFilterView;                                 // 当前是否显示筛选列表
}

@property (nonatomic, copy) FilterCompleteBlock filterCompleteBlock; // 选择筛选项后回调的block
@end

@implementation APFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _isShowFilterView = NO;
        _tempFilterViewRect = self.frame;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

/// 创建筛选view
- (UIView *)createFiterViewWithItemTitleArray:(NSArray *)itemTitleArray
                           andDataSourceArray:(NSArray *)dataSourceArray
                                 andFiterType:(FilterType)filterType
                                     andBlock:(FilterCompleteBlock)block
{
    _filterType = filterType;
    _itemTitleArray = [itemTitleArray mutableCopy];
    _dataSourceArray = [dataSourceArray mutableCopy];
    _filterCompleteBlock = block;
    
    // 创建筛选itemView
    _itemView = [[ItemView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, FilterViewHeight)];
    [_itemView setItemTitleArray:itemTitleArray];
    
    WS(weakSelf);
    // 点击item按钮回调
    _itemView.btnClickBlock = ^(UIButton *button)
    {
        [weakSelf itemBtnClickWithBtn:button];
    };

    // 阴影View
    _shadowBackView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                              0,
                                                              APP_SCREEN_WIDTH,
                                                              0)];
    [_shadowBackView setBackgroundColor:UICOLOR_RGB_Alpha(0x000000,0.4)];
    
    UITapGestureRecognizer *tapHideGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                                    action:@selector(removeShadowAndListView)];
    tapHideGesture.numberOfTapsRequired = 1;
    tapHideGesture.numberOfTouchesRequired = 1;
    [_shadowBackView addGestureRecognizer:tapHideGesture];
    
    [self addSubview:_itemView];
    [self addSubview:_shadowBackView];
    
    return self;
}

- (void)setFilterEntity:(FilterEntity *)filterEntity
{
    _filterEntity = filterEntity;
    
    // 更多筛选是否选中item
    // 选择筛选的个数
    NSInteger selectFilterCount = _filterEntity.roomStatus.count + _filterEntity.roomSituation.count + _filterEntity.roomLevels.count + _filterEntity.roomType.count
    + _filterEntity.propTag.count + _filterEntity.direction.count + _filterEntity.buildingType.count + _filterEntity.minBuildingArea.length
    + _filterEntity.maxBuildingArea.length;
    
    // 改变ItemView箭头文字颜色以及将选择的文字回调
    UILabel *lastSelectLabel = (UILabel *)[[super superview] viewWithTag:ItemTitleBaseTag + 3];
    UIImageView *selectArrowImg = (UIImageView *)[[super superview] viewWithTag:ArrowImageBaseTag + 3];
    
    // 大于0说明有选中的筛选，更多变红
    if (selectFilterCount > 0)
    {
        lastSelectLabel.textColor = YCTextColorSelect;
        [selectArrowImg setImage:[UIImage imageNamed:ArrowDownRedImgName]];
    }
    else
    {
        lastSelectLabel.textColor = YCTextColorBlack;
        [selectArrowImg setImage:[UIImage imageNamed:ArrowDownGrayImgName]];
    }
}

#pragma mark Item Button Click

/// item按钮点击事件
- (void)itemBtnClickWithBtn:(UIButton *)clickBtn
{
    // 当前选择筛选项的箭头图标
    NSInteger selectArrowImgTag = ArrowImageBaseTag + clickBtn.tag - ItemButtonBaseTag;
    UIImageView *selectArrowImg = (UIImageView *)[self viewWithTag:selectArrowImgTag];
    
    if (_isShowFilterView)
    {
        // 当前有显示筛选列表
        if (clickBtn.tag == _lastSelectIndex)
        {
            // 两次点击Item上的按钮一样  移除筛选列表跟阴影
            [self removeShadowAndListView];
        }
        else
        {
            // 点击的是其它筛选列表    先移除之前的视图，再显示或创建
            [self removeLastLastTableView];
            [self createTableViewWithButton:clickBtn];
            
            // 设置本次点击的箭头颜色
            [selectArrowImg setImage:[UIImage imageNamed:ArrowDownRedImgName]];
            
            // 设置上次点击的箭头颜色
            [self setLastArrowColor];
        }
    }
    else
    {
        // 当前没显示筛选列表则创建
        [self showShadowView];
        [self createTableViewWithButton:clickBtn];
        
        _isShowFilterView = YES;
        [selectArrowImg setImage:[UIImage imageNamed:ArrowDownRedImgName]];
    }
    
    _lastSelectIndex = clickBtn.tag;
}

/// TableView点击cell回调
- (void)selectCellBlockWithCellTextStr:(NSString *)cellTextStr
{
    // 移除阴影View跟列表
    [self removeShadowAndListView];
    
    // 传值给控制器
    _filterCompleteBlock(cellTextStr);
}

#pragma mark createClickView

/// 创建列表
- (void)createTableViewWithButton:(UIButton *)button
{
    [self endEditing:YES];
    
    WS(weakSelf);
    NSInteger selectIndex = button.tag - ItemButtonBaseTag;
    
    // createTableView
    if (selectIndex == 3 && _filterType != FilterClient)
    {
        // 更多View
        if (!_filterMoreDetailView)
        {
            _filterMoreDetailView = [[FilterMoreDetailView alloc] initWithFrame:CGRectMake(0, FilterViewHeight, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT  - FilterViewHeight - APP_NAV_HEIGHT)];
    
            _filterMoreDetailView.block = ^()
            {
                // 移除阴影View跟列表
                [weakSelf removeShadowAndListView];
                weakSelf.filterCompleteBlock(@"更多筛选完成");
            };
            [_filterMoreDetailView setFilterEntity:_filterEntity];
            [self addSubview:_filterMoreDetailView];
        }
        _filterMoreDetailView.hidden = NO;
    }
    else
    {
        // 房源筛选详情VIew
        _filterEstateDetailView = [[FilterEstateDetailView alloc] initWithFrame:CGRectMake(0, FilterViewHeight, APP_SCREEN_WIDTH, TableViewCellHeight)];
        [self addSubview:_filterEstateDetailView];
        
        [_filterEstateDetailView setDataSourceWithDataArray:_dataSourceArray
                                          andItemTitleArray:_itemTitleArray
                                             andSelectIndex:selectIndex
                                            andFilterEntity:_filterEntity];
        // tableView数量
        NSInteger tableViewNumber = 1;      // 默认1个, 价格有2个tableView
        
        // 下标为1是价格有两个tableview
        if (selectIndex == 1)
        {
            tableViewNumber = 2;
            _filterEstateDetailView.height = TableViewRowNumber * TableViewCellHeight;
        }
        else
        {
            _filterEstateDetailView.height = [_dataSourceArray[selectIndex] count] * TableViewCellHeight;
        }
        
        _filterEstateDetailView.tableViewNumber = tableViewNumber;
        
        __weak __typeof(&*self)weakSelf = self;
        // 点击cell回调
        _filterEstateDetailView.block = ^(NSString *cellTextStr)
        {
            [weakSelf selectCellBlockWithCellTextStr:cellTextStr];
        };
    }
}

#pragma mark ShadowView State

/// 显示阴影
- (void)showShadowView
{
    [self setFrame:CGRectMake(0,
                              _tempFilterViewRect.origin.y,
                              APP_SCREEN_WIDTH,
                              APP_SCREEN_HEIGHT - APP_NAV_HEIGHT)];
    
    [_shadowBackView setFrame:CGRectMake(0,
                                         FilterViewHeight,
                                         APP_SCREEN_WIDTH,
                                         APP_SCREEN_HEIGHT - FilterViewHeight - APP_NAV_HEIGHT)];
    
    [UIView animateWithDuration:0.1 animations:^{
        
        _shadowBackView.alpha = 1.0;
    }];
}


/// 移除筛选列表和阴影
- (void)removeShadowAndListView
{
    // 因为更多筛选每次创建都会卡，所以更多只是隐藏
    _filterMoreDetailView.hidden = YES;
    [_filterMoreDetailView.selectMoreItemDic removeAllObjects];
    [_filterMoreDetailView setFilterEntity:_filterEntity];
    
    [self endEditing:YES];
    [_filterEstateDetailView removeFromSuperview];
    _filterEstateDetailView = nil;
    
    _isShowFilterView = NO;
    
    // 上一次选择箭头的置为未选择
    if (_lastSelectIndex != 0)
    {
        [self setLastArrowColor];
    }
    
    _shadowBackView.alpha = 0;
    
    [self setFrame:CGRectMake(0,
                              _tempFilterViewRect.origin.y,
                              APP_SCREEN_WIDTH,
                              FilterViewHeight)];
    
    [_shadowBackView setFrame:CGRectMake(0,
                                         FilterViewHeight,
                                         APP_SCREEN_WIDTH,
                                         0)];
}

/// 移除上次点击的的视图
- (void)removeLastLastTableView
{
    [_filterEstateDetailView removeFromSuperview];
    _filterMoreDetailView.hidden = YES;
    [_filterMoreDetailView.selectMoreItemDic removeAllObjects];
    [_filterMoreDetailView setFilterEntity:_filterEntity];
}

/// 设置上次选中的颜色
- (void)setLastArrowColor
{
    NSInteger lastSelectArrowImgTag = ArrowImageBaseTag + (_lastSelectIndex - ItemButtonBaseTag);
    NSInteger lastSelectLabelTag = ItemTitleBaseTag + (_lastSelectIndex - ItemButtonBaseTag);
    
    UIImageView *lastSelectArrowImg = (UIImageView *)[self viewWithTag:lastSelectArrowImgTag];
    UILabel *lastSelectLabel = (UILabel *)[self viewWithTag:lastSelectLabelTag];
    
    if (CGColorEqualToColor(lastSelectLabel.textColor.CGColor, YCTextColorSelect.CGColor))
    {
        [lastSelectArrowImg setImage:[UIImage imageNamed:ArrowDownRedImgName]];
    }
    else
    {
        [lastSelectArrowImg setImage:[UIImage imageNamed:ArrowDownGrayImgName]];
    }
}

@end
