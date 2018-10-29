//
//  DascomDefine.h
//  PanKeTong
//
//  Created by 燕文强 on 15/10/20.
//  Copyright (c) 2015年 苏军朋. All rights reserved.
//

#ifndef PanKeTong_DascomDefine_h
#define PanKeTong_DascomDefine_h

#pragma mark - 拨打虚拟号时使用
#define     DAS_CALL_KEY        @"dascom"//虚拟号秘钥


#pragma mark - 用于UserDefault
#define     DAS_MSISDN          @"DAS_MSISDN"//用户主号码
#define     DAS_SSMNNUMBER      @"DAS_SSMNNUMBER"//用户副号码


#pragma mark - 拨打虚拟号码时显示的提示信息
#define     DAS_CALL_NAME       @"移动A+虚拟号"// 接入码联系人名称


#pragma mark - url path
#define     Request_DascomGetRealPhone          @"GetSsmnNumber.do"// 获取手机号码
#define     Request_DascomSendCallNumber        @"ReceiveNumber.do"// 发送拨打号码
#define     Request_DascomChangePhoneNumber     @"ChangeMsisdn.do"//修改手机号码


#pragma mark - dascom接口返回code
#define     RESPONSE_SUC                @"0000"//成功
#define     RESPONSE_NOT_STAFF          @"1001"//员工编号不存在
#define     RESPONSE_KEY_ERROR          @"1002"//鉴权密码错误

#define     RESPONSE_HEADER_ERROR       @"2001"//消息头格式错误
#define     RESPONSE_CONTENT_ERROR      @"2002"//消息体格式错误
#define     RESPONSE_IP_INVALID         @"2003"//无效的IP地址
#define     RESPONSE_MSG_ERROR          @"2004"//请求消息格式错误

#define     RESPONSE_PARAM_FAL          @"5001"//请求参数个数错误
#define     RESPONSE_STAFF_ERROR        @"5002"//员工编号不正确
#define     RESPONSE_SSNUM_ERROR        @"5003"//主号码不正确
#define     RESPONSE_SSNUM_FAL          @"5004"//主号码已被使用
#define     RESPONSE_SYS_ERROR          @"5018"//系统错误

#define     RESPONSE_UNKNOW_ERROR       @"9999"//未定义错误

#endif
