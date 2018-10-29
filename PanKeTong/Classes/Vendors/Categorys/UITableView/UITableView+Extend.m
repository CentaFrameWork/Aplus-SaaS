//
//  UITableView+Extend.m
//  APlus
//
//  Created by 李慧娟 on 2017/11/22.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "UITableView+Extend.h"

@implementation UITableView (Extend)

///// 创建公共下拉刷新
//- (void)createHeaderRefreshWithTarget:(id)target
//                            andAction:(SEL)action
//{
//    MJRefreshNormalHeader *headerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:target
//                                                                            refreshingAction:action];
//
//    headerRefresh.lastUpdatedTimeLabel.hidden = YES;
//    self.mj_header = headerRefresh;
//}
//
///// 结束下拉刷新
//- (void)endHeaderRefresh
//{
//    [self.mj_header endRefreshing];
//}
//
//
///// 创建公共上拉加载
//- (void)createFooterRefreshWithTarget:(id)target
//                            andAction:(SEL)action
//{
//    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
//
//    refreshFooter.automaticallyRefresh = YES;
//    refreshFooter.automaticallyHidden = YES;
//
//    self.mj_footer = refreshFooter;
//}
//
//
///// 结束上拉加载
//- (void)endFooterRefreshWithNoMore:(BOOL)noMore
//{
//    if (noMore)
//    {
//        [self.mj_footer endRefreshingWithNoMoreData];
//    }
//    else
//    {
//        [self.mj_footer endRefreshing];
//    }
//}

/// 从xib中加载cell
- (UITableViewCell *)cellFromXib:(NSString *)identifier
{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:identifier owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}


@end
