//
//  CustomWebProgressView.m
//  电动生活
//
//  Created by 陈行 on 15-12-17.
//  Copyright (c) 2015年 陈行. All rights reserved.
//

#import "CustomWebProgressView.h"

#define FINAL_ESTIMATED_PROGRESS @"estimatedProgress"

@interface CustomWebProgressView()

@property (nonatomic, weak) WKWebView *webView;

@property (nonatomic, assign) double oldEstimatedProgress;

@property (nonatomic, strong) NSMutableArray * kvoKeyPathArr;

@end

@implementation CustomWebProgressView

+ (CustomWebProgressView *)progressViewAndFrame:(CGRect)frame andWebView:(WKWebView *)webView andDelegate:(id<CustomWebProgressViewDelegate>)delegate{
    
    return [[self alloc]initWithFrame:frame andWebView:webView andDelegate:delegate];
}

- (instancetype)initWithFrame:(CGRect)frame andWebView:(WKWebView *)webView andDelegate:(id<CustomWebProgressViewDelegate>)delegate{
    
    frame.origin.x = -[UIScreen mainScreen].bounds.size.width;
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor greenColor];
        self.hidden = YES;
        self.kvoKeyPathArr = [[NSMutableArray alloc] init];
        self.delegate = delegate;
        self.webView = webView;
        [self.kvoKeyPathArr addObject:FINAL_ESTIMATED_PROGRESS];
        
        [self.webView addObserver:self forKeyPath:FINAL_ESTIMATED_PROGRESS options:NSKeyValueObservingOptionNew context:NULL];
        
    }
    return self;
}

- (void)setEstimatedProgress:(CGFloat)estimatedProgress{
    
    _estimatedProgress = estimatedProgress;
    
    self.hidden = NO;
    
    if(estimatedProgress == 1){
        
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect rect = self.frame;
            rect.origin.x = 0;
            self.frame = rect;
            
        } completion:^(BOOL finished) {
            
            if([self.delegate respondsToSelector:@selector(webProgressViewLoadFinish:)]){
                
                [self.delegate webProgressViewLoadFinish:self];
                
            }
            
            [self freeWebProgressView];
        }];
        
    }else{
        
        if(_estimatedProgress >= _oldEstimatedProgress){
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(webProgressViewLoading:andProgress:)]) {
                
                [self.delegate webProgressViewLoading:self andProgress:estimatedProgress];
                
            }
            
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect rect = self.frame;
                rect.origin.x = (estimatedProgress-1)*[UIScreen mainScreen].bounds.size.width;
                self.frame = rect;
                
            } completion:^(BOOL finished) {
                
                _oldEstimatedProgress = estimatedProgress;
                
            }];
        }
    }
}

- (void)freeWebProgressView{
    @synchronized (self) {
        
        for (NSString * keyPath in self.kvoKeyPathArr) {
            
            [self.webView removeObserver:self forKeyPath:keyPath];
            
        }
        
        [self.kvoKeyPathArr removeAllObjects];
        
        [self removeFromSuperview];
        
    }
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if([keyPath isEqualToString:FINAL_ESTIMATED_PROGRESS]){
        
        double progress = [change[@"new"] doubleValue];
        self.estimatedProgress = progress;
        
    }
}

- (void)dealloc{
    
    [self freeWebProgressView];
    
}

@end
