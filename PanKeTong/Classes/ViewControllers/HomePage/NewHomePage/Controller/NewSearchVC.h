//
//  NewSearchVC.h
//  APlus
//
//  Created by 李慧娟 on 2017/10/16.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchPropertyManager.h"
#import "SearchPropDetailEntity.h"
#import "EstateListVC.h"

typedef void(^SearchCompleteBlock)(SearchPropDetailEntity *entity,BOOL isEstateNo);

/// 搜索
@interface NewSearchVC : BaseViewController

@property (nonatomic, assign) BOOL isSearchNow; // 是否要进行搜索
@property (nonatomic, assign) BOOL isOpenVoice; // 是否打开语音

// 房源搜索的查询类型
@property (nonatomic, copy) NSString *estateSelectType;

// 从那个模块跳进来
@property (nonatomic, assign)ModuleSearchType moduleSearchType;

@property (nonatomic, copy) SearchCompleteBlock block;

@end
