//
//  PhoneListUtil.m
//  PanKeTong
//
//  Created by 李慧娟 on 2018/1/8.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "PhoneListUtil.h"


@implementation PhoneListUtil

/// 新增联系人
+ (void)addContacter
{
    NSString *phoneName = [NSString stringWithFormat:@"%@虚拟号",SettingProjectName];
    NSString *phoneNumber = [[BaseApiDomainUtil getApiDomain] getDascomNumber];

    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
    ABRecordRef newPerson = ABPersonCreate();
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(phoneName), nil);

    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(phoneNumber), kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone, nil);
    CFRelease(multiPhone);

    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, nil);
    ABAddressBookSave(iPhoneAddressBook, nil);
    CFRelease(newPerson);
    CFRelease(iPhoneAddressBook);
}

/// 删除联系人
+ (void)deletePeople
{
    ABAddressBookRef addressBook = ABAddressBookCreate();

    // 获取通讯录中所有的联系人
    NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);

    // 遍历所有的联系人并删除(这里只删除姓名为张三的)
    for (id obj in array)
    {
        ABRecordRef people = (__bridge ABRecordRef)obj;
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
        if ([lastName isEqualToString:@"移动A+虚拟号"])
        {
            ABAddressBookRemoveRecord(addressBook, people, NULL);
        }
    }

    // 保存修改的通讯录对象
    ABAddressBookSave(addressBook, NULL);

    // 释放通讯录对象的内存
    if (addressBook)
    {
        CFRelease(addressBook);
    }
}

+ (BOOL)filterContentForSearchText:(NSString *)searchText andNumber:(NSString *)number
{
    NSInteger count = 0;
    BOOL existPhoneNumber = NO; // 是否存在手机号

    // 判断授权状态
    if (ABAddressBookGetAuthorizationStatus()!=kABAuthorizationStatusAuthorized)
    {
        return YES;
    }

    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);

    if (searchText.length == 0)
    {
        count = 0;
    }
    else
    {
        // 根据字符串查找前缀关键字
        CFStringRef cfSearchText = (CFStringRef)CFBridgingRetain(searchText);
        NSArray *listContacts = CFBridgingRelease(ABAddressBookCopyPeopleWithName(addressBook, cfSearchText));
        count = listContacts.count;

        for (int i = 0; i < count; i++)
        {
            // 从搜索出的联系人数组中获取一条数据 转换为ABRecordRef格式
            ABRecordRef thisPerson = CFBridgingRetain([listContacts objectAtIndex:i]);
            ABMultiValueRef valuesRef = ABRecordCopyValue(thisPerson, kABPersonPhoneProperty);

            // 电话号码
            NSString *phoneNumber = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(valuesRef, 0));

            if([phoneNumber isEqualToString:number])
            {
                // 存在
                existPhoneNumber = YES;
            }
        }

        CFRelease(cfSearchText);
    }

    CFRelease(addressBook);

    if (count > 0 && existPhoneNumber)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


@end
