//
//  NewContactViewController.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/8.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "BaseViewController.h"

@interface NewContactViewController : BaseViewController

@property (nonatomic, strong)NSString *propertyKeyId;   // 房源keyid
@property (nonatomic, strong)NSString *keyId;           // 联系人id
@property (nonatomic, assign)BOOL isEditor;             // YES编辑  NO新增
@property (nonatomic, copy) void(^theRefresh)(void);

@end
