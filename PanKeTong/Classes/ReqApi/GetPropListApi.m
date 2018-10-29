//
//  GetPropListApi.m
//  PanKeTong
//
//  Created by 王雅琦 on 16/8/1.
//  Copyright © 2016年 苏军朋. All rights reserved.
//

#import "GetPropListApi.h"
#import "PropListEntity.h"
@implementation GetPropListApi


//请求体参数
- (NSDictionary *)getBody {
    NSString *updPermisstionsTime = @"UpdPermisstionsTime";
    NSString *propStatus = @"PropStatus";
    NSString *propSituation = @"PropSituation";
    NSString *propLevel = @"PropLevel";
    NSString *propSquareType = @"PropSquareType";
    NSString *propType = @"PropType";
    
    if ([CommonMethod isRequestFinalApiAddress])
    {
        updPermisstionsTime = @"UpdatePermisstionsTime";
        propStatus = @"PropertyStatus";
        propSituation = @"PropertySituation";
        propLevel = @"PropertyLevel";
        propSquareType = @"PropertySquareType";
        propType = @"PropertyType";
    }
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"2016-12-09T10:21:54.727",updPermisstionsTime,
                              _propListTyp?_propListTyp:@"",propType,
                              _propertyTypes?_propertyTypes:@"",@"PropertyTypes",
                              _popStatus?_popStatus:@"",propStatus,
                              _propSituationValue?_propSituationValue:@"",propSituation,
                              _roomLevelValue?_roomLevelValue:@"",propLevel,
                              _houseDirection?_houseDirection:@"",@"HouseDirection",
                              _propertyboolTag?_propertyboolTag:@"",@"PropertyboolTag",
                              _isNewProInThreeDay?_isNewProInThreeDay:@"",@"IsNewProIn72",
                              _isPanorama?_isPanorama:@"",@"IsPanorama",
                              _isNoCall?_isNoCall:@"",@"IsNoCall",
                              _isPropertyKey?_isPropertyKey:@"",@"IsPropertyKey",
                              _isRealSurvey?_isRealSurvey:@"",@"IsRealSurvey",
                              _buildTypes?_buildTypes:@"",@"BulidTypes",
                              @"1",propSquareType,
                              _minBuildingArea?_minBuildingArea:@"",@"SquareFrom",
                              _maxBuildingArea?_maxBuildingArea:@"",@"SquareTo",
                              _minRentPrice?_minRentPrice:@"",@"RentPriceFrom",
                              _maxRentPrice?_maxRentPrice:@"",@"RentPriceTo",
                              _minSalePrice?_minSalePrice:@"",@"SalePriceFrom",
                              _maxSalePrice?_maxSalePrice:@"",@"SalePriceTo",
                              _estateSelectType?_estateSelectType:@"",@"EstateSelectType",
                              _trustType?_trustType:@"",@"TrustType",
                              _scope?_scope:@"",@"Scope",
                              _searchKeyWord?_searchKeyWord:@"",@"Keywords",
                              _keywordType?_keywordType:@"",@"KeywordType",
                              _isRecommend?_isRecommend:@NO,@"IsRecommend",
                              _pageIndex?_pageIndex:@"",@"PageIndex",
                              _isVideo?_isVideo:@"",@"IsVideo",
                              @"10",@"PageSize",
                              _sortField?_sortField:@"",@"SortField",
                              _ascending?_ascending:@"true",@"Ascending",
                              _hasPropertyKey?_hasPropertyKey:@"",@"HasPropertyKey",
                              _isOnlyTrust,@"IsOnlyTrust",
                              _houseNo?_houseNo:@"",@"HouseNo",
                              _buildingNames?_buildingNames:@"",@"BuildingNames",
                              _isTrustsApproved?_isTrustsApproved:@"",@"IsTrustsApproved",
                              _isCredentials?_isCredentials:@"",@"IsCredentials",
                              _isHasRegisterTrusts?_isHasRegisterTrusts:@"",@"IsHasRegisterTrusts",
                              _propertyNo?_propertyNo:@"", @"PropertyNo",
                              _isRealSurvey?_isRealSurvey:@"", @"IsRealSurvey",
                              _houseNoType?_houseNoType:@"1", @"HouseNoType",
                              nil];
    
    return paramDic;
    
//    NSString *string = [paramDic JSONString];
//    NSString *encodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, (CFStringRef)@":", kCFStringEncodingUTF8));
//
//    return @{@"urlParams":encodedString};
    
}

- (NSString *)getPath {
    //通盘房源列表
    
    
    return @"property/war-zone";
    
}




- (Class)getRespClass
{
    return [PropListEntity class];
}

- (int)getRequestMethod {
    
    return RequestMethodPOST;
}

- (void)addValue:(NSString *)obj andKey:(NSString *)key andDict:(NSMutableDictionary *)dict{
    
    if (![obj isKindOfClass:[NSString class]] || obj == nil || obj.length == 0) {
        
        return;
        
    }
    
    [dict setObject:obj forKey:key];
    
}

@end
