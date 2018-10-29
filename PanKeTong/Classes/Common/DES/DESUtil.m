//
//  DESUtil.m
//  testdes
//
//  Created by 陈行 on 2018/6/19.
//  Copyright © 2018年 陈行. All rights reserved.
//

#import "DESUtil.h"
#import "GTMBase64.h"

#import <CommonCrypto/CommonCryptor.h>

@implementation DESUtil

+ (NSString *)encrypWithText:(NSString *)text andKey:(NSString *)key{
    
    NSString *ciphertext = nil;
    const char *textBytes = [text UTF8String];
    NSUInteger dataLength = [text length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    const void *iv = (const void *)[key UTF8String];
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          textBytes,
                                          dataLength,
                                          buffer,
                                          1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [[NSString alloc] initWithData:[GTMBase64 encodeData:data] encoding:NSUTF8StringEncoding];
    }
    return ciphertext;
    
}

@end
