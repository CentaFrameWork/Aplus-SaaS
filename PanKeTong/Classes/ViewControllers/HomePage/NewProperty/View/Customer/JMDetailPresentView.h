//
//  JMDetailPresentView.h
//  PanKeTong
//
//  Created by Admin on 2018/4/19.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SeeType) {
    SeeHouse,
    SeeTel
    
};

@protocol DetailPresentDelegate <NSObject>
@optional
- (void)didClickSureBtn:(UIButton *)btn withType:(SeeType)type;
- (void)didSelectCell:(NSInteger)index;
@end
@interface JMDetailPresentView : UIView

@property (nonatomic,weak)id<DetailPresentDelegate>delegate;
- (instancetype)initPresentViewWithNumber:(NSString*)number withTpe:(SeeType)type;
- (instancetype)initPresentViewWithArray:(NSArray*)array;
- (instancetype)initPresentViewContactWithArray:(NSArray*)array;
@end
