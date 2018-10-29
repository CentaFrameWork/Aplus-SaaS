//
//  Error.m
//  PanKeTong
//
//  Created by 苏军朋 on 15/9/30.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "Error.h"

static Error *error = nil;

@implementation Error

+ (Error *)sharedError {
    @synchronized (self) {
        if (error == nil) {
            error = [[self alloc] init];
            [error setStatus:ERROR];
        }
    }
    
    return error;
}

@end
