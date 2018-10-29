//
//  DealDetailController.h
//  PanKeTong
//
//  Created by Admin on 2018/3/19.
//  Copyright © 2018年 中原集团. All rights reserved.
//

#import "BaseViewController.h"
#import "WJDealListModel.h"

@interface DealDetailController : BaseViewController
@property (nonatomic,strong) WJDealListModel *model;
@property (nonatomic,copy) NSString *titleString;


@end


#pragma mark -  测试 租的类型

//- (NSDictionary *)dict {
//
//    if (!_dict) {
//
//        _dict = @{
//
//                  @"transactionInfo": @{ //1.基本信息
//
//                          @"TransactionNo": @"00000001",
//                          @"CreateTime": @"2018-03-23",
//                          @"Price": @"10000万",
//                          @"CustomerName": @"小张",
//                          @"TrustorName": @"小旺旺",
//                          @"Performances": @[
//                                           @{
//                                               @"UserName": @"校长",
//                                               @"Description": @"住房子",
//                                               @"Rate": @"独家"
//                                           },
//                                           @{
//                                               @"UserName": @"老师",
//                                               @"Description": @"住房子",
//                                               @"Rate": @"独家"
//                                           },
//                                           @{
//                                               @"UserName": @"同学",
//                                               @"Description": @"买房子",
//                                               @"Rate": @"带看"
//                                           }
//                                           ]
//                          },
//
//                  @"depositInfo": @{//2.定金
//                          @"DepositNo": @"sample string 1",
//                          @"IntentionPrice": @"sample string 2",
//                          @"IntentionPayTime": @"sample string 3",
//                          @"PayType": @"sample string 4",
//                          @"DepositPrice": @"sample string 5",
//                          @"PayTime": @"sample string 6",
//                          @"AttachmentFile": @[
//                                  @"sample string 1",
//                                  @"sample string 2",
//                                  @"sample string 3"
//                                  ],
//                          },
//
//                  @"signingInfo": @{//3.签约
//                          @"SigningUserName": @"sample string 1",
//                          @"SigningTime": @"sample string 2",
//                          @"ContractNo": @"sample string 3",
//                          @"ContractStatus": @"sample string 4",
//                          @"Remark": @"sample string 5"
//                          },
//
//                  @"commissionInfo": @{//4.收佣
//                          @"CommissionNo": @"sample string 1",
//                          @"Price": @"sample string 2",
//                          @"CommissionTime": @"sample string 3",
//                          @"PayType": @"sample string 4",
//                          @"AttachmentFile": @[
//                                  @"sample string 1",
//                                  @"sample string 2",
//                                  @"sample string 3"
//                                  ],
//                          @"Remark": @"sample string 5"
//                          },
//
//                  @"internetSignInfo": [NSNull null],
//
//                  @"faceSignInfo": [NSNull null],
//                  @"auditLoanInfo": @{//7.批贷
//                          @"TransactionKeyId": @"9405257c-8827-4269-b271-7d0a08717ae2",
//                          @"AuditLoanUserName": @"sample string 1",
//                          @"LoanBank": @"sample string 2",
//                          @"LoanPersonName": @"sample string 3",
//                          @"LoanPrice": @"sample string 4",
//                          @"LoanYear": @5,
//                          @"LoanRate": @"sample string 6",
//                          @"LoanAgreeTime": @"sample string 7",
//                          @"PayMentType": @"sample string 8"
//                          },
//
//                  @"scottareMobileInfo":[NSNull null],
//
//
//
//                  @"transferInfo": [NSNull null],
//
//                  @"mortgageInfo": @{//10.抵押
//                          @"UserName": @"sample string 1",
//                          @"Time": @"sample string 2"
//                          },
//
//                  @"bankLendingInfo": [NSNull null],
//
//                  @"transactionComplateInfo": [NSNull null],
//
//
//
//                  @"recissionInfo": [NSNull null]
//                  };
//    }
//
//    return _dict;
//}
#pragma mark -  测试 售的类型

//- (NSDictionary *)dict {
//
//    if (!_dict) {
//
//        _dict = @{
//
//                  @"transactionInfo": @{ //1.基本信息
//
//                          @"TransactionNo": @"00000001",
//                          @"CreateTime": @"2018-03-23",
//                          @"Price": @"10000万",
//                          @"CustomerName": @"小张",
//                          @"TrustorName": @"小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺旺小旺123",
//                          @"Performances": @[
//                                  @{
//                                      @"UserName": @"校长",
//                                      @"Description": @"住房子",
//                                      @"Rate": @"独家"
//                                      },
//                                  @{
//                                      @"UserName": @"老师",
//                                      @"Description": @"住房子",
//                                      @"Rate": @"独家"
//                                      },
//                                  @{
//                                      @"UserName": @"同学",
//                                      @"Description": @"买房子",
//                                      @"Rate": @"带看"
//                                      }
//                                  ]
//                          },
//
//                  @"depositInfo": @{//2.定金
//                          @"DepositNo": @"sample string 1",
//                          @"IntentionPrice": @"sample string 2",
//                          @"IntentionPayTime": @"sample string 3",
//                          @"PayType": @"sample string 4",
//                          @"DepositPrice": @"sample string 5",
//                          @"PayTime": @"sample string 6",
//                          @"AttachmentFile": @[
//                                  @"sample string 1",
//                                  @"sample string 2",
//                                  @"sample string 3"
//                                  ],
//                          },
//
//                  @"signingInfo": @{//3.签约
//                          @"SigningUserName": @"sample string 1",
//                          @"SigningTime": @"sample string 2",
//                          @"ContractNo": @"sample string 3",
//                          @"ContractStatus": @"sample string 4",
//                          @"Remark": @"sample string 5"
//                          },
//
//                  @"commissionInfo": @{//4.收佣
//                          @"CommissionNo": @"sample string 1",
//                          @"Price": @"sample string 2",
//                          @"CommissionTime": @"sample string 3",
//                          @"PayType": @"sample string 4",
//                          @"AttachmentFile": @[
//                                  @"sample string 1",
//                                  @"sample string 2",
//                                  @"sample string 3"
//                                  ],
//                          @"Remark": @"sample string 5"
//                          },
//
//                  @"internetSignInfo": @{// 5.网签
//                          @"SignUserName": @"sample string 1",
//                          @"SignNo": @"sample string 2",
//                          @"ValidatePropertyTime": @"sample string 3",
//                          @"ComplateTime": @"sample string 4",
//                          @"Price": @"sample string 5",
//                          @"AttachmentFile": @[
//                                  @"sample string 1",
//                                  @"sample string 2",
//                                  @"sample string 3"
//                                  ],
//                          @"AuditAttachmentFile": @[
//                                  @"sample string 1",
//                                  @"sample string 2",
//                                  @"sample string 3"
//                                  ]
//                          },
//
//                  @"faceSignInfo": @{//6.面签
//                          @"SignUserName": @"sample string 1",
//                          @"EstimatePrice": @"sample string 2",
//                          @"EstimateTime": @"sample string 3",
//                          @"LoanTime": @"sample string 4",
//                          @"LoanBank": @"sample string 5",
//                          @"LoanPrice": @"sample string 6"
//                          },
//                  @"auditLoanInfo": @{//7.批贷
//                          @"TransactionKeyId": @"9405257c-8827-4269-b271-7d0a08717ae2",
//                          @"AuditLoanUserName": @"sample string 1",
//                          @"LoanBank": @"sample string 2",
//                          @"LoanPersonName": @"sample string 3",
//                          @"LoanPrice": @"sample string 4",
//                          @"LoanYear": @5,
//                          @"LoanRate": @"sample string 6",
//                          @"LoanAgreeTime": @"sample string 7",
//                          @"PayMentType": @"sample string 8"
//                          },
//
//                  @"scottareMobileInfo": @{//8.缴税
//                          @"Details": @[
//                                  @{
//                                      @"ScottareType": @"个人所得税",
//                                      @"ScottarePrice": @"100万"
//                                      },
//                                  @{
//                                      @"ScottareType": @"商业税",
//                                      @"ScottarePrice": @"800万"
//                                      },
//                                  @{
//                                      @"ScottareType": @"契税",
//                                      @"ScottarePrice": @"900万"
//                                      }
//                                  ],
//                          @"ScottareUserName": @"sample string 1",
//                          @"ScottareTime": @"sample string 2"
//                          },
//
//
//
//                  @"transferInfo": @{//9.过户
//                          @"UserName": @"sample string 1",
//                          @"Time": @"sample string 2"
//                          },
//
//                  @"mortgageInfo": @{//10.抵押
//                          @"UserName": @"sample string 1",
//                          @"Time": @"sample string 2"
//                          },
//
//                  @"bankLendingInfo": @{// 11.放款
//                          @"UserName": @"sample string 1",
//                          @"Time": @"sample string 2"
//                          },
//
//                  @"transactionComplateInfo": @{//12.结案
//                          @"UserName": @"sample string 1",
//                          @"Time": @"sample string 2"
//                          },
//
//
//
//                  @"recissionInfo": @{//13.解约
//                          @"RecissionNo": @"sample string 1",
//                          @"PayTypeKey": @"sample string 2",
//                          @"UserName": @"sample string 3",
//                          @"RecissionType": @"sample string 4",
//                          @"Price": @"sample string 5",
//                          @"RecissionTime": @"sample string 6",
//                          @"RefundTime": @"sample string 7",
//                          @"Reason": @"sample string 8",
//                          @"Remark": @"sample string 9"
//                          },
//
//                    @"billRecordInfo": @[//收付款信息
//                    @{
//                        @"BillRecordNo": @"sample string 1",
//                        @"SourceStatus": @"sample string 2",
//                        @"SourceCategory": @"sample string 3",
//                        @"SourceTime": @"sample string 4",
//                        @"Price": @"sample string 5",
//                        @"PayTypeName": @"sample string 6",
//                        @"Remark": @"sample string 7"
//                    },
//                    @{
//                        @"BillRecordNo": @"sample string 1",
//                        @"SourceStatus": @"sample string 2",
//                        @"SourceCategory": @"sample string 3",
//                        @"SourceTime": @"sample string 4",
//                        @"Price": @"sample string 5",
//                        @"PayTypeName": @"sample string 6",
//                        @"Remark": @"sample string 7"
//                    },
//                    @{
//                        @"BillRecordNo": @"sample string 1",
//                        @"SourceStatus": @"sample string 2",
//                        @"SourceCategory": @"sample string 3",
//                        @"SourceTime": @"sample string 4",
//                        @"Price": @"sample string 5",
//                        @"PayTypeName": @"sample string 6",
//                        @"Remark": @"sample string 7"
//                    }],
//
//
//
//
//                  @"Flag": @true,
//                  @"ErrorMsg": @"sample string 2",
//                  @"RunTime": @"sample string 3"
//                  };
//    }
//
//    return _dict;
//}




/**
 
 
 
 if (indexPath.section == 0) {
 
 if (indexPath.row > 4) {
 
 NSDictionary *dict = self.mutArr[0][indexPath.row];
 NSArray *arr = dict.allValues.firstObject;
 
 return 44 * arr.count;
 
 }else{
 
 return 44;
 }
 
 
 }else if (indexPath.section == 7){//纳税
 
 
 if (indexPath.row ) {
 return 44;
 
 
 }else{
 
 NSDictionary *dict = self.mutArr[7][0];
 NSArray *arr = dict.allValues.firstObject;
 return 44 * arr.count;
 
 }
 
 }else if (indexPath.section == self.array.count/2-1){//收付款信息
 
 CGFloat billHeight = 0;
 NSArray <NSDictionary*>*arr = dict.allValues[0];
 
 for (int j = 0; j<arr.count; j++) {
 
 billHeight += [DealDeatailCell sizeWithString:arr[j].allValues[0]];
 
 }
 
 return billHeight;
 
 }else{
 
 return 44;
 }
 
 
 
 */


