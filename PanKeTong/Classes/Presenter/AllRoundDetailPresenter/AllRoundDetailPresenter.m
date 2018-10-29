//
//  AllRoundDetailPresenter.m
//  PanKeTong
//
//  Created by 中原管家 on 2017/4/24.
//  Copyright © 2017年 中原集团. All rights reserved.
//

#import "AllRoundDetailPresenter.h"
#import "TrustorEntity.h"
#import "CheckPermissionInstantiation.h"

@implementation AllRoundDetailPresenter

- (instancetype)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self)
    {
        _selfView = delegate;
        self.permissionDelegate = [[CheckPermissionInstantiation alloc] init];
    }
    return self;
}


/// 获取联系人数据源
- (void)getDataSource:(NSDictionary *)trustorDic
{
    _trustorEntity = [DataConvert convertDic:trustorDic toEntity:[PropTrustorsInfoEntity class]];

}

/// 是否可以查看全部房号
- (BOOL)isAllHouseNum
{
    return NO;
}

//是否显示拼接的房源字段
- (BOOL)isShowPinPropertyTitle{
    return NO;
}

/// 是否需要验证实勘保护期
- (BOOL)isCheckRealProtected
{
    return YES;
}

/// 是否需要验证房源状态
- (BOOL)isCheckPropertyStatus
{
    return NO;
}

/// 查看联系人权限
- (BOOL)canViewTrustors:(NSString *)deptPerm
{
    return [_permissionDelegate haveViewTrustorsPerm:deptPerm];
}

/// 是否使用虚拟号拨打
- (BOOL)isCallVirtualPhone
{
    return ![_trustorEntity.virtualCall boolValue];
}

///  使用虚拟号拨打
- (void)callVirtualPhoneSelectIndex:(NSInteger)selectIndex
                           andMobil:(NSString *)mobile
                       andPropKeyId:(NSString *)propKeyId
                      andPropertyNo:(NSString *)propertyNo
{
    
    TrustorEntity *trustor = _trustorEntity.trustors[selectIndex];
    
    IdentifyEntity *entity = [AgencyUserPermisstionUtil getIdentify];
    
    [[DascomUtil shareDascomUtil] callVirtualPhone:mobile
                                      andProperty:propKeyId
                                       andPhoneID:trustor.keyId
                                         andEmpID:entity.uId
                                        andDeptID:entity.departId
                                     andPropertyNo:propertyNo];
}

/// 是否使用得实达康
- (BOOL)isUseDascom
{
    return YES;
}

/// 获得拨打次数
- (NSInteger)getCallLimit
{
    return [_trustorEntity.callLimit integerValue];
}

/// 获得应拨打的电话
- (NSString *)getCallNumSelectIndex:(NSInteger)selectIndex
{
    TrustorEntity *trustor = _trustorEntity.trustors[selectIndex];
    return trustor.trustorMobile.length == 0 ? trustor.tel : trustor.trustorMobile;
}

/// 是否可以显示联系人
- (NSString *)showTrustorsErrorMsg
{
    if(!_trustorEntity.canBrowse)
    {
        return _trustorEntity.noCallMessage;
    }
    
    NSInteger used = _trustorEntity.usedBrowseCount;
    NSInteger limit = _trustorEntity.totalBrowseCount;
    
    used =  0;
    limit       =  0;
    // 同时为0时为开启虚拟号  不限制次数
    if (!(limit == 0 && used == 0))
    {
        if(limit >= 0)
        {
            if(used >= limit)
            {
                return @"今日查看业主电话次数已达到上限!";
            }
        }
    }
    
    return nil;
}

/// 获取联系人列表对话框的姓名数组
- (NSArray *)getTrustorsName
{
    NSMutableArray *nameArr = [NSMutableArray array];
    
    //陈行修改163bug
    SysParamItemEntity * sysParamItem = [AgencySysParamUtil getSysParamByTypeId:SystemParamTypeEnum_CUTOMER_TYPE];
    
    for (TrustorEntity *trustor in _trustorEntity.trustors) {
        
        if (trustor.trustorType.length == 0) {
            
            for (SelectItemDtoEntity * tmp in sysParamItem.itemList) {
                
                if ([tmp.itemValue isEqualToString:trustor.trustorTypeKeyId]) {
                    
                    trustor.trustorType = tmp.itemText;
                    
                    break;
                    
                }
                
            }
            
        }
        
        trustor.trustorType = trustor.trustorType ? : @"";
        
        [nameArr addObject:[NSString stringWithFormat:@"%@(%@)",trustor.trustorName,trustor.trustorType]];
        
    }
    
    return (NSArray *)nameArr;
}


/// 是否可以进入通话记录
- (BOOL)haveCallRecordPermission
{
    return NO;
}

/// 右上角更多
- (NSArray *)rightNavTitleArr:(NSString *)isCollection
{
    
    
    if (isCollection) {
        return @[@"首页",@"消息",@"分享",@"上传实勘",isCollection,@"录音",@"周边",@"调价",@"状态修改",@"上传委托",@"维护联系人"];
    }
    return @[@"首页",@"消息",@"分享",@"上传实勘",@"录音",@"周边",@"调价",@"状态修改",@"上传委托",@"维护联系人"];
}

/// 查看跟进
- (BOOL)canViewFollowList:(NSString *)deptPerm;
{
    return [_permissionDelegate haveFollowListPerm:deptPerm];
}

/// 添加实勘权限
- (BOOL)canAddUploadrealSurvey:(NSString *)deptPerm
{
    return [_permissionDelegate haveAddUploadrealSurveyPerm:deptPerm];
}

// 查看实勘权限
- (BOOL)canViewUploadrealSurvey:(NSString *)deptPerm
{
    return [_permissionDelegate haveUploadrealSurveyPerm:deptPerm];
}

// 查看钥匙权限
- (BOOL)canViewPropKey:(NSString *)deptPerm
{
    return [_permissionDelegate havePropKeyPerm:deptPerm];
}

// 拨打联系人提示语 
- (NSString *)callTrustorsMsgSelectIndex:(NSInteger)selectIndex
{
    NSInteger trustorsCount = _trustorEntity.trustors.count;
    if (trustorsCount <= 0) {
        return @"暂无联系人信息!";
    }
    
    TrustorEntity *trustor = (TrustorEntity *)_trustorEntity.trustors[selectIndex];

    BOOL valid = YES;
    
    //陈行修改164bug
    if (trustor.trustorMobile.length == 0 && trustor.tel.length == 0) {
        
        valid = NO;
        
    }
    
//    if(trustor.trustorMobile)
//    {
//        if([trustor.trustorMobile isEqualToString:@""])
//        {
//            valid = NO;
//        }
//    }
//    else
//    {
//        valid = NO;
//    }
    
    if(!valid)
    {
        return [NSString stringWithFormat:@"没有%@的联系方式！",trustor.trustorName];
    }
    
    return nil;
}


/// 是否含有装修情况、实用面积、建筑面积、房屋用途
- (BOOL)haveSquareOrSquareUseOrDecorationSituationOrPropertyUsage
{
    return NO;
}

///  含有装修情况、实用面积、建筑面积、房屋用途时所增加的高度
- (float)haveSquareOrSquareUseOrDecorationSituationOrPropertyUsageAddHight
{
    return 0;
}

/// 签约/独家
- (NSString *)getOnlyTrustString
{
    return @"独家";
}

/// 点击发布房源时是否需要验证房源面积
- (EditHouseVO *)needCheckHouseSquare:(PropPageDetailEntity *)propDetailEntity andCheckHouseInfoEntity:(EditHouseVO *)entity
{
    BOOL isArea = ([propDetailEntity.square doubleValue]>=2.00 && [propDetailEntity.square doubleValue] <= 10000000.00)?YES:NO;
    if (!isArea)
    {
        entity.title = @"房源面积必须为2-10000000m²之间!";
        entity.message = @"请通过编辑房源补充信息";
    }
    
    return entity;
}

/// 点击发布房源时是否需要验证房源价格(租价, 售价)
- (EditHouseVO *)needCheckHousePrice:(PropPageDetailEntity *)propDetailEntity
                        andTrustType:(NSString *)trustType
             andCheckHouseInfoEntity:(EditHouseVO *)entity
{
    // 价格
    if ([trustType isEqualToString:@"1"])
    {
        // 出售
        BOOL isSale = ([propDetailEntity.salePrice doubleValue]>=5.00 && [propDetailEntity.salePrice doubleValue] <= 10000.00)?YES:NO;
        if (!isSale)
        {
            entity.title = @"售价必须在5万－1亿之间!";
            entity.message = @"请通过编辑房源补充信息";
        }
    }
    else if ([trustType isEqualToString:@"2"])
    {
        // 出租
        BOOL isRent = ([propDetailEntity.rentPrice doubleValue]>=800.00 && [propDetailEntity.rentPrice doubleValue] <= 500000.00)?YES:NO;
        if (!isRent)
        {
            entity.title = @"租价必须在800-50万之间!";
            entity.message = @"请通过编辑房源补充信息";
        }
    }

    return entity;
}

/// 点击发布房源时是否需要验证房屋朝向
- (EditHouseVO *)needCheckHouseDirection:(PropPageDetailEntity *)propDetailEntity andCheckHouseInfoEntity:(EditHouseVO *)entity
{
    // 朝向
    BOOL isDirection = (propDetailEntity.houseDirection.length > 0) ? YES : NO;
    if (!isDirection)
    {
        entity.title = @"房源必须有朝向信息!";
        entity.message = @"请通过编辑房源补充信息";
    }
    
    return entity;
}

/// 点击发布房源时是否需要验证产权性质
- (EditHouseVO *)needCheckHousePropertyRight:(PropPageDetailEntity *)propDetailEntity andCheckHouseInfoEntity:(EditHouseVO *)entity
{
    // 产权性质
    BOOL isPropertyRight = (propDetailEntity.propertyCardClassName.length > 0) ? YES : NO;
    if (!isPropertyRight)
    {
        entity.title = @"房源必须有产权性质!";
        entity.message = @"请通过编辑房源补充信息";
    }

    return entity;
}

/// 点击发布房源时是否需要验证房屋用途
- (EditHouseVO *)needCheckHousePropertyType:(PropPageDetailEntity *)propDetailEntity andCheckHouseInfoEntity:(EditHouseVO *)entity
{
    // 房屋用途
    BOOL isPropertyType = (propDetailEntity.propertyUsage.length > 0) ? YES : NO;
    if (!isPropertyType)
    {
        entity.title = @"房源必须有房屋用途!";
        entity.message = @"请通过编辑房源补充信息";
    }
    return entity;
}

/// 点击发布房源时是否需要验证楼层
- (EditHouseVO *)needCheckHouseFloor:(PropPageDetailEntity *)propDetailEntity andCheckHouseInfoEntity:(EditHouseVO *)entity
{
    BOOL isFloor = (propDetailEntity.floor.length > 0) ? YES : NO;
    
    if (!isFloor)
    {
        entity.title = @"楼层不能为空!";
        entity.message = @"请联系数据组同事补充信息";
    }
    
    return entity;
}

/// 点击发布房源时是否需要验证实勘
- (EditHouseVO *)needCheckHouseRealSurvey:(CheckRealSurveyEntity *)checkRealSurveyEntity andCheckHouseInfoEntity:(EditHouseVO *)entity
{
    BOOL isRealSurveyCount = (checkRealSurveyEntity.propertyRoomTypePhotoIsHav == YES) ? YES : NO;
    
    if (!isRealSurveyCount)
    {
        // 没有实勘
        entity.title = @"室内图或户型图不能为空!";
        entity.message = @"请完善实勘";
    }
    return entity;
}

/// 点击发布房源时是否需要验证户型/房型
- (EditHouseVO *)needCheckHouseRoomType:(PropPageDetailEntity *)propDetailEntity andCheckHouseInfoEntity:(EditHouseVO *)entity
{
    return entity;
}

- (NSString *)getPageSize
{
    return @"10";
}


// 获取房源详情的详情字段
- (NSArray *)getDetailLeftArrayWithTrustType:(NSInteger)trustType
{
    NSArray *dataArr;

    if (trustType == SALE) {
        // 售
        dataArr = @[
                    @"朝       向",
                    @"房屋现状",
                    @"产权性质",
                    @"单       价",
                    @"建筑面积",
                    @"楼层总层"
                    ];
    }else if (trustType == RENT) {
        // 租
        dataArr = @[
                    @"朝       向",
                    @"房屋现状",
                    @"产权性质",
                    @"建筑面积",
                    @"楼层总层"
                    ];
    }else if (trustType == BOTH) {
        // 租售
        dataArr = @[
                    @"朝       向",
                    @"房屋现状",
                    @"产权性质",
                    @"单       价",
                    @"建筑面积",
                    @"楼层总层"
                    ];
    }else if (trustType == typeDfeauth) {
        // 默认类型
        dataArr = @[
                    @"朝       向",
                    @"房屋现状",
                    @"产权性质",
                    @"建筑面积",
                    @"楼层总层"
                    ];
    }

    return dataArr;
}

//获取房源详情的详情数据
- (NSArray *)getDetailRightArrayWithEntity:(PropPageDetailEntity *)entity {
   
    
    NSInteger trustType = [entity.trustType integerValue]?:0;
   
    
    NSString *saleUnit = _propDetailEntity.saleUnitPrice;

  
    NSString *square;
   
    if (fmodf([_propDetailEntity.square doubleValue], 1)==0) {
        //87m²
         square = [NSString stringWithFormat:@"%.0f平",[_propDetailEntity.square doubleValue]];
    
    }else{
        
        
        square = [NSString stringWithFormat:@"%.2f平",[_propDetailEntity.square doubleValue]];
        

    }
      //0/0层

    NSString *floor = _propDetailEntity.floor.length > 0?[NSString stringWithFormat:@"%@层",_propDetailEntity.floor]:@"";
    
     NSArray *dataArr;
    
    if (trustType == SALE){
        // 售
        dataArr = @[
                    
                    [self nilToEmptyWithStr:_propDetailEntity.houseDirection],
                    [self nilToEmptyWithStr:_propDetailEntity.propertySituation],
                    [self nilToEmptyWithStr:_propDetailEntity.propertyCardClassName],
                    saleUnit,
                    square,
                    floor,
                    ];
        
    }else if (trustType == RENT){
     
        // 租
        dataArr = @[
                    
                    [self nilToEmptyWithStr:_propDetailEntity.houseDirection],
                    [self nilToEmptyWithStr:_propDetailEntity.propertySituation],
                    [self nilToEmptyWithStr:_propDetailEntity.propertyCardClassName],
                    square,
                    floor
                    ];
    }else if (trustType == BOTH) {
      
        // 租售
        dataArr = @[
                    
                    [self nilToEmptyWithStr:_propDetailEntity.houseDirection],
                    [self nilToEmptyWithStr:_propDetailEntity.propertySituation],
                    [self nilToEmptyWithStr:_propDetailEntity.propertyCardClassName],
                    saleUnit,
                    square,
                    floor
                    ];
    }else if (trustType == typeDfeauth){
        
        
        dataArr = @[
                    
                    [self nilToEmptyWithStr:_propDetailEntity.houseDirection],
                    [self nilToEmptyWithStr:_propDetailEntity.propertySituation],
                    [self nilToEmptyWithStr:_propDetailEntity.propertyCardClassName],
                    square,
                    floor
                
                    ];
    }

    return dataArr;
}


- (NSString*)nilToEmptyWithStr:(NSString*)string {
    
    
    return string.length?string:@"-";

}




@end
