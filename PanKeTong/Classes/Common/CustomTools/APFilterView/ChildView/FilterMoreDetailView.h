//
//  FilterMoreDetailView.h
//  APlusFilterView
//
//  Created by 张旺 on 2017/10/25.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APFilterView.h"

#define ItemTitleBaseTag                30000
#define ArrowImageBaseTag               10000
#define ArrowDownGrayImgName        @"icon_jm_arrow_under_solid_gray"
#define ArrowDownRedImgName         @"icon_jm_arrow_under_solid_green"

typedef void(^ MoreFilterComplete)(void);
@interface FilterMoreDetailView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomConstant;      // 适配iPhone X

@property (nonatomic, strong)NSMutableDictionary *selectMoreItemDic;                // 选中更多筛选项字典
@property (nonatomic, copy)MoreFilterComplete block;

- (void)setFilterEntity:(FilterEntity *)filterEntity;

@end
