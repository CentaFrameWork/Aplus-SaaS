//
//  CustomChatIcon.h
//  IMProject
//
//  Created by 苏军朋 on 15/4/27.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomChatIcon : UIView

@property (nonatomic,strong) CustomChatIcon *customChatIcon;
@property (nonatomic,strong) UIView *currentView;
@property (nonatomic,strong) NSString * currentChatBadge;
@property (nonatomic,strong) UILabel * chatBadgeLabel;
@property (nonatomic,strong) UIButton * clickChatBtn;

-(void)createViewItem;

@end
