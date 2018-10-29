//
//  DascomGetPhoneBodyEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MTLModel.h"
#import "MTLJSONAdapter.h"
#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@interface DascomGetPhoneBodyEntity : MTLModel<MTLJSONSerializing>

//用户主号码
@property (nonatomic, strong) NSString  *mMsisdn;
//用户副号码
@property (nonatomic, strong) NSString  *mSsmnNumber;


@end
