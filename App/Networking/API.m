//
//  API.m
//  App
//
//  Created by 李保路 on 13-12-2.
//  Copyright (c) 2013年 IT-Hamal. All rights reserved.
//

#import "API.h"
#import "HttpTool.h"
#import "APIInterface.h"

@implementation API
#pragma mark - 具体网络业务类

+ (void)moreNewsSuccess:(void (^)())success failure:(void (^)( NSError *error))failure{
    
    [HttpTool GET:APIBaseURL parameters:nil success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 具体业务
//判断手机号码
- (BOOL)isValidPhoneNum:(NSString *)sender {
    NSString *phoneNumber = sender;
    NSString *phoneRegex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [test evaluateWithObject:phoneNumber];
}
//判断邮箱
- (BOOL)isValidEmail:(NSString *)sender {
    BOOL stricterFilter = YES;
    NSString *mailNumber = sender;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:mailNumber];
}
//密码限制3-9个由字母/数字组成的字符串
- (BOOL)isValidPasswordNum:(NSString *)sender {
    NSString * regex = @"^[A-Za-z0-9]{3,9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:sender];
    return isMatch;
}

//昵称只能由中文、字母或数字组成
- (BOOL)isValidNickName:(NSString *)sender {
    NSString * regex = @"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:sender];
    return isMatch;
}

@end
