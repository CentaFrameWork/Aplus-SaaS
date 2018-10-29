//
//  DropDownMeunView.h
//  下拉菜单
//
//  Created by 王雅琦 on 16/7/14.
//  Copyright © 2016年 王雅琦. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownMeunDelegate <NSObject>

@required

- (void)dropDownMeunLabelText:(NSString *)text andIndexPath:(NSIndexPath *)indexPath;

@optional

//点击黑色背景
- (void)chickBackgroud;

@end


@interface DropDownMeunView : UIView<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>


#pragma mark ========UITableView=======

@property (nonatomic, strong) UIView *lightGrayView;
@property (nonatomic, assign) id<DropDownMeunDelegate>delegate;



- (id)initTableViewWithFrame:(CGRect)frame andDataArray:(NSMutableArray *)dataArray;
/*
 *   显示table目录列表
 */
- (void)tableViewAppear;

/*
 *  移除table目录列表
 */
- (void)tableViewDismiss;


#pragma mark ========UICollectionView=======

@property (assign, nonatomic) CGSize ItemSize;


- (id)initCollectionFrame:(CGRect)frame andItemSize:(CGSize)itemSize andDataArray:(NSArray *)dataArray;
/*
 *   显示collection目录列表
 */
- (void)collectionViewAppear;

/*
 *  移除collection目录列表
 */
- (void)collectionViewDismiss;


@end
