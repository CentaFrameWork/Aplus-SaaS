//
//  MyClientApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/1.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
#import "CustomerListEntity.h"
/// 我的客户列表
@interface MyClientApi : APlusBaseApi
@property (nonatomic, copy) NSString *privateInquiryRange;      // 私客查看范围枚举：1-全部，3-本部，4-本人
@property (nonatomic, strong) NSArray *inquiryStatusKeyIds;     // 客源状态KeyId集合
@property (nonatomic, copy) NSString *contactType;              // 联系人方式
@property (nonatomic, copy) NSString *contactContent;           // 联系数据
@property (nonatomic, strong) NSArray *houseTypeKeyIds;         // 房型KeyId集合
@property (nonatomic, copy) NSString *inquiryTag;               // 客源标签
@property (nonatomic, copy) NSString *isExpire30Day;            // 30天到期客
@property (nonatomic, copy) NSString *inquiryTradeTypeKeyId;    // 客源交易类型（求购、求租、租购）KeyId
@property (nonatomic, copy) NSString *salePriceFrom;            // 售价区间
@property (nonatomic, copy) NSString *salePriceTo;              // 售价区间
@property (nonatomic, copy) NSString *rentPriceFrom;            // 租价区间
@property (nonatomic, copy) NSString *rentPriceTo;              // 租价区间
@property (nonatomic, copy) NSString *searchKey;                // 搜索关键字
@property (nonatomic, copy) NSString *pageIndex;                // 当前页码
@property (nonatomic, copy) NSString *pageSize;                 // 页容量
@property (nonatomic, copy) NSString *sortField;                // 排序字段名称
@property (nonatomic, copy) NSString *ascending;                // 排序方向
@property (nonatomic, copy) NSString *chiefKeyId;           // 原客源所属人KeyId
@property (nonatomic, copy) NSString *chiefDeptKeyId;       // 原客源所属人部门KeyId

@end
