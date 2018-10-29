//
//  HomeConfigUtils.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/6/30.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "HomeConfigUtils.h"
#import "CityConfigApi.h"
#import "CheckHttpErrorUtil.h"

@implementation HomeConfigUtils

static HomeConfigUtils *homeConfigUtils;


+ (HomeConfigUtils *)shareHomeConfigUtils
{
    if(homeConfigUtils)
    {
        return homeConfigUtils;
    }
    
    homeConfigUtils = [[self alloc]init];
    
    return homeConfigUtils;
}

/**
 *  获取城市配置
 */
- (void)getHomeConfig
{
    [homeConfigUtils hasManager];
    
    CityConfigApi *cityConfigApi = [[CityConfigApi alloc] init];
    [self.manager sendRequest:cityConfigApi];
    
}

- (void)hasManager
{
    if (!homeConfigUtils.manager) {
        homeConfigUtils.manager = [RequestManager initManagerWithDelegate:self];
    }
}



#pragma mark - <ResponseDelegate>

/// 响应成功
- (void)respSuc:(id)data andRespClass:(id)cls
{
    if([cls isEqual:CityConfigEntity.class]){
        //获取城市域名及保存
        CityConfigEntity * cityConfigEntity = [DataConvert convertDic:data toEntity:cls];
        
        [[BaseApiDomainUtil getApiDomain] saveApiDomainInfo:cityConfigEntity];
        
        // 检查通讯录授权
       
        [CommonMethod CheckAddressBookAuthorization:^(bool isAuthorized){
                
                if(isAuthorized)
                {
                    NSString *photoName = @"移动A+虚拟号";
                    NSString *photoNumber = [[BaseApiDomainUtil getApiDomain] getDascomNumber];
                    
                    // 通讯录无此联系人 且 虚拟号接入码为空时不做添加号码操作
                    if(![self filterContentForSearchText:photoName andNumber:photoNumber] && ![NSString isNilOrEmpty:photoNumber]){
                        [self addPeople];
                    }
                }
                else
                {
                    showMsg(@"请到设置>隐私>通讯录打开本应用的权限设置");
                }
            }];
        
    }
}


// 新增联系人
- (void)addPeople {
    
    NSString *phoneName = @"移动A+虚拟号";
    NSString *photoNumber = [[BaseApiDomainUtil getApiDomain] getDascomNumber];
    
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
    
    ABRecordRef newPerson = ABPersonCreate();
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(phoneName), nil);
    
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(photoNumber), kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, nil);
    
    CFRelease(multiPhone);
    
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, nil);
    ABAddressBookSave(iPhoneAddressBook, nil);
    CFRelease(newPerson);
    CFRelease(iPhoneAddressBook);
    
}


/**
 *  删除联系人
 */
- (void)deletePeople
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    // 获取通讯录中所有的联系人
    NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    // 遍历所有的联系人并删除(这里只删除姓名为张三的)
    for (id obj in array) {
        ABRecordRef people = (__bridge ABRecordRef)obj;
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
        
        if ([lastName isEqualToString:@"移动A+虚拟号"]) {
            ABAddressBookRemoveRecord(addressBook, people, NULL);
        }
    }
    // 保存修改的通讯录对象
    ABAddressBookSave(addressBook, NULL);
    // 释放通讯录对象的内存
    if (addressBook) {
        CFRelease(addressBook);
    }
    
}

- (BOOL)filterContentForSearchText:(NSString *)searchText andNumber:(NSString *)number
{
    NSInteger count = 0;
    BOOL phoneNumberBool = NO;
    
    // 判断授权状态
    if (ABAddressBookGetAuthorizationStatus()!=kABAuthorizationStatusAuthorized) {
        return YES;
    }
    
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (searchText.length == 0) {
        count = 0;
    }
    else
    {
        // 根据字符串查找前缀关键字
        CFStringRef cfSearchText = (CFStringRef)CFBridgingRetain(searchText);
        NSArray *listContacts = CFBridgingRelease(ABAddressBookCopyPeopleWithName(addressBook, cfSearchText));
        
        
        count = listContacts.count;
        
        for (int i = 0; i < count; i++) {
            // 从搜索出的联系人数组中获取一条数据 转换为ABRecordRef格式
            ABRecordRef thisPerson = CFBridgingRetain([listContacts objectAtIndex:i]);
            ABMultiValueRef valuesRef = ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);
            // 电话号码
            NSString *phoneNumber = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(valuesRef, 0));
            
            if([phoneNumber isEqualToString:number]){
                // 存在
                phoneNumberBool = YES;
            }
        }
        CFRelease(cfSearchText);
    }
    CFRelease(addressBook);
    
    if(count > 0 && phoneNumberBool){
        return YES;
    }else{
        return NO;
    }
}


/// 响应失败
- (void)respFail:(NSError *)error andRespClass:(id)cls
{
    if ([error isKindOfClass:[Error class]]) {
        Error *failError = (Error *)error;
        [self handleError:failError];
        
    }else{
        Error *failError = [[Error alloc]init];
        
        failError.rDescription = error.localizedDescription;
        [self handleError:failError];
    }
}


- (void)handleError:(Error *)error
{
    NSString *errorMsg = [CheckHttpErrorUtil handleError:error];

    if (_isShowErrorAlert)
    {
        if (![NSString isNilOrEmpty:errorMsg])
        {
            showMsg(errorMsg);
            _isShowErrorAlert = NO;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestFeild:)]) {
        [self.delegate requestFeild:errorMsg];
    }

    //    [self hiddenLoadingView];
    
//    if ([@"A connection failure occurred" isEqualToString:error.rDescription]) {
//        
//        showMsg(@"无法连接服务器，请稍后再试!");
//    } else if ([@"The request timed out" isEqualToString:error.rDescription]) {
//        
//        showMsg(@"网络不给力，请稍后再试!");
//    } else if ([error.rDescription rangeOfString:@"SSL"].location != NSNotFound){
//        //连接到需要认证的wifi环境
//        showMsg(@"网络不给力，请稍后再试!");
//    }
//    else {
//        
//        NSString *errorMsg = error.rDescription;
//        
//        if (error.rDescription) {
//            
//            if ([error.rDescription isEqualToString:@"数据为空"]) {
//                
//                [CustomAlertMessage showAlertMessage:@"没有找到符合条件的信息\n\n"
//                                     andButtomHeight:APP_SCREEN_HEIGHT/2];
//                
//            }else{
//                
//                if (_isShowErrorAlert) {
//                    showMsg(errorMsg);
//                    _isShowErrorAlert = NO;
//                }else{
//                    
//                }
//                
//                if (self.delegate && [self.delegate respondsToSelector:@selector(requestFeild:)]) {
//                    [self.delegate requestFeild:errorMsg];
//                }
//            }
//            
//        }
//    }
    
}

@end
