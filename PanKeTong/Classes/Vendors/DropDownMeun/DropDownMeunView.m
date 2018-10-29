//
//  DropDownMeunView.m
//  下拉菜单
//
//  Created by 王雅琦 on 16/7/14.
//  Copyright © 2016年 王雅琦. All rights reserved.
//

#import "DropDownMeunView.h"
#import "UIView+Extension.h"
#import "DropDownMeunCollectionCell.h"


//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// RGB颜色
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]



@interface DropDownMeunView (){
    CGRect _frame;
    NSArray *_dataArray;
    
    UITableView *_tableView;
    UICollectionView *_collectionView;
    
    CGFloat _collectionHeight;
    
    
}

@end

@implementation DropDownMeunView


#pragma mark ==========tableView=========

- (id)initTableViewWithFrame:(CGRect)frame andDataArray:(NSMutableArray *)dataArray
{
    if (self == [super initWithFrame:frame]) {
        _frame = frame;
        _dataArray = dataArray;
        [self initTableView];
    }
    
    return self;
}


- (void)initTableView
{
    
    //黑色背景
    _lightGrayView = [UIView new];
    _lightGrayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _lightGrayView.opaque = NO;
    _lightGrayView.backgroundColor = [UIColor blackColor];
    _lightGrayView.alpha = 0.5;
    [self addSubview:_lightGrayView];
    _lightGrayView.hidden = YES;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    _tableView.hidden = YES;
    
    //为背景添加手势
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeLightGrayView:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [singleRecognizer setNumberOfTouchesRequired:1];//1个手指操作
    [_lightGrayView addGestureRecognizer:singleRecognizer];
    
}

/*
 *  移除目录列表
 */
- (void)removeLightGrayView:(UITapGestureRecognizer*)recognizer
{
    [self tableViewDismiss];
    [self collectionViewDismiss];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chickBackgroud)])
    {
        [self.delegate chickBackgroud];
    }
    
}

/*
 *   显示目录列表
 */
- (void)tableViewAppear
{
    _lightGrayView.hidden = NO;
    _tableView.hidden = NO;
    
    [UIView beginAnimations:@"dropDownloadLabel" context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration: 0.2];
    [UIView setAnimationBeginsFromCurrentState: NO];
    
    _tableView.height = 44*4;
    
    [UIView commitAnimations];

}

/*
 *  移除目录列表
 */
- (void)tableViewDismiss
{
    _lightGrayView.hidden = YES;
    
    [UIView beginAnimations:@"dropDownloadLabel" context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration: 0.3];
    [UIView setAnimationBeginsFromCurrentState: NO];
    
    _tableView.height = 0;
    
    [UIView commitAnimations];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    // 初始化cell并指定其类型，也可自定义cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *labelText = _dataArray[indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownMeunLabelText:andIndexPath:)])
    {
        [self.delegate dropDownMeunLabelText:labelText andIndexPath:indexPath];
    }
}

#pragma mark - collectionView

- (id)initCollectionFrame:(CGRect)frame andItemSize:(CGSize)itemSize andDataArray:(NSArray *)dataArray
{
    if (self == [super initWithFrame:frame]) {
        _frame = frame;
        _dataArray = dataArray;
        _ItemSize = itemSize;
        [self initCollectionView];
    }
    
    return self;
}

- (void)initCollectionView
{
    // 黑色背景
    _lightGrayView = [UIView new];
    _lightGrayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _lightGrayView.opaque = NO;
    _lightGrayView.backgroundColor = [UIColor blackColor];
    _lightGrayView.alpha = 0.5;
    [self addSubview:_lightGrayView];
    _lightGrayView.hidden = YES;
    
    //collectionItem
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    //设置item大小
    flowLayout.itemSize = _ItemSize;
    //section距离边界的间距
    flowLayout.sectionInset = UIEdgeInsetsMake(10 , 10 , 10 , 10);
    //垂直:各小方格之间的列间距
    flowLayout.minimumInteritemSpacing = 10;
    //行间距
    flowLayout.minimumLineSpacing = 10;
    
    //集合视图
    _collectionView = [[UICollectionView alloc]initWithFrame:[[UIScreen mainScreen]bounds] collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = RGBColor(230, 230, 230);
    [self addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.hidden = YES;
    _collectionView.height = 0;

    
    //注册item
    [_collectionView registerClass:[DropDownMeunCollectionCell class] forCellWithReuseIdentifier:@"reuse"];
    
    //注册头部
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerReuse"];
    //    //注册尾部
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footReuse"];
    
    
    //collection应该的高度
    int itemCount = (SCREEN_WIDTH - 20)/_ItemSize.width;
    float rowCount = (float)_dataArray.count/(float)itemCount;
    int newRowCount  = ceil(rowCount);
    
    _collectionHeight = newRowCount * _ItemSize.height + (newRowCount + 1) * 10;
    
    
    //为背景添加手势
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeLightGrayView:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [singleRecognizer setNumberOfTouchesRequired:1];//1个手指操作
    [_lightGrayView addGestureRecognizer:singleRecognizer];
    
}


/*
 *   显示目录列表
 */
- (void)collectionViewAppear
{
    self.hidden = NO;
    _lightGrayView.hidden = NO;
    _collectionView.hidden = NO;
    
    [UIView beginAnimations:@"dropDownloadLabel" context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDuration: 0.2];
    [UIView setAnimationBeginsFromCurrentState: NO];
    
    _collectionView.height = _collectionHeight;
    
    [UIView commitAnimations];
    
}

/*
 *  移除目录列表
 */
- (void)collectionViewDismiss
{
    _lightGrayView.hidden = YES;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _collectionView.height = 0;
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             self.hidden = YES;
                         }
                     }
     ];
    
   
}






#pragma mark ====collectionViewDelegate====


//点击某个item
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *labelText = _dataArray[indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropDownMeunLabelText:andIndexPath:)])
    {
        [self.delegate dropDownMeunLabelText:labelText andIndexPath:indexPath];
    }
    
}

//设置分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//设置item的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _dataArray.count;
    
}

//布局cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //直接从系统的重用池里取cell
    DropDownMeunCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    cell.cellframe = CGRectMake(0, 0, _ItemSize.width, _ItemSize.height);
    
    cell.cellText.text = _dataArray[indexPath.row];
    
    
    return cell;
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
