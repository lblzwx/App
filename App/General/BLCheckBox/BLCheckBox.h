//
//  BLCheckBox.h
//  lblzwx
//
//  Created by 李保路 on 14-11-16.
//  Copyright (c) 2014年 Chinamobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLCheckBox : UIView

/**
 *  快速创建一个选择框
 *
 *  @param title 选择框提示的文字
 *
 *  @return 返回一个选择框 ，默认选择框绑定一个tag 101
 */
-(instancetype)checkBox:(NSString *)title;

@end
