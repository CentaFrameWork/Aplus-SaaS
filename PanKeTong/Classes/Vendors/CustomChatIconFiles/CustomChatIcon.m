//
//  CustomChatIcon.m
//  IMProject
//
//  Created by 苏军朋 on 15/4/27.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "CustomChatIcon.h"

@implementation CustomChatIcon

@synthesize currentChatBadge = _currentChatBadge;

-(void)createViewItem
{
    if (self) {
        
        UIImageView *chatIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                                      0,
                                                                                      53,
                                                                                      53)];
        [chatIconImageView setImage:[UIImage imageNamed:@"goChat_icon"]];
        
        _chatBadgeLabel = [[UILabel alloc]init];
        
        _chatBadgeLabel.layer.masksToBounds = YES;
        _chatBadgeLabel.layer.cornerRadius = 7.0;
        [_chatBadgeLabel setBackgroundColor:[UIColor whiteColor]];
        [_chatBadgeLabel setTextColor:[UIColor redColor]];
        [_chatBadgeLabel setFont:[UIFont systemFontOfSize:13.0]];
        [_chatBadgeLabel setTextAlignment:NSTextAlignmentCenter];
        
        _clickChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickChatBtn.backgroundColor = [UIColor clearColor];
        [_clickChatBtn setFrame:CGRectMake(0,
                                           0,
                                           53,
                                           53)];
        
        
        [self addSubview:chatIconImageView];
        [self addSubview:_chatBadgeLabel];
        [self addSubview:_clickChatBtn];
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    
}

-(void)setCurrentChatBadge:(NSString *)currentChatBadge
{
    
    if ([currentChatBadge isEqualToString:@"0"]) {
        
        [_chatBadgeLabel setHidden:YES];
        return;
    }
    
    CGFloat strWidth = [currentChatBadge getStringWidth:[UIFont systemFontOfSize:13.0]
                                                 Height:13.0
                                                   size:13.0];
    [_chatBadgeLabel setHidden:NO];
    [_chatBadgeLabel setFrame:CGRectMake(53-strWidth-7,
                                         5,
                                         strWidth+7,
                                         14)];
    if (currentChatBadge.intValue > 99) {
        
        _chatBadgeLabel.text = @"99+";
    }else{
        
        _chatBadgeLabel.text = currentChatBadge;
    }
    
    
}


@end
