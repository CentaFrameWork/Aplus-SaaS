//
//  VideoUploadMainView.m
//  AplusVideoUploadDemo
//
//  Created by Liyn on 2017/11/22.
//  Copyright © 2017年 Liyn. All rights reserved.
//

/*
 本视图托管上传控制器中的子视图
 */



#import "VideoUploadMainView.h"


@implementation VideoUploadMainView

    /// 初始化
- (instancetype)init{
    self = [super init];
    if (self) {
        [self initData];
        [self initView];
    }
    return self;
}
    /// 初始化数据
- (void)initData{

}
    /// 初始化视图
- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.countView];
    [self addSubview:self.uploadListTab];
}
-(void)setCount:(NSInteger)count{
    self.countLabel.text = [NSString stringWithFormat:@"正在上传 ( %ld )",count];
}
- (void)layoutSubviews{
    self.uploadListTab.frame = CGRectMake(0, 27, self.frame.size.width, self.frame.size.height - 64 - 27);
    self.countView.frame = CGRectMake(0, 0, self.frame.size.width, 27);
}

#pragma mark -----------------------  懒加载  -------------------------
- (UITableView *)uploadListTab{
    if (_uploadListTab == nil) {
        _uploadListTab = [[UITableView alloc] initWithFrame:CGRectZero
                                                      style:UITableViewStylePlain];
        _uploadListTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _uploadListTab.showsHorizontalScrollIndicator = NO;
        _uploadListTab.rowHeight = 112;
    }
    return _uploadListTab;
}
-(UIView *)countView{
    if (!_countView) {
        _countView = [[UIView alloc] init];
        _countView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];//UIColorFromHex(0xfbfbfb, 1);
        [_countView addSubview:self.countLabel];
    }
    return _countView;
}
-(UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 5, 100, 17)];
        _countLabel.textColor = UIColorFromHex(0x333333, 1);
        _countLabel.font = [UIFont systemFontOfSize:12];
    }
    return _countLabel;
}
@end
