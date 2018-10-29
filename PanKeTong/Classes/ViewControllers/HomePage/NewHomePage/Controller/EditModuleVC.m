//
//  EditModuleVC.m
//  APlus
//
//  Created by 李慧娟 on 2017/10/24.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "EditModuleVC.h"
#import "GridCell.h"
#import "EditModuleView.h"
#import "APPConfigEntity.h"

#define GridCellIdtifier    @"GridCell"
#define Home_Default        @"Home_Default"         // 首页默认显示


@interface EditModuleVC ()<EditorModuleProtocal,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    __weak IBOutlet EditModuleView *_editView;
    __weak IBOutlet UICollectionView *_allCollectionView;
    __weak IBOutlet UICollectionViewFlowLayout *_flowLayOut;

    NSMutableArray *_editMarray;    // 编辑视图的数据
    NSMutableArray *_allMarray;     // 所有数据

    NSInteger _lastRowCount;        // 之前的行数
}

@end

@implementation EditModuleVC

- (void)viewDidLoad {
    _isNewVC = YES;
    [super viewDidLoad];

    [self setNavTitle:@"编辑首页应用"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"back"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:@"完成"
                                backgroundImage:nil
                                     foreground:nil
                                            sel:@selector(complentAction:)]];


    _editMarray = [NSMutableArray arrayWithArray:_homeModuleArr];
    _allMarray = [NSMutableArray arrayWithArray:_allModuleArr];

    _lastRowCount = [CommonMethod getRowNumWithSunCount:_editMarray.count + 1 andEachRowNum:4];
    _editViewHeight.constant = _lastRowCount * GridHeight + 80*NewRatio;

    [self initData];

}

#pragma mark - 完成

- (void)complentAction:(UIButton *)btn
{
    // 存储到本地
    [_editMarray removeLastObject];
    NSArray *dataArr = [MTLJSONAdapter JSONArrayFromModels:_editMarray];
    NSLog(@"%@",dataArr);
    [CommonMethod setUserdefaultWithValue:dataArr forKey:Home_Default];

    [self.navigationController popToRootViewControllerAnimated:YES];

}

#pragma mark - init

- (void)initData
{
    if (_homeModuleArr.count < 12)
    {
        // 添加占位
        APPLocationEntity *entity = [[APPLocationEntity alloc] init];
        entity.title = @"占位";
        entity.configId = EMPTY_ID;
        entity.dispIndex = [NSNumber numberWithInteger:_editMarray.count];
        [_editMarray addObject:entity];
    }

    [self initView];

    [_allCollectionView reloadData];

}

- (void)initView
{
    [_editView createViewWithDataArr:_editMarray];
    _editView.delegate = self;

    _flowLayOut.minimumInteritemSpacing = 0;
    _flowLayOut.minimumLineSpacing = 10*NewRatio;
    CGFloat width = (APP_SCREEN_WIDTH - 50*NewRatio) / 4;
    _flowLayOut.itemSize = CGSizeMake(width, width);

    _allCollectionView.backgroundColor = [UIColor whiteColor];
    _allCollectionView.delegate = self;
    _allCollectionView.dataSource = self;
    _allCollectionView.showsVerticalScrollIndicator = NO;

    UINib *attentionNib = [UINib nibWithNibName:GridCellIdtifier bundle:nil];
    [_allCollectionView registerNib:attentionNib forCellWithReuseIdentifier:GridCellIdtifier];
}


#pragma mark - <UICollectionViewDelegate>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _allMarray.count;
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    GridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GridCellIdtifier
                                                               forIndexPath:indexPath];

    APPLocationEntity *entity = _allMarray[indexPath.item];

    [cell fillDataWithDataArr:_editMarray andEntity:entity];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GridCell *cell = (GridCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.addBtn.hidden == NO)
    {
        APPLocationEntity *entity = _allMarray[indexPath.item];

        [_editView addBoxActionWithIsEmpty:NO WithEntity:entity];
    }
}

#pragma mark - <EditorModuleProtocal>

/// 移除
- (void)finishedRemoveWithGrid:(NSInteger)gridId
{
    for (APPLocationEntity *entity in _editMarray)
    {
        if (entity.configId == gridId)
        {
            [_editMarray removeObject:entity];
            break;
        }
    }

    NSInteger rowCount = [CommonMethod getRowNumWithSunCount:_editMarray.count
                                               andEachRowNum:4];
    if (_lastRowCount != rowCount)
    {
        self.editViewHeight.constant = rowCount * GridHeight + 80*NewRatio;
    }

    _lastRowCount = rowCount;

    [_allCollectionView reloadData];
}

// 添加
- (void)finishedAddGridWithEntity:(APPLocationEntity *)entity
{
    if (_editMarray.count < MAX_COUNT)
    {
        [_editMarray insertObject:entity atIndex:_editMarray.count - 1];
    }
    else
    {
        [_editMarray addObject:entity];
    }
    NSLog(@"添加完成------%@", _editMarray);
    // 计算行数
    NSInteger rowCount = [CommonMethod getRowNumWithSunCount:_editMarray.count
                                               andEachRowNum:4];
    if (_lastRowCount != rowCount)
    {
        self.editViewHeight.constant = rowCount * GridHeight + 80*NewRatio;
    }

    _lastRowCount = rowCount;
    [_allCollectionView reloadData];
}

// 移动
- (void)finishedMoveGridWithDataArr:(NSArray *)dataArr
{
    [_editMarray removeAllObjects];
    [_editMarray addObjectsFromArray:dataArr];
    NSLog(@"移动完成-----%@", _editMarray);
}



@end
