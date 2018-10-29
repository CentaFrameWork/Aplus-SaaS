//
//  SelectBtnView.h
//  APlus
//
//  Created by 李慧娟 on 2017/10/19.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define DidSelectBtnNotification    @"DidSelectBtnNotification"

//typedef NS_ENUM(NSInteger, SelectBtn) {
//    SelectLeftBtn,
//    SelectRightBtn
//};

@protocol SelectBtnDelegate <NSObject>

- (void)didSelectWithBtnIndex:(NSInteger)selectBtnIndex;

@end

@interface SelectBtnView : UIView

- (instancetype)initWithFrame:(CGRect)frame andTitleArr:(NSArray *)titleArr;

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, assign) id <SelectBtnDelegate> selectBtnDelegate;

@end
