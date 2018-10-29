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
                           @"keyId":model.keyId == nil?@"":model.keyId,
                           @"propertyKeyId":model.propertyKeyId == nil?@"":model.propertyKeyId,
                           @"propertyKeyStatus":@(model.propertyKeyStatus),
                           @"remark":model.remark == nil?@"":model.remark,
                           @"receiverKeyId":model.receiverKeyId == nil?@"":model.receiverKeyId,
                           @"receiver":model.receiver == nil?@"":model.receiver,
                           @"departmentKeyId":model.departmentKeyId == nil?@"":model.departmentKeyId,
                           };
    return dict;
}

@end
