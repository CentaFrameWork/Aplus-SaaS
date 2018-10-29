//
//  SystemParamTypeEnum.h
//  PanKeTong
//
//  Created by 燕文强 on 16/8/20.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#ifndef SystemParamTypeEnum_h
#define SystemParamTypeEnum_h

enum SystemParamTypeEnum {
    SystemParamTypeEnum_COMMUNITY_PIC = 1,          //小区图
    SystemParamTypeEnum_INDOOR_PIC = 2,             //室内图
    SystemParamTypeEnum_BUILDING_TYPE = 4,          //建筑类型
    SystemParamTypeEnum_DIRECTION = 8,              //朝向
    SystemParamTypeEnum_TRUST_TYPE = 20,            //交易类型
    SystemParamTypeEnum_TRUST_CONTACT_TYPE = 41,    //客户联系人类型
    SystemParamTypeEnum_CUSTOMER_CONTACT_TYPE = 60, // 客源跟进类型
    SystemParamTypeEnum_GENDER = 23,                //性别
    SystemParamTypeEnum_PROP_SITUATION = 24,        //房源现状
    SystemParamTypeEnum_ROOM_TYPE = 25,             //房型
    SystemParamTypeEnum_PROP_TAG = 27,              //房源标签
    SystemParamTypeEnum_PROP_FOLLOW_TYPE = 29,      //房源跟进类型
    SystemParamTypeEnum_CUTOMER_TRADE_TYPE = 45,    //客源交易类型
    SystemParamTypeEnum_CUTOMER_STATUS = 52,        //客户状态
    SystemParamTypeEnum_MARRIAGE_STATUS = 118,    // 婚姻情况
    SystemParamTypeEnum_HOUSE_TYPE_PIC = 56,        //户型图
    SystemParamTypeEnum_CUSTOMER_FOLLOW_TYPE = 60,  //客源跟进类型
    SystemParamTypeEnum_PROP_STATUS = 75,           //房源状态
    SystemParamTypeEnum_CUTOMER_TYPE = 21,          //委托人类型
    SystemParamTypeEnum_CUTOMER_SOURCE = 50,        //客源来源
    SystemParamTypeEnum_PURCHASE_REASON = 46,       //购房原因
    SystemParamTypeEnum_REGION_SELECTION = 125,     //区域选择 (手机号)
    SystemParamTypeEnum_DECORATION_SITUATION = 38,  //装修情况
    SystemParamTypeEnum_BUYHOUSE_PAYMENT_METHOD = 49,   // 买房付款方式
    SystemParamTypeEnum_ENTRUSTFILING_PHOTOTYPE = 122,  // 新增委托照片类型
    SystemParamTypeEnum_PHOTOTYPE_KEYID = 130,// 上传视频KeyId
    SystemParamTypeEnum_PayType_KEYID = 119
    
};

/// 房源搜索的智能提示查询类型枚举值
enum EstateSelectTypeEnum {
    /// 行政区 "1"
    EstateSelectTypeEnum_DISTRICTNAME = 1,
    /// 地理片区 "2"
    EstateSelectTypeEnum_REGIONNAME,
    /// 楼盘 "3"
    EstateSelectTypeEnum_ESTATENAME,
    /// 全部 "4"
    EstateSelectTypeEnum_ALLNAME,
    /// 楼栋 "5"
    EstateSelectTypeEnum_BUILDINGBELONG,
    
};




/// 房源租售状态
enum TrustTypeEnum {
    typeDfeauth = 0,
    SALE = 1,//出售
    RENT = 2,//出租
    BOTH = 3,//租售
    RENTBOTH = 4,//出租 租售
    SALEBOTH = 5,//出售 租售
    ALLBOTH = 6,//全部
};

/// 委托审批状态
enum EntrustStateEnum {
    NOENTRUST = -1,      // 无委托信息
    AUDIT = 0,          // 待审核
    AUDITED = 1,        // 审核通过
    AUDITREJECT = 2,    // 审核拒绝
};


#endif /* SystemParamTypeEnum_h */
