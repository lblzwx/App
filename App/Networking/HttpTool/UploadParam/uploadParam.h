//
//  uploadParam.h
//  HttpTool
//
//  Created by 李保路 on 13-12-1.
//  Copyright (c) 2013年 IT-Hamal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface uploadParam : NSObject

/**
 *  Data:要拼接文件的二进制数据,image -> data
 */
@property (nonatomic, strong) NSData *data;
/**
 *  paramName:参数名称,拼接的二进制数据属于哪个参数
 */
@property (nonatomic, copy) NSString *paramName;
/**
 *  fileName:文件名称,上传到服务器显示的名称
 */
@property (nonatomic, copy) NSString *fileName;
/**
 *  mimeType:文件格式,通过这个格式,服务器就知道需要把二进制数据转换成什么文件
 */
@property (nonatomic, copy) NSString *mimeType;

@end
