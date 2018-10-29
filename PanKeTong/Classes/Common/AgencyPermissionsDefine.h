//
//  AgencyPermissionsDefine.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/13.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#ifndef PanKeTong_AgencyPermissionsDefine_h
#define PanKeTong_AgencyPermissionsDefine_h

//操作权限
#define     PROPERTY_ALLTREDE_SEARCH                         @"Property.AllTrade.Search"                         // 查看全部房源
#define     PROPERTY_RENT_SEARCH_ALL                         @"Property.Rent.Search-All"                         // 查看出租房源
#define     PROPERTY_SALE_SEARCH_ALL                         @"Property.Sale.Search-All"                         // 查看出售房源
#define     PROPERTY_CONTACTINFORMATION_SEARCH_ALL           @"Property.ContactInformation.Search-All"           // 查看联系人信息
#define     PROPERTY_FOLLOW_SEARCH_ALL                       @"Property.Follow.Search-All"                       // 查看房源跟进
#define     PROPERTY_FOLLOWINFORMATION_ADD                   @"Property.FollowInformation.Add"                   // 新增跟进信息补充
#define     PROPERTY_FOLLOWTURN_ADD                          @"Property.FollowTurn.Add"                          // 新增跟进申请转盘
#define     PROPERTY_REALSURVEY_SEARCH_ALL                   @"Property.RealSurvey.Search-All"                   // 查看实堪
#define     PROPERTY_REALSURVEY_ADD_ALL                      @"Property.RealSurvey.Add-All"                      // 新增实堪
#define     PROPERTY_CONTRIBUTION_SEARCH_MYSELF              @"Property.Contribution.Search-MySelf"              // 查看本人房源贡献
#define     PROPERTY_CONTRIBUTION_SEARCH_MYDEPARTMENT        @"Property.Contribution.Search-MyDepartment"        // 查看本部房源贡献
#define     PROPERTY_CONTRIBUTION_SEARCH_ALL                 @"Property.Contribution.Search-All"                 // 查看全部房源贡献
#define     PROPERTY_PREORDAINPROPERTY_SEARCH_MYSELF         @"Property.PreordainProperty.Search-MySelf"         // 查看本人预定房源－－暂无使用
#define     PROPERTY_PREORDAINPROPERTY_SEARCH_MYDEPARTMENT   @"Property.PreordainProperty.Search-MyDepartment"   // 查看本部预定房源－－暂无使用
#define     PROPERTY_PREORDAINPROPERTY_SEARCH_ALL            @"Property.PreordainProperty.Search-All"
#define     PROPERTY_REALSURVEY_VIDEO_ADD                    @"Property.RealSurvey.Video-Add"                    // 补传视频的权限

//查看全部预定房源－－暂无使用
#define     CUSTOMER_INQUIRY_ADD_ALL                         @"Customer.Inquiry.Add-All"                         //新增客源
#define     CUSTOMER_INQUIRY_SEARCH_MYSELF                   @"Customer.Inquiry.Search-MySelf"                   //查看本人客源
#define     CUSTOMER_INQUIRY_SEARCH_MYDEPARTMENT             @"Customer.Inquiry.Search-MyDepartment"             //查看本部客源
#define     CUSTOMER_INQUIRY_SEARCH_ALL                      @"Customer.Inquiry.Search-All"                      //查看全部客源
#define     CUSTOMER_CONTACTINFORMATION_SEARCH_MYDEPARTMENT  @"Customer.ContactInformation.Search-MyDepartment"  //查看本部电话－－暂无使用
#define     CUSTOMER_CONTACTINFORMATION_SEARCH_ALL           @"Customer.ContactInformation.Search-All"           //联系人电话--权限
#define     CUSTOMER_PUBLICINQUIRY_MYSELF_OTHER              @"Customer.PublicInquiryToMyself.Other"        // 抢公客转私客
#define     CUSTOMER_CHANNEL_SEARCH_MYSELF                   @"Customer.Channel.Search-MySelf"           //查看本人渠道来电
#define     CUSTOMER_CHANNEL_SEARCH_MYDEPARTMENT             @"Customer.Channel.Search-MyDepartment"     //查看本部渠道来电
#define     CUSTOMER_CHANNEL_SEARCH_ALL                      @"Customer.Channel.Search-All"              //查看全部渠道来电

#define CUSTOMER_TAKE @"Customer.take"  //带看记录

#define		PROPERTY_FOLLOWCALLPRICE_ADD				     @"Property.FollowCallPrice.Add"		//房源管理.新增.叫价申请跟进
#define     PROPERTY_FOLLOWNEWCONTACT_ADD				     @"Property.FollowNewContact.Add"	//房源管理.新增.新增联系人跟进
#define     PROPERTY_FOLLOWNEWOPENING_ADD				     @"Property.FollowNewOpening.Add"	//房源管理.新增.新开盘跟进
#define		PROPERTY_FOLLOWCLEAN_ADD						 @"Property.FollowClean.Add"			//房源管理.新增.洗盘跟进

//2.经理确认跟进
#define     PROPERTY_FOLLOW_CONFIRM_MYDEPARTMENT             @"Property.Follow.Confirm-MyDepartment"     //房源跟进.确认(本部).跟进
#define     PROPERTY_FOLLOW_CONFIRM_NONE                     @"Property.Follow.Confirm-None"             //房源跟进.确认(无).跟进
#define     PROPERTY_FOLLOW_CONFIRM_ALL                      @"Property.Follow.Confirm-All"              //房源跟进.确认(全部).跟进
#define     PROPERTY_FOLLOW_CONFIRM_MYSELF                   @"Property.Follow.Confirm-MySelf"           //房源跟进.确认(本人).跟进

// 跟进置顶权限（南京新加）
#define     PROPERTY_FOLLOW_TOP_NONE                         @"Property.Follow.Top-None"                 // 无置顶权限
#define     PROPERTY_FOLLOW_TOP_MYSELF                       @"Property.Follow.Top-MySelf"               // 置顶本人跟进
#define     PROPERTY_FOLLOW_TOP_MYDEPARTMENT                 @"Property.Follow.Top-MyDepartment"         // 置顶本部门跟进
#define     PROPERTY_FOLLOW_TOP_ALL                          @"Property.Follow.Top-All"                  // 置顶全部


//7.删除
#define     PROPERTY_FOLLOW_DELETE_MYSELF                    @"Property.Follow.Delete-MySelf"        //房源跟进.删除(本人).跟进
#define     PROPERTY_FOLLOW_DELETE_MYDEPARTMENT              @"Property.Follow.Delete-MyDepartment"  //房源跟进.删除(本部).跟进
#define     PROPERTY_FOLLOW_DELETE_NONE                      @"Property.Follow.Delete-None"          //房源跟进.删除(无).跟进
#define     PROPERTY_FOLLOW_DELETE_ALL                       @"Property.Follow.Delete-All"           //房源跟进.删除(全部).跟进

//1. 签到
#define     CENTER_CHENCKIN_SEARCH_ALL                       @"Center.CheckIn.Search-All"            //个人中心.查看(全部).签到
#define     CENTER_CHENCKIN_SEARCH_MYDEPT                    @"Center.CheckIn.Search-MyDept"         //个人中心.查看(本部).签到
#define     CENTER_CHENCKIN_SEARCH_MySELF                    @"Center.CheckIn.Search-MySelf"         //个人中心.查看(本人).签到
#define     CENTER_CHENCKIN_SEARCH_NONE                      @"Center.CheckIn.Search-None"           //个人中心.查看(无).签到

//菜单权限，顶导权限
#define     MENU_PROPERTY                                    @"Property"                 //房源(主导)－－暂无使用
#define     MENU_PROPERTY_WAR_ZONE                           @"Property.war-zone"        //通盘房源(左导)
#define     MENU_PROPERTY_PUBLIC_ESTATE                      @"Property.public-estate"   //公盘池(左导)
#define     MENU_PROPERTY_MY_SHARING                         @"Property.my-sharing"      //房源贡献(左导)
#define     MENU_PROPERTY_MY_FAVORITE                        @"Property.my-favorite"     //我的收藏(左导)
#define     MENU_PROPERTY_AREA_MANAGER_RECOMMEND             @"Property.area-manager-recommend"      //推荐房源(左导)
#define     MENU_CUSTOMER                                    @"Customer"                             //客源模块(主导)
#define     MENU_CUSTOMER_PUBLIC_CUSTOMER                    @"Customer.public-customer"             //公客池(左导)
#define     MENU_CUSTOMER_ALL_CUSTOMER                       @"Customer.all-customer"                //全部客户(左导)
#define     MENU_ADVERT                                      @"Advert"                       //放盘管理主导
#define     CUSTOMER_ALL_CHANNEL                             @"Customer.all-channel"         //渠道来电(左导)
#define     CUSTOMER_PUBLIC_CHANNEL                          @"Customer.public-channel"      //渠道公客池(左导)
#define     MENU_PROPERTY_FOLLOW                             @"Property.follow"              //左导跟进
#define     MENU_PROPERTY_REALSURVEYS                        @"Property.realSurveys"         //实勘审核(左导)
#define     MENU_PROPERTY_REGISTERTRUSTS                     @"Property.RegisterTrusts"      //委托审核（左导）

//查看联系人权限
#define     PROPERTY_CONTACTINFORMATION_SEARCH               @"Property.ContactInformation.Search"
#define     PROPERTY_CONTACTINFORMATION_SEARCH_ISDEPT        @"Property.ContactInformation.Search-IsDept"    //要根据返回的配额和已查看次数限制经纪人查看次数
#define     PROPERTY_CONTACTINFORMATION_SEARCH_NONE          @"Property.ContactInformation.Search-None"      //不允许查看
#define     PROPERTY_CONTACTINFORMATION_SEARCH_NODEPT        @"Property.ContactInformation.Search-NoDept"    //不限制查看次数
#define     PROPERTY_CONTACTINFORMATION_SEARCH_ALL           @"Property.ContactInformation.Search-All"       //允许查看
#define     PROPERTY_CONTACTINFORMATION_MODIFY_ALL           @"Property.ContactInformation.Modify-All"       //允许编辑
#define     PROPERTY_CONTACTINFORMATION_ADD_ALL              @"Property.ContactInformation.Add-All"          //允许新增
// 房源详情通话记录权限
#define     PROPERTY_CALLLOG_MODIFY_MYDEPARTMENT             @"Property.CallLog.Modify-MyDepartment"          // 本部
#define     PROPERTY_CALLLOG_MODIFY_MYSELF                   @"Property.CallLog.Modify-MySelf"          // 本人
#define     PROPERTY_CALLLOG_MODIFY_ALL                      @"Property.CallLog.Modify-All" // 全部

// 实勘审核权限
#define     PROPERTY_REALSURVEY_AUDIT_NONET                  @"Property.RealSurvey.Audit-None"              //房源管理.审核(无).实勘
#define     PROPERTY_REALSURVEY_AUDIT_MYDEPARTMENT           @"Property.RealSurvey.Audit-MyDepartment"       //房源管理.审核(本部).实勘
#define     PROPERTY_REALSURVEY_AUDIT_ALL                    @"Property.RealSurvey.Audit-All"                //房源管理.审核(全部).实勘
#define     PROPERTY_REALSURVEY_REVIEW_NONE                  @"Property.RealSurvey.Review-None"              //房源管理.复审(无).实勘
#define     PROPERTY_REALSURVEY_REVIEW_MYDEPARTMENT          @"Property.RealSurvey.Review-MyDepartment"      //房源管理.复审(本部).实勘
#define     PROPERTY_REALSURVEY_REVIEW_ALL                   @"Property.RealSurvey.Review-All"               //房源管理.复审(全部).实勘

// 实勘左导查看权限
#define     PROPERTY_LEFTREALSURVEY_SEARCH_NONE                 @"Property.LeftRealSurvey.Search-None"              // 实勘左导-查看-无
#define     PROPERTY_LEFTREALSURVEY_SEARCH_MYSELF               @"Property.LeftRealSurvey.Search-MySelf"            //  实勘左导-查看-本人
#define     PROPERTY_LEFTREALSURVEY_SEARCH_MYDEPARTMENT         @"Property.LeftRealSurvey.Search-MyDepartment"      //  实勘左导-查看-本部
#define     PROPERTY_LEFTREALSURVEY_SEARCH_ALL                  @"Property.LeftRealSurvey.Search-All"               //  实勘左导-查看-全部

// 实勘审核查看权限
#define     PROPERTY_REALSURVEY_SEARCH_ALL                      @"Property.RealSurvey.Search-All"              // 查看实勘 * 全部
#define     PROPERTY_REALSURVEY_SEARCH_MYDEPARTMENT             @"Property.RealSurvey.Search-MyDepartment"     // 查看实勘 * 本部
#define     PROPERTY_REALSURVEY_SEARCH_MYSELF                   @"Property.RealSurvey.Search-MySelf"           // 查看实勘 * 本人
#define     PROPERTY_REALSURVEY_SEARCH_NONE                     @"Property.RealSurvey.Search-None"             // 查看实勘 * 无

#define     PROPERTY_REALSURVEY_REVIEW                          @"Property.RealSurvey.Review"       //复审权限
#define     PROPERTY_REALSURVEY_AUDIT                           @"Property.RealSurvey.Audit"        //初审权限

// 业主委托审核权限
#define     PROPERTY_REGISTERTRUSTS_AUDIT_MYDEPARTMENT          @"Property.RegisterTrusts.Audit-MyDepartment"   // 委托审核－本部
#define     PROPERTY_REGISTERTRUSTS_AUDIT_ALL                   @"Property.RegisterTrusts.Audit-All"            //委托审核－全部
#define     PROPERTY_REGISTERTRUSTS_AUDIT_NONE                  @"Property.RegisterTrust.Audit-None"            //委托审核－无

// 备案查看权限
#define     PROPERTY_REGISTERTRUSTS_VIEW_MYSELF                 @"Property.RegisterTrust.View-MySelf"           // 本人
#define     PROPERTY_REGISTERTRUSTS_VIEW_MYDEPARTMENT           @"Property.RegisterTrust.View-MyDepartment"     // 本部
#define     PROPERTY_REGISTERTRUSTS_VIEW_ALL                    @"Property.RegisterTrust.View-All"              // 全部 查看权限
#define     PROPERTY_REGISTERTRUSTS_VIEW_NONE                   @"Property.RegisterTrust.View-None"             // 无

// 备案编辑权限
#define     PROPERTY_REGISTERTRUSTS_MODIFY_MYSELF                @"Property.RegisterTrust.Modify-MySelf"        // 本人
#define     PROPERTY_REGISTERTRUSTS_MODIFY_MYDEPARTMENT          @"Property.RegisterTrust.Modify-MyDepartment"  // 本部
#define     PROPERTY_REGISTERTRUSTS_MODIFY_ALL                   @"Property.RegisterTrust.Modify-All"            // 全部 编辑权限
#define     PROPERTY_REGISTERTRUSTS_MODIFY_NONE                  @"Property.RegisterTrust.Modify-None"          // 无

// 组织结构权限
#define     DEPARTMENT_PROPERTY_FOLLOW_SEARCH_ALL               @"Property.Follow.Search-All"               // 房源跟进-查看
#define     DEPARTMENT_PROPERTY_CONTACTINFORMATION_SEARCH_ALL   @"Property.ContactInformation.Search-All"   // 查看联系人列表
#define     DEPARTMENT_PROPERTY_ONLYTRUST_SEARCH_ALL            @"Property.OnlyTrust.Search-All"            // 独家-查看（全部）
#define     DEPARTMENT_PROPERTY_REALSURVEY_ADD_ALL              @"Property.RealSurvey.Add-All"              // 添加实勘
#define     DEPARTMENT_PROPERTY_REALSURVEY_SEARCH_ALL           @"Property.RealSurvey.Search-All"           // 查看实勘
#define     DEPARTMENT_PROPERTY_FOLLOW_ADD_ALL                  @"Property.Follow.Add-All"                  // 添加房源跟进
#define     DEPARTMENT_PROPERTY_PROPERTY_MODIFY_ALL             @"Property.Property.Modify-All"
#define     DEPARTMENT_PROPERTY_SEARCH_NONE                     @"Property.ContactInformation.Search-None"

//房源基本信息-编辑
#define  PROPERTY_PROPERTY_MODIFY_NONE             @"Property.Property.Modify-None"         //无
#define  PROPERTY_PROPERTY_MODIFY_MYSELF           @"Property.Property.Modify-MySelf"       //本人
#define  PROPERTY_PROPERTY_MODIFY_MYDEPARTMENT     @"Property.Property.Modify-MyDepartment" //本部
#define  PROPERTY_PROPERTY_MODIFY_ALL              @"Property.Property.Modify-All"          //全部    编辑房源

//房源基本信息-编辑-基本信息
#define  PROPERTY_BASICINFORMATION_MODIFY_MYSELF        @"Property.BasicInformation.Modify-MySelf"       //本人
#define  PROPERTY_BASICINFORMATION_MODIFY_MYDEPARTMENT  @"Property.BasicInformation.Modify-MyDepartmeeent" //本部
#define  PROPERTY_BASICINFORMATION_MODIFY_ALL           @"Property.BasicInformation.Modify-All"          //全部

//房源基本信息-编辑-交易信息
#define PROPERTY_TRANSACTIONINFORMATION_MODIFY_MYSELF   @"Property.TransactionInformation.Modify-MySelf"       //本人
#define PROPERTY_TRANSACTIONINFORMATION_MYDEPARTMENT    @"Property.TransactionInformation.Modify-MyDepartment" //本部
#define PROPERTY_TRANSACTIONINFORMATION_MODIFY_ALL      @"Property.TransactionInformation.Modify-All"          //全部

//成交权限
#define PROPERTY_MY_TRANSACTION @"Property.my-transaction"//我的成交
#define PROPERTY_ALL_TRANSACTION @"Property.all-transaction"//全部成交

// 钥匙箱还钥相关权限
#define PROPERTY_KEY_RETURN_NONE                        @"Property.Key.Return-None"                            // 无
#define PROPERTY_KEY_RETURN_MYSELF                      @"Property.Key.Return-MySelf"                          // 本人
#define PROPERTY_KEY_RETURN_MYDEPARTMENT                @"Property.Key.Return-MyDepartment"                    // 本部
#define PROPERTY_KEY_RETURN_ALL                         @"Property.Key.Return-All"                             // 全部
#define PROPERTY_KEY_MODIFY_ALL @"Property.Key.Modify-All" //钥匙编辑权限

// 钥匙查看权限
#define PROPERTY_KEY_SEARCH_ALL                         @"Property.Key.Search-All"                             

#define PROPERTY_PROPERTYSTATUS_MODIFY_ALL              @"Property.PropertyStatus.Modify-All"                   // 房源状态修改


//工作量化
#define CENTER_QUANTIZATION @"Center.quantization"          //工作量化权限

#endif
