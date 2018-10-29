//
//  RealSurveyStatusEnum.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/26.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#ifndef RealSurveyStatusEnum_h
#define RealSurveyStatusEnum_h

///实勘审核状态
enum RealSurveyStatusEnum{
    UNAPPROVED = 0,//未审核
    APPROVED = 1,//审核通过
    REJECT = -1,//审核拒绝
    TWOAPPROVED = 2,//复审通过
    TWOREJECT = -2,//复审拒绝
    UNSUBMIT = -3, // 待提交
};

#endif /* RealSurveyStatusEnum_h */
