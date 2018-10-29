//
//  AccessModelScopeEnum.h
//  PanKeTong
//
//  Created by 李慧娟 on 16/8/26.
//  Copyright © 2016年 中原集团. All rights reserved.
//

#ifndef AccessModelScopeEnum_h
#define AccessModelScopeEnum_h

///部门权限范围
enum AccessModelScopeEnum{
    NONE = 0,//无
    ALL = 1,//全部
    MYDEPARTMENT = 3,//本部含有下级
    MYSELF = 4,//本人
    MYDEPARTMENTONLY = 8,//仅本部
};

#endif /* AccessModelScopeEnum_h */
