//
//  ChooseLocationViewController.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/25.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "BaseViewController.h"
#import "LocationEntity.h"

typedef void(^ locationBlock)(LocationEntity *locationEntity);
@interface ChooseLocationViewController : BaseViewController

@property (nonatomic, strong) LocationEntity *chooseLocationEntity; //选择过的地址进来后选中
@property (nonatomic, copy) locationBlock block;

@end
