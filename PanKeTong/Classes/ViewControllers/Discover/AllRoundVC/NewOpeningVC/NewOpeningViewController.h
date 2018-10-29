//
//  NewOpeningViewController.h
//  PanKeTong
//
//  Created by zhwang on 16/4/5.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "BaseViewController.h"
#import "ApplyTransferPubEstViewController.h"

@protocol NewOpeningDelegate <NSObject>

- (void)newOpenSuccess:(NSInteger)tradingState;

@end


@interface NewOpeningViewController : BaseViewController

@property (strong,nonatomic)NSString *propertyKeyId;//房源id
@property (nonatomic,assign)id <NewOpeningDelegate>delegate;
@property (nonatomic, copy)NSString *tradingState; //交易状态
@property (nonatomic, assign)NSInteger propertyStatus; // 房源状态   1,有效  其余均视为无效
@property (strong, nonatomic) NSMutableArray *trustorsArray;
@end
