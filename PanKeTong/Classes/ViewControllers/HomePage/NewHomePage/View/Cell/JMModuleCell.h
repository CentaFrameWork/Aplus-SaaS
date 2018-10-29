//
//  ModuleCell.h
//  APlus
//
//  Created by 李慧娟 on 2017/10/13.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPConfigEntity.h"

/// 模块视图cell
@interface JMModuleCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemWidth;

@property (nonatomic, strong) APPLocationEntity *entity;

@end
