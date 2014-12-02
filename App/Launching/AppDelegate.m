//
//  AppDelegate.m
//  App
//
//  Created by 李保路 on 13-12-1.
//  Copyright (c) 2013年 IT-Hamal. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeController.h"
#import "HttpTool.h"
#import "AppUpdate.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#ifdef __IPHONE_8_0
    //只有在iOS8中需要注册通知
    if (iOS8) {
        UIUserNotificationSettings *setting  = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [application registerUserNotificationSettings:setting];
    }
#endif
//检测网络状态
    //[HttpTool doUpdate];

    self.window = [[UIWindow alloc]initWithFrame:ScreenSizes];
    self.window.rootViewController = [[HomeController alloc]init];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

}

@end
