//
//  ModuleCollectionView.h
//  APlus
//
//  Created by 李慧娟 on 2017/10/13.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Item_width   65*NewRatio

#define Module_space (APP_SCREEN_WIDTH - (Item_width * 4)) / 5
/// 模块视图
@interface ModuleCollectionView : UICollectionView <UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataArr;

@end
