//
//  PublishEstateOrCustomerViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"

typedef enum
{
    TrustTypeSale = 1,
    TrustTypeRent,
    TrustTypeBoth,
}TrustType;

@interface CommonEstateOrCustomerVC : BaseViewController

@property (nonatomic,assign)BOOL isPublishEstate;

@end
