//
//  ZYHomeMainView.h
//  Aplus-SaaS
//
//  Created by 陈行 on 2018/8/27.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYMainTableView.h"

@interface ZYHomeMainView : ZYMainTableView<UITableViewDataSource>
- (void)setViewData :(NSObject*)data;
@end
