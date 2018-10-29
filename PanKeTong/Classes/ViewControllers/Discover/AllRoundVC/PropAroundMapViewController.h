//
//  PropAroundMapViewController.h
//  PanKeTong
//
//  Created by 苏军朋 on 15/11/10.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>         //base相关所有头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>   //检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>     //引入计算工具所有的头文件

@interface PropAroundMapViewController : BaseViewController


@property (nonatomic,assign)double longitude; // 经度
@property (nonatomic,assign)double latitude;  // 纬度

@property (nonatomic,strong) NSString *propTitleString; //房源标题

@end
