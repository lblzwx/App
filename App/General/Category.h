//
//  Category.h
//  lblzwx
//
//  Created by 李保路 on 13-11-17.
//  Copyright (c) 2013年 IT-Hamal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (BL)



@end

@interface UIWebView (BL)
/**
 *  修改文字大小
 */
- (void)changeWebkitfont:(NSString *)value;
//改变字体颜色  gray
-(void)changeWebkitTextFillColor:(NSString *)String;
//改变北京颜色  black
-(void)changeWebkitBackgroundColor:(NSString *)String;

@end


@interface UIAlertView (App)
+ (void)showWithTitle:(NSString *)title message:(NSString *)message  buttonTitle:(NSString *)buttonTitle;
@end
@interface UIBarButtonItem (BL)
/**
 *  快速创建一个显示图片和标题的的item(标题可写成nil)
 *
 *  @param action   监听方法
 */
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon  Title:(NSString *)title target:(id)target action:(SEL)action;
@end
@interface UIImage (App)
/*
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithImage:(UIImage *)image;
@end

//一下代码一般用在注册的时候使用
@interface NSString (App)
/*
 *email 格式检查
 */

- (BOOL)isValidEmail;

/**
 *  是否是大陆手机手机号
 */

- (BOOL)isValidPhoneNumber;
/*
 * 车牌号验证
 */
- (BOOL)isValidCarNo;

/** 网址验证 */
- (BOOL)isValidUrl;

/**
 @brief     是否符合IP格式，xxx.xxx.xxx.xxx
 */
- (BOOL)isValidIP;

/*
 * 身份证验证
 */
- (BOOL)isValidIdCardNum;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
maxLenth:(NSInteger)maxLenth
containChinese:(BOOL)containChinese
firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;



/*
 * 去掉两端空格和换行符
 */
- (NSString *)stringByTrimmingBlank;
@end