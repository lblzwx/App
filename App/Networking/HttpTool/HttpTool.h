//
//  HttpTool.h
//  HttpTool
//
//  Created by 李保路 on 13-12-1.
//  Copyright (c) 2013年 IT-Hamal. All rights reserved.
//
/**
 *
 *  在这里定义的是网络访问工具
 *  导入头文件直接使用就可以，不需要管理内部实现
 *  让你的工程不再依赖与AFNetworking
 *  以后如果程序更换框架，只需修改.m文件，不需要修改其他的工程
 *
 **/

#import <Foundation/Foundation.h>
@class uploadParam;
@interface HttpTool : NSObject
/**
 *  基础的Get数据提交
 *
 *  @param URLString  需要发生的网址
 *  @param parameters 需要传递的参数
 *  @param success    成功回掉
 *  @param failure    失败回掉
 */
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
/**
 *  基础的POST数据提交
 *
 *  @param URLString  需要发生的网址
 *  @param parameters 需要传递的参数
 *  @param success    成功回掉
 *  @param failure    失败回掉
 */
+ (void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)( id responseObject))success failure:(void (^)(NSError *error))failure;
/**
 *  带有单张图片的POST数据提交
 *
 *  @param URLString   需要发生的网址
 *  @param parameters  需要传递的参数
 *  @param uploadParam 需要传递的模型
 *  @param success     成功回掉
 *  @param failure     失败回掉
 */
+ (void)upload:(NSString *)URLString parameters:(id)parameters uploadParam:(uploadParam *)uploadParam  success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
/**
 *  检测网络状态
 */
+(void)doUpdate;
@end

