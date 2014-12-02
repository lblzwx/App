//
//  AppUpdate.h
//  App
//
//  Created by 李保路 on 14-12-1.
//  Copyright (c) 2014年 IT-Hamal. All rights reserved.
//

#import <Foundation/Foundation.h>
//是否强制更新，默认是NO
static BOOL ForceUpdate = NO;

// 2.应用的AppID
#define AppID                 @"573293275"

// 3. 设置提示信息
#define AlertViewTitle        @"有新版本"
#define CancelButtonTitle     @"稍后再说"
#define UpdateButtonTitle     @"现在更新"

@interface AppUpdate : NSObject
/**
 *  实现app在线检测是否有新的版本
 *  只需设置AppID，只需一句代码，既可以华丽的完成版本检测
 */
+ (void)checkVersion;
@end
