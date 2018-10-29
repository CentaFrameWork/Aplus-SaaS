//
//  CustomGrid.m
//  MoveGrid
//
//  Created by fuzheng on 16-5-26.
//  Copyright © 2016年 付正. All rights reserved.
//

#import "CustomGrid.h"

@implementation CustomGrid
{
    BOOL _isEmpty;  // 是否为最后一个占位格子
    BOOL _canDelete;// 是否能删除
}
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

//创建格子
- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
        normalImage:(UIImage *)normalImage
   highlightedImage:(UIImage *)highlightedImage
             gridId:(NSInteger)gridId
            atIndex:(NSInteger)index
         isShowIcon:(BOOL)isShowIcon
        isCanDelete:(BOOL)isCanDelete
         deleteIcon:(UIImage *)deleteIcon
      withIconImage:(NSString *)imageString
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _isEmpty = !isShowIcon;
        _canDelete = isCanDelete;
        // 计算每个格子的X坐标
        CGFloat pointX = (index % PerRowGridCount) * (GridWidth + PaddingX) + PaddingX;
        // 计算每个格子的Y坐标
        CGFloat pointY = (index / PerRowGridCount) * (GridHeight + PaddingY) + PaddingY;
        
        [self setFrame:CGRectMake(pointX, pointY, GridWidth+1, GridHeight+1)];
        self.backgroundColor = APP_BACKGROUND_COLOR;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:14*NewRatio];
        [self addTarget:self action:@selector(gridClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 图片icon
        UIImageView *imageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-18*NewRatio, self.frame.size.height / 2 - 18*NewRatio - 10*NewRatio, 40*NewRatio, 40*NewRatio)];
        [imageIcon sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"mrt"]];
        imageIcon.tag = self.gridId;
        [self addSubview:imageIcon];
        
        // 标题
        UILabel * title_label = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/2-42*NewRatio, imageIcon.bottom + 5*NewRatio, 84*NewRatio, 20*NewRatio)];
        title_label.text = title;
        title_label.textAlignment = NSTextAlignmentCenter;
        title_label.font = [UIFont systemFontOfSize:14*NewRatio];
        title_label.backgroundColor = [UIColor clearColor];
        title_label.textColor = MainGrayFontColor;
        [self addSubview:title_label];
        
        // 设置属性
        [self setGridId:gridId];
        [self setGridImageString:imageString];
        [self setGridTitle:title];
        [self setGridIndex:index];
        [self setGridCenterPoint:self.center];
        
        // 判断是否要添加删除图标
        if (isShowIcon)
        {
            // 当长按时添加删除按钮图标
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            deleteBtn.contentMode = UIViewContentModeScaleAspectFit;
            [deleteBtn setFrame:CGRectMake(imageIcon.right, 5*NewRatio, 20*NewRatio, 20*NewRatio)];
            [deleteBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [deleteBtn setBackgroundColor:[UIColor clearColor]];
            [deleteBtn setImage:deleteIcon forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(deleteGrid:) forControlEvents:UIControlEventTouchUpInside];
            [deleteBtn setHidden:NO];
            
            [deleteBtn setTag:gridId];
            [self addSubview:deleteBtn];

            // 添加长按手势
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gridLongPress:)];
            [self addGestureRecognizer:longPressGesture];
             longPressGesture = nil;
        }
        else
        {
            //最后一个占位格子
            self.backgroundColor = [UIColor whiteColor];
            CAShapeLayer *borderLayer = [CAShapeLayer layer];
            borderLayer.bounds = CGRectMake(0, 0, GridWidth, GridHeight);
            borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

            borderLayer.path = [UIBezierPath bezierPathWithRect:borderLayer.bounds].CGPath;
            borderLayer.lineWidth = 1.5;
            // 虚线边框
            borderLayer.lineDashPattern = @[@7, @7];
            borderLayer.fillColor = [UIColor clearColor].CGColor;
            borderLayer.strokeColor = RGBColor(230, 230, 230).CGColor;
            [self.layer addSublayer:borderLayer];

            for (UIView *subView in self.subviews)
            {
                [subView removeFromSuperview];
            }
        }
    }
    return self;
}


// 响应格子点击事件
- (void)gridClick:(CustomGrid *)clickItem
{
    if (_canDelete)
    {
        [self.delegate gridItemDidClicked:clickItem];
    }
}

- (void)deleteGrid:(UIButton *)deleteButton
{
    if (_canDelete)
    {
        [self.delegate gridItemDidDeleteClicked:deleteButton];
    }
}

// 响应格子的长按手势事件
- (void)gridLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    switch (longPressGesture.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self.delegate pressGestureStateBegan:longPressGesture withGridItem:self];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            // 应用移动后的新坐标
            CGPoint newPoint = [longPressGesture locationInView:longPressGesture.view];
            [self.delegate pressGestureStateChangedWithPoint:newPoint gridItem:self];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self.delegate pressGestureStateEnded:self];
            break;
        }
        default:
            break;
    }
}

// 根据格子的坐标计算格子的索引位置
+ (NSInteger)indexOfPoint:(CGPoint)point
               withButton:(UIButton *)btn
                gridArray:(NSMutableArray *)gridListArray
{
    for (NSInteger i = 0;i < gridListArray.count;i++)
    {
        UIButton *appButton = gridListArray[i];
        if (appButton != btn)
        {
            NSLog(@"point----%@",NSStringFromCGPoint(point));
            NSLog(@"appButton.frame----%@",NSStringFromCGRect(appButton.frame));
            if (CGRectContainsPoint(appButton.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}

// 添加格子后调用
- (void)addGridAction
{
    if (_isEmpty)
    {
        // 计算占位格子的X坐标
        CGFloat pointX;
        // 计算占位格子的Y坐标
        CGFloat pointY;
        if (self.gridIndex % PerRowGridCount == 0) {
            NSLog(@"第一个");
            // 最后一列 要换行
            pointX = PaddingX;
            pointY = (self.gridIndex / PerRowGridCount) * (GridHeight + PaddingY) + PaddingY;
        }
        else
        {
            pointX = (self.gridIndex % PerRowGridCount) * (GridWidth + PaddingX) + PaddingX;
            pointY = (self.gridIndex / PerRowGridCount) * (GridHeight + PaddingY) + PaddingY;
        }
        [UIView animateWithDuration:0.3 animations:^{
            [self setFrame:CGRectMake(pointX, pointY, GridWidth+1, GridHeight+1)];
        }];
    }
}

@end
