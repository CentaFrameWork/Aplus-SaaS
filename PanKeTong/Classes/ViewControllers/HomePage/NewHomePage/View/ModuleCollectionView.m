//
//  ModuleCollectionView.m
//  APlus
//
//  Created by 李慧娟 on 2017/10/13.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "ModuleCollectionView.h"
#import "ModuleCell.h"

#import "APPConfigEntity.h"


@implementation ModuleCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout{
    
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.itemSize = CGSizeMake(Item_width, Item_width+10*NewRatio);
    flowLayOut.minimumLineSpacing = 16*NewRatio;
    flowLayOut.minimumInteritemSpacing = Module_space;
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    self = [super initWithFrame:frame collectionViewLayout:flowLayOut];
    if (self) {
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.contentInset = UIEdgeInsetsMake(20*NewRatio, 0, -20*NewRatio, 0);
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr
{
    if (_dataArr != dataArr)
    {
        _dataArr = dataArr;


        NSInteger rowCount = [CommonMethod getRowNumWithSunCount:_dataArr.count + 1
                                                   andEachRowNum:4];
        CGFloat height = rowCount * 90*NewRatio + 5*NewRatio;
        self.height = height;
        
        [self reloadData];
    }
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count + 1;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *identifier = @"ModuleCell";
    UINib *nib = [UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    ModuleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    if (_dataArr.count > 0 && indexPath.item < _dataArr.count)
    {
        cell.entity = _dataArr[indexPath.item];
    }
    else
    {
        // 更多
        APPLocationEntity *entity = [[APPLocationEntity alloc] init];
        entity.title = @"更多";
        cell.entity = entity;
    }

    return cell;
}

@end
