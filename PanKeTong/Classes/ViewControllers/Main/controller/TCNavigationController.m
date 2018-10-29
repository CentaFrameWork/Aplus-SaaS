//
//  TCNavigationController.m
//  PanKeTong
//
//  Created by TailC on 16/3/31.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "TCNavigationController.h"
#import "UIColor+Custom.h"
#import "NSString+Extension.h"


@interface TCNavigationController ()<UINavigationControllerDelegate>

@end

@implementation TCNavigationController

/// 第一次使用这个类的时候调用1次
+ (void)initialize
{
//	// 设置UINavigationBarTheme
//	[self setupNavigationBarTheme];

	// 设置UIBarButtonItem的主题
	[self setupBarButtonItemTheme];
}


///// 设置UINavigationBarTheme主题
//+ (void)setupNavigationBarTheme
//{
////	UINavigationBar *appearance = [UINavigationBar appearance];
////	// 设置文字属性
////	NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
////	textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
////	textAttrs[NSFontAttributeName] = [UIFont fontWithName:FontName size:14.0];
////	
////	// 设置导航栏背景
////	[appearance setBackgroundImage:[UIImage imageNamed:@"navBarBg_img"] forBarMetrics:UIBarMetricsDefault];
////	textAttrs[NSShadowAttributeName] = [[NSShadow alloc] init];
////	
////	[appearance setTitleTextAttributes:textAttrs];
//}

/// 设置UIBarButtonItem的主题
+ (void)setupBarButtonItemTheme
{
	// 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
	UIBarButtonItem *appearance = [UIBarButtonItem appearance];
	
	/**设置文字属性**/
	// 设置普通状态的文字属性
	[appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName,nil]
							  forState:UIControlStateNormal];
	
	// 设置不可用状态(disable)的文字属性
	[appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:15],NSFontAttributeName,nil] forState:UIControlStateDisabled];
}

/**
 *  当导航控制器的view创建完毕就调用
 */
- (void)viewDidLoad
{
	[super viewDidLoad];
    self.delegate = self;
    self.navigationBar.translucent = NO;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	// 判断是否为栈底控制器
	if (self.viewControllers.count > 0)
    {
        // 自动显示和隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        // 添加返回按钮
        UIImage *image2 = [UIImage imageNamed:@"navigator_btn_back.png"];
        image2 = [image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image2
                                                                                          style:UIBarButtonItemStylePlain
                                                                                         target:self
                                                                                         action:@selector(back)];
    }
    
    [super pushViewController:viewController animated:animated];
}

// 返回上一页
-(void)back
{
    [self popViewControllerAnimated:YES];
}

- (void)more
{
	
}

#pragma mark-<UINavigationControllerDelegate>
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated{
    if (navigationController.viewControllers.count > 1)
    {
        self.tabBarController.tabBar.hidden = YES;
    }
    else
    {
        self.tabBarController.tabBar.hidden = NO;
    }
}

@end
