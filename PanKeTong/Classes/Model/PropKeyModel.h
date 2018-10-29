//
//  PropKeyModel.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/15.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropKeyModel : NSObject

@property (nonatomic, strong)NSString *keyId;                       // 房源id
@property (nonatomic, strong)NSString *propertyKeyId;               // 房源id
@property (nonatomic, assign)int propertyKeyStatus;                 // 状态  1无  2在店  3同行
@property (nonatomic, strong)NSString *remark;               // 备注
@property (nonatomic, strong)NSString *keyPersonKeyId;              // 钥匙人id
@property (nonatomic, strong)NSString *keyPersonName;               // 钥匙人名字
@property (nonatomic, strong)NSString *keyPersonDepartmentKeyId;    // 钥匙人的某个id
@property (nonatomic, assign)int isMobileRequest;                   // 1手机  0pc

+ (PropKeyModel *)modelWithDict:(NSDictionary *)dict Model:(PropKeyModel *)model;

+ (NSDictionary *)dictWithModel:(PropKeyModel *)model;

@end
