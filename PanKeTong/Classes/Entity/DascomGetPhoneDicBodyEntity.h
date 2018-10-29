//
//  DascomGetPhoneDicBodyEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/6.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MTLModel.h"
#import "DascomGetPhoneHeaderEntity.h"

@interface DascomGetPhoneDicBodyEntity : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong) DascomGetPhoneHeaderEntity *mHeader;
@property (nonatomic,strong) NSDictionary *mBody;
@property (nonatomic,assign) NSInteger tag;

@end
