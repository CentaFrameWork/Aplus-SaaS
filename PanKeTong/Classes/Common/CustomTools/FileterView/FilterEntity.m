//
//  FilterEntity.m
//  PanKeTong
//
//  Created by wanghx17 on 15/10/8.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#import "FilterEntity.h"

@implementation FilterEntity
- (id)copyWithZone:(NSZone *)zone
{

    FilterEntity *copyFilterEntity = [FilterEntity allocWithZone:zone];

    copyFilterEntity.clientStatuText = _clientStatuText;
    copyFilterEntity.clientStatuValue = _clientStatuValue;
    copyFilterEntity.estDealTypeText = _estDealTypeText;
    copyFilterEntity.estDealTypeValue = _estDealTypeValue;
    copyFilterEntity.clientDealTypeText = _clientDealTypeText;
    copyFilterEntity.clientDealTypeValue = _clientDealTypeValue;
    copyFilterEntity.priceType =_priceType;
    copyFilterEntity.salePriceText = _salePriceText;
    copyFilterEntity.maxSalePrice = _maxSalePrice;
    copyFilterEntity.minSalePrice = _minSalePrice;
    copyFilterEntity.rentPriceText = _rentPriceText;
    copyFilterEntity.maxRentPrice = _maxRentPrice;
    copyFilterEntity.minRentPrice = _minRentPrice;
    copyFilterEntity.isInpuntPrice = _isInpuntPrice;
    copyFilterEntity.tagText = _tagText;
    copyFilterEntity.isNewProInThreeDay = _isNewProInThreeDay;
    copyFilterEntity.isPanorama = _isPanorama;
    copyFilterEntity.isNoCall = _isNoCall;
    copyFilterEntity.isPropertyKey = _isPropertyKey;
    copyFilterEntity.isRealSurvey = _isRealSurvey;
    copyFilterEntity.isRecommend = _isRecommend;
    copyFilterEntity.isOnlyTrust = _isOnlyTrust;
    copyFilterEntity.hasPropertyKey = _hasPropertyKey;
    copyFilterEntity.estateSelectType = _estateSelectType;

    copyFilterEntity.roomType = _roomType;
    copyFilterEntity.roomStatus = _roomStatus;
    copyFilterEntity.propSituationText = _propSituationText;
    copyFilterEntity.propSituationValue = _propSituationValue;
    copyFilterEntity.roomSituation = _roomSituation;
    copyFilterEntity.roomLevelText = _roomLevelText;
    copyFilterEntity.roomLevelValue = _roomLevelValue;
    copyFilterEntity.roomLevels = _roomLevels;
    copyFilterEntity.direction = _direction;
    copyFilterEntity.propTag = _propTag;
    copyFilterEntity.buildingType = _buildingType;
    copyFilterEntity.levelLogButtonTag = _levelLogButtonTag;
    copyFilterEntity.propSituationLogButtonTag = _propSituationLogButtonTag;
    copyFilterEntity.levelLogButtonSelect = _levelLogButtonSelect;
    copyFilterEntity.propSituationLogButtonSelect = _propSituationLogButtonSelect;
    copyFilterEntity.minBuildingArea = _minBuildingArea;
    copyFilterEntity.maxBuildingArea = _maxBuildingArea;

    copyFilterEntity.moreFilterMinRentPrice = _moreFilterMinRentPrice;
    copyFilterEntity.moreFilterMaxRentPrice = _moreFilterMaxRentPrice;
    copyFilterEntity.moreFilterMinSalePrice = _moreFilterMinSalePrice;
    copyFilterEntity.moreFilterMaxSalePrice = _moreFilterMaxSalePrice;
    copyFilterEntity.isCurrent = _isCurrent;
    copyFilterEntity.houseNo = _houseNo;
    
    copyFilterEntity.sortField = _sortField;
    copyFilterEntity.ascending = _ascending;
    copyFilterEntity.isTrustsApproved = _isTrustsApproved == nil?@"":_isTrustsApproved;
    copyFilterEntity.isCompleteDoc = _isCompleteDoc == nil?@"":_isCompleteDoc;
    copyFilterEntity.isTrustProperty = _isTrustProperty == nil?@"":_isTrustProperty;
    copyFilterEntity.propertyNo = _propertyNo == nil?@"":_propertyNo;
    copyFilterEntity.isRealSurvey = _isRealSurvey==nil?@"":_isRealSurvey;
    
    return copyFilterEntity;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
            @"clientStatuText":@"clientStatuText",
            @"clientStatuValue":@"clientStatuValue",
            @"estDealTypeText":@"estDealTypeText",
            @"estDealTypeValue":@"estDealTypeValue",
            @"clientDealTypeText":@"clientDealTypeText",
            @"clientDealTypeValue":@"clientDealTypeValue",
            @"priceType":@"priceType",
            @"salePriceText":@"salePriceText",
            @"maxSalePrice":@"maxSalePrice",
            @"minSalePrice":@"minSalePrice",
            @"rentPriceText":@"rentPriceText",
            @"maxRentPrice":@"maxRentPrice",
            @"minRentPrice":@"minRentPrice",
            @"isInpuntPrice":@"isInpuntPrice",
            @"tagText":@"tagText",
            @"isNewProInThreeDay":@"isNewProInThreeDay",
            @"isPanorama":@"isPanorama",
            @"isNoCall":@"isNoCall",
            @"isPropertyKey":@"isPropertyKey",
            @"isRealSurvey":@"isRealSurvey",
            @"isRecommend":@"isRecommend",
            @"roomType":@"roomType",
            @"roomStatus":@"roomStatus",
            @"roomSituation":@"roomSituation",
            @"roomLevels":@"roomLevels",
            @"propSituationText":@"propSituationText",
            @"propSituationValue":@"propSituationValue",
            @"roomLevelText":@"roomLevelText",
            @"roomLevelValue":@"roomLevelValue",
            @"direction":@"direction",
            @"propTag":@"propTag",
            @"buildingType":@"buildingType",
            @"levelLogButtonTag":@"levelLogButtonTag",
            @"propSituationLogButtonTag":@"propSituationLogButtonTag",
            @"levelLogButtonSelect":@"levelLogButtonSelect",
            @"propSituationLogButtonSelect":@"propSituationLogButtonSelect",
            @"minBuildingArea":@"minBuildingArea",
            @"maxBuildingArea":@"maxBuildingArea",
            @"moreFilterMinRentPrice":@"moreFilterMinRentPrice",
            @"moreFilterMaxRentPrice":@"moreFilterMaxRentPrice",
            @"moreFilterMinSalePrice":@"moreFilterMinSalePrice",
            @"moreFilterMaxSalePrice":@"moreFilterMaxSalePrice",
            @"isCurrent":@"isCurrent",
            @"hasPropertyKey":@"hasPropertyKey",
            @"isOnlyTrust":@"isOnlyTrust",
            @"estateSelectType":@"estateSelectType",
            @"houseNo":@"HouseNo",
            @"sortField":@"SortField",
            @"ascending":@"Ascending",
            @"isTrustsApproved":@"isTrustsApproved",
            @"isCompleteDoc":@"isCompleteDoc",
            @"isTrustProperty":@"isTrustProperty",
            @"propertyNo":@"PropertyNo",
            @"isVideo":@"IsVideo",
            @"isRealSurvey":@"IsRealSurvey"
            };
}
+ (NSValueTransformer *)roomTypeJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SelectItemDtoEntity class]];
}

+ (NSValueTransformer *)roomStatusJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SelectItemDtoEntity class]];
}

+ (NSValueTransformer *)roomSituationJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SelectItemDtoEntity class]];
}

+ (NSValueTransformer *)roomLevelsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SelectItemDtoEntity class]];
}

+ (NSValueTransformer *)buildingTypeJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SelectItemDtoEntity class]];
}

+ (NSValueTransformer *)directionJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SelectItemDtoEntity class]];
}

+ (NSValueTransformer *)propTagJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[SelectItemDtoEntity class]];
}
@end
