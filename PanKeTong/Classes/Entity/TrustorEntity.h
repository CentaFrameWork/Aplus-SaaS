//
//  TrustorEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/9.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface TrustorEntity : SubBaseEntity

@property (nonatomic,copy) NSString *trustorName;
@property (nonatomic,copy) NSString *trustorType;
@property (nonatomic,copy) NSString *trustorMobile;
/**
 *  业主keyID
 */
@property (nonatomic, copy) NSString *keyId;

//陈行修改163bug
@property (nonatomic, copy) NSString * tel;
@property (nonatomic, copy) NSString * trustorTypeKeyId;


@end
