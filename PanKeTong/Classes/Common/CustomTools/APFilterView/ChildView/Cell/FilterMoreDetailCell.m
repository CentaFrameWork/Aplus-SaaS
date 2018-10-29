//
//  FilterMoreDetailCell.m
//  APlus
//
//  Created by 张旺 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "FilterMoreDetailCell.h"

@interface FilterMoreDetailCell() <UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSString *_filterTitle;                 // 筛选标题
    NSInteger _lineNum;                     // CollectionViewCell的每行数量
    FilterEntity *_filterEntity;
}

@property (strong, nonatomic) NSArray *filterDataArray;         // 筛选数据源
@property (strong, nonatomic) NSMutableArray *selectRowsArray;  // 选中个数数组

@end

@implementation FilterMoreDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    self.minBuildingAreaText.inputAccessoryView = [self setInputView];
    self.maxBuildingAreaText.inputAccessoryView = [self setInputView];
    [self.minBuildingAreaText setValue:@10 forKey:@"limit"];
    [self.maxBuildingAreaText setValue:@10 forKey:@"limit"];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (FilterMoreDetailCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    FilterMoreDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@", @(indexPath.row)]];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"FilterMoreDetailCell" bundle:nil] forCellReuseIdentifier:[NSString stringWithFormat:@"%@", @(indexPath.row)]];
        
        cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%@", @(indexPath.row)]];
    }
    return cell;
}

- (UIView *)setInputView
{
    UIToolbar * toolView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 44)];
    [toolView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    [toolView setItems:[NSArray arrayWithObjects:space,doneButton,nil]];
    return toolView;
}

- (void)resignKeyboard
{
    [self endEditing:YES];
}

- (void)setCellDataWithTitle:(NSString *)title
                andDataArray:(NSArray *)dataArray
             andFilterEntity:(FilterEntity *)filterEntity
                andIndexPath:(NSIndexPath *)indexPath
       andSelectRowItemArray:(NSMutableArray *)selectRowItemArray
                  andLineNum:(NSInteger)lineNum
{
    // 筛选标题
    self.estateFilterTitle.text = title;
    
    /// 滑动优化
    if ([self isEqualArray1:self.filterDataArray array2:dataArray] &&
        [self isEqualArray1:self.self.selectItemArray array2:selectRowItemArray])
    {
        return;
    }
    
    _filterEntity = filterEntity;
    _filterTitle = title;
    self.selectItemArray = [selectRowItemArray mutableCopy];
    self.filterDataArray = [dataArray mutableCopy];
    
    _lineNum = lineNum;
    
    self.areaView.hidden = ![title isEqualToString:FilterAreaKey];
    self.collectionView.hidden = [title isEqualToString:FilterAreaKey];
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _filterDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    SelectItemDtoEntity * selectItemDtoEntity = self.filterDataArray[indexPath.row];
    
    [cell setCellDataWithData:selectItemDtoEntity.itemText andIsSelected:[self checkArray:self.selectItemArray
                                                                         containsObjectId:selectItemDtoEntity]];
    return cell;
}

- (BOOL)checkArray:(NSMutableArray *)array containsObjectId:(SelectItemDtoEntity *)selectItemDtoEntity
{
    __block BOOL isContains = NO;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SelectItemDtoEntity *itemEntity = obj;
        
        if (selectItemDtoEntity.itemValue.length < 1 && [selectItemDtoEntity.itemText isEqualToString:@"委托已审"])
        {
            selectItemDtoEntity.itemValue = FilterTrustsTagItemValue;
        }
        
        if ([itemEntity.itemValue isEqualToString:selectItemDtoEntity.itemValue])
        {
            isContains = YES;
            *stop = YES;
        }
    }];
    
    return isContains;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SelectItemDtoEntity * selectItemDtoEntity = self.filterDataArray[indexPath.row];
    
    // 房源现状跟房源等级不支持多选
    if ([_filterTitle isEqualToString:FilterEstateStatusQuoKey] || [_filterTitle isEqualToString:FilterEstateGrade])
    {
        // 房源现状
        [self simpleSelectWithEntity:selectItemDtoEntity indexPath:indexPath];
    }
    else
    {
        // 委托已审的坑
        if ([selectItemDtoEntity.itemText isEqualToString:@"委托已审"])
        {
            selectItemDtoEntity.itemValue = FilterTrustsTagItemValue;
        }
        // 多选
        [self multipleSelectWithEntity:selectItemDtoEntity indexPath:indexPath];
    }
    
    if (self.selectItemBlock)
    {
        self.selectItemBlock(_filterTitle,self.selectItemArray);
    }
}

/// 单选
- (void)simpleSelectWithEntity:(SelectItemDtoEntity *)selectItemDtoEntity indexPath:(NSIndexPath *)indexPath
{
    // 单选
    // 1.获取上一个选中的 item 的 indexpath
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:NSNotFound inSection:0];
    if (self.selectItemArray.count > 0)
    {
        SelectItemDtoEntity *lastItemEntity = self.selectItemArray.firstObject;
        lastIndexPath = [self queryIndexPathWithArray:self.filterDataArray onlyId:lastItemEntity.itemValue];
    }
    
    // 2. 如果之前选中过这个 item 则先移除, 负责移除之前 item 加入现在的 item
    SelectItemDtoEntity *tempItemEntity = [self queryItemEntityWithArray:self.selectItemArray onlyId:selectItemDtoEntity.itemValue];
    if (tempItemEntity)
    {
        [self.selectItemArray removeObject:tempItemEntity];
    }else
    {
        [self.selectItemArray removeAllObjects];
        [self.selectItemArray addObject:selectItemDtoEntity];
    }
    
    // 3. 刷新当前选中和之前选中的 item
    NSMutableArray *reloadIndexPaths = [NSMutableArray arrayWithObjects:indexPath, nil];
    
    if (lastIndexPath && indexPath.row != lastIndexPath.row)
    {
        if (lastIndexPath.row != NSNotFound)
        {
            [reloadIndexPaths addObject:lastIndexPath];
        }
    }
    
    [self.collectionView reloadItemsAtIndexPaths:reloadIndexPaths];
}

/// 多选
- (void)multipleSelectWithEntity:(SelectItemDtoEntity *)itemEntity indexPath:(NSIndexPath *)indexPath
{
    // 2.选中或取消选中
    SelectItemDtoEntity *selectItemDtoEntity = [self queryItemEntityWithArray:self.selectItemArray onlyId:itemEntity.itemValue];
    if (selectItemDtoEntity)
    {
        if ([selectItemDtoEntity.itemText isEqualToString:@"委托已审"])
        {
            _filterEntity.isTrustsApproved = @"false";
        }
        [self.selectItemArray removeObject:selectItemDtoEntity];
    }else
    {
        if ([itemEntity.itemText isEqualToString:@"委托已审"])
        {
            _filterEntity.isTrustsApproved = @"true";
        }
        [self.selectItemArray addObject:itemEntity];
    }
    
    // 3.刷新相关 item
    NSMutableArray *reloadIndexPaths = [NSMutableArray arrayWithObjects:indexPath, nil];
    [self.collectionView reloadItemsAtIndexPaths:reloadIndexPaths];
}

- (NSIndexPath *)queryIndexPathWithArray:(NSArray *)array onlyId:(NSString *)onlyId
{
    __block NSIndexPath *indexPath = nil;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SelectItemDtoEntity *tempEntity = obj;
        if ([tempEntity.itemValue isEqualToString: onlyId])
        {
            indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
            *stop = YES;
        }
    }];
    
    return indexPath;
}

- (SelectItemDtoEntity *)queryItemEntityWithArray:(NSArray *)array onlyId:(NSString *)onlyId
{
    __block SelectItemDtoEntity *itemEntity = nil;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SelectItemDtoEntity *tempEntity = obj;
        if ([tempEntity.itemValue isEqualToString: onlyId])
        {
            itemEntity = tempEntity;
            *stop = YES;
        }
    }];
    
    return itemEntity;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //  每列的宽度 = (屏幕宽 - 两边边距 - 两个按钮直接的间距 *(num-1) ) / num - 0.1
    CGFloat width = (APP_SCREEN_WIDTH  - InteritemSpacing * 2 - InteritemSpacing * (_lineNum - 1))/_lineNum - 0.1;
    return CGSizeMake(width, ItemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, InteritemSpacing, 0, InteritemSpacing);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    // 行间距
    return LineSpacing;
}

- (NSMutableArray *)selectRowsArray
{
    if (!_selectRowsArray) {
        _selectRowsArray = [NSMutableArray array];
    }
    return _selectRowsArray;
}

- (NSMutableArray *)selectItemArray
{
    if (!_selectItemArray) {
        _selectItemArray = [NSMutableArray array];
    }
    return _selectItemArray;
}


- (BOOL)isEqualArray1:(NSArray *)array1 array2:(NSArray *)array2
{
    NSSet *set1 = [NSSet setWithArray:array1];
    NSSet *set2 = [NSSet setWithArray:array2];
    
    if ([set2 isSubsetOfSet:set1] && array1.count == array2.count) {
        return YES;
    }
    else {
        return NO;
    }
}



@end

@interface CollectionCell()
@property (strong, nonatomic) UIButton *filterButton;
@end

@implementation CollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.filterButton = [[UIButton alloc] init];
        [self.filterButton setTitleColor:UICOLOR_RGB_Alpha(0x666666,1.0) forState:UIControlStateNormal];
        [self.filterButton setTitleColor:UICOLOR_RGB_Alpha(0xEE4848,1.0) forState:UIControlStateSelected];
        [self.filterButton setBackgroundImage:[UIImage imageNamed:@"filter_more_btn_normal"] forState:UIControlStateNormal];
        [self.filterButton setBackgroundImage:[UIImage imageNamed:@"filter_more_btn_select"] forState:UIControlStateSelected];
        self.filterButton.titleLabel.font = [UIFont fontWithName:FontName size:12];
        self.filterButton.userInteractionEnabled = NO;
        [self.contentView addSubview:self.filterButton];
    }
    return self;
}

- (void)setCellDataWithData:(NSString *)data andIsSelected:(BOOL)isSelected
{
    [self.filterButton setTitle:data forState:UIControlStateNormal];
    self.filterButton.selected = isSelected;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.filterButton.frame = self.bounds;
}

@end
