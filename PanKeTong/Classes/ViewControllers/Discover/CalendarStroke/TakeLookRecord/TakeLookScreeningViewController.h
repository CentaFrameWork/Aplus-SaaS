//
//  TakeLookScreeningViewController.h
//  PanKeTong
//
//  Created by 张旺 on 16/11/29.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#import "BaseViewController.h"
#import "TakeSeeApi.h"
#import "TakeLookScreeningVO.h"

typedef void(^ takeLookScreeningBlock)(TakeLookScreeningVO *takeSeeEntity);
@interface TakeLookScreeningViewController : BaseViewController

@property (nonatomic, copy) takeLookScreeningBlock block;

@property (nonatomic, strong) TakeLookScreeningVO *takeLookVO;

@end
