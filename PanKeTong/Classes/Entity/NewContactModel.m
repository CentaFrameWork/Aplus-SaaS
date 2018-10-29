//
//  NewContactModel.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/12.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "NewContactModel.h"

@implementation NewContactModel

+ (instancetype)modelWithDict:(NSDictionary *)dict keyId:(NSString *)keyId{
    NewContactModel *model = [[NewContactModel alloc] init];
//    [model setValuesForKeysWithDictionary:dict];

    model.typeSelectorKeyId = dict[@"TrustorTypeKeyId"];
    model.name = dict[@"TrustorName"];
    model.appellationSelectorKeyId = dict[@"TrustorGenderKeyId"];
    model.marriageSelectorKeyId = dict[@"MaritalStatusKeyId"];
    model.note = dict[@"Remark"];
    model.keyId = keyId;
    
    // 手机
    if ([dict[@"Mobile"] isEqualToString:@"(null)"]) {
        model.mobilePhone = @"";
    }else {
        model.mobilePhone = dict[@"Mobile"];
    }
    // 区号
    if ([dict[@"telphone1"] isEqualToString:@"(null)"]) {
        model.areaCode = @"";
    }else {
        model.areaCode = dict[@"telphone1"];
    }
    // 座机
    if ([dict[@"telphone2"] isEqualToString:@"(null)"]) {
        model.phone = @"";
    }else {
        model.phone = dict[@"telphone2"];
    }
    // 分机号
    if ([dict[@"telphone3"] isEqualToString:@"(null)"]) {
        model.extension = @"";
    }else {
        model.extension = dict[@"telphone3"];
    }
    
    // 联系人类型
    SysParamItemEntity *genderSysParamItemEntity1 = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_CUTOMER_TYPE];
    for (int i = 0; i<genderSysParamItemEntity1.itemList.count; i++) {
        SelectItemDtoEntity *itemDto = genderSysParamItemEntity1.itemList[i];
        if ([itemDto.itemValue isEqualToString:dict[@"TrustorTypeKeyId"]]) {
            model.typeSelector = [NSString stringWithFormat:@"%d",i];
        }
    }
    // 性别
    SysParamItemEntity *genderSysParamItemEntity2 = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_GENDER];
    for (int i = 0; i<genderSysParamItemEntity2.itemList.count; i++) {
        SelectItemDtoEntity *itemDto = genderSysParamItemEntity2.itemList[i];
        if ([itemDto.itemValue isEqualToString:dict[@"TrustorGenderKeyId"]]) {
            model.appellationSelector = [NSString stringWithFormat:@"%d",i];
        }
    }
    // 婚姻情况
    SysParamItemEntity *genderSysParamItemEntity3 = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_MARRIAGE_STATUS];
    for (int i = 0; i<genderSysParamItemEntity3.itemList.count; i++) {
        SelectItemDtoEntity *itemDto = genderSysParamItemEntity3.itemList[i];
        if ([itemDto.itemValue isEqualToString:dict[@"MaritalStatusKeyId"]]) {
            model.marriageSelector = [NSString stringWithFormat:@"%d",i];
        }
    }
    
    return model;
}

+ (NSDictionary *)dictWithArray:(NSArray *)array propertyKeyId:(NSString *)propertyKeyId {
    
    NSMutableArray *muArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<array.count; i++) {
        NewContactModel *model = array[i];
        NSDictionary *dic;
        dic = @{
                @"TrustorTypeKeyId":model.typeSelectorKeyId == nil?@"":model.typeSelectorKeyId,
                @"TrustorName":model.name == nil?@"":model.name,
                @"TrustorGenderKeyId":model.appellationSelectorKeyId == nil?@"":model.appellationSelectorKeyId,
                @"MaritalStatusKeyId":model.marriageSelectorKeyId == nil?@"":model.marriageSelectorKeyId,
                @"Mobile":model.mobilePhone == nil?@"":model.mobilePhone,
                
                @"areaCode":model.areaCode == nil?@"":model.areaCode,
                @"phone":model.phone == nil?@"":model.phone,
                @"extension":model.extension == nil?@"":model.extension,
                
                @"Tel":[NSString stringWithFormat:@"%@-%@-%@",model.areaCode == nil?@"":model.areaCode,model.phone == nil?@"":model.phone,model.extension == nil?@"":model.extension],
                @"Remark":model.note == nil?@"":model.note,
                @"KeyId":model.keyId == nil?@"":model.keyId
                };
        [muArray addObject:dic];
    }
    
    NSDictionary *dict = @{
                           @"Trustor":muArray == nil?@"":muArray,
                           @"PropertyKeyId":propertyKeyId == nil?@"":propertyKeyId,
                           };
    
    return dict;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
