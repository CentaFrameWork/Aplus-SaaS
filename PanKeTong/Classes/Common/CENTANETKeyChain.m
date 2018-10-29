//
//  CENTANETKeyChain.m
//  PanKeTong
//

#import "CENTANETKeyChain.h"

@implementation CENTANETKeyChain




#define AppUniqueIdentifier @"AppUniqueIdentifierPanKeTong"

/*
 *  获取应用在设备的唯一标示存入到钥匙串中 防止卸载或重启程序后发生变化
 *  唯一标示组成：
 *      >= iOS7:           [UUID+model+localizedModel md5]
 *      <  iOS6:           [Mac地址+model+localizedModel md5]
 *  先获取钥匙串中所存入的唯一标示 如果为空 将生成的唯一标示存入
 */
+ (NSString *)getAppOnlyIdentifierOnDevice
{
    NSString *machineId = @"";
    
    NSString *bundleIdentifier = [NSString stringWithFormat:@"%@_CENTANET",[[NSBundle mainBundle] bundleIdentifier]];

    
    NSMutableDictionary *onlySignDic = [CENTANETKeyChain load:bundleIdentifier];
    
    NSString *onlySign = [onlySignDic objectForKey:AppUniqueIdentifier];
    
    if ( !onlySign || ![onlySign length]) {
        
        [CENTANETKeyChain delete:bundleIdentifier];
        
        UIDevice *device = [UIDevice currentDevice];
        
        if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0){
            
            NSString *uuid = [[device identifierForVendor] UUIDString];
            machineId = [NSString stringWithFormat:@"%@,%@,%@",uuid,device.model,device.localizedModel];
            
        }else{
            
            machineId = [NSString stringWithFormat:@"%@,%@,%@",[device getMacAddress],device.model,device.localizedModel];
        }
        
        machineId = [machineId md5];
        
        NSMutableDictionary *appUniqueIdentifierKVPairs = [NSMutableDictionary dictionary];
        [appUniqueIdentifierKVPairs setObject:machineId forKey:AppUniqueIdentifier];
        [CENTANETKeyChain save:bundleIdentifier data:appUniqueIdentifierKVPairs];
        
    }else {
        
        machineId = [onlySignDic objectForKey:AppUniqueIdentifier];
    }
    
    return machineId;
}


+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

+ (void)delete:(NSString *)service {
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
}

@end
