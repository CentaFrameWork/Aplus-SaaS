//
//  ReleaseEstManageApi.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/9.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "APlusBaseApi.h"
//#define ReleaseEstManage 1
//#define ReleaseEstRefresh 2
// 放盘管理与刷新
enum ReleaseEst{
    ReleaseEstManage = 1,
    ReleaseEstRefresh = 2
};

///放盘管理与刷新放盘管理
@interface ReleaseEstManageApi : APlusBaseApi

@property (nonatomic,copy)NSString *staffno;
@property (nonatomic,copy)NSString *pageindex;
@property (nonatomic,copy)NSString *posttype;
@property (nonatomic,copy)NSString *poststatus;
@property (nonatomic,copy)NSString *postid;

@property (nonatomic,assign)NSInteger ReleaseEstManageType;

@end
