//
//  FilterMoreDetailCell.m
//  APlus
//
//  Created by 张旺 on 2017/11/8.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "FilterMoreDetailCell.h"

#import "JMFilterMoreDetailCollectionCell.h"

#import "UICollectionView+Category.h"

@interface FilterMoreDetailCell() <UICollectionViewDelegate,UICollectionViewDataSource, UITextFieldDelegate>
{
    NSString *_filterTitle;                 // 筛选标题
    NSInteger _lineNum;                     // CollectionViewCell的每行数量
    FilterEntity *_filterEntity;
}

@property (strong, nonatomic) NSArray *filterDataArray;         // 筛选数据源
@property (strong, nonatomic) NSMutableArray *selectRowsArray;  // 选中个数数组
@property (nonatomic, strong) NSMutableArray *reloadIndexPathsMultiSelect; // 多选

@end

@implementation FilterMoreDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
//    [self.collectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
//    self.minBuildingAreaText.inputAccessoryView = [self setInputView];
//    self.maxBuildingAreaText.inputAccessoryView = [self setInputView];
    [self.minBuildingAreaText setValue:@10 forKey:@"limit"];
    [self.maxBuildingAreaText setValue:@10 forKey:@"limit"];
    self.minBuildingAreaText.delegate = self;
    self.maxBuildingAreaText.delegate = self;
    [self.minBuildingAreaText setLayerCornerRadius:YCLayerCornerRadius];
    [self.maxBuildingAreaText setLayerCornerRadius:YCLayerCornerRadius];
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

//- (UIView *)setInputView
//{
//    UIToolbar * toolView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 44)];
//    [toolView setBarStyle:UIBarStyleDefault];
//    UIBarButtonItem * space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
//    [toolView setItems:[NSArray arrayWithObjects:space,doneButton,nil]];
//    return toolView;
//}

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

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //过滤掉数字，如果还有其他字符串，证明输入的有非数字字符
    NSString * tmpStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    
    return tmpStr.length > 0 ? NO : YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (_minBuildingAreaText == textField) {
        
        self.filterEntity.minBuildingArea = textField.text;
        
    }else if (_maxBuildingAreaText == textField){
        
        self.filterEntity.maxBuildingArea = textField.text;
        
    }
    
}

- (void)setFilterEntity:(FilterEntity *)filterEntity{
    
    _filterEntity = filterEntity;
    
    self.minBuildingAreaText.text = filterEntity.minBuildingArea;
    self.maxBuildingAreaText.text = filterEntity.maxBuildingArea;
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _filterDataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * identitfier = @"JMFilterMoreDetailCollectionCell";

    JMFilterMoreDetailCollectionCell * cell = [collectionView collectionViewCellByNibWithIdentifier:identitfier andIndexPath:indexPath];

    SelectItemDtoEntity * selectItemDtoEntity = self.filterDataArray[indexPath.row];

    [cell.titleBtn setTitle:selectItemDtoEntity.itemText forState:UIControlStateNormal];
    
    [cell setIsSelect:[self checkArray:self.selectItemArray containsObjectId:selectItemDtoEntity]];

//    for (int i=0; i<_reloadIndexPathsMultiSelect.count; i++) {
//        if (([_reloadIndexPathsMultiSelect[i] compare:indexPath] == NSOrderedSame) ? YES : NO) {
//
//            [cell setIsSelect:YES];
//
//            break;
//        }
//    }

    return cell;
    
//    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
//    SelectItemDtoEntity * selectItemDtoEntity = self.filterDataArray[indexPath.row];
//    [cell setCellDataWithData:selectItemDtoEntity.itemText andIsSelected:[self checkArray:self.selectItemArray containsObjectId:selectItemDtoEntity]];
//
//    for (int i=0; i<_reloadIndexPathsMultiSelect.count; i++) {
//        if (([_reloadIndexPathsMultiSelect[i] compare:indexPath] == NSOrderedSame) ? YES : NO) {
//            [cell.filterButton setBackgroundImage:[UIImage imageNamed:@"filter_more_btn_multi_select"] forState:UIControlStateSelected];
//            [cell.filterButton setTitleColor:YCTextColorMoreSelect forState:UIControlStateSelected];
//        }
//    }
//
//    return cell;
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

#pragma mark - private
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
    _reloadIndexPathsMultiSelect = [NSMutableArray arrayWithObjects:indexPath, nil];
    [self.collectionView reloadItemsAtIndexPaths:_reloadIndexPathsMultiSelect];
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

#pragma mark - getter
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




@end

//@interface CollectionCell()
//
//@end
//
//@implementation CollectionCell
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self)
//    {
//        self.filterButton = [[UIButton alloc] init];
//        [self.filterButton setTitleColor:YCTextColorBlack forState:UIControlStateNormal];
//        [self.filterButton setTitleColor:YCTextColorMoreSelect forState:UIControlStateSelected];
////        [self.filterButton setBackgroundImage:[UIImage imageNamed:@"filter_more_btn_normal"] forState:UIControlStateNormal];
////        [self.filterButton setBackgroundImage:[UIImage imageNamed:@"filter_more_btn_select"] forState:UIControlStateSelected];
//        self.filterButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightLight];
//        self.filterButton.userInteractionEnabled = NO;
//        [self.contentView addSubview:self.filterButton];
//
//        self.filterButton.layer.borderColor = YCTextColorBlack.CGColor;
//        self.filterButton.layer.borderWidth = SINGLE_LINE_WIDTH;
//        [self.filterButton setLayerCornerRadius:YCLayerCornerRadius];
//    }
//    return self;
//}
//
//- (void)setCellDataWithData:(NSString *)data andIsSelected:(BOOL)isSelected
//{
//    [self.filterButton setTitle:data forState:UIControlStateNormal];
//    self.filterButton.selected = isSelected;
//
//    self.layer.borderColor = isSelected ? YCTextColorMoreSelect.CGColor : YCTextColorBlack.CGColor;
//
//}
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    self.filterButton.frame = self.bounds;
//}
//
//@end

