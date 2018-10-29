//
//  PropKeyModel.h
//  PanKeTong
//
//  Created by 连京帅 on 2018/3/15.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropKeyModel : NSObject

/*
 {
 ReceiverKeyId = "673c55ab-a811-c1a0-4e25-08d56fbd98cc",
 }
 */

@property (nonatomic, strong)NSString *keyId;                       // 钥匙id
@property (nonatomic, strong)NSString *propertyKeyId;               // 房源id
@property (nonatomic, assign)int propertyKeyStatus;                 // 状态  1无  2在店  3同行
@property (nonatomic, strong)NSString *remark;                      // 钥匙说明
@property (nonatomic, strong)NSString *receiverKeyId;              // 钥匙人id  keyPersonKeyId
@property (nonatomic, strong)NSString *receiver;               // 钥匙人名字 keyPersonName
@property (nonatomic, strong)NSString *departmentKeyId;    // 钥匙人的某个id

+ (PropKeyModel *)modelWithDict:(NSDictionary *)dict Model:(PropKeyModel *)model;

+ (NSDictionary *)dictWithModel:(PropKeyModel *)model;

@end
