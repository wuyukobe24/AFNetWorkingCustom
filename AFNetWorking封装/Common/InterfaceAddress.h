//
//  InterfaceAddress.h
//  AFNetWorking封装
//
//  Created by WangXueqi on 2018/5/31.
//  Copyright © 2018年 JingBei. All rights reserved.
//

#ifndef InterfaceAddress_h
#define InterfaceAddress_h

/**
 *  1.调试阶段，写代码调试错误，需要打印。(系统会自定义一个叫做DEBUG的宏)
 *  2.发布阶段，安装在用户设备上，不需要打印。(系统会删掉这个叫做DEBUG的宏)
 */
#if DEBUG
#define DebugLog(...)    NSLog(__VA_ARGS__)
#else
#define DebugLog(...)
#endif

//正式
#define k_server_base                        @"https://www.jingdaizi.com/"//服务器地址

#define K_NewsList                     @"api/news/listNewsPage"//咨询列表
#define K_PhotovoltaicList             @"api/common/listEnterprisePage"//企业列表
#define K_UploadLoanImage              @"api/common/uploadImg"//上传图片

#endif /* InterfaceAddress_h */
