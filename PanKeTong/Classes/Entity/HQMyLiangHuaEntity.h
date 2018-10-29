//
//  HQMyLiangHuaEntity.h
//  PanKeTong
//
//  Created by 中原管家 on 2016/11/24.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "SubBaseEntity.h"

@interface HQMyLiangHuaEntity : SubBaseEntity

@property (nonatomic,copy)NSString *userKeyId;//用户ID
@property (nonatomic,copy)NSString *employeeName;// 用户名称
@property (nonatomic,copy)NSString *departmentKeyId;// 部门ID
@property (nonatomic,copy)NSString *parentDepartmentKeyId;// 父部门ID
@property (nonatomic,copy)NSString *departmentName;// 部门名称
@property (nonatomic,copy)NSString *departmentNo;// 部门编号
@property (nonatomic,copy)NSString *startDate;// 开始日期
@property (nonatomic,copy)NSString *endDate;// 结束日期
@property (nonatomic,copy)NSString *level;// 部门等级
@property (nonatomic,copy)NSString *type;// 详情类型
@property (nonatomic,copy)NSString *dateType;// 日期类型
@property (nonatomic,copy)NSString *remark;// 备注
@property (nonatomic,copy)NSString *column;// 列
@property (nonatomic,copy)NSString *sDate;// 日期
@property (nonatomic,copy)NSString *theNewInquirysCountSale; //纯新增售客源Sale数量
@property (nonatomic,copy)NSString *theNewInquirysCountRent;// 纯新增租客源Rent数量
@property (nonatomic,copy)NSString *dragInquirysCountRent;// 公客池捞客租客源Rent数量 (String)
@property (nonatomic,copy)NSString *dragInquirysCountSale;// 公客池捞客售客源Sale数量
@property (nonatomic,copy)NSString *inquirysCountSaleSum;// 售客源Sale总数量
@property (nonatomic,copy)NSString *inquirysCountRentSum;// 租客源Rent总数量
@property (nonatomic,copy)NSString *theNewPropertysCountRent;// 纯新增租房源Rent数量
@property (nonatomic,copy)NSString *theNewPropertysCountSale;// 纯新增售房源Sale数量
@property (nonatomic,copy)NSString *propertysCountRentSum;// 租房源Rent总数量
@property (nonatomic,copy)NSString *propertysCountSaleSum;// 售房源Sale总数量
@property (nonatomic,copy)NSString *keysRent;// 新增钥匙
@property (nonatomic,copy)NSString *exclusive;// 新增独家
@property (nonatomic,copy)NSString *realSurvey;// 新增实勘 (String)
@property (nonatomic,copy)NSString *propertyFllow;// 新增房源跟进 (String)
@property (nonatomic,copy)NSString *takeSeeRent;// 新增租带看客源 (String)
@property (nonatomic,copy)NSString *takeSeeSale;// 新增售带看客源 (String)
@property (nonatomic,copy)NSString *takeSeeSum;// 新增带看客源总数量 (String)
@property (nonatomic,copy)NSString *inquiryFllow;// 新增客源跟进 (String)
@property (nonatomic,copy)NSString *commission;// 佣金,数字字符串 (String)
@property (nonatomic,copy)NSString *officialWebsite;// 官网数量 (String)
@property (nonatomic,copy)NSString *clone;// 克隆数量 (String)
@property (nonatomic,copy)NSString *changeCount;// 叫价申请次数
@property (nonatomic,copy)NSString *browsePhoneCount;// 业务员看业主电话数量
@property (nonatomic,copy)NSString *exclusiveEntrustCount;// 压房数量
@property (nonatomic,copy)NSString *virtualNumberCount;// 虚拟号拨打数量
@property (nonatomic,copy)NSString *channelInquiryCount;// 400 渠道来电统计

@end
