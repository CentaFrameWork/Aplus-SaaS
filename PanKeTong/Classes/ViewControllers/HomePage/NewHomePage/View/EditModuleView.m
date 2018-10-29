//
//  EditorModuleView.m
//  APlus
//
//  Created by 李慧娟 on 2017/10/20.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "EditModuleView.h"
#import "APPConfigEntity.h"

@implementation EditModuleView
{
    NSMutableArray *_gridListArray;
    NSMutableArray *_myHomeArr;

    UIImage *_deleteIconImage;

    BOOL _isSelected;       // 格子是否被选中
    BOOL _contain;

    CGPoint _startPoint;    //  选中格子的起始位置
    CGPoint _originPoint;   // 选中格子的起始坐标位置（中心点）
}


- (void)createViewWithDataArr:(NSMutableArray *)dataArr
{
    _myHomeArr = [NSMutableArray arrayWithArray:dataArr];
    _gridListArray = [NSMutableArray array];
    _deleteIconImage = [UIImage imageNamed:@"删除"];
    BOOL isShowICon = YES;
    BOOL isCanDelete = YES;

    NSInteger count = MIN(MAX_COUNT, dataArr.count);

    for (NSInteger index = 0; index < count; index++)
    {
        APPLocationEntity *entity = dataArr[index];

        NSString *gridTitle = entity.title;
        NSInteger gridID = entity.configId;
        if (entity.iconFrame.length > 0)
        {
            _deleteIconImage = [UIImage imageNamed:@"newtag"];
            isCanDelete = NO;
        }
        else
        {
            _deleteIconImage = [UIImage imageNamed:@"删除"];
            isCanDelete = YES;
        }
        if (gridID == EMPTY_ID)
        {
            // 占位
            isShowICon = NO;
            isCanDelete = NO;
        }

        CustomGrid *gridItem = [[CustomGrid alloc] initWithFrame:CGRectZero
                                                           title:gridTitle
                                                     normalImage:nil
                                                highlightedImage:nil
                                                          gridId:gridID
                                                         atIndex:index
                                                      isShowIcon:isShowICon
                                                     isCanDelete:isCanDelete
                                                      deleteIcon:_deleteIconImage
                                                   withIconImage:entity.iconUrl];

        gridItem.delegate = self;
        gridItem.gridTitle = gridTitle;
        gridItem.gridImageString = entity.iconUrl;
        gridItem.gridId = gridID;
        gridItem.gridCenterPoint = gridItem.center;

        [self addSubview:gridItem];
        [_gridListArray addObject:gridItem];
    }

}

- (void)addBoxActionWithIsEmpty:(BOOL)isEmpty
                     WithEntity:(APPLocationEntity *)entity
{
    NSInteger gridListCount = _gridListArray.count;
    if (gridListCount == MAX_COUNT)
    {
        showMsg(@"最多只能添加11个模块");
        return;
    }

    CustomGrid *gridItem;
    if (isEmpty)
    {

        gridItem  = [[CustomGrid alloc] initWithFrame:CGRectZero
                                                title:@"占位"
                                          normalImage:nil
                                     highlightedImage:nil
                                               gridId:EMPTY_ID
                                              atIndex:_gridListArray.count
                                           isShowIcon:NO
                                          isCanDelete:NO
                                           deleteIcon:nil
                                        withIconImage:@"虚线框"];
        [_gridListArray addObject:gridItem];
    }
    else
    {
        gridItem = [[CustomGrid alloc] initWithFrame:CGRectZero
                                               title:entity.title
                                         normalImage:nil
                                    highlightedImage:nil
                                              gridId:entity.configId
                                             atIndex:_gridListArray.count - 1
                                          isShowIcon:!isEmpty
                                         isCanDelete:YES
                                          deleteIcon:_deleteIconImage
                                       withIconImage:entity.iconUrl];

        [_myHomeArr insertObject:entity atIndex:_myHomeArr.count - 1];

        gridItem.gridId = entity.configId;


        [_gridListArray insertObject:gridItem atIndex:_gridListArray.count - 1];

        // 最后一个是占位格子
        CustomGrid *lastView = _gridListArray.lastObject;
        lastView.gridId = EMPTY_ID;
        lastView.gridIndex = _gridListArray.count - 1;


        [lastView addGridAction];

    }

    gridItem.delegate = self;
    [self addSubview:gridItem];

    // 排列格子顺序和更新格子坐标信息
    [self sortGridList];

    if ([self.delegate respondsToSelector:@selector(finishedAddGridWithEntity:)])
    {
        [self.delegate finishedAddGridWithEntity:entity];
    }

}


#pragma mark - 操作模块

/// 点击格子
- (void)gridItemDidClicked:(CustomGrid *)gridItem
{
    NSLog(@"点击的格子Tag是：%ld", (long)gridItem.gridId);
    NSInteger girdId = gridItem.gridId;

    // 删除
    if (_gridListArray.count == MIN_COUNT)
    {
        showMsg(@"至少保留3个模块");
        return;
    }
    NSLog(@"删除的格子是GridId：%ld", girdId);

    for (NSInteger i = 0; i < _gridListArray.count; i++)
    {
        CustomGrid *removeGrid = _gridListArray[i];

        if (removeGrid.gridId == girdId)
        {
            NSInteger count = _gridListArray.count - 1;

            for (NSInteger index = removeGrid.gridIndex; index < count; index++)
            {
                CustomGrid *preGrid = _gridListArray[index];
                CustomGrid *nextGrid = _gridListArray[index+1];
                [UIView animateWithDuration:0.5 animations:^{
                    nextGrid.center = preGrid.gridCenterPoint;
                }];
                nextGrid.gridIndex = index;
            }

            [removeGrid removeFromSuperview];

            // 排列格子顺序和更新格子坐标信息
            [self sortGridList];

            // 删除
            [_gridListArray removeObjectAtIndex:removeGrid.gridIndex];

            for (APPLocationEntity *entity in _myHomeArr)
            {
                if (entity.configId == removeGrid.gridId)
                {
                    [_myHomeArr removeObject:entity];
                    break;
                }
            }

            removeGrid = nil;


            break;
        }
    }

    if ([self.delegate respondsToSelector:@selector(finishedRemoveWithGrid:)])
    {
        [self.delegate finishedRemoveWithGrid:gridItem.gridId];
    }


}

/// 删除格子
- (void)gridItemDidDeleteClicked:(UIButton *)deleteButton
{
    if (_gridListArray.count == 2)
    {
        showMsg(@"至少有一个模块");
        return;
    }
    NSLog(@"删除的格子是GridId：%ld", (long)deleteButton.tag);

    for (NSInteger i = 0; i < _gridListArray.count; i++)
    {
        CustomGrid *removeGrid = _gridListArray[i];

        if (removeGrid.gridId == deleteButton.tag)
        {
            NSInteger count = _gridListArray.count - 1;

            for (NSInteger index = removeGrid.gridIndex; index < count; index++)
            {
                CustomGrid *preGrid = _gridListArray[index];
                CustomGrid *nextGrid = _gridListArray[index+1];
                [UIView animateWithDuration:0.5 animations:^{
                    nextGrid.center = preGrid.gridCenterPoint;
                }];
                nextGrid.gridIndex = index;
            }

            [removeGrid removeFromSuperview];

            // 排列格子顺序和更新格子坐标信息
            [self sortGridList];

            // 删除
            [_gridListArray removeObjectAtIndex:removeGrid.gridIndex];

            for (APPLocationEntity *entity in _myHomeArr)
            {
                if (entity.configId == removeGrid.gridId)
                {
                    [_myHomeArr removeObject:entity];
                    break;
                }
            }

            removeGrid = nil;


            break;
        }
    }

    if ([self.delegate respondsToSelector:@selector(finishedRemoveWithGrid:)])
    {
        [self.delegate finishedRemoveWithGrid:deleteButton.tag];
    }
}

/// 长按格子
- (void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture
                  withGridItem:(CustomGrid *) grid
{
    NSLog(@"长按.........");
    NSLog(@"isSelected: %d", _isSelected);
    
    // 判断格子是否已经被选中并且是否可移动状态,如果选中就加一个放大的特效
    if (_isSelected && grid.isChecked)
    {
        /// 放大效果
        grid.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }
    
    // 没有一个格子选中的时候
    if (!_isSelected)
    {
        NSLog(@"没有一个格子选中............");
        grid.isChecked = YES;
        grid.isMove = YES;
        _isSelected = YES;
        
        // 获取移动格子的起始位置
        _startPoint = [longPressGesture locationInView:longPressGesture.view];

        // 获取移动格子的起始位置中心点
        _originPoint = grid.center;
        
        // 给选中的格子添加放大的特效
        [UIView animateWithDuration:0.5 animations:^{
            grid.transform = CGAffineTransformMakeScale(1.1, 1.1);
            grid.alpha = 1;
        }];
    }
}

/// 拖动位置
- (void)pressGestureStateChangedWithPoint:(CGPoint) gridPoint gridItem:(CustomGrid *) gridItem
{
    if (_isSelected && gridItem.isChecked)
    {
        [self bringSubviewToFront:gridItem];

        // 应用移动后的X坐标
        CGFloat deltaX = gridPoint.x - _startPoint.x;

        // 应用移动后的Y坐标
        CGFloat deltaY = gridPoint.y - _startPoint.y;

        // 拖动的应用跟随手势移动
        gridItem.center = CGPointMake(gridItem.center.x + deltaX, gridItem.center.y + deltaY);
        
        // 移动的格子索引下标
        NSInteger fromIndex = gridItem.gridIndex;

        // 移动到目标格子的索引下标
        NSInteger toIndex = [CustomGrid indexOfPoint:gridItem.center
                                          withButton:gridItem
                                           gridArray:_gridListArray];


        NSInteger borderIndex = -1;
        CustomGrid *customGrid = _gridListArray.lastObject;
        if (customGrid.gridId == EMPTY_ID)
        {
            borderIndex = _gridListArray.count - 1;
        }

        // 占位格子的坐标
        if (toIndex < 0 || toIndex >= borderIndex)
        {
            _contain = NO;
        }
        else
        {
            // 获取移动到目标格子
            CustomGrid *targetGrid = _gridListArray[toIndex];
            gridItem.center = targetGrid.gridCenterPoint;
            _originPoint = targetGrid.gridCenterPoint;
            gridItem.gridIndex = toIndex;
            
            // 判断格子的移动方向，是从后往前还是从前往后拖动
            if ((fromIndex - toIndex) > 0)
            {
                NSLog(@"从后往前拖动格子.......");

                // 从移动格子的位置开始，始终获取最后一个格子的索引位置
                NSInteger lastGridIndex = fromIndex;
                for (NSInteger i = toIndex; i < fromIndex; i++)
                {
                    CustomGrid *lastGrid = _gridListArray[lastGridIndex];
                    CustomGrid *preGrid = _gridListArray[lastGridIndex-1];
                    [UIView animateWithDuration:0.5 animations:^{
                        preGrid.center = lastGrid.gridCenterPoint;
                    }];
                    // 实时更新格子的索引下标
                    preGrid.gridIndex = lastGridIndex;
                    lastGridIndex--;
                }

                // 排列格子顺序和更新格子坐标信息
                [self sortGridList];
            }
            else if((fromIndex - toIndex) < 0)
            {
                // 从前往后拖动格子
                NSLog(@"从前往后拖动格子.......");

                // 从移动格子到目标格子之间的所有格子向前移动一格
                for (NSInteger i = fromIndex; i < toIndex; i++)
                {
                    CustomGrid *topOneGrid = _gridListArray[i];
                    CustomGrid *nextGrid = _gridListArray[i+1];
                    // 实时更新格子的索引下标
                    nextGrid.gridIndex = i;
                    [UIView animateWithDuration:0.5 animations:^{
                        nextGrid.center = topOneGrid.gridCenterPoint;
                    }];
                }
                // 排列格子顺序和更新格子坐标信息
                [self sortGridList];
            }
        }
    }
}

/// 拖动格子结束
- (void)pressGestureStateEnded:(CustomGrid *) gridItem
{
    //    NSLog(@"拖动格子结束.........");
    if (_isSelected && gridItem.isChecked)
    {
        // 撤销格子的放大特效
        [UIView animateWithDuration:0.5 animations:^{
            gridItem.transform = CGAffineTransformIdentity;
            gridItem.alpha = 1.0;
            _isSelected = NO;
            if (!_contain)
            {
                gridItem.center = _originPoint;
            }
        }];
        
        // 排列格子顺序和更新格子坐标信息
        for (APPLocationEntity *entity in _myHomeArr)
        {
            if (entity.configId == gridItem.gridId)
            {
                [_myHomeArr removeObject:entity];
                [_myHomeArr insertObject:entity atIndex:gridItem.gridIndex];
                break;
            }
        }
        [self sortGridList];
        if ([self.delegate respondsToSelector:@selector(finishedMoveGridWithDataArr:)])
        {
            [self.delegate finishedMoveGridWithDataArr:_myHomeArr];
        }
    }
}

/// 排序
- (void)sortGridList
{
    // 重新排列数组中存放的格子顺序
    [_gridListArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CustomGrid *tempGrid1 = (CustomGrid *)obj1;
        CustomGrid *tempGrid2 = (CustomGrid *)obj2;
        return tempGrid1.gridIndex > tempGrid2.gridIndex;
    }];
    
    // 更新所有格子的中心点坐标信息
    NSInteger gridListCount = _gridListArray.count;
    for (NSInteger i = 0; i < gridListCount; i++)
    {
        CustomGrid *gridItem = _gridListArray[i];
        gridItem.gridCenterPoint = gridItem.center;
    }
    }

@end
