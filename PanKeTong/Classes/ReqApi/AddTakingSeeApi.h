//
//  AddTakingSeeApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/16.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "APlusBaseApi.h"

///新增约看
@interface AddTakingSeeApi : APlusBaseApi

//数组集合
@property (nonatomic,strong) NSArray *inquiryFollows;//约看房源列表

//选择的房源
@property (nonatomic,strong) NSArray *selectPropertyArr;

//每个房源的约看信息
@property (nonatomic,copy) NSString *reserveTime;/// 约看时间
@property (nonatomic,copy) NSString *content;/// 反馈
@property (nonatomic,copy) NSString *custumerKeyId; /// 客户
@property (nonatomic,copy) NSString *inquiryKeyId;/// 客源
@property (nonatomic,strong) NSArray *msgUserKeyIds;/// 跟进站内信对应人
@property (nonatomic, copy) NSString *propertyKeyId;
/*[
                  "164fa2be-dee2-45af-b9de-e1d0df069524",
                  "dcfa9339-8c89-4815-81e0-2639fdff35a4",
                  "0a8270a7-5e6f-41ca-96db-c57e68bbea43"
                  ], /// 跟进站内信对应人
 */


@property (nonatomic,strong)NSArray *MsgDeptKeyIds;/// 跟进站内信对应部门
/* [
                  "276dc91a-e713-4abd-854d-423afd6f6a63",
                  "00f8730b-d873-421f-8121-25f2bae22ca0",
                  "960f5153-5dc6-471a-a574-3cb498fd983e"
                  ]/// 跟进站内信对应部门
 */


//====================================================
//广州新增字段
@property (nonatomic, strong) NSArray *reserves;
@property (nonatomic, copy) NSString *msgTime;//提醒时间

@end
