//
//  DecodePhoneNoUtils.h
//  PanKeTong
//
//  Created by 乔书超 on 2017/11/27.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DecodePhoneNoUtils : NSObject

+ (DecodePhoneNoUtils *)sharedDecodeUtils;

- (NSString *)decodePhoneNo:(NSString *)encodeContent;

@end
