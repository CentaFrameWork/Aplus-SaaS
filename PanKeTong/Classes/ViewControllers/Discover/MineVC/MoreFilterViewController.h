//
//  MoreFilterViewController.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "FilterEntity.h"

@protocol MoreFilterInfoDelegate <NSObject>

- (void)getFilterEntity:(FilterEntity *)entity;
- (void)moreFilterBack;
@end

@interface MoreFilterViewController : BaseViewController

@property (nonatomic,assign)id <MoreFilterInfoDelegate>delegate;
@property (nonatomic,strong)FilterEntity *filterEntity;
@property (strong, nonatomic) NSMutableDictionary *dataDic;


@end
