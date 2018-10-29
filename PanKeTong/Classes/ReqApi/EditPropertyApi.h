//
//  EditPropertyApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/23.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

///编辑房源
@interface EditPropertyApi : APlusBaseApi

@property (nonatomic,copy)NSString *square;//面积
@property (nonatomic,copy)NSString *squareUse;//实用面积
@property (nonatomic,copy)NSString *rentPrice;//租价
@property (nonatomic,copy)NSString *salePrice;//售价
@property (nonatomic,copy)NSString *houseDirectionKeyId;//房屋朝向keyid
@property (nonatomic,copy)NSString *propertyRightNatureKeyId;//产权性质keyid
@property (nonatomic,copy)NSString *propertyUsageKeyId;//房屋用途keyid
@property (nonatomic,copy)NSString *trustType;// 房屋租售类型
@property (nonatomic,copy)NSString *keyId;//房源keyid

@end
