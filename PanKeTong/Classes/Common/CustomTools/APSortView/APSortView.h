//
//  APSortView.h
//  APlus
//
//  Created by 张旺 on 2017/11/10.
//  Copyright © 2017年 CentaLine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectSortCompleteBlock)(NSString *sortStr);

@interface APSortView : UIView

@property (nonatomic, copy) SelectSortCompleteBlock block;

- (void)showSortViewWithSortDataArr:(NSArray *)sortDataArr
                      andSelectData:(NSString *)selectData
                   andCompleteBlock:(SelectSortCompleteBlock)completeBlock;

@end
