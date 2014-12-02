//
//  AppUpdate.m
//  App
//
//  Created by 李保路 on 14-12-1.
//  Copyright (c) 2014年 IT-Hamal. All rights reserved.
//

#import "AppUpdate.h"

#define CurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]

@interface AppUpdate ()<UIAlertViewDelegate>

+ (void)showAlertWithAppStoreVersion:(NSString*)appStoreVersion;

@end

@implementation AppUpdate

+ (void)checkVersion
{
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", AppID];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSLog(@"%@",error);
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
        if ( [data length] > 0 && !error ) { // Success
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
            
                if ( ![versionsInAppStore count] ) { // No versions of app in AppStore
                    
                    return;
                    
                } else {
                    
                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                    
                    if ([CurrentVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
                        
                        [AppUpdate showAlertWithAppStoreVersion:currentAppStoreVersion];
                        
                    }
                    else {
                        
                        // Current installed version is the newest public version or newer
                        
                    }
                    
                }
                
            });
        }
        
    }];
}

#pragma mark - Private Methods
+ (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion
{
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    if ( ForceUpdate ) { //强制用户升级
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:AlertViewTitle
                                                            message:[NSString stringWithFormat:@"%@有新版本. 请更新新版本%@", appName, currentAppStoreVersion]
                                                           delegate:self
                                                  cancelButtonTitle:UpdateButtonTitle
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
        
    } else { //允许用户稍后升级
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:AlertViewTitle
                                                            message:[NSString stringWithFormat:@"%@有新版本. 请更新新版本%@", appName, currentAppStoreVersion]
                                                           delegate:self
                                                  cancelButtonTitle:CancelButtonTitle
                                                  otherButtonTitles:UpdateButtonTitle, nil];
        
        [alertView show];
        
    }
    
}

#pragma mark - UIAlertViewDelegate Methods
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (ForceUpdate ) {
        
        NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", AppID];
        NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
        [[UIApplication sharedApplication] openURL:iTunesURL];
        
    } else {
        
        switch ( buttonIndex ) {
                
            case 0:{
  
                
            } break;
                
            case 1:{ // 更新
                
                NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", AppID];
                NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                [[UIApplication sharedApplication] openURL:iTunesURL];
                
            } break;
                
            default:
                break;
        }
        
    }
    
    
}



@end
