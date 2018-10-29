//
//  EstateReleaseManageViewController.m
//  PanKeTong
//
//  Created by wanghx17 on 15/9/25.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "EstatePublishManageVC.h"
#import "SellAndRentViewController.h"
#import "WaitOnTheShelveViewController.h"

#import "AgencyPermissionsDefine.h"

#define ChooseTag 100
@interface EstatePublishManageVC ()
@end

@implementation EstatePublishManageVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self checkShowViewPermission:MENU_ADVERT andHavePermissionBlock:^(NSString *permission) {
        [self initData];
        [self initNavTitleView];
    }];
}

- (void)initNavTitleView
{
    [self setNavTitle:@"放盘管理"
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:nil];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData
{
    NSArray *imgArray = [NSArray arrayWithObjects:@"sell_img.png",@"rent_img.png",@"wait_ues_Img.png", nil];
    NSArray *textArray = [NSArray arrayWithObjects:@"出售",@"出租",@"待上架", nil];
    
   
    for (int i = 0; i<3; i++)
    {
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont fontWithName:FontName  size:14.0]};
        CGSize size = [textArray[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, 28) options: NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
        
        NSInteger interval = (APP_SCREEN_HEIGHT - 237 ) * 3 / 11;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((APP_SCREEN_WIDTH / 2) -37.5, interval / 2 + i * (75 + interval), 75, 75);
        button.tag = i + ChooseTag;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imgArray[i]]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((APP_SCREEN_WIDTH / 2) - size.width / 2, button.frame.origin.y + 90, size.width, 15)];
        label.text = textArray[i];
        label.font = [UIFont fontWithName:FontName size:14.0];
        label.textColor = LITTLE_GRAY_COLOR;
        [self.view addSubview:label];
    }
}

- (void)chooseButtonClick:(UIButton*)button
{
    if (button.tag == ChooseTag)
    {
        SellAndRentViewController *sellAndRentVC = [[SellAndRentViewController alloc]initWithNibName:@"SellAndRentViewController" bundle:nil];
        sellAndRentVC.titleString = @"出售";
        sellAndRentVC.isSellEstate = YES;
        [self.navigationController pushViewController:sellAndRentVC  animated:YES];

    }
    else if (button.tag == ChooseTag + 1)
    {
        SellAndRentViewController *sellAndRentVC = [[SellAndRentViewController alloc]initWithNibName:@"SellAndRentViewController" bundle:nil];
        sellAndRentVC.titleString = @"出租";
        sellAndRentVC.isSellEstate = NO;
        [self.navigationController pushViewController:sellAndRentVC  animated:YES];

    }
    else
    {
        WaitOnTheShelveViewController *waitVC = [[WaitOnTheShelveViewController alloc]initWithNibName:@"WaitOnTheShelveViewController"
                                                                                         bundle:nil];
        [self.navigationController pushViewController:waitVC
                                             animated:YES];
    }
}




@end
