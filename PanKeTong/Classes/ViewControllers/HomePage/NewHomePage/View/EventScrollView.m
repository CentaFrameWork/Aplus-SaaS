//
//  EventScrollView.m
//  PanKeTong
//
//  Created by 李慧娟 on 2017/12/22.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "EventScrollView.h"
#import "APPConfigEntity.h"
#import "MyClientVC.h"

@implementation EventScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame])
    {
        self.showsHorizontalScrollIndicator = NO;
        self.contentSize = CGSizeMake(APP_SCREEN_WIDTH, frame.size.height);
    }
    
    return self;
}

- (void)setEventArr:(NSArray *)eventArr
{
    if (_eventArr != eventArr)
    {
        _eventArr = eventArr;
        
        [self initView];
    }
}

- (void)initView {
    
    
    //    self.contentSize = CGSizeMake((width + 5) * _eventArr.count + 10, 80);
    
    CGFloat width = (APP_SCREEN_WIDTH - YCAppMargin*3) / 2;
    
    CGFloat height = width * 100 / 170;
    
    for (int i = 0; i < _eventArr.count; i ++) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((width+YCAppMargin) * i + YCAppMargin,0, width, height)];
        [btn setLayerCornerRadius:5];
        btn.tag = i;
        NSString *name = i>0?@"carrySee":@"aboutSee";
        
        [btn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(addNewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

- (void)addNewAction:(UIButton *)btn {
    
    
    if (!btn.tag){
        if (![AgencyUserPermisstionUtil hasMenuPermisstion:MENU_CUSTOMER_ALL_CUSTOMER])
        {
            // 查看全部客户权限
            showMsg(@(NotHavePermissionTip));
            return;
        }
        
        AddTakingSeeVC *vc = [[AddTakingSeeVC alloc] init];
        vc.isFromHomePage = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }else {
        if (![AgencyUserPermisstionUtil hasMenuPermisstion:MENU_CUSTOMER_ALL_CUSTOMER])
        {
            // 查看全部客户权限
            showMsg(@(NotHavePermissionTip));
            return;
        }
        
        NewTakeLookRecordViewController *vc = [[NewTakeLookRecordViewController alloc] init];
        vc.isFromHomePage = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

@end
