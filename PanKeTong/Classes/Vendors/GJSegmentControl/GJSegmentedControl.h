//
//  GJSegmentedControl.h
//  PanKeTong
//
//  Created by zhwang on 16/4/6.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  选择筛选项后回调的block
 */
typedef void(^GJSegmentedIndexChangeBlock)(NSInteger selectedIndex);

///自定义工具类
@interface GJSegmentedControl : UIView

/**
 *  设置title数据源
 */
-(void)sectionTitles:(NSArray *)sectionTitles;

/**
 *  设置默认选中项
 */
-(void)selectedItemWithIndex:(NSInteger)selectedIndex;


/**
 *  设置回调block
 */
-(void)indexChangeBlock:(GJSegmentedIndexChangeBlock)indexChangeBlock;


@end
