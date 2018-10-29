//
//  EstReleaseDetailImgResultEntity.h
//  PanKeTong
//
//  Created by wanghx17 on 15/10/21.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "SubBaseEntity.h"

@interface EstReleaseDetailImgResultEntity : SubBaseEntity


@property (nonatomic,strong)NSString * postId;
@property (nonatomic,strong)NSString * imgId;
@property (nonatomic,strong)NSString * imgPath;
@property (nonatomic,strong)NSString * imgSrcExt;
@property (nonatomic,strong)NSString * imgDestExt;
@property (nonatomic,assign)NSInteger imgClassId;
@property (nonatomic,strong)NSString * imgTitle;
@property (nonatomic,strong)NSString * imgDescription;
@property (nonatomic,assign)NSInteger imgOrder;
@property (nonatomic,assign)BOOL isDefault;
@property (nonatomic,strong)NSString * createTime;
@property (nonatomic,strong)NSString * updateTime;


@end
