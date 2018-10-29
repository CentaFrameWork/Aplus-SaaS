//
//  EditViewController.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/21.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "BaseViewController.h"
#import "PropPageDetailEntity.h"


///编辑房源
@interface EditViewController : BaseViewController


//@property (nonatomic,strong)PropPageDetailEntity *propertyDetailEntity;

@property (nonatomic,copy)NSString *propTrustType;//房源租售类型

@property (nonatomic,copy)NSString *propertyKeyId;//房源keyID

@end
