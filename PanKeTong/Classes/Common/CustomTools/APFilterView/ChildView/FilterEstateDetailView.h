//
//  FilterEstateDetailView.h
//  APlusFilterView
//
//  Created by 张旺 on 2017/10/25.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterEntity.h"

#define TableViewCellHeight            50

typedef void(^selectTableViewCellBlock)(NSString *);

@interface FilterEstateDetailView : UIView

@property(nonatomic, assign)NSInteger tableViewNumber;  // 显示几列就用几个tableVIew

@property(nonatomic, copy)selectTableViewCellBlock block;

- (void)setDataSourceWithDataArray:(NSArray *)dataArray
                 andItemTitleArray:(NSArray *)itemTitleArray
                    andSelectIndex:(NSInteger)selectIndex
                   andFilterEntity:(FilterEntity *)filterEntity;

@end
