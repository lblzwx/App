//
//  API.h
//  App
//
//  Created by 李保路 on 14-12-2.
//  Copyright (c) 2014年 IT-Hamal. All rights reserved.
//
/**
 API
 *  网络基础及接口封装，所有的网络请求是用HttpTool，让代码减少对第三方框架的依赖
 *  减少控制器的代码
 *  提高代码的可扩展性
 */
#import <Foundation/Foundation.h>

@class HttpTool;


@interface API : NSObject

#pragma mark - 具体网络业务类

+ (void)moreNewsSuccess:(void (^)())success failure:(void (^)( NSError *error))failure;


#pragma mark - 具体业务
//判断手机号码
- (BOOL)isValidPhoneNum:(NSString *)sender;
//判断邮箱
- (BOOL)isValidEmail:(NSString *)sender;
//密码限制3-9个由字母/数字组成的字符串
- (BOOL)isValidPasswordNum:(NSString *)sender;
//昵称只能由中文、字母或数字组成
- (BOOL)isValidNickName:(NSString *)sender;

@end
