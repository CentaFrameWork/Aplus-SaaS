//
//  DascomReceiveNumberEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 15/11/3.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "MTLModel.h"
#import "DascomGetPhoneHeaderEntity.h"
#import "ReceiveBodyEntity.h"


@interface DascomReceiveNumberEntity : MTLModel<MTLJSONSerializing>

@property (nonatomic,strong) DascomGetPhoneHeaderEntity *mHeader;
@property (nonatomic,strong) ReceiveBodyEntity *mBody;
@property (nonatomic,assign) NSInteger tag;

@end
