//
//  WJAllDealModel.h
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/27.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJAllDealModel : NSObject
@property (nonatomic, copy) NSString *KeyId;//成交标示
@property (nonatomic, copy) NSString *TransactionNo;//成交编号
@property (nonatomic, copy) NSString *TransactionType;//成交类型
@property (nonatomic, copy) NSString *CreateTime;//创建时间
@property (nonatomic, copy) NSString *TransactionNode;//成交流程
@property (nonatomic, copy) NSString *CustomerName;//买房客户名称
@property (nonatomic, copy) NSString *TrustorName;//业主名称
@property (nonatomic, copy) NSString *PropertyNo;//房源编号
@property (nonatomic, copy) NSString *EstateName;//物业地址

- (WJAllDealModel *)initDic:(NSDictionary *)dic;



@end
