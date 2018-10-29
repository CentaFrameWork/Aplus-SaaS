//
//  DealDetailController.m
//  PanKeTong
//
//  Created by Admin on 2018/3/19.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "DealDetailController.h"
#import "DealDeatailCell.h"
#import "DealDeatailHeadCell.h"
#import "rightTopView.h"
#import "DealIploadImageController.h"
#import "JMPhotoBrowser.h"

//#define IMageURL @"http://10.1.30.115:9000"
@interface DealDetailController ()<UITableViewDelegate,UITableViewDataSource,DealDeatailHeadCellDelegate,DealDeatailCell>


@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) NSMutableArray<NSDictionary<NSString*, NSString*>*> *array;
@property (nonatomic,strong) NSDictionary *dict;
@property (nonatomic,strong) NSMutableArray<NSArray*> *mutArr;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,assign) int number;
@property (nonatomic,assign) BOOL selected;
@property (nonatomic,strong) rightTopView *right;

@end

@implementation DealDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    [self.view addSubview:self.myTableView];
    [self getNetworkDealDetail];
    
}

#pragma mark -  导航
- (void)setNav {
    
   
    [self setNavTitle:self.titleString
       leftButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"backBtnImg"
                                            sel:@selector(back)]
      rightButtonItem:[self customBarItemButton:nil
                                backgroundImage:nil
                                     foreground:@"更多_black"
                                            sel:@selector(rightClick)]];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReloadNetwork) name:JM_refreshDeal object:nil];
    
}



#pragma mark -  网络请求

- (void)notificationReloadNetwork {
    
    self.mutArr = nil;
    [self getNetworkDealDetail];
    
}
- (void)getNetworkDealDetail {

    [AFUtils GET:AipPropertyDealDetail parameters:@{@"KeyId":self.model.KeyId} controller:self successfulDict:^(NSDictionary *successfuldict) {
        
        self.dict = successfuldict;
        
        NSLog(@"%@",successfuldict);
        
        self.myTableView.tableHeaderView = self.headView;
        
        
        [self.myTableView reloadData];
        
    } failureDict:^(NSDictionary *failuredict) {
        
    } failureError:^(NSError *failureerror) {
        
    }];
    
}
#pragma mark -  右上角
- (void)rightClick {
    
    if (!_selected) {
        
        __block NSArray *arr;
        
        if ([self.model.TransactionType contains:@"售"]) {
            
            arr = @[@"定金收据",@"佣金收据",@"审核材料收据",@"网签合同收据"];
        }else{
            
            arr = @[@"定金收据",@"佣金收据"];
        }
        
        
        __weak typeof (self) weakSelf = self;
        
        _right = [[rightTopView alloc] initWithFrame:self.view.bounds withArray:arr];
        
        _right.didSelect = ^(NSNumber *number){
            
            weakSelf.selected = !weakSelf.selected;
            DealIploadImageController *vc = [[DealIploadImageController alloc] init];
            vc.title = arr[number.intValue - 1];
            vc.number = number;
            
            //为了符合后台
            if (number.intValue == 1) {
                
                vc.number = @(2);
                
            } else if (number.intValue == 2) {
                
                vc.number = @(1);
            }
            
            vc.model = weakSelf.model;
            
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
            
        };
        
        [self.view addSubview:_right];
        
    }else{
        
        [_right removeFromSuperview];
        
    }
    
    _selected = !_selected;
    
    
}

#pragma mark - ******tableView******
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.mutArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.array[2*section + 1][@"isopen"].boolValue?self.mutArr[section].count:0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DealDeatailCell *cell = [DealDeatailCell loadDealDetailWithTableView:tableView];
    cell.delegate = self;
    cell.DealType = self.model.TransactionType;
    cell.dict  = self.mutArr[indexPath.section][indexPath.row];
    
    return cell;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    DealDeatailHeadCell * headView = [DealDeatailHeadCell loadDealDetailHeadWithTableView:tableView];
    headView.delegate = self;
    headView.tag = section;
    headView.typeString = self.model.TransactionType;
    headView.headName.text = self.array[2 * section].allValues.firstObject;
    headView.headHaveData = self.mutArr[section].count? YES:NO;
    headView.headIsOpen = self.array[2 * section + 1].allValues.firstObject.boolValue;
    
    
   
    
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    return  [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.mutArr[indexPath.section][indexPath.row];
    
    
    if ([dict.allValues[0] isKindOfClass:[NSString class]]) {
        
        return [DealDeatailCell sizeWithString:dict.allValues[0]];
        
   
    }else if ([dict.allValues[0] isKindOfClass:[NSArray class]]) {
        
        NSArray *valueArray = dict.allValues[0];
        
        if ([valueArray.firstObject isKindOfClass:[NSDictionary class]]) {
            
            CGFloat billHeight = 0;
            NSArray <NSDictionary*>*arr = dict.allValues[0];
            
            for (int j = 0; j<arr.count; j++) {
                
                if ([arr[j].allValues[0] isKindOfClass:[NSString class]]) {
                    
                    billHeight += [DealDeatailCell sizeWithString:arr[j].allValues[0]];
               
                }else{
                    
                    billHeight += Row_Height;
                }
                
            }
            
            return billHeight;
            
        }else{
            
           //区分 附件 和图片
            if (indexPath.section == 0 || indexPath.section == 7) {

                return Row_Height * valueArray.count;

            }else{

                 return Row_Height;
            }

        }
        
    }else{
        
        
        return Row_Height;
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
#pragma mark -  tableView代理
- (void)didSelectHeadCell:(DealDeatailHeadCell *)cell {
    
    
    BOOL isopen = self.array[2 * cell.tag + 1].allValues.firstObject.boolValue;
    

    [self.array replaceObjectAtIndex:2 * cell.tag + 1 withObject:@{@"isopen":@(!isopen).description}];
    
    [self.myTableView reloadData];
    
    if (!isopen && self.mutArr[cell.tag].count) {
        
        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:cell.tag] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
}

- (void)didClickBtnSeeImage:(UIButton *)btn withArr:(NSArray *)arr {
    
    
    
    
    NSMutableArray *mutArrUrl = [NSMutableArray array];
    for (NSString *string in arr) {
        
        // 添加水印后的图片
//        NSString *newImagePath = [NSString stringWithFormat:@"%@%@%@%@",IMageURL,string, PhotoDownWidth, WaterMark];
//
        // 添加水印后的图片
        NSString *newImagePath = [NSString stringWithFormat:@"%@%@",string, PhotoDownWidth];
        
        
        NSURL *url = [NSURL URLWithString:newImagePath];
        
        [mutArrUrl addObject:url];
    }
    
    
     [JMPhotoBrowser showPhotoBrowserWithImages:mutArrUrl currentImageIndex:0];
    
}



- (UIView *)headView {
    
    if (!_headView) {
        
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 132)];
        _headView.backgroundColor = UICOLOR_RGB_Alpha(0xF4F4F4,1.0);
        
        UIView *headV = [[UIView alloc] initWithFrame:CGRectMake(12, 12, _headView.width-24, 108)];
        headV.backgroundColor = [UIColor whiteColor];
        
        [_headView addSubview:headV];
        
        
        NSArray *arr = @[@{
                             @"ScottareType": @"房源编号",
                             @"ScottarePrice": self.model.PropertyNo?:@""
                             },
                         @{
                             @"ScottareType": @"物业地址",
                             @"ScottarePrice": self.model.EstateName?:@""
                             },
                         @{
                             @"ScottareType": @"交易类型",
                             @"ScottarePrice": self.model.TransactionType?:@""
                             }];
        for (int i = 0; i<arr.count; i++) {
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 9, 9)];
            imageV.image = [UIImage imageNamed:@"Oval 5"];
            [headV addSubview:imageV];
            
            
            NSArray *arr2 = [arr[i] objectsForKeys:@[@"ScottareType",@"ScottarePrice"] notFoundMarker:@"不存在"];;
            
            
            for (int j = 0; j<arr2.count; j++) {
                
                UILabel *label = [[UILabel alloc] init];
                 label.font = [UIFont systemFontOfSize:14];
                
                if (j/1) {
                    label.textColor = YCTextColorBlack;
                    label.frame = CGRectMake(105, i*30+20, APP_SCREEN_WIDTH - 140, 30);
                }else{
                    
                    label.textColor = YCTextColorGray;
                    label.frame = CGRectMake(imageV.right+5, i*30+20, 80, 30);
                    imageV.centerY = label.centerY;
                }
                
                label.text = arr2[j];
                [headV addSubview:label];
                
            }
            
            
        }
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(12, _headView.height-12, _headView.width-24, 12)];
        imageV.image = [UIImage imageNamed:@"Combined Shape"];
        [_headView addSubview:imageV];
    }
    return _headView;
}



- (UITableView *)myTableView {
   
    if (!_myTableView) {
        
        self.view.backgroundColor =  UICOLOR_RGB_Alpha(0xF4F4F4,1.0);
        
        UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(12, 0, APP_SCREEN_WIDTH-24, APP_SCREEN_HEIGHT)];
        backV.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:backV];
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT- APP_NAV_HEIGHT) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = 0;
        _myTableView.backgroundColor = [UIColor clearColor];

    }
    
    return _myTableView;
    
}
#pragma mark -  数据解析
- (NSMutableArray *)array {
    
    if (!_array) {
        
        if ([self.model.TransactionType contains:@"售"]) {
            
            _array = @[
                       
                       @{@"transactionInfo":@"基本信息"},
                       @{@"isopen":@YES},
                       
                       @{@"depositInfo":@"定金"},
                       @{@"isopen":@NO},
                       
                       @{@"signingInfo":@"签约"},
                       @{@"isopen":@NO},
                       
                       @{@"commissionInfo":@"收佣"},
                       @{@"isopen":@NO},
                       
                       @{@"internetSignInfo":@"网签"},
                       @{@"isopen":@NO},
                       
                       @{@"faceSignInfo":@"面签"},
                       @{@"isopen":@NO},
                       
                       @{@"auditLoanInfo":@"批贷"},
                       @{@"isopen":@NO},
                       
                       @{@"scottareMobileInfo":@"缴税"},
                       @{@"isopen":@NO},
                       
                       @{@"transferInfo":@"过户"},
                       @{@"isopen":@NO},
                       
                       @{@"mortgageInfo":@"抵押"},
                       @{@"isopen":@NO},
                       
                       @{@"bankLendingInfo":@"放款"},
                       @{@"isopen":@NO},
                       
                       @{@"transactionComplateInfo":@"结案"},
                       @{@"isopen":@NO},
                       
                       @{@"recissionInfo":@"退解约"},
                       @{@"isopen":@NO},
                       
                       @{@"billRecordInfo":@"收退款信息"},
                       @{@"isopen":@NO}
                       
                       
                       ].mutableCopy;
        }else{
            
            _array = @[
                       
                       @{@"transactionInfo":@"基本信息"},
                       @{@"isopen":@YES},
                       
                       @{@"depositInfo":@"定金"},
                       @{@"isopen":@NO},
                       
                       @{@"signingInfo":@"签约"},
                       @{@"isopen":@NO},
                       
                       @{@"commissionInfo":@"收佣"},
                       @{@"isopen":@NO},
                       
                       @{@"transactionComplateInfo":@"结案"},
                       @{@"isopen":@NO},
                       
                       @{@"recissionInfo":@"退解约"},
                       @{@"isopen":@NO},
                       
                       @{@"billRecordInfo":@"收退款信息"},
                       @{@"isopen":@NO}
                       
                       
                       ].mutableCopy;
            
        }
        
        
        
        
    }
    
    return _array;
}

- (NSMutableArray *)mutArr {
    
    if (!_mutArr) {
        
        if (self.dict.count) {
            
            _mutArr = [NSMutableArray array];
            NSMutableArray *keyMutArray = [NSMutableArray array];
            
            
            for (int i = 0; i < self.array.count * 0.5; i++) {
                
                [keyMutArray addObject:self.array[2*i].allKeys.firstObject];
                
            }
            
            NSArray *arr3 = [self.dict objectsForKeys:keyMutArray notFoundMarker:@"不存在"];
            
            NSArray<NSArray<NSDictionary *>*> *arr5;
            if ([self.model.TransactionType contains:@"售"]) {
                
                
                arr5 = @[
                         
                         @[ //1.基本信息
                             
                             @{@"TransactionNo": @"成交编号"},
                             @{@"CreateTime": @"创建时间"},
                             @{@"Price": @"成交价格"},
                             @{ @"CustomerName":@"客户姓名"},
                             @{@"TrustorName": @"业主姓名"},
                             @{@"Performances":@"Performances"}
                             ],
                         
                         @[//2.定金
                             @{@"DepositNo":@"定金编号"},
                             @{@"IntentionPrice":@"意向金额"},
                             @{@"IntentionPayTime":@"支付时间"},
                             @{@"PayType":@"支付方式"},
                             @{@"DepositPrice":@"定金额度"},
                             @{@"PayTime":@"支付时间"},
                             @{@"AttachmentFile":@"定金收据"}
                             ],
                         
                         @[//3.签约
                              @{@"ContractNo":@"合同编号"},
                             @{@"SigningUserName":@"经纪人"},
                             @{@"SigningTime":@"签约时间"},
                             @{@"Remark":@"签约备注"}
                             ],
                         
                         @[//4.收佣
                             @{@"CommissionNo":@"收佣编号"},
                             @{@"Price":@"收佣额度"},
                             @{@"CommissionTime":@"支付时间"},
                             @{ @"PayType":@"支付方式"},
                             @{@"AttachmentFile":@"收佣收据"},
                             @{@"Remark":@"收佣备注"},
                             
                             ],
                         
                         @[// 5.网签
                             @{@"SignNo":@"网签编号"},
                             @{@"SignUserName":@"经纪人"},
                             @{@"ValidatePropertyTime":@"核房时间"},
                             @{@"ComplateTime":@"签完时间"},
                             @{@"Price":@"网签价"},
                             @{@"AuditAttachmentFile":@"审核材料"},
                             @{@"AttachmentFile":@"网签合同"}
                             
                             
                             ],
                         
                         @[//6.面签
                             @{@"SignUserName":@"成交顾问"},
                             @{@"EstimatePrice":@"评估价"},
                             @{@"EstimateTime":@"评估时间"},
                             @{@"LoanTime":@"申贷时间"},
                             @{@"LoanBank":@"贷款银行"},
                             @{ @"LoanPrice":@"贷款金额"}
                             ],
                         
                         
                         
                         
                         @[//7.批贷
                             @{@"PayType":@"付款类型"},
                             @{@"AuditLoanUserName":@"成交顾问"},
                             @{@"LoanBank":@"贷款银行"},
                             @{@"LoanPersonName":@"贷款人员"},
                             @{@"LoanPrice":@"贷款金额"},
                             @{@"LoanYear":@"贷款年限"},
                             @{@"LoanRate":@"贷款利率"},
                             @{@"LoanAgreeTime":@"批贷时间"},
                             @{@"PayMentType":@"还款方式"}
                             ],
                         
                         
                         @[//8.缴税
                             @{@"Details":@"Details"},
                             @{@"ScottareUserName":@"过户专员"},
                             @{@"ScottareTime":@"缴税时间"}
                             ],
                         
                         @[//9.过户
                             @{@"UserName":@"过户专员"},
                             @{@"Time":@"过户时间"}
                             ],
                         
                         @[//10.抵押
                             @{@"UserName":@"经纪人"},
                             @{@"Time":@"抵押时间"}
                             ],
                         
                         @[// 11.放款
                             @{@"UserName":@"放款顾问"},
                             @{@"Time":@"放款时间"}
                             ],
                         
                         
                         @[//12.结案
                             @{@"UserName":@"经纪人"},
                             @{@"Time":@"结案时间"}
                             ],
                         
                         @[//13.解约
                             @{@"RecissionNo":@"编号"},
                             @{@"PayTypeKey":@"支付方式"},
                             @{@"UserName":@"经纪人"},
                             @{@"RecissionType":@"退款款项"},
                             @{@"Price":@"退款金额"},
                             @{@"RecissionTime":@"退单时间"},
                             @{@"RefundTime":@"退款时间"},
                             @{@"Reason":@"退款原因"},
                             @{@"Remark":@"备      注"}
                             ],
                         @[//13.收退款信息
                             ]
                         
                         ];
                
                
            }else{   ///租的类型
                
                arr5 = @[
                         
                         @[ //1.基本信息
                             
                             @{@"TransactionNo": @"成交编号"},
                             @{@"CreateTime": @"创建时间"},
                             @{@"Price": @"成交价格"},
                             @{ @"CustomerName":@"客户姓名"},
                             @{@"TrustorName": @"业主姓名"},
                             @{@"Performances":@"Performances"}
                             ],
                         
                         @[//2.定金
                             @{@"DepositNo":@"定金编号"},
                             @{@"IntentionPrice":@"意向金额"},
                             @{@"IntentionPayTime":@"支付时间"},
                             @{@"PayType":@"支付方式"},
                             @{@"DepositPrice":@"定金额度"},
                             @{@"PayTime":@"支付时间"},
                             @{@"AttachmentFile":@"定金收据"}
                             ],
                         
                          @[//3.签约
                             @{@"ContractNo":@"合同编号"},
                             @{@"SigningUserName":@"经纪人"},
                             @{@"SigningTime":@"签约时间"},
                             @{@"Remark":@"签约备注"}
                             ],
                         
                         @[//4.收佣
                             @{@"CommissionNo":@"收佣编号"},
                             @{@"Price":@"收佣额度"},
                             @{@"CommissionTime":@"支付时间"},
                             @{ @"PayType":@"支付方式"},
                             @{@"AttachmentFile":@"收佣收据"},
                             @{@"Remark":@"收佣备注"},
                             
                             ],
                         
                         
                         
                         @[//12.结案
                             @{@"UserName":@"经纪人"},
                             @{@"Time":@"结案时间"}
                             ],
                         
                         @[//13.解约
                             @{@"RecissionNo":@"编号"},
                             @{@"PayTypeKey":@"支付方式"},
                             @{@"UserName":@"经纪人"},
                             @{@"RecissionType":@"退款款项"},
                             @{@"Price":@"退款金额"},
                             @{@"RecissionTime":@"退单时间"},
                             @{@"RefundTime":@"退款时间"},
                             @{@"Reason":@"退款原因"},
                             @{@"Remark":@"备      注"}
                             ],
                         @[//13.收退款信息
                             ]
                         
                         ];
                
            }
            
            
            for (int i = 0; i < arr3.count; i++) {
                
                
                
                NSMutableArray *mutArr = [NSMutableArray array];
                for (NSDictionary *dict in arr5[i]) {
                    
                    [mutArr addObject:dict.allKeys[0]];
                }
                
                if ([arr3[i] isKindOfClass:[NSDictionary class]]) {
                    
                    NSArray *arr6 = [arr3[i] objectsForKeys:mutArr notFoundMarker:@"不存在"];
                    
                    NSMutableArray *mutArr1 = [NSMutableArray array];
                    for (int j = 0; j < arr6.count; j++) {
                        
                        NSDictionary *dict1 = [NSDictionary dictionaryWithObject:arr6[j] forKey:arr5[i][j].allValues[0]];
                        [mutArr1 addObject:dict1];
                    }
                    
                    [_mutArr addObject:mutArr1];
                    
                }else  if ([arr3[i] isKindOfClass:[NSArray class]]) {
                    
                    
                    NSArray<NSDictionary*>*BillArr =  @[
                                                        @{@"BillRecordNo": @"编       号"},
                                                        @{@"SourceStatus": @"收退状态"},
                                                        @{@"SourceCategory": @"收退名目"},
                                                        @{@"SourceTime": @"收退时间"},
                                                        @{@"Price": @"收退金额"},
                                                        @{@"PayTypeName":@"支付方式"},
                                                        @{@"Remark": @"备       注"}
                                                        
                                                        ];
                    
                    
                    
                    NSMutableArray *mutA = [NSMutableArray array];
                    
                    for (NSDictionary*dict in arr3[i]) {
                        
                        NSMutableArray *mutB = [NSMutableArray array];
                        
                        
                        for (int i = 0; i < BillArr.count; i++) {
                            
                            
                            NSString*string =  [dict objectForKey:BillArr[i].allKeys.firstObject];
                            
                            NSDictionary *billDict  = @{BillArr[i].allValues.firstObject:string};
                            
                            [mutB addObject:billDict];
                            
                        }
                        NSString *name = [NSString stringWithFormat:@"billRecordInfo%02d",_number++];
                        [mutA addObject:@{name:mutB}];
                        
                    }
                    
                    [_mutArr addObject:mutA];
                    
                    
                    
                } else{
                    
                    [_mutArr addObject:@[]];
                }
                
            }
            
            
        }else{
            
            _mutArr = nil;
        }
        
    }
    return _mutArr;
}


@end

