//
//  AppConfigResponseEntity.h
//  PanKeTong
//
//  Created by 燕文强 on 16/4/11.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfigResponseEntity : SubBaseEntity

@property (nonatomic,assign) NSInteger configId;        // 编号 （Int32）
@property (nonatomic,assign) NSInteger parentId;        // ParentId （Int32）
@property (nonatomic,strong) NSString *title;           // 标题 （String）
@property (nonatomic,strong) NSString *mdescription;    // 描述
@property (nonatomic,strong) NSString *iconUrl;         // 图标 （String）
@property (nonatomic,assign) NSInteger jumpType;        // 跳转类型 （Int32）
@property (nonatomic,strong) NSString *jumpContent;     // 跳转内容 （String）
@property (nonatomic,assign) BOOL homeShow;             // 是否APP首页显示 （Boolean）
@property (nonatomic, assign) NSInteger DispIndex;      // 显示顺序

@end
