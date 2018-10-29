//
//  FilterView.h
//  Demo
//
//  Created by wanghx17 on 15/4/28.
//  Copyright (c) 2015年 wanghx17. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FilterEntity.h"
typedef enum TableViewType
{
    OneTableView=1,
    TwoTableView=2,
    ThreeTableView=3
    
}TableViewType;
//代理
@protocol FilterViewDelegate <NSObject>

@optional
-(void)requestNeedEntity:(FilterEntity*)entity andType:(BOOL)type;
@end

@interface FilterView : UIView<UITableViewDelegate,UITableViewDataSource>

-(void)creatTableViewWithFirstArray:(NSArray*)array1
                     AndSecondArray:(NSArray*)array2
                      AndThirdArray:(NSArray*)array3
                   AndTableViewType:(TableViewType)orderType
                          AndBtnTag:(NSInteger)tag
                       AndTitleType:(NSString*)titleType;

-(void)filterEntity:(FilterEntity *)entity;
- (void)ClicktapGesture;

@property (nonatomic,assign)id<FilterViewDelegate>delegate;
@property (nonatomic, assign, getter = isOpened) BOOL opened;

@end


