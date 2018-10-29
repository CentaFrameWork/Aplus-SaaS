//
//  FilterListViewController.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/17.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "DataFilterEntity.h"
@protocol FilterListDelegate <NSObject>
@optional
-(void)getFilterListEntity:(DataFilterEntity *)entity isSendService:(BOOL)isSend isSettingName:(BOOL)isSetting;

@end


@interface FilterListViewController : BaseViewController

@property (nonatomic,assign)id <FilterListDelegate>delegate;


//默认选中的名字
@property (nonatomic,strong)NSString * currentSelectName;

@end
