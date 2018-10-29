//
//  PublishPropertyVC.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/12/26.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <iflyMSC/iflyMSC.h>

#import "PropertysModelEntty.h"

/// 网页模块控制器
@interface WebViewModuleVC : BaseViewController<IFlyRecognizerViewDelegate>

@property (nonatomic,copy)NSString *requestUrl;

@property (nonatomic,copy)NSString *tradeType;


@property (nonatomic,strong)PropertysModelEntty *propModelEntity;

@property (nonatomic,copy)NSString *adKeyId;                        // 房源广告keyId

@end
