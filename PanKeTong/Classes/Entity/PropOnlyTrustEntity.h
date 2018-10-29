//
//  PropOnlyTrustEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface PropOnlyTrustEntity : SubBaseEntity

/// <summary>
///  独家上传人
/// </summary>
@property (nonatomic,strong) NSString *onlyTrustPerson;
/// <summary>
///  独家类型上钱/未上钱
/// </summary>
@property (nonatomic,strong) NSString *onlyTrustType;
/// <summary>
///  独家有效时间
/// </summary>
@property (nonatomic,strong) NSString *effectiveDate;

@end
