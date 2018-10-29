//
//  WJTaskSeeModel.h
//  PanKeTong
//
//  Created by 徐庆标 on 2018/3/9.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJTaskSeeModel : NSObject
@property (nonatomic, copy) NSString *PropertyInfo;
@property (nonatomic, copy) NSString *InquiryKeyId;
@property (nonatomic, strong) NSArray *PropertyList;
@property (nonatomic,copy)NSString *customerName;//客户
@property (nonatomic,copy)NSString *takeSeeTime;//带看时间
@property (nonatomic,copy)NSString *lookWithUserName;//陪看人
@property (nonatomic,copy)NSString *seePropertyType;//看房类型
@property (nonatomic,copy)NSString *attachmentName;// 附件名称
@property (nonatomic,copy)NSString *attachmentPath;//附件路径

-(WJTaskSeeModel *)initDic:(NSDictionary *)dic;



@end
@interface PropertyList : NSObject
@property (nonatomic,copy)NSString *Content;// 附件名称
@property (nonatomic,copy)NSString *PropertyInfo;
-(PropertyList *)initDic:(NSDictionary *)dic;

@end

