//
//  HttpTool.m
//  HttpTool
//
//  Created by 李保路 on 13-12-1.
//  Copyright (c) 2013年 IT-Hamal. All rights reserved.
//

#import "HttpTool.h"
#import "AFNetworking.h"
#import "uploadParam.h"

@interface HttpTool ()<UIAlertViewDelegate>

@end

@implementation HttpTool
+(void)doUpdate{
    AFNetworkReachabilityManager *manger = [[AFNetworkReachabilityManager alloc]init];
    if (!manger.reachable) {
        [UIAlertView showWithTitle:@"提示" message:@"可能尚未联网，请检查你的网络连接" buttonTitle:@"OK"];
    }
}

//POST
+(void)POST:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    //创建以恶搞http管理对象
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    
    [manger POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
//GET

+(void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
//上传图片
+(void)upload:(NSString *)URLString parameters:(uploadParam *)parameters uploadParam:(uploadParam *)uploadParam success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
   
    [manger POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        /**
         *  拼接参数
         */
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.paramName fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
