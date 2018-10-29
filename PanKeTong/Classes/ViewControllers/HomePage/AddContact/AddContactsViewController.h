//
//  AddContactsViewController.h
//  PanKeTong
//
//  Created by TailC on 16/4/5.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "BaseViewController.h"
#import "ApplyTransferPubEstViewController.h"
#import "PropertyFollowAllAddEntity.h"

@class PropertysModelEntty;

@interface AddContactsViewController : BaseViewController

@property (strong, nonatomic) PropertysModelEntty *propModelEntity;

@property (strong, nonatomic) NSString *propertyKeyId;

@property (nonatomic, assign) id <ApplyTransferEstDelegate> delegate;

@property (strong, nonatomic) PropertyFollowAllAddEntity *propertyFollowAllAddEntity;

@property (copy, nonatomic) NSString *contactTypeStr;                // 联系人类型名
@property (copy, nonatomic) NSString *contactRender;                 // 联系人性别名
@property (copy, nonatomic) NSString *phoneType;                     // 手机类型 (大陆/港台之类)
@property (nonatomic, strong) NSMutableArray *phoneTypeArray;        // 手机类型
@property (nonatomic, strong) NSMutableArray *phoneTypeVauleArray;   // 手机类型

@property (nonatomic,strong)NSIndexPath *indexPath;

@end
