//
//  ZYHomeController.m
//  Aplus-SaaS
//
//  Created by Admin on 2018/8/22.
//  Copyright © 2018年 CentaLine. All rights reserved.
//

#import "ZYHomeController.h"
#import "ZYHomeControllerPresent.h"
#import "ZYHomeMainView.h"

@interface ZYHomeController ()<UITableViewDelegate>

@property (nonatomic, strong) ZYHomeControllerPresent * present;
@property (nonatomic, weak) ZYHomeMainView * mainView;
@property (nonatomic, strong) NSArray * dataArray;
@end

@implementation ZYHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
}

- (void)loadMainView{
    
    ZYHomeMainView * mainView = [[ZYHomeMainView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    mainView.delegate = self;

    [self.view addSubview:mainView];
    
    self.mainView = mainView;

    self.present = [[ZYHomeControllerPresent alloc] initWithView:self];
    [self.present setPresentView:mainView];
    [self.present sendRequest];
    
    
}

- (void)loadNavigationBar{
    
    self.navigationItem.title = @"首页";
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"*********");
}
@end
