//
//  FilterMoreDetailView.m
//  APlusFilterView
//
//  Created by 张旺 on 2017/10/25.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "FilterMoreDetailView.h"
#import "FilterMoreDetailCell.h"
#import "MoreFilterBasePresenter.h"

#import "MoreFilterZJPresenter.h"

#define TableViewBaseTag       1000

@interface FilterMoreDetailView () <UITableViewDelegate,UITableViewDataSource>
{
    __weak IBOutlet UITableView *_mainTableView;
    NSMutableArray *_selectDataArray;
    NSMutableArray *_cellHeightArray;
    
    NSArray *_headerTitleArray;
    NSArray *_allMessageArray;
    
    MoreFilterBasePresenter *_moreFilterPresenter;
    FilterEntity *_filterEntity;
    
    BOOL _isClickClearBtn;       // 是否点击重置按钮
}


@property (weak, nonatomic) IBOutlet UIView *funcConView;

@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@end

@implementation FilterMoreDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self = [FilterMoreDetailView viewFromXib];
        self.frame = frame;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _selectDataArray = [[NSMutableArray alloc] init];
        self.selectMoreItemDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.funcConView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.funcConView.layer.shadowOpacity = 0.2;
    self.funcConView.layer.shadowRadius = 2;
    
    [self.resetBtn setLayerCornerRadius:YCLayerCornerRadius];
    [self.submitBtn setLayerCornerRadius:YCLayerCornerRadius];
    
}

#pragma mark - init

- (void)initPresenter{
    _moreFilterPresenter = [[MoreFilterBasePresenter alloc] initWithDelegate:self];
}

- (void)setFilterEntity:(FilterEntity *)filterEntity
{
    // 设置筛选数据跟实体
    _filterEntity = filterEntity;
    [self initPresenter];
    _headerTitleArray = [_moreFilterPresenter getHeaderTitleArray];
    _allMessageArray = [_moreFilterPresenter getValueArray];
    _cellHeightArray = [self getCellHeightArray];
    
    // 给字典赋值让筛选实体已有的字段选中
    if (_filterEntity.roomSituation.count > 0)
    {
        [self.selectMoreItemDic setObject:_filterEntity.roomSituation forKey:FilterEstateStatusQuoKey];
    }
    if (_filterEntity.roomLevels.count > 0)
    {
        [self.selectMoreItemDic setObject:_filterEntity.roomLevels forKey:FilterEstateGrade];
    }
    if (_filterEntity.roomStatus.count > 0)
    {
        [self.selectMoreItemDic setObject:_filterEntity.roomStatus forKey:FilterEstateStateKey];
    }
    if (_filterEntity.roomType.count > 0)
    {
        [self.selectMoreItemDic setObject:_filterEntity.roomType forKey:FilterRoomKey];
    }
    if (_filterEntity.direction.count > 0)
    {
        [self.selectMoreItemDic setObject:_filterEntity.direction forKey:FilterDirectionKey];
    }
    if (_filterEntity.propTag.count > 0)
    {
        [self.selectMoreItemDic setObject:_filterEntity.propTag forKey:FilterEstateTag];
    }
    if (_filterEntity.buildingType.count > 0)
    {
        [self.selectMoreItemDic setObject:_filterEntity.buildingType forKey:FilterBuildingTypeKey];
    }
    
//    FilterMoreDetailCell *cell = [_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    cell.minBuildingAreaText.text = _filterEntity.minBuildingArea;
//    cell.maxBuildingAreaText.text = _filterEntity.maxBuildingArea;
    
    [_mainTableView reloadData];
}

#pragma mark - Button Click

// 提交更多筛选
- (IBAction)commitClick:(id)sender
{
    /// 是否点了重置按钮
    if (_isClickClearBtn)
    {
        [_filterEntity.roomStatus removeAllObjects];
        [_filterEntity.roomSituation removeAllObjects];
        [_filterEntity.roomLevels removeAllObjects];
        [_filterEntity.roomType removeAllObjects];
        [_filterEntity.propTag removeAllObjects];
        [_filterEntity.direction removeAllObjects];
        [_filterEntity.buildingType removeAllObjects];
        _filterEntity.propSituationValue = @"";
        _filterEntity.roomLevelValue = @"";
        _filterEntity.minBuildingArea = @"";
        _filterEntity.maxBuildingArea = @"";
    }
    
    // 获取建筑面积cell上文本的值
//    FilterMoreDetailCell *cell = [_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    // 建筑面积如果，这种获取数据写法也是醉了，cell滑上去根本就不会获取到数据
//    NSInteger temp = 0;
//    NSInteger minBuildingArea = [cell.minBuildingAreaText.text integerValue];
//    NSInteger maxBuildingArea = [cell.maxBuildingAreaText.text integerValue];
//
//    if (maxBuildingArea < minBuildingArea)
//    {
//        if (maxBuildingArea > 0)
//        {
//            temp = maxBuildingArea;
//            maxBuildingArea = minBuildingArea;
//            minBuildingArea = temp;
//        }
//    }
//
//    cell.minBuildingAreaText.text = minBuildingArea > 0? [NSString stringWithFormat:@"%@",@(minBuildingArea)] : @"";
//    cell.maxBuildingAreaText.text = maxBuildingArea > 0? [NSString stringWithFormat:@"%@",@(maxBuildingArea)] : @"";
//    _filterEntity.minBuildingArea = cell.minBuildingAreaText.text;
//    _filterEntity.maxBuildingArea = cell.maxBuildingAreaText.text;
    
    // 给筛选实体赋值
    for (NSString *key in [self.selectMoreItemDic allKeys])
    {
        if ([key isEqualToString:FilterEstateStatusQuoKey])
        {
            _filterEntity.roomSituation = [self.selectMoreItemDic objectForKey:key];
            SelectItemDtoEntity *selectItemDtoEntity = [_filterEntity.roomSituation firstObject];
            _filterEntity.propSituationValue = selectItemDtoEntity.itemValue;
        }
        else if([key isEqualToString:FilterEstateGrade])
        {
            _filterEntity.roomLevels = [self.selectMoreItemDic objectForKey:key];
            
            SelectItemDtoEntity * selectEntity = [_filterEntity.roomLevels firstObject];
            _filterEntity.roomLevelValue = selectEntity.itemValue;
        }
        else if([key isEqualToString:FilterEstateStateKey])
        {
            _filterEntity.roomStatus = [self.selectMoreItemDic objectForKey:key];
        }
        else if([key isEqualToString:FilterRoomKey])
        {
            _filterEntity.roomType = [self.selectMoreItemDic objectForKey:key];
            
        }
        else if([key isEqualToString:FilterDirectionKey])
        {
            _filterEntity.direction = [self.selectMoreItemDic objectForKey:key];
        }
        else if([key isEqualToString:FilterEstateTag])
        {
            _filterEntity.propTag = [self.selectMoreItemDic objectForKey:key];
        }
        else if([key isEqualToString:FilterBuildingTypeKey])
        {
            _filterEntity.buildingType = [self.selectMoreItemDic objectForKey:key];
        }
    }
    
    if (_block)
    {
        _block();
    }
    
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
    _isClickClearBtn = NO;
}

// 重置更多筛选
- (IBAction)clearClick:(id)sender
{
    _isClickClearBtn = YES;
    [self.selectMoreItemDic removeAllObjects];
    
    _filterEntity.minBuildingArea = nil;
    _filterEntity.maxBuildingArea = nil;
    
//    // 获取建筑面积cell上文本的值
//    FilterMoreDetailCell *cell = [self viewWithTag:TableViewBaseTag + 1];
//    cell.minBuildingAreaText.text = @"";
//    cell.maxBuildingAreaText.text = @"";
    
    [_mainTableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _headerTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *heightCacheDict = _cellHeightArray[indexPath.row];    // LJS
    
    CGFloat cellHeight = [[heightCacheDict valueForKey:@"height"] floatValue];
    
    if ([_headerTitleArray[indexPath.row] isEqualToString:@"建筑面积（平)"])
    {
        cellHeight = 70;
    }
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FilterMoreDetailCell *cell = [FilterMoreDetailCell cellWithTableView:tableView indexPath:indexPath];
    
    cell.tag = TableViewBaseTag + indexPath.row;
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        cell.filterEntity = _filterEntity;
        
        cell.estateFilterTitle.text = _headerTitleArray[indexPath.row];
        
    }else{
        
        [cell setCellDataWithTitle:_headerTitleArray[indexPath.row]
                      andDataArray:_allMessageArray[indexPath.row]
                   andFilterEntity:_filterEntity
                      andIndexPath:indexPath
             andSelectRowItemArray:[self.selectMoreItemDic valueForKey:_headerTitleArray[indexPath.row]]
                        andLineNum:[[_cellHeightArray[indexPath.row] valueForKey:@"num"] integerValue]];
        
        cell.selectItemBlock = ^(NSString *key, NSMutableArray *itemArray)
        {
            [self.selectMoreItemDic setValue:itemArray forKey:key];
        };
        
    }
    
    return cell;
}

/// 获取更多TablewCell高度
- (NSMutableArray *)getCellHeightArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < _allMessageArray.count; i++)
    {
        // 1. 计算列数
        __block NSInteger num = 4;
        CGFloat commonFourWidth = (APP_SCREEN_WIDTH-10-10-10*3)/4;
        CGFloat commonThreeWidth = (APP_SCREEN_WIDTH-10-10-10*2)/3;
        
        NSArray *messageArray = _allMessageArray[i];
        [messageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            
            SelectItemDtoEntity *selectEntity = obj;
            CGFloat actureW = [selectEntity.itemText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15) options:NSStringDrawingUsesFontLeading attributes:nil context:nil].size.width;
            
            if (actureW > commonThreeWidth)
            {
                num = 2;
                *stop = YES;
            }
            else if (actureW > commonFourWidth)
            {
                num = 3;
            }
        }];
        
        // 2. 计算cell高度
        NSInteger lat = messageArray.count % num;
        NSInteger lng = messageArray.count / num;
        if (lat > 0) {
            lng = lng + 1;
        }
        // 高度 =  sectionInsert + itemHeight*lng + LineSpacing*(lng-1)
//        CGFloat height = 36 + InteritemSpacing * 2 + lng * ItemHeight + (lng - 1) * LineSpacing;
        CGFloat height = InteritemSpacing * 2 + lng * ItemHeight + (lng - 1) * LineSpacing + 24;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setValue:[NSNumber numberWithInteger:num] forKey:@"num"];
        [dict setValue:[NSNumber numberWithFloat:height] forKey:@"height"];
        [array addObject:dict];
    }
    
    return array;
}

@end
