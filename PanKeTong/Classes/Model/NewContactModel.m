//
//  NewContactModel.m
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/12.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "NewContactModel.h"

@implementation NewContactModel

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    NewContactModel *model = [[NewContactModel alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}

+ (NSMutableArray *)dictWithArray:(NSArray *)array {
    
    NSMutableArray *muArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<array.count; i++) {
        NewContactModel *model = array[i];
        NSDictionary *dic;
        dic = @{
                @"typeSelector":model.typeSelector == nil?@"":model.typeSelector,
                @"name":model.name == nil?@"":model.name,
                @"appellationSelector":model.appellationSelector == nil?@"":model.appellationSelector,
                @"marriageSelector":model.marriageSelector == nil?@"":model.marriageSelector,
                @"mobilePhone":model.mobilePhone == nil?@"":model.mobilePhone,
                @"areaCode":model.areaCode == nil?@"":model.areaCode,
                @"phone":model.phone == nil?@"":model.phone,
                @"extension":model.extension == nil?@"":model.extension,
                @"note":model.note == nil?@"":model.note
                };
        [muArray addObject:dic];
    }
    return muArray;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
