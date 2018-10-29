//
//  SubScrollView.h
//  UI10-task4
//
//  Created by imac on 15/8/18.
//  Copyright (c) 2015年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubScrollView : UIScrollView<UIScrollViewDelegate>
{
    UIImageView *imgView;
}

@property (nonatomic, copy) NSString *imageUrlStr;

@end
