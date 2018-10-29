//
//  PropKeyModel.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/15.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "PropKeyModel.h"

@implementation PropKeyModel

+ (PropKeyModel *)modelWithDict:(NSDictionary *)dict Model:(PropKeyModel *)model {
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+ (NSDictionary *)dictWithModel:(PropKeyModel *)model {
    
    
    NSDictionary *dict = @{
                           @"keyId":model.keyId,
                           @"propertyKeyId":model.propertyKeyId?@"":model.propertyKeyId,
                           @"propertyKeyStatus":@(model.propertyKeyStatus),
                           @"remark":model.remark?@"":model.remark,
                           @"keyPersonKeyId":model.keyPersonKeyId?@"":model.keyPersonKeyId,
                           @"keyPersonName":model.keyPersonName?@"":model.keyPersonName,
                           @"keyPersonDepartmentKeyId":model.keyPersonDepartmentKeyId?@"":model.keyPersonDepartmentKeyId,
                           @"isMobileRequest":@(1),
                           };
    
    return dict;
}

@end
