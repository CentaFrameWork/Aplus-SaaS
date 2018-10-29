//
//  Error.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/30.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef	uint32_t ERROR_STATUS;
enum {
    NONE_ERROR = 0,
    ERROR = 1
};

@interface Error : NSError

@property (nonatomic, assign) ERROR_STATUS status;
@property (nonatomic, assign) NSInteger rCode;
@property (nonatomic, strong) NSString *rDescription;
@property (nonatomic, assign) NSInteger httpCode;

@property (nonatomic, assign) BOOL isDataError;

+ (Error *)sharedError;

@end
