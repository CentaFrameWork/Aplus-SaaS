//
//  FaceRecogApi.h
//  PanKeTong
//
//  Created by 乔书超 on 2017/12/8.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "FaceBaseApi.h"
#import "FaceRecogEntity.h"

/*
 CompanyCode    string        城市编号
 StaffCode      string        员工编号
 AppCode        string        应用编号
 CallOn         string        调用时间
 Sign           string        签名结果
 ImageBest	string	No
 ImageEnv	string	No
 Delta
  */

@interface FaceRecogApi : FaceBaseApi

@property (nonatomic, copy) NSString *companyCode;
@property (nonatomic, copy) NSString *staffCode;
@property (nonatomic, copy) NSString *appCode;
@property (nonatomic, copy) NSString *callOn;
@property (nonatomic, copy) NSString *sign;
@property (nonatomic, copy) NSString *imageBest;
@property (nonatomic, copy) NSString *imageEnv;
@property (nonatomic, copy) NSString *delta;


@end
