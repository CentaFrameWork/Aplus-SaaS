//
//  EditHouseVO.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/7/27.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BaseVO.h"

/// 验证发布房源必要要素提示信息
@interface EditHouseVO : BaseVO

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@end
