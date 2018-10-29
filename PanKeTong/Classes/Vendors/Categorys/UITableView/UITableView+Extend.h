//
//  UITableView+Extend.h
//  APlus
//
//  Created by 李慧娟 on 2017/11/22.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"


@interface UITableView (Extend)

///// 创建公共下拉刷新
//- (void)createHeaderRefreshWithTarget:(id)target
//                            andAction:(SEL)action;
///// 结束下拉刷新
//- (void)endHeaderRefresh;
//
//
///// 创建公共上拉加载
//- (void)createFooterRefreshWithTarget:(id)target
//                            andAction:(SEL)action;
//
///// 结束上拉加载
//- (void)endFooterRefreshWithNoMore:(BOOL)noMore;


/// 从xib中加载cell
- (UITableViewCell *)cellFromXib:(NSString *)identifier;

@end
