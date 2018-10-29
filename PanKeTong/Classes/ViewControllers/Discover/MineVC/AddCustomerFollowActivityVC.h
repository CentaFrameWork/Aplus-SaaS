//
//  AddCustomerFollowActivityVC.h
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/18.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "BaseViewController.h"
#import "ApplyTransferPubEstViewController.h"

@interface AddCustomerFollowActivityVC : BaseViewController

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic,strong)NSString *inquiryKeyId;
@property (strong,nonatomic) UICollectionView *remindPersonCollectionView;

@property (nonatomic,assign)id <ApplyTransferEstDelegate>delegate;

@end
