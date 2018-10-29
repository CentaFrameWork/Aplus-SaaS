//
//  AddEntrustFilingVC.h
//  PanKeTong
//
//  Created by 张旺 on 2017/7/18.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

@interface AddEntrustFilingVC : BaseViewController

@property(nonatomic, copy)NSString *signType;       //签署类型

@property(nonatomic, copy)NSString *propertyKeyId;  //房源id

/**
 *  新增成功
 */
@property (nonatomic, copy) void (^addEntrustfilingSuccBlock)(void);

@end
