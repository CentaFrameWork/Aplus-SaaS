//
//  SelectPropertyEntity.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/15.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PropertysModelEntty.h"

@interface SelectPropertyEntity : NSObject

@property (nonatomic,strong)PropertysModelEntty *propertyEntity;//约看房源

@property (nonatomic,copy)NSString *takeSeeType;//约看类型

@property (nonatomic,copy)NSString *takeSeeTime;//约看时间

@property (nonatomic,copy)NSString *content;
@end
