//
//  NewContactModel.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/12.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewContactModel : NSObject

@property (nonatomic, copy)NSString *typeSelector;              // 联系人类型
@property (nonatomic, copy)NSString *typeSelectorKeyId;         // 联系人类型id      TrustorTypeKeyId
@property (nonatomic, copy)NSString *name;                      // 姓名             TrustorName
@property (nonatomic, copy)NSString *appellationSelector;       // 联系人称谓
@property (nonatomic, copy)NSString *appellationSelectorKeyId;  // 联系人称谓id      TrustorGenderKeyId
@property (nonatomic, copy)NSString *marriageSelector;          // 婚姻情况
@property (nonatomic, copy)NSString *marriageSelectorKeyId;     // 婚姻情况id       MaritalStatusKeyId
@property (nonatomic, copy)NSString *mobilePhone;               // 手机号           Mobile
@property (nonatomic, copy)NSString *areaCode;                  // 区号
@property (nonatomic, copy)NSString *phone;                     // 电话             Tel
@property (nonatomic, copy)NSString *extension;                 // 分机
@property (nonatomic, copy)NSString *note;                      // 备注            Remark
@property (nonatomic, copy)NSString *keyId;                     // 编辑是联系人的id



+ (instancetype)modelWithDict:(NSDictionary *)dict keyId:(NSString *)keyId;
+ (NSDictionary *)dictWithArray:(NSArray *)array propertyKeyId:(NSString *)propertyKeyId;

@end
