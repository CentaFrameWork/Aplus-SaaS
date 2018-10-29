//
//  CustomGrid.h
//  MoveGrid
//
//  Created by fuzheng on 16-5-26.
//  Copyright © 2016年 付正. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

// 每行显示格子的列数
#define PerRowGridCount     4
// 每列显示格子的行数
#define PerColumGridCount   6
// 每个格子的X轴间隔
#define PaddingX            10*NewRatio
// 每个格子的Y轴间隔
#define PaddingY            10*NewRatio
// 每个格子的宽度
#define GridWidth           ((ScreenWidth - PaddingX * (PerRowGridCount + 1))/PerRowGridCount)
// 每个格子的高度
#define GridHeight          GridWidth


@protocol CustomGridDelegate;

@interface CustomGrid : UIButton
//格子的ID
@property(nonatomic, assign)NSInteger gridId;

//格子的title
@property(nonatomic, strong)NSString *gridTitle;
//格子的图片
@property(nonatomic, strong)NSString *gridImageString;

//格子的选中状态
@property(nonatomic, assign)BOOL      isChecked;
//格子的移动状态
@property(nonatomic, assign)BOOL      isMove;
//格子的排列索引位置
@property(nonatomic, assign)NSInteger gridIndex;
//格子的位置坐标
@property(nonatomic, assign)CGPoint   gridCenterPoint;
//代理方法
@property(nonatomic, weak)id<CustomGridDelegate> delegate;

/**
 * 创建格子
   gridId       格子的ID
   index        格子所在位置的索引下标
   isAddDelete  是否增加删除图标
 **/
- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
        normalImage:(UIImage *)normalImage
   highlightedImage:(UIImage *)highlightedImage
             gridId:(NSInteger)gridId
            atIndex:(NSInteger)index
         isShowIcon:(BOOL)isShowIcon
        isCanDelete:(BOOL)isCanDelete
         deleteIcon:(UIImage *)deleteIcon
      withIconImage:(NSString *)imageString;

// 根据格子的坐标计算格子的索引位置
+ (NSInteger)indexOfPoint:(CGPoint)point
               withButton:(UIButton *)btn
                gridArray:(NSMutableArray *)gridListArray;

// 添加格子后调用
- (void)addGridAction;

@end

@protocol CustomGridDelegate <NSObject>

// 响应格子的点击事件
- (void)gridItemDidClicked:(CustomGrid *)clickItem;

// 响应格子删除事件
- (void)gridItemDidDeleteClicked:(UIButton *)deleteButton;

// 响应格子的长安手势事件
- (void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture withGridItem:(CustomGrid *) grid;

- (void)pressGestureStateChangedWithPoint:(CGPoint) gridPoint gridItem:(CustomGrid *) gridItem;

- (void)pressGestureStateEnded:(CustomGrid *) gridItem;

@end


