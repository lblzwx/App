//  Created by 李保路 on 13-12-2.
//  Copyright (c) 2013年 IT-Hamal. All rights reserved.


#import <UIKit/UIKit.h>

/**
 *  文件主要是在网络加载时，或者网络加载失败，或者是网络速度慢
 *  网页没有加载出来，友情的提示
 *
 *
 *  具体栗子在   Example.h
 */


typedef void(^ReloadButtonClickedCompleted)(UIButton *sender);

@interface LoadingView : UIView
@property (nonatomic, copy) ReloadButtonClickedCompleted reloadButtonClickedCompleted;

+ (instancetype)shareFriendlyLoadingView;

- (void)showFriendlyLoadingViewWithText:(NSString *)text loadingAnimated:(BOOL)animated;

/**
 * 隐藏页面加载动画及信息提示
 */
- (void)hideLoadingView;

/**
 * 重新加载提示
 * @param reloadString 要显示的提示字符串
 */
- (void)showReloadViewWithText:(NSString *)reloadString;

@end
