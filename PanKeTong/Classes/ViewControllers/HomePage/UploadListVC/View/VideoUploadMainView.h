//
//  VideoUploadMainView.h
//  AplusVideoUploadDemo
//
//  Created by Liyn on 2017/11/22.
//  Copyright © 2017年 Liyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoUploadMainView : UIView
@property (nonatomic, strong) UITableView *uploadListTab;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView  *countView;
- (void)setCount:(NSInteger )count;
@end
